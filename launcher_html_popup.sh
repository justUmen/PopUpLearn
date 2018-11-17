#!/bin/bash
function keyboard_language_change(){
	sleep 3 && ibus engine > $HOME/.PopUpLearn/tmp/ibus.tmp
	case $LANGUAGE_2 in
		en) ibus engine xkb:us::eng; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/usa.jpg "xkb:us::eng" ;;
		th) ibus engine libthai; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/thai.jpg "libthai" ;;
		jp) ibus engine anthy; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/japan.jpg "anthy" ;;
		cn) ibus engine pinyin; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/china.jpg "pinyin" ;;
	esac
}
function keyboard_language_previous_one(){
	ibus engine `cat $HOME/.PopUpLearn/tmp/ibus.tmp`
}
function loop_quiz(){
	#~ LOOP_QUIZ=$1
	# 3 - WAIT AND QUIZ
	quizzed=0
	while [ $1 -ne $quizzed ]; do
		quizzed=`expr $quizzed + 1`
		waited=1
		if [ $SIGSTOP_MPV -eq 1 ]; then
			sleep 3 && $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE &> /dev/null &
		fi
		sleep 3 && i3-msg workspace "Learn" &
		#Unknown if python3 is closed without answering
		echo unknown > $HOME/.PopUpLearn/tmp/result.tmp

		keyboard_language_change
		python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ &> /dev/null
		keyboard_language_previous_one

		i3-msg workspace back_and_forth #What about others wm ?
		if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE &> /dev/null; fi
		#$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24))) => Days since 1 january 2018
		#~ ANSWER= #real < can't be displayed by notify-send...
		if [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "good" ]]; then
			#??? UGLY
			notify-send -i $HOME/.PopUpLearn/img/good.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
			echo "$LINE" >> $ANSWERED_GOOD
			echo "$LINE€$TODAY" >> $ANSWERED_GOOD_DATE
		elif [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "bad" ]]; then
			notify-send -i $HOME/.PopUpLearn/img/bad.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
			echo "$LINE" >> $ANSWERED_BAD
			echo "$LINE€$TODAY" >> $ANSWERED_BAD_DATE
		else
			#~ notify-send -i $HOME/.PopUpLearn/img/unknown.png "$LEFT : $RIGHT ($quizzed/$LOOP_QUIZ)"
			notify-send -i $HOME/.PopUpLearn/img/unknown.png "You can't do that, you need to answer something..."
		fi
		sleep $SEC_BEFORE_QUIZ
	done
	sleep $SEC_AFTER_QUIZ
}
function show_good_answer(){
	if [ $SIGSTOP_MPV -eq 1 ]; then sleep 3 && $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE &> /dev/null & fi
	if [ "$TIME_DISPLAYED" == 0 ];then #LOCK, unlimited
		sleep 3 && i3-msg workspace "Learn" &
		python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO NO
		i3-msg workspace back_and_forth #What about others wm ?
	else
		sleep 3 && i3-msg workspace "Learn" &
		python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO NO &
		sleep $TIME_DISPLAYED
		pkill -f "python3 $HOME/.PopUpLearn/html_popup.py" &> /dev/null
		i3-msg workspace back_and_forth #What about others wm ?
	fi
	if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE &> /dev/null; fi
	sleep $SEC_BEFORE_QUIZ
}
function create_file_content_BAD_answers_tmp(){
	cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' > $HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp
}
function prepare_buttons_wrong_answers(){
	create_file_content_BAD_answers_tmp
	if [[ "$TYPE" == "BUTTON" ]];then
		rm $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp 2> /dev/null
		while read line; do
			left=`echo $line | sed 's/£.*//'`
			right=`echo $line | sed 's/.*£//'`
			#~ if [[ "$left" != "$LEFT" ]] : BETTER FOR MULTIPLE ANSWERS POSSIBLE ???
			if [[ "$left" != "$LEFT" ]] || [[ "$right" != "$RIGHT" ]];then
				echo "$right" >> $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
			fi
		done < "$HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp"
	fi
}
function create_session_folder(){
	echo "mkdir $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/"
	mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/" 2> /dev/null
}
function create_session_specific_config(){
	echo "create : $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_specific_config.conf"
	#add identical configuration but without "ANSWER_BEFORE_QUIZ=1" because you are supposed to know this already...
	sed 's/ANSWER_BEFORE_QUIZ=1/ANSWER_BEFORE_QUIZ=0/' $HOME/.PopUpLearn/tmp/session_specific_config.tmp > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_specific_config.conf"
}
function create_session_content_pul(){
	echo "create : $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	if [ $SESSION_NUMBER -eq 1 ]; then
		cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' | head -n $SESSION_SIZE > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	else
		cat $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_*/session_content.pul > $HOME/.PopUpLearn/tmp/content_old_sessions.tmp
		cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' | grep -F -x -v -f $HOME/.PopUpLearn/tmp/content_old_sessions.tmp | head -n $SESSION_SIZE > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	fi
}
function create_session_content_tmp(){
	cp "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" $HOME/.PopUpLearn/tmp/session_content.tmp
}
function create_session_content_remove_tmp(){
	cp "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" $HOME/.PopUpLearn/tmp/session_content_remove.tmp
}
function prepare_session_good_answers(){
	TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
	ANSWERED_GOOD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good"
	ANSWERED_GOOD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good.date"
}
function prepare_session_bad_answers(){
	TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
	ANSWERED_BAD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.bad"
	ANSWERED_BAD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.bad.date"
}
function create_current_line_file_tmp(){
	cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
}
function create_current_line_session_tmp(){
	cat $HOME/.PopUpLearn/tmp/session_content_remove.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
}
function remove_answer_from_session_tmp(){
	cp $HOME/.PopUpLearn/tmp/session_content_remove.tmp $HOME/.PopUpLearn/tmp/session_content_2.tmp
	grep -F -x -v -f $HOME/.PopUpLearn/tmp/current_line.tmp $HOME/.PopUpLearn/tmp/session_content_2.tmp > $HOME/.PopUpLearn/tmp/session_content_remove.tmp
	rm $HOME/.PopUpLearn/tmp/session_content_2.tmp
}
function prepare_current_line_parsing(){
	LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
	LEFT=`echo "$LINE" | sed 's/£.*//'`
	RIGHT=`echo "$LINE" | sed 's/.*£//'`
}
function create_my_line_tmp(){
	echo
	echo "my_line.tmp : 0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}"
	echo "0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}" > $HOME/.PopUpLearn/tmp/my_line.tmp
}
function create_file_content_tmp(){ #??? CHANGE
	if [ $ANSWER_BEFORE_QUIZ -eq 1 ];then
		#~ cat $FILE | grep -v "^#" | sed '/^$/d' | sed 's/ |=| /£/' | sed 's/^\t//' | sed 's/^[\t]*//' | sed 's/^[ ]*//' | sed 's/[ ]*$//' | grep '£' > $HOME/.PopUpLearn/tmp/file_content.tmp
		cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' > $HOME/.PopUpLearn/tmp/file_content.tmp
		cp -f $HOME/.PopUpLearn/tmp/file_content.tmp $HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp
	else
		cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' > $HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp
		cat $HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp | sort -R | head -n $SESSION_SIZE > $HOME/.PopUpLearn/tmp/file_content.tmp
	fi
	#~ echo -e "\n$HOME/.PopUpLearn/tmp/file_content.tmp : `cat $HOME/.PopUpLearn/tmp/file_content.tmp`\n"
}
function session_old(){
	create_session_content_tmp
	create_session_content_remove_tmp
	SESSION_NUMBER=$1
	LOOP_QUIZ=1 #IF OLD SESSION, ONLY ONE QUESTION ??? :P
	while read X; do
		prepare_session_good_answers
		prepare_session_bad_answers
		prepare_buttons_wrong_answers
		#~ create_current_line_file_tmp #(based on file_content.tmp)
		create_current_line_session_tmp #(based on session_content_remove.tmp)
		prepare_current_line_parsing
		create_session_content_tmp
		create_my_line_tmp
		#~ show_good_answer
		loop_quiz $LOOP_QUIZ
		remove_answer_from_session_tmp
	done < "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	notify-send -i $HOME/.PopUpLearn/img/unknown.png "End of session $SESSION_NUMBER"
}
function session_new(){
	create_session_folder
	create_session_specific_config #(based on session_specific_config.tmp)
	create_session_content_pul
	create_session_content_tmp
	create_session_content_remove_tmp #(based on session_content.pul)
	create_file_content_tmp #???
	while read X; do
		prepare_session_good_answers
		prepare_session_bad_answers
		prepare_buttons_wrong_answers
		#~ create_current_line_file_tmp #(based on file_content.tmp)
		create_current_line_session_tmp #(based on session_content_remove.tmp)
		prepare_current_line_parsing
		create_session_content_tmp
		create_my_line_tmp
		show_good_answer
		loop_quiz $LOOP_QUIZ
		remove_answer_from_session_tmp
	done < "$HOME/.PopUpLearn/tmp/session_content.tmp"
	notify-send -i $HOME/.PopUpLearn/img/unknown.png "End of session $SESSION_NUMBER"
}
function quiz_only(){
	create_file_content_tmp
	while read X; do
		mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/" 2> /dev/null
		TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
		ANSWERED_GOOD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.good"
		ANSWERED_GOOD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.good.date"
		ANSWERED_BAD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.bad"
		ANSWERED_BAD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.bad.date"
		if [ -e "$ANSWERED_GOOD" ];then
			cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | grep -F -x -v -f $ANSWERED_GOOD | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
			LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
		else
			cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
			LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
		fi
		if [ "$LINE" == "" ]; then
			notify-send "You know everything about $FILE"
			exit
		fi
		LEFT=`echo "$LINE" | sed 's/£.*//'`
		RIGHT=`echo "$LINE" | sed 's/.*£//'` #~ echo "$LINE\n$LEFT\n$RIGHT"
		#85:hsk1_PI:hànyǔ:mandarin_chinese:13:2 (my_line.tmp)
		echo "0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}" > $HOME/.PopUpLearn/tmp/my_line.tmp		
		#~ echo " -- $TYPE -- "
		#Prepare "wrong_answers_BUTTON.tmp" for popup_quiz if TYPE is BUTTON
		if [[ "$TYPE" == "BUTTON" ]];then
			rm $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp 2> /dev/null
			while read line; do
				left=`echo $line | sed 's/£.*//'`
				right=`echo $line | sed 's/.*£//'`
				#~ if [[ "$left" != "$LEFT" ]] : BETTER FOR MULTIPLE ANSWERS POSSIBLE ???
				if [[ "$left" != "$LEFT" ]] || [[ "$right" != "$RIGHT" ]];then
					echo "$right" >> $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
				fi
			done < "$HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp"
		fi
			quizzed=0
		while [ $LOOP_QUIZ -ne $quizzed ]; do
			quizzed=`expr $quizzed + 1`
			waited=1
			if [ $SIGSTOP_MPV -eq 1 ]; then
				sleep 3 && $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE 2> /dev/null &
			fi
			sleep 3 && i3-msg workspace "Learn" &
			#Unknown if python3 is closed without answering
			echo unknown > $HOME/.PopUpLearn/tmp/result.tmp
			python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ
			i3-msg workspace back_and_forth #What about others wm ?
			if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE 2> /dev/null; fi

			#$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24))) => Days since 1 january 2018
				#~ ANSWER= #real < can't be displayed by notify-send...
			if [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "good" ]]; then
				notify-send -i $HOME/.PopUpLearn/img/good.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
				echo "$LINE" >> $ANSWERED_GOOD
				echo "$LINE€$TODAY" >> $ANSWERED_GOOD_DATE
			elif [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "bad" ]]; then
				notify-send -i $HOME/.PopUpLearn/img/bad.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
				echo "$LINE" >> $ANSWERED_BAD
				echo "$LINE€$TODAY" >> $ANSWERED_BAD_DATE
			else
				#~ notify-send -i $HOME/.PopUpLearn/img/unknown.png "$LEFT : $RIGHT ($quizzed/$LOOP_QUIZ)"
				notify-send -i $HOME/.PopUpLearn/img/unknown.png "You can't do that, you need to answer something..."
			fi
			sleep $SEC_BEFORE_QUIZ
		done

		sleep $SEC_AFTER_QUIZ
	done < "$HOME/.PopUpLearn/tmp/file_content.tmp"
}

