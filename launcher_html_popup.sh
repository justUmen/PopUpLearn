#!/bin/bash

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
FILE="$HOME/.PopUpLearn/DB/fr/GS/bash/_1-11.pul"
#~ FILE="$HOME/.PopUpLearn/DB/LANGUAGE/CN/hsk/hsk1/ALL/HSK1_PI_en.pul"

#Personal BrainZ
#~ FILE="/home/umen/SyNc/Brain/MD/languages/ไทย.md"

#~ LANGUAGE_1="fr"
#~ LANGUAGE_2="fr"
#~ SUBJECT="bash"
#~ NUMBER="1"
#~ TYPE="TEXT" #TEXT for typing answer, BUTTON for a list of answers
#~ FILE="$HOME/SyNc/Projects/Wallpaper_Generator/DB/$LANGUAGE/$SUBJECT/_$NUMBER.txt"

#SPLIT CONTENT FROM .pul FILE AND CONFIG + source
cat $FILE | grep -v "^#!#" | sed '/^$/d' | sed 's/ |=| /£/' | sed 's/^\t//' | sed 's/^[\t]*//' | sed 's/^[ ]*//' | sed 's/[ ]*$//' | grep '£' > $HOME/.PopUpLearn/tmp/file_content.tmp #Remove empty lines if any
cat $FILE | grep "^#!#" | sed 's/^#!#//' > $HOME/.PopUpLearn/tmp/file_specific_config.tmp
source $HOME/.PopUpLearn/tmp/file_specific_config.tmp

while [ 1 ]; do
	# PREPARE LOGS SYSTEM ??? ADD DATE TO THIS
	TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
	FILENAME="`echo "$FILE"|sed 's#.*/##'`"
	MISTAKE=0
	mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/" 2> /dev/null
	ANSWERED_GOOD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.good"
	ANSWERED_GOOD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.good.date"
	ANSWERED_BAD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.bad"
	ANSWERED_BAD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/answer.bad.date"
	#~ LEARNED="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/`echo "$FILE"|sed 's#.*/##'`.learned"
	#CREATE $LEARNED IF answer.good more than X times ???
	
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
	echo "$LINE"
	
	LEFT=`echo "$LINE" | sed 's/£.*//'`
	RIGHT=`echo "$LINE" | sed 's/.*£//'`
	echo "$LEFT"
	echo "$RIGHT"

	#85:hsk1_PI:hànyǔ:mandarin_chinese:13:2 (my_line.tmp)
	echo "0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}" > $HOME/.PopUpLearn/tmp/my_line.tmp
	
	#~ echo " -- $TYPE -- "

	#Prepare "wrong_answers_BUTTON.tmp" for popup_quiz if TYPE is BUTTON
	if [[ "$TYPE" == "BUTTON" ]];then
		rm $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
		while read line; do
			left=`echo $line | sed 's/£.*//'`
			right=`echo $line | sed 's/.*£//'`
			if [[ "$left" != "$LEFT" ]] || [[ "$right" != "$RIGHT" ]];then
				echo "$right" >> $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
			fi
		done < "$HOME/.PopUpLearn/tmp/file_content.tmp"
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
		if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE; fi
sleep $SEC_BEFORE_QUIZ
	fi

	# 3 - WAIT AND QUIZ
	quizzed=0
	while [ $LOOP_QUIZ -ne $quizzed ]; do
		quizzed=`expr $quizzed + 1`
		waited=1
		if [ $SIGSTOP_MPV -eq 1 ]; then
			sleep 3 && $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE &
		fi
		sleep 3 && i3-msg workspace "Learn" &
#Unknown if python3 is closed without answering
echo unknown > $HOME/.PopUpLearn/tmp/result.tmp
		python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ
		i3-msg workspace back_and_forth #What about others wm ?
		if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE; fi


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
		#WAIT ONE MORE "$SEC_BEFORE_QUIZ" EVERY LOOP (q/w : 1/0 , 1/1 , 1/2 , 1/3 , 1/4 ...)
		#~ while [ $waited -ne $quizzed ]; do
			#~ sleep $SEC_BEFORE_QUIZ
			#~ waited=`expr $waited + 1`
		#~ done

	done

	# 4 - MOVE TO LEARNED IF NO NMISTAKE IN THE WHOLE SERIES ()
	#~ ${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}"
	#~ if [ $MISTAKE -eq 0 ];then
		#~ echo "$LINE" >> $LEARNED
	#~ fi

	sleep $SEC_AFTER_QUIZ
done < "$HOME/.PopUpLearn/tmp/file_content.tmp"
