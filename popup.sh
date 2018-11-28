#!/bin/bash
function keyboard_language_change(){
	command -v ibus >/dev/null 2>&1 || return
	sleep 5 && ibus engine > $HOME/.PopUpLearn/tmp/ibus.tmp
	case $LANGUAGE_2 in
		en) ibus engine xkb:us::eng; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/usa.jpg "xkb:us::eng" ;;
		th) ibus engine libthai; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/thai.jpg "libthai" ;;
		jp) ibus engine anthy; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/japan.jpg "anthy" ;;
		cn) ibus engine pinyin; notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/china.jpg "pinyin" ;;
	esac
}
function keyboard_language_previous_one(){
	command -v ibus >/dev/null 2>&1 || return
	ibus engine `cat $HOME/.PopUpLearn/tmp/ibus.tmp`
}
function mpv_pause(){
	echo "{ \"command\": [\"set_property\", \"pause\", true] }" | socat - /tmp/mpvsocket &> /dev/null
}
function mpv_play(){
	echo "{ \"command\": [\"set_property\", \"pause\", false] }" | socat - /tmp/mpvsocket &> /dev/null
}
function loop_quiz(){
	quizzed=0
	while [ $1 -ne $quizzed ]; do
		quizzed=`expr $quizzed + 1`
		waited=1
		if [ $SIGSTOP_MPV -eq 1 ]; then
			sleep 5 && mpv_pause &> /dev/null &
		fi
		#Unknown if python3 is closed without answering
		echo unknown > $HOME/.PopUpLearn/tmp/result.tmp

		sleep 5 && i3-msg workspace "Learn" &
		keyboard_language_change &
		surf -F http://127.0.0.1:9999/popup_quiz.php &> /dev/null
		#~ python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ &> /dev/null
		keyboard_language_previous_one

		i3-msg workspace back_and_forth #What about others wm ?
		if [ $SIGSTOP_MPV -eq 1 ]; then mpv_play &> /dev/null; fi
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
	if [ $SIGSTOP_MPV -eq 1 ]; then sleep 5 && mpv_pause &> /dev/null & fi
	if [ "$TIME_DISPLAYED" == 0 ];then #LOCK, unlimited
		sleep 5 && i3-msg workspace "Learn" &
		surf -F http://127.0.0.1:9999/popup.php &> /dev/null
		i3-msg workspace back_and_forth #What about others wm ?
	else
		sleep 5 && i3-msg workspace "Learn" &
		surf -F http://127.0.0.1:9999/popup.php &> /dev/null &
		sleep $TIME_DISPLAYED
		pkill -f "surf -F http://127.0.0.1:9999/popup.php" &> /dev/null
		i3-msg workspace back_and_forth #What about others wm ?
	fi
	if [ $SIGSTOP_MPV -eq 1 ]; then mpv_play &> /dev/null; fi
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
function quiz_only(){ #OBSOLETE ?
	create_file_content_tmp
	#~ check_needed_variables
	while [ 1 ]; do
	echo "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/"
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
		#~ echo $LINE
		if [ "$LINE" == "" ]; then
			notify-send "You know everything about $FILE, restart from start... ???"
			#~ exit
			return
			#~ cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
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
				sleep 5 && mpv_pause 2> /dev/null &
			fi
			sleep 5 && i3-msg workspace "Learn" &
			#Unknown if python3 is closed without answering
			echo unknown > $HOME/.PopUpLearn/tmp/result.tmp
			#~ python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ
			surf -F http://127.0.0.1:9999/popup_quiz.php
			i3-msg workspace back_and_forth #What about others wm ?
			if [ $SIGSTOP_MPV -eq 1 ]; then mpv_play &> /dev/null; fi

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
				notify-send -i $HOME/.PopUpLearn/img/unknown.png "You need to answer something... Legal authorities have been informed of this misbehaviour. The dissident will be chased and prosecuted according to the law."
			fi
			sleep $SEC_BEFORE_QUIZ
		done

		sleep $SEC_AFTER_QUIZ
	done
	 #~ < "$HOME/.PopUpLearn/tmp/file_content.tmp"
}
function display_menu_session(){
	while [ -d "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/" ]; do
		SESSION_NUMBER=`expr $SESSION_NUMBER + 1`
	done
	NB_SESSION=$SESSION_NUMBER
	if [ $SESSION_NUMBER -gt 1 ];then
		echo -e "\t- WORK ON A SESSION OR START A NEW ONE ?"
	else
		echo -e "\t- DO YOU WANT TO START A NEW SESSION ?"
	fi
	ARG=0
	while [ $ARG -ne `expr $SESSION_NUMBER - 1` ]; do
	  ARG=`expr $ARG + 1`
	  echo -en "\t\e[0;100m $ARG) \e[97;42m Session $ARG \e[0m ["
	  cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/session_content.pul" 2>/dev/null | sed 's/.*£//' | tr '\n' '|' | sed 's/^/|/' > "$HOME/.PopUpLearn/tmp/list_answers.tmp"
	  LAST_DAY=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
	  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
	  LAST_GOOD_ANSWER=""
	  ERROR_TEST=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null | tail -n 1`
	  if [[ "$LAST_DAY" != "" ]]; then
		LAST_GOOD_ANSWER=": last good answer was `expr $TODAY - $LAST_DAY ` days ago (`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null|wc -l` bad, `cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null|wc -l` good)"
	  fi
	  if [[ "$ERROR_TEST" != "" ]]; then
		cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2> /dev/null | sed 's/.*£//' | sed 's/€.*//' > "$HOME/.PopUpLearn/tmp/list_mistakes.tmp"
		while read mistake; do
			sed -i "s/|$mistake|/|\\\e[0;101m$mistake\\\e[0m|/" "$HOME/.PopUpLearn/tmp/list_answers.tmp"
		done < "$HOME/.PopUpLearn/tmp/list_mistakes.tmp"
	  fi
	  echo -en $(cat "$HOME/.PopUpLearn/tmp/list_answers.tmp")
	  echo -n "] "
	  echo $LAST_GOOD_ANSWER
	done
	selected=99
	echo -e "\t\\e[0;100m n) \\e[0m New session"
	echo -e "\t\\e[0;100m N) \\e[0m New sessions (infinite loop of a new session)"
	#~ echo -e "\t\\e[0;100m s) \\e[0m All questions from all sessions [not yet implemented]"
	#~ echo -e "\t\\e[0;100m q) \\e[0m All questions from the file [not yet implemented]"
	#~ echo -e "\t\\e[0;100m m) \\e[0m All mistakes from all sessions [not yet implemented]"
	echo -e "\t\\e[0;100m e) \\e[0m Return"
	while :; do
		echo -en "\t\e[97;45m # \e[0m"
		read selected < /dev/tty
		case $selected in
			e) return ;;
			n) break ;;
			N) break ;;
			a) break ;;
			[0-9]*) SESSION_NUMBER=$selected; test "$selected" -le "`expr $NB_SESSION - 1`" && break ;;
		esac
	done
}

function ⬚_before_start(){
	command -v surf -F >/dev/null 2>&1 || { echo "Veuillez installer les dépendances requises. Faites en tant qu'administrateur : apt-get install surf" >&2; exit 3; }
	exec 6<>/dev/tcp/127.0.0.1/9999 && echo "php server available on port 9999" || { echo "Please run the php server with : php -S 127.0.0.1:9999 -t ~/.PopUpLearn" && exec 6>&- && exec 6<&- && exit; }
	exec 6<>/dev/tcp/127.0.0.1/8888 && echo "nodejs server available on port 8888" || { echo "Please run the nodejs server with : node ~/.PopUpLearn/node_server.js || nodejs ~/.PopUpLearn/node_server.js" && exec 6>&- && exec 6<&- && exit; }
	touch $HOME/.PopUpLearn/MYDB/my.list
}
function ⬚⬚_start(){
	source $HOME/.GameScript/config 2> /dev/null #LANGUAGE=fr used for quiz language
	⬚⬚⬚_menu_main
	if [[ "$selected" == "g" ]]; then
		⬚⬚⬚⬚_menu_gamescript
	else
		⬚⬚⬚⬚_menu_session
	fi
}
function ⬚⬚⬚_menu_main(){
	#PREPARE
	#Personal BrainZ
	FILES=()
	FILES+=("empty")
	while read mylist;do
		FILES+=($mylist)
	done < $HOME/.PopUpLearn/MYDB/my.list

	find /home/umen/SyNc/Projects/PopUpLearn/DB -name "*.pul" > "$HOME/.PopUpLearn/tmp/list_pul.tmp"
	find /home/umen/SyNc/Projects/PopUpLearn/MYDB -name "*.pul" >> "$HOME/.PopUpLearn/tmp/list_pul.tmp"
	while read PUL; do
		FILES+=($PUL)
	done < "$HOME/.PopUpLearn/tmp/list_pul.tmp"
	#DISPLAY
	echo
	echo "Menu list all .pul files in ~/.PopUpLearn/DB/ and ~/.PopUpLearn/MYDB/ folders + manual entries from ~/.PopUpLearn/MYDB/my.list too (Full path of .pul file, one per line.)"
	arraylength=${#FILES[@]}
	for (( i=1; i<${arraylength}; i++ )); do
		  echo -en "\e[0;100m $i) \e[97;42m ${FILES[i]} \e[0m"
		  FILE_NAME=`echo ${FILES[i]} | sed 's#.*/##'`
		  FILE_PATH="$HOME/.PopUpLearn/logs/*/*/*/*/$FILE_NAME/"
		  LAST_DAY=`cat $FILE_PATH/session_*/answer.good.date 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
		  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
		  DAYS=`expr $TODAY - $LAST_DAY 2>/dev/null`
		  if [[ "$DAYS" == "" ]]; then
			echo -n " never used"
		  elif [ $DAYS -eq 0 ]; then
			echo -n " used today"
		  elif [ $DAYS -eq 1 ]; then
			echo -n " used yesterday"
		  else
			echo -n " used $DAYS days ago"
		  fi
		  NB_GOOD=`cat $FILE_PATH/session_*/answer.good 2>/dev/null|sort|uniq|wc -l`
		  NB_LINES=`cat ${FILES[i]}|wc -l`
		echo " => `expr $NB_GOOD / $NB_LINES`%"
	done
	echo -e "\e[0;100m g) \e[0m GameScript Quizzes [for `cat ~/.GameScript/username`]"
	selected=99
	echo -e "\\e[0;100m e) \\e[0m Return"
	while :; do
		echo -en "\e[97;45m # \e[0m"
		read selected < /dev/tty
		case $selected in
			e) exit ;;
			g) break ;;
			[0-9]*) test "$selected" -le "`expr $arraylength - 1`" && echo -e "\n====> ${FILES[selected]}" && break ;;
		esac
	done
}
function ⬚⬚⬚⬚_menu_gamescript(){
	SUBJECTS=();
	SUBJECTS=("empty")
	SUBJECTS+=("bash")
	#~ SUBJECTS+=("sys")
	#~ SUBJECTS+=("i3wm")
	selected=99
	echo -e "\n\tPopUpLearn + GameScript [`cat ~/.GameScript/username`]";
	arraylength=${#SUBJECTS[@]}
	for (( i=1; i<${arraylength}; i++ )); do
	  echo -en "\t\e[0;100m $i) \e[97;42m ${SUBJECTS[i]} \e[0m"
	  LIST_CHAPTERS=`ls /home/umen/.GameScript/passwords/${SUBJECTS[i]}* 2>/dev/null | sed "s#.*${SUBJECTS[i]}##" | tr '\n' ',' | sed 's/,$//'`
	  mkdir -p $HOME/.PopUpLearn/logs/GameScript/${SUBJECTS[i]} 2> /dev/null
	  LAST_DAY=`cat $HOME/.PopUpLearn/logs/GameScript/$LANGUAGE/${SUBJECTS[i]}/answer.good.date 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
	  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
	  DAYS=`expr $TODAY - $LAST_DAY 2>/dev/null`
	  if [ "$LIST_CHAPTERS" ]; then
		echo -n " [Chapters with password : $LIST_CHAPTERS]"
	  fi
	  if [ "$DAYS" ]; then
		echo " $DAYS days ago"
	  else
		echo " never used"
	  fi
	done
	#~ /home/umen/.GameScript/passwords
	echo -e "\t\\e[0;100m e) \\e[0m Return"
	while :; do
		echo -en "\t\e[97;45m # \e[0m"
		read selected < /dev/tty
		case $selected in
			e) return ;;
			0) ;;
			[0-9]*) break ;;
		esac
	done
	⬚⬚⬚⬚⬚_menu_gamescript_chapters
}
function ⬚⬚⬚⬚⬚_menu_gamescript_chapters(){
	SUBJ=${SUBJECTS[selected]}
	#LIST CHAPTERS OF SUBJECT
	ls /home/umen/.GameScript/passwords/${SUBJECTS[selected]}* 2>/dev/null | sed "s#.*$SUBJ##" > ~/.PopUpLearn/tmp/list_chapters.tmp
	rm ~/.PopUpLearn/tmp/all_chapters.tmp 2> /dev/null
	while read chapter; do
		cat ~/.PopUpLearn/DB/GS/$LANGUAGE/${SUBJECTS[selected]}/_$chapter >> ~/.PopUpLearn/tmp/all_chapters.tmp
	done < ~/.PopUpLearn/tmp/list_chapters.tmp
	echo -e "\n\t\t====> $SUBJ ($LANGUAGE) "
	CHAPTER_NUM=1
	#~ while [ -f ~/.PopUpLearn/DB/GS/$LANGUAGE/${SUBJECTS[selected]}/_$CHAPTER_NUM ];do
	while read chapter; do
		echo -en "\t\t\\e[0;100m $CHAPTER_NUM) \\e[0m $SUBJ chapter $chapter\\e[0m "

	  cat "$HOME/.PopUpLearn/DB/GS/$LANGUAGE/$SUBJ/_$chapter" 2>/dev/null | sed 's/.*£//' | tr '\n' '|' | sed 's/^/|/' | sed 's/\\\\\\\\/\\\\/g' > "$HOME/.PopUpLearn/tmp/list_answers.tmp"
	  LAST_DAY=`cat "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/$SUBJ/_$chapter/answer.good.date" 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
	  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
	  LAST_GOOD_ANSWER=""
	  ERROR_TEST=`cat "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/$SUBJ/_$chapter/answer.bad.date" 2>/dev/null | tail -n 1`
	  if [[ "$LAST_DAY" != "" ]]; then
  		LAST_GOOD_ANSWER=": last good answer was `expr $TODAY - $LAST_DAY ` days ago (`cat "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/$SUBJ/_$chapter/answer.bad.date" 2>/dev/null|wc -l` bad, `cat "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/$SUBJ/_$chapter/answer.good.date" 2>/dev/null|wc -l` good)"
	  fi
	  if [[ "$ERROR_TEST" != "" ]]; then
		cat "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/$SUBJ/_$chapter/answer.bad.date" 2> /dev/null | sed 's/.*£//' | sed 's/€.*//' > "$HOME/.PopUpLearn/tmp/list_mistakes.tmp"
		while read mistake; do
			# cat $HOME/.PopUpLearn/tmp/list_answers.tmp
			mistake2=`echo $mistake | sed 's/\\\\\\\\/\\\\\\\\\\\\\\\\/g'`
			# echo "----{$mistake}---{$mistake2}----"
			sed -i "s/|$mistake|/|\\\e[0;101m$mistake\\\e[0m|/" "$HOME/.PopUpLearn/tmp/list_answers.tmp"
			sed -i "s/|$mistake2|/|\\\e[0;101m$mistake2\\\e[0m|/" "$HOME/.PopUpLearn/tmp/list_answers.tmp"
		done < "$HOME/.PopUpLearn/tmp/list_mistakes.tmp"
		echo -en $(cat "$HOME/.PopUpLearn/tmp/list_answers.tmp")
		echo -n $LAST_GOOD_ANSWER
	  fi
	echo

		#~ if [ -e "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/${SUBJECTS[selected]}/_$chapter/answer.good" ]; then

			#~ GOOD=`cat $HOME/.PopUpLearn/logs/GS/$LANGUAGE/${SUBJECTS[selected]}/_$chapter/answer.good| wc -l`
			#~ echo " : last good answer was 4 days ago (4 bad, 7 good)"

		#~ else
			#~ echo
		#~ fi
		CHAPTER_NUM=`expr $CHAPTER_NUM + 1`
	done < ~/.PopUpLearn/tmp/list_chapters.tmp

	if [ -f "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/$SUBJ/_a/answer.bad.date" ]; then
		cat "$HOME/.PopUpLearn/logs/GS/$LANGUAGE/$SUBJ/_a/answer.bad.date" 2> /dev/null | sed 's/.*£//' | sed 's/€.*//' > "$HOME/.PopUpLearn/tmp/list_mistakes.tmp"
		echo -e "\t\t\\e[0;100m a) \\e[0m All my chapters (separate logs) $(cat "$HOME/.PopUpLearn/tmp/list_mistakes.tmp" | tr '\n' '|' | sed 's/^/Errors : |/')"
	else
		echo -e "\t\t\\e[0;100m a) \\e[0m All my chapters (separate logs)"
	fi
	
	echo -e "\t\t\\e[0;100m e) \\e[0m Return"
	while :; do
		echo -en "\t\t\e[97;45m # \e[0m"
		read selected_chapter < /dev/tty
		case $selected_chapter in
			e) return ;;
			a) break ;;
			0) ;;
			[0-9]*) break ;;
		esac
	done
	#~ echo "!!! $selected ${SUBJECTS[selected]} !!!"
	⬚⬚⬚⬚⬚⬚_quiz_gamescript
}
function ⬚⬚⬚⬚⬚⬚_quiz_gamescript(){
	SESSION_SIZE=999 #For gs, always 999
	if [[ "$selected_chapter" == "a" ]];then
		FILE="$HOME/.PopUpLearn/tmp/all_chapters.tmp"
	else
		FILE="$HOME/.PopUpLearn/DB/GS/$LANGUAGE/${SUBJECTS[selected]}/_$selected_chapter"
	fi
	create_file_content_tmp
	while read X; do
		mkdir -p "$HOME/.PopUpLearn/logs/GS/${LANGUAGE}/${SUBJECTS[selected]}/_${selected_chapter}/" 2> /dev/null
		TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
		ANSWERED_GOOD="$HOME/.PopUpLearn/logs/GS/${LANGUAGE}/${SUBJECTS[selected]}/_${selected_chapter}/answer.good"
		ANSWERED_GOOD_DATE="$HOME/.PopUpLearn/logs/GS/${LANGUAGE}/${SUBJECTS[selected]}/_${selected_chapter}/answer.good.date"
		ANSWERED_BAD="$HOME/.PopUpLearn/logs/GS/${LANGUAGE}/${SUBJECTS[selected]}/_${selected_chapter}/answer.bad"
		ANSWERED_BAD_DATE="$HOME/.PopUpLearn/logs/GS/${LANGUAGE}/${SUBJECTS[selected]}/_${selected_chapter}/answer.bad.date"
		if [ -e "$ANSWERED_GOOD" ];then
			cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | grep -F -x -v -f $ANSWERED_GOOD | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
			LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
		else
			cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
			LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
		fi
		if [ "$LINE" == "" ]; then
			# notify-send "You know everything about $FILE... but I will find something... your mistakes..."
			#~ exit
			# return
			cat $HOME/.PopUpLearn/tmp/file_content.tmp $ANSWERED_BAD $ANSWERED_BAD | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
			LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
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
				sleep 5 && mpv_pause 2> /dev/null &
			fi
			sleep 5 && i3-msg workspace "Learn" &
			#Unknown if python3 is closed without answering
			echo unknown > $HOME/.PopUpLearn/tmp/result.tmp
			#~ python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ
			surf -F http://127.0.0.1:9999/popup_quiz.php &> /dev/null
			i3-msg workspace back_and_forth #What about others wm ?
			if [ $SIGSTOP_MPV -eq 1 ]; then mpv_play &> /dev/null; fi

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
				notify-send -i $HOME/.PopUpLearn/img/unknown.png "You need to answer something... Legal authorities have been informed of this misbehaviour. The dissident will be chased and prosecuted according to the law."
			fi
			sleep $SEC_BEFORE_QUIZ
		done

		sleep $SEC_AFTER_QUIZ
	done < "$HOME/.PopUpLearn/tmp/file_content.tmp"
}
function ⬚⬚⬚⬚_menu_session(){
	FILE=${FILES[selected]}
	#SPLIT CONTENT FROM .pul FILE AND CONFIG + source
	cat $FILE | grep "^#!#" | sed 's/^#!#//' > $HOME/.PopUpLearn/tmp/session_specific_config.tmp

	source $HOME/.PopUpLearn/tmp/session_specific_config.tmp
	if [ "$SESSION_SIZE" == "" ]; then
		SESSION_SIZE=5
	fi
	if [ $SESSION_SIZE -eq 0 ]; then
		SESSION_SIZE=9999
	fi

	echo "$HOME/.PopUpLearn/tmp/session_specific_config.tmp :"
	cat $HOME/.PopUpLearn/tmp/session_specific_config.tmp
	echo
	FILENAME="`echo "$FILE"|sed 's#.*/##'`"
	#IF SESSION EXIST, ASK TO LEARN MORE ABOUT A SPECIFIC SESSION ???
	#PUT SAME VARIABLES INTO
	SESSION_NUMBER=1
	while [ 1 ]; do
		if [ "$1" != "NO_MENU" ]; then
			display_menu_session
		fi
		if [[ "$selected" == "e" ]]; then
			break
		elif [[ "$selected" == "n" ]]; then
			⬚⬚⬚⬚⬚_session_new
		elif [[ "$selected" == "N" ]]; then
			while [ 1 ];do
				⬚⬚⬚⬚⬚_session_new
				SESSION_NUMBER=`expr $SESSION_NUMBER + 1`
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"
			done
		else
			⬚⬚⬚⬚⬚_session_old $selected
		fi
	done
}
function ⬚⬚⬚⬚⬚_session_new(){
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
		test $ANSWER_BEFORE_QUIZ -eq 1 && show_good_answer
		loop_quiz $LOOP_QUIZ
		remove_answer_from_session_tmp
	done < "$HOME/.PopUpLearn/tmp/session_content.tmp"
	notify-send -i $HOME/.PopUpLearn/img/unknown.png "End of session $SESSION_NUMBER"
}
function ⬚⬚⬚⬚⬚_session_old(){
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

⬚_before_start
echo
echo "Warning : This is an early release, might not work as expected."
echo "Warning : PopUpLearn is been tested only on i3wm, so code is specific to i3. (All wms supported soon.)"
if [ $1 ]; then TIME_DISPLAYED="$1"; else TIME_DISPLAYED=0; fi #0 for infinite
if [ $2 ]; then SEC_BEFORE_QUIZ="$2"; else SEC_BEFORE_QUIZ=30; fi
if [ $3 ]; then SEC_AFTER_QUIZ="$3"; else SEC_AFTER_QUIZ=60; fi
if [ $4 ]; then SIGSTOP_MPV="$4"; else SIGSTOP_MPV=0; fi #ONLY FOR ME AS OF NOW... KEEP 0 FOR ALL
if [ $5 ]; then LANGUAGE_1="$5"; else LANGUAGE_1="xx"; fi
if [ $6 ]; then LANGUAGE_2="$6"; else LANGUAGE_2="xx"; fi
if [ $7 ]; then SUBJECT="$7"; else SUBJECT="unknown"; fi
if [ $8 ]; then NUMBER="$8"; else NUMBER="unknown"; fi
if [ $9 ]; then TYPE="$9"; else TYPE="TEXT"; fi
if [ $10 ]; then ANSWER_BEFORE_QUIZ="$10"; else ANSWER_BEFORE_QUIZ=1; fi
if [ $11 ]; then LOOP_QUIZ="$11"; else LOOP_QUIZ=3; fi
while [ 1 ];do ⬚⬚_start; done