function new_start(){
	if [ $ANSWER_BEFORE_QUIZ -eq 1 ];then
		mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/" 2> /dev/null
		sed 's/ANSWER_BEFORE_QUIZ=1/ANSWER_BEFORE_QUIZ=0/' $HOME/.PopUpLearn/tmp/session_specific_config.tmp > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_specific_config.tmp"
		cat $HOME/.PopUpLearn/tmp/file_content.tmp | head -n $SESSION_SIZE >> "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	else
		mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/" 2> /dev/null
	fi
	while [ 1 ]; do
		# PREPARE LOGS SYSTEM ??? ADD DATE TO THIS
		TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
		MISTAKE=0
		if [ $ANSWER_BEFORE_QUIZ -eq 1 ];then
			ANSWERED_GOOD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good"
			ANSWERED_GOOD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good.date"
			ANSWERED_BAD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.bad"
			ANSWERED_BAD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.bad.date"
			#add identical configuration but without "ANSWER_BEFORE_QUIZ=1" because you are supposed to know this already...
		else
			ANSWERED_GOOD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.good"
			ANSWERED_GOOD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.good.date"
			ANSWERED_BAD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.bad"
			ANSWERED_BAD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.bad.date"
		fi
		#~ LEARNED="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/`echo "$FILE"|sed 's#.*/##'`.learned"
		#CREATE $LEARNED IF answer.good more than X times ???


		if [ $ANSWER_BEFORE_QUIZ -eq 1 ];then
			cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
			LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
		else
			# 1 - CHOOSE LINE FROM $FILE (RANDOM ?) AND REMOVE SOMETHING THAT IS ALREADY LEARNED
			#grep -F -x -v -f $LEARNED : if not in answer.good file, for now I guess only one time but after need to be answered X times correctly ??
			#OR maybe answered correctly more than X days ago ???	
			if [ -e "$ANSWERED_GOOD" ];then
				cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | grep -F -x -v -f $ANSWERED_GOOD | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
				LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
			else
				cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
				LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
			fi
			if [ "$LINE" == "" ]; then
				notify-send "You know everything about $FILE"
				exit
			fi
		fi
		LEFT=`echo "$LINE" | sed 's/£.*//'`
		RIGHT=`echo "$LINE" | sed 's/.*£//'` #~ echo "$LINE\n$LEFT\n$RIGHT"

		#85:hsk1_PI:hànyǔ:mandarin_chinese:13:2 (my_line.tmp)
		echo "0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}" > $HOME/.PopUpLearn/tmp/my_line.tmp		
		#~ echo " -- $TYPE -- "
		#Prepare "wrong_answers_BUTTON.tmp" for popup_quiz if TYPE is BUTTON
		if [[ "$TYPE" == "BUTTON" ]];then
			rm $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp 2> /dev/null
			while read line; do
				left=`echo $line | sed 's/£.*//'`
				right=`echo $line | sed 's/.*£//'`
				#~ if [[ "$left" != "$LEFT" ]] : BETTER FOR MULTIPLE ANSWERS POSSIBLE ???
				if [[ "$left" != "$LEFT" ]] || [[ "$right" != "$RIGHT" ]];then
					echo "$right" >> $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
				fi
			done < "$HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp"
		fi
		
		# 2 - SHOW ANSWER
		if [ $ANSWER_BEFORE_QUIZ -eq 1 ];then
			if [ $SIGSTOP_MPV -eq 1 ]; then
				sleep 3 && $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE &
			fi
			if [ "$TIME_DISPLAYED" == 0 ];then #LOCK, unlimited
				sleep 3 && i3-msg workspace "Learn" &
				python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO NO
				i3-msg workspace back_and_forth #What about others wm ?
			else
				sleep 3 && i3-msg workspace "Learn" &
				python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO NO &
				sleep $TIME_DISPLAYED
				pkill -f "python3 $HOME/.PopUpLearn/html_popup.py"
				i3-msg workspace back_and_forth #What about others wm ?
			fi
			if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE 2> /dev/null; fi
			sleep $SEC_BEFORE_QUIZ
		fi

		# 3 - WAIT AND QUIZ
		quizzed=0
		while [ $LOOP_QUIZ -ne $quizzed ]; do
			quizzed=`expr $quizzed + 1`
			waited=1
			if [ $SIGSTOP_MPV -eq 1 ]; then
				sleep 3 && $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE 2> /dev/null &
			fi
			sleep 3 && i3-msg workspace "Learn" &
			#Unknown if python3 is closed without answering
			echo unknown > $HOME/.PopUpLearn/tmp/result.tmp
			python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ
			i3-msg workspace back_and_forth #What about others wm ?
			if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE 2> /dev/null; fi

			#$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24))) => Days since 1 january 2018
				#~ ANSWER= #real < can't be displayed by notify-send...
			if [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "good" ]]; then
				notify-send -i $HOME/.PopUpLearn/img/good.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
				echo "$LINE" >> $ANSWERED_GOOD
				echo "$LINE€$TODAY" >> $ANSWERED_GOOD_DATE
			elif [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "bad" ]]; then
				notify-send -i $HOME/.PopUpLearn/img/bad.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
				echo "$LINE" >> $ANSWERED_BAD
				echo "$LINE€$TODAY" >> $ANSWERED_BAD_DATE
			else
				#~ notify-send -i $HOME/.PopUpLearn/img/unknown.png "$LEFT : $RIGHT ($quizzed/$LOOP_QUIZ)"
				notify-send -i $HOME/.PopUpLearn/img/unknown.png "You can't do that, you need to answer something..."
			fi
			sleep $SEC_BEFORE_QUIZ
		done

		sleep $SEC_AFTER_QUIZ
	done < "$HOME/.PopUpLearn/tmp/file_content.tmp"
}

