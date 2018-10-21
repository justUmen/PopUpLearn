#!/bin/bash

#EXIT IF SERVER IS NOT RUNNING (php -S 127.0.0.1:9999 -t $HOME/.PopUpLearn)
#https://stackoverflow.com/questions/9609130/efficiently-test-if-a-port-is-open-on-linux-without-nmap-or-netcat#9609247
exec 6<>/dev/tcp/127.0.0.1/9999 \
	&& echo "php server available on port 9999" \
	|| { echo "Please run the php server with : php -S 127.0.0.1:9999 -t ~/.PopUpLearn" && exec 6>&- && exec 6<&- && exit; }

exec 6<>/dev/tcp/127.0.0.1/8888 \
	&& echo "nodejs server available on port 8888" \
	|| { echo "Please run the nodejs server with : node ~/.PopUpLearn/node_server.js || nodejs ~/.PopUpLearn/node_server.js" && exec 6>&- && exec 6<&- && exit; }

if [ $1 ]; then TIME_DISPLAYED=$1; else TIME_DISPLAYED=0; fi #0 for infinite
if [ $2 ]; then SEC_BEFORE_QUIZ=$2; else SEC_BEFORE_QUIZ=30; fi
if [ $3 ]; then SEC_AFTER_QUIZ=$3; else SEC_AFTER_QUIZ=60; fi
if [ $4 ]; then SIGSTOP_MPV=$4; else SIGSTOP_MPV=0; fi #ONLY FOR ME AS OF NOW... KEEP 0

FILE="$HOME/.PopUpLearn/DB/fr/GS/bash/_1-11.pul"

#~ LANGUAGE_1="fr"
#~ LANGUAGE_2="fr"
#~ SUBJECT="bash"
#~ NUMBER="1"
#~ TYPE="TEXT" #TEXT for typing answer, BUTTON for a list of answers
#~ FILE="$HOME/SyNc/Projects/Wallpaper_Generator/DB/$LANGUAGE/$SUBJECT/_$NUMBER.txt"

#~ LANGUAGE_1="PI"
#~ LANGUAGE_2="en"
#~ SUBJECT="hsk"
#~ NUMBER="1"
#~ TYPE="BUTTON"
#~ FILE="$HOME/SyNc/Projects/PopUpLearn/DB/LANGUAGE/CN/hsk/hsk1/ALL/HSK1_PI_en"

#SPLIT CONTENT FROM .pul FILE AND CONFIG + source
cat $FILE | grep -v "^#" > $HOME/.PopUpLearn/tmp/file_content.tmp
cat $FILE | grep "^#" | sed 's/^#//' > $HOME/.PopUpLearn/tmp/file_specific_config.tmp
source $HOME/.PopUpLearn/tmp/file_specific_config.tmp

while [ 1 ]; do

	# 1 - CHOOSE LINE FROM $FILE (RANDOM ?) AND REMOVE SOMETHING THAT IS ALREADY LEARNED
	LINE=`cat $HOME/.PopUpLearn/tmp/file_content.tmp | sort -R | tail -n 1`
	LEFT=`echo $LINE | sed 's/£.*//'`
	RIGHT=`echo $LINE | sed 's/.*£//'`
	#85:hsk1_PI:hànyǔ:mandarin_chinese:13:2 (my_line.tmp)
	echo "0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}" > $HOME/.PopUpLearn/tmp/my_line.tmp

	#Prepare "wrong_answers_BUTTON.tmp" for popup_quiz if TYPE is BUTTON
	if [[ "$TYPE" == "BUTTON" ]];then
		rm $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
		while read line; do
			left=`echo $line | sed 's/£.*//'`
			right=`echo $line | sed 's/.*£//'`
			if [[ "$left" != "$LEFT" ]] || [[ "$right" != "$RIGHT" ]];then
				echo "$right" >> $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
			fi
		done < "$HOME/.PopUpLearn/tmp/content.tmp"
	fi
	
	# 2 - SHOW ANSWER
	if [ $ANSWER_BEFORE_QUIZ -eq 1 ];then
		if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE; fi
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
		if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh PAUSE; fi
		sleep 3 && i3-msg workspace "Learn" &
		python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ
		i3-msg workspace back_and_forth #What about others wm ?
		if [ $SIGSTOP_MPV -eq 1 ]; then $HOME/SyNc/Scripts/System/toggle_mpv_mpc.sh UNPAUSE; fi

if [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "good" ]];then
	notify-send -i $HOME/.PopUpLearn/img/good.png "$LEFT : $RIGHT ($quizzed/$LOOP_QUIZ)"
else
	notify-send -i $HOME/.PopUpLearn/img/bad.png "$LEFT : $RIGHT ($quizzed/$LOOP_QUIZ)"
fi
		
		sleep $SEC_BEFORE_QUIZ
		#WAIT ONE MORE "$SEC_BEFORE_QUIZ" EVERY LOOP (q/w : 1/0 , 1/1 , 1/2 , 1/3 , 1/4 ...)
		#~ while [ $waited -ne $quizzed ]; do
			#~ sleep $SEC_BEFORE_QUIZ
			#~ waited=`expr $waited + 1`
		#~ done

	done

	# 4 - MOVE TO LEARNED
	# ...
	
	sleep $SEC_AFTER_QUIZ
done < "$HOME/.PopUpLearn/tmp/file_content.tmp"