#EXIT IF SERVER IS NOT RUNNING (php -S 127.0.0.1:9999 -t $HOME/.PopUpLearn)
#https://stackoverflow.com/questions/9609130/efficiently-test-if-a-port-is-open-on-linux-without-nmap-or-netcat#9609247
exec 6<>/dev/tcp/127.0.0.1/9999 \
	&& echo "php server available on port 9999" \
	|| { echo "Please run the php server with : php -S 127.0.0.1:9999 -t ~/.PopUpLearn" && exec 6>&- && exec 6<&- && exit; }

exec 6<>/dev/tcp/127.0.0.1/8888 \
	&& echo "nodejs server available on port 8888" \
	|| { echo "Please run the nodejs server with : node ~/.PopUpLearn/node_server.js || nodejs ~/.PopUpLearn/node_server.js" && exec 6>&- && exec 6<&- && exit; }

if [ $1 ]; then TIME_DISPLAYED="$1"; else TIME_DISPLAYED=0; fi #0 for infinite
if [ $2 ]; then SEC_BEFORE_QUIZ="$2"; else SEC_BEFORE_QUIZ=30; fi
if [ $3 ]; then SEC_AFTER_QUIZ="$3"; else SEC_AFTER_QUIZ=60; fi
if [ $4 ]; then SIGSTOP_MPV="$4"; else SIGSTOP_MPV=1; fi #ONLY FOR ME AS OF NOW... KEEP 0 FOR ALL
if [ $5 ]; then LANGUAGE_1="$5"; else LANGUAGE_1="xx"; fi
if [ $6 ]; then LANGUAGE_2="$6"; else LANGUAGE_2="xx"; fi
if [ $7 ]; then SUBJECT="$7"; else SUBJECT="unknown"; fi
if [ $8 ]; then NUMBER="$8"; else NUMBER="unknown"; fi
if [ $9 ]; then TYPE="$9"; else TYPE="TEXT"; fi
if [ $10 ]; then ANSWER_BEFORE_QUIZ="$10"; else ANSWER_BEFORE_QUIZ=1; fi
if [ $11 ]; then LOOP_QUIZ="$11"; else LOOP_QUIZ=3; fi

#My ~/.PopUpLearn is linked to the real SyNc : ln -fs ~/SyNc/Projects/PopUpLearn ~/.PopUpLearn
#~ FILE="$HOME/.PopUpLearn/DB/fr/GS/bash/_1-11.pul"
#~ FILE="$HOME/.PopUpLearn/DB/LANGUAGE/CN/hsk/hsk1/ALL/HSK1_PI_en.pul"

#FOR GAMESCRIPT, TAKE CUSTOM CONFIG
source $HOME/.GameScript/config #LANGUAGE=fr used for quiz language

#Personal BrainZ
FILES=()
FILES+=("empty")
FILES+=("/home/umen/SyNc/Brain/MD/languages/ไทย.md")
FILES+=("$HOME/.PopUpLearn/DB/LANGUAGE/CN/hsk/hsk1/ALL/HSK1_PI_en.pul")

echo -e "\e[0;100m 0) \e[97;42m GameScript Quizzes [for `cat ~/.GameScript/username`] \e[0m"
arraylength=${#FILES[@]}
for (( i=1; i<${arraylength}; i++ )); do
	  echo -en "\e[0;100m $i) \e[97;42m ${FILES[i]} \e[0m"
	  LAST_DAY=`cat $HOME/.PopUpLearn/logs/*/*/*/*/*/session_$i/answer.good.date 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
	  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
	  DAYS=`expr $TODAY - $LAST_DAY 2>/dev/null`
	  if [ "$DAYS" ]; then
		echo " $DAYS days ago"
	  else
		echo " never"
	  fi
done
selected=99
echo -e "\\e[0;100m e) \\e[0m exit"
while :; do
	echo -en "\e[97;45m # \e[0m"
	read selected < /dev/tty
	case $selected in
		e) exit ;;
		0) echo -e "\n====> GameScript [`cat ~/.GameScript/username`]"; break ;;
		[0-9]*) echo -e "\n====> ${FILES[selected]}"; break ;;
		*) test "$selected" -le "$SESSION_SIZE" && break ;;
	esac
done
FILE=${FILES[selected]}
#SPLIT CONTENT FROM .pul FILE AND CONFIG + source
cat $FILE | grep "^#!#" | sed 's/^#!#//' > $HOME/.PopUpLearn/tmp/session_specific_config.tmp
source $HOME/.PopUpLearn/tmp/session_specific_config.tmp
echo "$HOME/.PopUpLearn/tmp/session_specific_config.tmp :"
cat $HOME/.PopUpLearn/tmp/session_specific_config.tmp
echo
FILENAME="`echo "$FILE"|sed 's#.*/##'`"	

function session_menu(){
	while [ -d "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/" ]; do
		SESSION_NUMBER=`expr $SESSION_NUMBER + 1`
	done
	if [ $SESSION_NUMBER -gt 1 ];then
		echo "- WORK ON A SESSION OR START A NEW ONE ?"
	else	
		echo "- DO YOU WANT TO START A NEW SESSION ?"
	fi
	ARG=0
	while [ $ARG -ne `expr $SESSION_NUMBER - 1` ]; do
	  ARG=`expr $ARG + 1`
	  echo -en "\e[0;100m $ARG) \e[97;42m Session $ARG \e[0m ["
	  cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/session_content.pul" | sed 's/.*£//' | tr '\n' '|' | sed 's/|$//'
	  echo -n "] : last good answer was "
	  LAST_DAY=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" | sed 's/.*€//' | sort -n | tail -n 1`
	  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
	  echo "`expr $TODAY - $LAST_DAY` days ago (`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null|wc -l` bad, `cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null|wc -l` good)"
	done
	selected=99
	echo -e "\\e[0;100m n) \\e[0m new session"
	echo -e "\\e[0;100m e) \\e[0m exit"
	while :; do
		echo -en "\e[97;45m # \e[0m"
		read selected < /dev/tty
		case $selected in
			e) break ;;
			n) break ;;
			[0-9]*) SESSION_NUMBER=$selected; break ;;
			*) test "$selected" -le "$SESSION_SIZE" && break ;;
		esac
	done
}

#IF SESSION EXIST, ASK TO LEARN MORE ABOUT A SPECIFIC SESSION ???
#PUT SAME VARIABLES INTO 
SESSION_SIZE=5
SESSION_NUMBER=1
if [ $ANSWER_BEFORE_QUIZ -eq 1 ];then
	while [ 1 ]; do
		session_menu
		if [[ "$selected" == "e" ]]; then
			exit 2
		elif [[ "$selected" == "n" ]]; then
			session_new
		else
			session_old $selected
		fi
		#~ $HOME/.PopUpLearn/tmp/session_specific_config.tmp ??? what is it doing here
	done
else
	quiz_only
fi

#GOAL only one comparison of ANSWER_BEFORE_QUIZ ???
#Rename ANSWER_BEFORE_QUIZ into SESSION ?
