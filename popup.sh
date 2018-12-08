#!/bin/bash
#~ 🔧 : debug information
#~ 📃 : interactive menu
#~ 💻 : change something on the system
#~ 🔄 : loop that needs to be exited
#~ 🛑 : end loop
#~ 🔄🔄 : infinite loop
#~ 📗 : start a new type
#~ 🏗 : create files
#~ 🚧 : prepare variables
#~ 🔀 : conditional if
#~ 🔢 : take argument
#~ 💣 : remove from file
#~ 🌐 : surf popup
#~ 🌘 : used for new session only

function 🔧(){
	echo -e "$BG_LIGHT_GRAY$BLACK 🔧 $@ 🔧 $ENDO"
}
function 💻_keyboard_language_change(){ 🔧 $FUNCNAME $@
	command -v ibus >/dev/null 2>&1 || return
	ibus engine > $HOME/.PopUpLearn/tmp/ibus.tmp
	CURRENT_LANGUAGE=`cat $HOME/.PopUpLearn/tmp/ibus.tmp`
	sleep 5
	case $LANGUAGE_2 in
		en)
		NEW_LANGUAGE="xkb:us::eng"
		echo $NEW_LANGUAGE > $HOME/.PopUpLearn/tmp/ibus_new.tmp
		echo "$CURRENT_LANGUAGE != $NEW_LANGUAGE"
		if [[ "$CURRENT_LANGUAGE" != "$NEW_LANGUAGE" ]]; then
			ibus engine xkb:us::eng
			notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/usa.jpg "xkb:us::eng"
		fi
		;;
		th)
		NEW_LANGUAGE="libthai"
		echo $NEW_LANGUAGE > $HOME/.PopUpLearn/tmp/ibus_new.tmp
		if [[ "$CURRENT_LANGUAGE" != "$NEW_LANGUAGE" ]]; then
			ibus engine libthai
			notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/thai.jpg "libthai"
		fi
		;;
		jp)
		NEW_LANGUAGE="anthy"
		echo $NEW_LANGUAGE > $HOME/.PopUpLearn/tmp/ibus_new.tmp
		if [[ "$CURRENT_LANGUAGE" != "$NEW_LANGUAGE" ]]; then
			ibus engine anthy
			notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/japan.jpg "anthy"
		fi
		;;
		cn)
		NEW_LANGUAGE="pinyin"
		echo $NEW_LANGUAGE > $HOME/.PopUpLearn/tmp/ibus_new.tmp
		if [[ "$CURRENT_LANGUAGE" != "$NEW_LANGUAGE" ]]; then
			ibus engine pinyin
			notify-send -i /home/umen/SyNc/Scripts/System/FLAGS/china.jpg "pinyin"
		fi
		;;
	esac
}
function 💻_keyboard_language_previous_one(){ 🔧 $FUNCNAME $@
	command -v ibus >/dev/null 2>&1 || return
	NEW_LANGUAGE=$(cat $HOME/.PopUpLearn/tmp/ibus_new.tmp)
	CURRENT_LANGUAGE=$(cat $HOME/.PopUpLearn/tmp/ibus.tmp)
	if [[ "$NEW_LANGUAGE" != "$CURRENT_LANGUAGE" ]]; then
		ibus engine `cat $HOME/.PopUpLearn/tmp/ibus.tmp`
	fi
}
function 💻_mpv_pause(){ 🔧 $FUNCNAME $@
	echo "{ \"command\": [\"set_property\", \"pause\", true] }" | socat - /tmp/mpvsocket &> /dev/null
}
function 💻_mpv_play(){ 🔧 $FUNCNAME $@
	echo "{ \"command\": [\"set_property\", \"pause\", false] }" | socat - /tmp/mpvsocket &> /dev/null
}
function display(){ 🔧 $FUNCNAME $@
	echo
}

function ⬚_before_start(){
	command -v surf -F >/dev/null 2>&1 || { echo "Veuillez installer les dépendances requises. Faites en tant qu'administrateur : apt-get install surf" >&2; exit 3; }
	exec 6<>/dev/tcp/127.0.0.1/9999 && echo "php server available on port 9999" || { echo "Please run the php server with : php -S 127.0.0.1:9999 -t ~/.PopUpLearn" && exec 6>&- && exec 6<&- && exit; }
	exec 6<>/dev/tcp/127.0.0.1/8888 && echo "nodejs server available on port 8888" || { echo "Please run the nodejs server with : node ~/.PopUpLearn/node_server.js || nodejs ~/.PopUpLearn/node_server.js" && exec 6>&- && exec 6<&- && exit; }
	mkdir $HOME/.PopUpLearn/MYDB 2> /dev/null
	touch $HOME/.PopUpLearn/MYDB/my.list
	mkdir $HOME/.PopUpLearn/tmp 2> /dev/null
	#PREPARE BACKGROUND COLORS
	ENDO="\e[0m"
	BG_BLUE="\e[44m"
	BG_BLACK="\e[40m"
	BG_LIGHT_GRAY="\e[107m"
	BG_LIGHT_MAGENTA="\e[105m"
	BG_LIGHT_GREEN="\e[102m"
	#PREPARE MENU COLORS
	BLACK="\e[30m"
	COLOR_SELECTION="$BG_LIGHT_MAGENTA$BLACK"
	COLOR_TITLE_SELECTED="$BG_LIGHT_GREEN$BLACK"
	#PREPARE COLORS QUESTIONS / ANSWERS ONLY !!! DIFFERENT FORMAT
	END="\\\e\[0m"
	GREY="\\\e\[38;5;59m" #GOOD 2+ / BAD 0
	BLUE="\\\e\[38;5;33m" #GOOD 0
	DARK_BLUE="\\\e\[38;5;25m" #GOOD 1
	YELLOW="\\\e\[38;5;184m" #BAD 1
	ORANGE="\\\e\[38;5;202m" #BAD 2
	RED="\\\e\[38;5;196m" #BAD AT LEAST 3
	🔧 $FUNCNAME $@ #HERE TO DISPLAY COLORS PROPERLY :P
}
function ⬚_🔄🔄_start(){ 🔧 $FUNCNAME $@
	while [ 1 ]; do
		source $HOME/.GameScript/config 2> /dev/null #LANGUAGE=fr used for quiz language
		#source $HOME/.PopUpLearn/my.config is launched later to replace other specific configurations
		⬚⬚_📃_main
		if [[ "$selected" == "g" ]]; then
			if [ -d "$HOME/.GameScript" ];then
				⬚⬚⬚_🔄🔄_gamescript
			else
				echo
				echo "$HOME/.GameScript n'existe pas..."
				echo
			fi
		else
			⬚⬚⬚_🔄🔄_session
		fi
	done
}
function ⬚⬚_📃_main(){ 🔧 $FUNCNAME $@
	#Prepare .pul files in DB and MYDB
	FILES=()
	FILES+=("empty")
	while read mylist;do
		FILES+=($mylist)
	done < $HOME/.PopUpLearn/MYDB/my.list
	find $HOME/.PopUpLearn/DB -name "*.pul" > "$HOME/.PopUpLearn/tmp/list_pul.tmp"
	find $HOME/.PopUpLearn/MYDB -name "*.pul" >> "$HOME/.PopUpLearn/tmp/list_pul.tmp"
	while read PUL; do
		FILES+=($PUL)
	done < "$HOME/.PopUpLearn/tmp/list_pul.tmp"
	#DISPLAY LIST .pul FILES
	echo
	echo "Menu list all .pul files in ~/.PopUpLearn/DB/ and ~/.PopUpLearn/MYDB/ folders + manual entries from ~/.PopUpLearn/MYDB/my.list too (Full path of .pul file, one per line.)"
	arraylength=${#FILES[@]}
	for (( i=1; i<${arraylength}; i++ )); do
		echo -en "$COLOR_SELECTION $i) $COLOR_TITLE_SELECTED ${FILES[i]} $ENDO"
		FILE_NAME=`echo ${FILES[i]} | sed 's#.*/##'`
		FILE_PATH="$HOME/.PopUpLearn/logs/*/*/*/*/$FILE_NAME/" # */* ???
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
	echo -e "$COLOR_SELECTION g) $ENDO GameScript Quizzes [for `cat ~/.GameScript/username`]"
	selected=99
	echo -e "$COLOR_SELECTION e) $ENDO Exit"
	while :; do
		echo -en "\e[97;45m # $ENDO"
		read selected < /dev/tty
		case $selected in
			e) exit ;;
			g) break ;;
			[0-9]*) test "$selected" -le "`expr $arraylength - 1`" && break ;;
		esac
	done
	🔧 "$FUNCNAME : \$selected=$selected"
}
function ⬚⬚⬚_🔄🔄_gamescript(){ 🔧 $FUNCNAME $@
	while [ 1 ]; do
		⬚⬚⬚⬚_📃_gamescript || return 2
		⬚⬚⬚⬚_📃_gamescript_chapters || return 2
		⬚⬚⬚⬚_📗_gamescript || return 2
	done
}
function ⬚⬚⬚⬚_📃_gamescript(){ 🔧 $FUNCNAME $@
	SUBJECTS=();
	SUBJECTS=("empty")
	SUBJECTS+=("bash")
	#~ SUBJECTS+=("sys")
	#~ SUBJECTS+=("i3wm")
	selected=99
	echo -e "\n\tPopUpLearn + GameScript [`cat ~/.GameScript/username`]";
	arraylength=${#SUBJECTS[@]}
	for (( i=1; i<${arraylength}; i++ )); do
		echo -en "\t$COLOR_SELECTION $i) $COLOR_TITLE_SELECTED ${SUBJECTS[i]} $ENDO"
		LIST_CHAPTERS=`ls $HOME/.GameScript/passwords/${SUBJECTS[i]}* 2>/dev/null | sed "s#.*${SUBJECTS[i]}##" | tr '\n' ',' | sed 's/,$//'`
		mkdir -p $HOME/.PopUpLearn/logs/GameScript/${SUBJECTS[i]} 2> /dev/null
		LAST_DAY=`cat $HOME/.PopUpLearn/logs/${LANGUAGE}/${LANGUAGE}/GameScript/1/${SUBJECTS[i]}/session_*/answer.good.date 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
		TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
		DAYS=`expr $TODAY - $LAST_DAY 2>/dev/null`
		if [ "$LIST_CHAPTERS" ]; then
			echo -n " [Chapters with password : $LIST_CHAPTERS]"
		fi
		if [ "$DAYS" ]; then
			if [[ "$DAYS" == "0" ]];then
				echo " used today"
			elif [[ "$DAYS" == "1" ]];then
				echo " used yesterday"
			else
				echo " used $DAYS days ago"
			fi
		else
		echo " never used"
		fi
	done
	echo -e "\t$COLOR_SELECTION e) $ENDO Return"
	while :; do
		echo -en "\t\e[97;45m # $ENDO"
		read selected < /dev/tty
		case $selected in
			e) return 2 ;;
			0) ;;
			[0-9]*) break ;;
		esac
	done
	🔧 "$FUNCNAME : \$selected=$selected, \${SUBJECTS[i]}=${SUBJECTS[i]}"
}
function ⬚⬚⬚⬚_📃_gamescript_chapters(){ 🔧 $FUNCNAME $@
	LANGUAGE_1=$LANGUAGE
	LANGUAGE_2=$LANGUAGE
	SUBJECT=GameScript
	FILENAME=${SUBJECTS[selected]}
	NUMBER=1
	SESSION_NUMBER=${selected}
	echo
	echo " - Warning : here sessions are chapters (unlock chapter's password on GameScript to use them here)"
	echo " - Warning : dates are recorded but are not yet used to organize and optimize your learning experience. (In future versions, the text will change colors depending of when it was answered.)"
	echo -e "
	\e[4mCOLORS LEGEND :$ENDO
		\e[38;5;59mGREY$ENDO : Good 2+ times or Bad 0 (user can ignore knowledge in grey)
		\e[38;5;33mBLUE$ENDO : Good 0 (user need to do this session until \e[38;5;59mGREY$ENDO)
		\e[38;5;25mDARK_BLUE$ENDO : Good 1 time (user need to do this session until \e[38;5;59mGREY$ENDO)
		\e[38;5;226mYELLOW$ENDO : Bad 1 time
		\e[38;5;202mORANGE$ENDO : Bad 2 times
		\e[38;5;196mRED$ENDO : Bad 3+ times (user need to focus on this)
	"

	SESSION_NUMBER=1
	while [ -f "$HOME/.GameScript/passwords/$FILENAME$SESSION_NUMBER" ]; do #
		SESSION_NUMBER=`expr $SESSION_NUMBER + 1`
		mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/"
		cat $HOME/.PopUpLearn/DB/GameScript/$LANGUAGE/$FILENAME/_$SESSION_NUMBER > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	done

	NB_SESSION=$SESSION_NUMBER
	ARG=0
	while [ $ARG -ne `expr $SESSION_NUMBER - 1` ]; do
	  ARG=`expr $ARG + 1`
	  echo -en "\t$COLOR_SELECTION $ARG) $COLOR_TITLE_SELECTED Chapter $ARG $ENDO "
	  cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/session_content.pul" 2>/dev/null > "$HOME/.PopUpLearn/tmp/list_lines.tmp"
	  LAST_DAY=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
	  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
	  LAST_GOOD_ANSWER=""
	  if [[ "$LAST_DAY" != "" ]]; then
			LAST_GOOD_ANSWER="last good answer was `expr $TODAY - $LAST_DAY ` days ago (`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null|wc -l` bad, `cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null|wc -l` good)"
	  fi
	  echo -e $LAST_GOOD_ANSWER
		#BAD (Not print if nothing bad)
	  ERROR_TEST=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null | tail -n 1`
	  if [[ "$ERROR_TEST" != "" ]]; then
			cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad" 2> /dev/null > "$HOME/.PopUpLearn/tmp/list_mistakes.tmp"
			cat "$HOME/.PopUpLearn/tmp/list_lines.tmp" "$HOME/.PopUpLearn/tmp/list_mistakes.tmp" | sort | uniq -c | sed "s#^ \+1 \+\(.*\)#$GREY[\1]$END#" | sed "s#^ \+2 \+\(.*\)#$YELLOW[\1]$END#" | sed "s#^ \+3 \+\(.*\)#$ORANGE[\1]$END#" | sed "s#^ \+[0-9]\+ \+\(.*\)#$RED[\1]$END#" > "$HOME/.PopUpLearn/tmp/display_mistakes.tmp"
			echo -en "\t\t  BAD : "
			echo -e $(cat "$HOME/.PopUpLearn/tmp/display_mistakes.tmp" | sed 's/£/ :: /')
	  fi
		#GOOD (Not print if all good : ALL_GOOD=0)
	  GOOD_TEST=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null | tail -n 1`
	  if [[ "$GOOD_TEST" != "" ]]; then
			ALL_GOOD=$(expr `wc -l "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date"|sed 's/ .*//'` - `wc -l "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/session_content.pul"|sed 's/ .*//'`)
			if [[ "$ALL_GOOD" == "0" ]]; then
				cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good" 2> /dev/null > "$HOME/.PopUpLearn/tmp/list_correct.tmp"
				cat "$HOME/.PopUpLearn/tmp/list_lines.tmp" "$HOME/.PopUpLearn/tmp/list_correct.tmp" | sort | uniq -c | sed "s#^ \+1 \+\(.*\)#$BLUE[\1]$END#" | sed "s#^ \+2 \+\(.*\)#$DARK_BLUE[\1]$END#" | sed "s#^ \+[0-9]\+ \+\(.*\)#$GREY[\1]$END#" > "$HOME/.PopUpLearn/tmp/display_correct.tmp"
				echo -en "\t\t GOOD : "
				echo -e $(cat "$HOME/.PopUpLearn/tmp/display_correct.tmp" | sed 's/£/ :: /')
			fi
	  else
			echo -en "\t\t GooD : "
			echo -e $(cat "$HOME/.PopUpLearn/tmp/list_lines.tmp" | sed "s#^\(.*\)#$BLUE[\1]$END#" | sed 's/£/ :: /')
	  fi
	done
	selected=99
	#~ echo -e "\t$COLOR_SELECTION n) $ENDO New session"
	#~ echo -e "\t$COLOR_SELECTION N) $ENDO New sessions (infinite loop of a new session)"
	echo -e "\t$COLOR_SELECTION s) $ENDO All questions from all current chapters (chapter random order) - NOT SHOW ANSWER"
	echo -e "\t$COLOR_SELECTION m) $ENDO All mistakes from all sessions (chapter random order) - NOT SHOW ANSWER"
	echo -e "\t$COLOR_SELECTION b) $ENDO $COLOR_TITLE_SELECTED[Recommended]$ENDO Detect your knowledge by asking only blue questions. (chapter random order) - NOT SHOW ANSWER"
	# ~ echo -e "\t$COLOR_SELECTION S) $ENDO All questions from all current sessions (session random order) - SHOW ANSWER FIRST"
	# ~ echo -e "\t$COLOR_SELECTION M) $ENDO All mistakes from all sessions (session random order) - SHOW ANSWER FIRST"
	# ~ echo -e "\t$COLOR_SELECTION q) $ENDO All questions from the .pul file \\e[38;5;196m[ not yet implemented... :( ]$ENDO" #MAYBE NOT... TRIGGER ANOTHER LOG...
	# ~ echo -e "\t$COLOR_SELECTION r) $ENDO All red mistakes from all sessions \\e[38;5;196m[ not yet implemented... :( ]$ENDO"
	# echo -e "\t$COLOR_SELECTION a) $ENDO Automated infinite loop, Optimized by PopUpLearn, focus on mistakes. \\e[38;5;196m[ not yet implemented... :( ]$ENDO"
	echo -e "\t$COLOR_SELECTION e) $ENDO Return"
	while :; do
		echo -en "\t\e[97;45m # $ENDO"
		read selected < /dev/tty
		case $selected in
			e) return 2 ;;
			#~ n) break ;;
			#~ N) break ;;
			#~ a) break ;;
			m) break ;;
			s) break ;;
			b) break ;;
			# M) break ;;
			#~ S) break ;;
			[0-9]*) SESSION_NUMBER=$selected; test "$selected" -le "`expr $NB_SESSION - 1`" && break ;;
		esac
	done
}
function ⬚⬚⬚⬚_📗_gamescript(){ 🔧 $FUNCNAME $@
	SESSION_SIZE=999 #For gs, always 999
	if [[ "$selected" == "m" ]];then
			ANSWER_BEFORE_QUIZ=0 #USE 'M' INSTEAD TO DISPLAY ANSWER
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}

				mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/"
				FILE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"

				cp $FILE "$HOME/.PopUpLearn/tmp/session_content.tmp"
				cp $FILE "$HOME/.PopUpLearn/tmp/session_content_remove.tmp"

				LANGUAGE_1=$LANGUAGE
				LANGUAGE_2=$LANGUAGE
				SUBJECT=GameScript
				NUMBER=1
				LOOP_QUIZ=1
				⬚⬚⬚⬚⬚_🔄_lines_in_gamescript_chapter || return 2

				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next subject."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					return 2 #STOPPED MANUALLY, break loop
				else
					return 0
				fi

			done
	elif [[ "$selected" == "s" ]];then
			ANSWER_BEFORE_QUIZ=0 #USE 'M' INSTEAD TO DISPLAY ANSWER
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"

				mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/"
				FILE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
				echo " === $FILE === "
				cp $FILE "$HOME/.PopUpLearn/tmp/session_content.tmp"
				cp $FILE "$HOME/.PopUpLearn/tmp/session_content_remove.tmp"

				LANGUAGE_1=$LANGUAGE
				LANGUAGE_2=$LANGUAGE
				SUBJECT=GameScript
				NUMBER=1
				LOOP_QUIZ=1
				⬚⬚⬚⬚⬚_🔄_lines_in_gamescript_chapter || return 2

				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next subject."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					return 2 #STOPPED MANUALLY, break loop
				else
					return 0
				fi
			done
	elif [[ "$selected" == "b" ]];then
			ANSWER_BEFORE_QUIZ=0 #USE 'M' INSTEAD TO DISPLAY ANSWER
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"

				mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/"

				#b -> 2 TIMES IF 0 GOOD, 1 TIME IF 1 GOOD, 0 TIME IF 2 GOOD (Technique to get rid of blue color quickly)
				#identical with ⬚⬚⬚⬚⬚_🏗_session_content_tmp_blue_only (change ?)
				cat $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good | sort | uniq -d > "$HOME/.PopUpLearn/tmp/answer_good_at_least_2.tmp"
				cat $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good | sort | uniq -u > "$HOME/.PopUpLearn/tmp/answer_good_only_1.tmp"

				cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" "$HOME/.PopUpLearn/tmp/answer_good_at_least_2.tmp" | sort | uniq -u > "$HOME/.PopUpLearn/tmp/good_removed_2_times.tmp"
				cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" "$HOME/.PopUpLearn/tmp/answer_good_at_least_2.tmp" "$HOME/.PopUpLearn/tmp/answer_good_only_1.tmp" | sort | uniq -u > "$HOME/.PopUpLearn/tmp/good_removed_1_time.tmp"

				cat "$HOME/.PopUpLearn/tmp/good_removed_1_time.tmp" "$HOME/.PopUpLearn/tmp/good_removed_2_times.tmp" > "$HOME/.PopUpLearn/tmp/good_removed.tmp"

				cp "$HOME/.PopUpLearn/tmp/good_removed.tmp" "$HOME/.PopUpLearn/tmp/session_content.tmp"
				cp "$HOME/.PopUpLearn/tmp/good_removed.tmp" "$HOME/.PopUpLearn/tmp/session_content_remove.tmp"
				#⬚⬚⬚⬚⬚_🏗_session_content_tmp_blue_only

				LANGUAGE_1=$LANGUAGE
				LANGUAGE_2=$LANGUAGE
				SUBJECT=GameScript
				NUMBER=1
				LOOP_QUIZ=1
				⬚⬚⬚⬚⬚_🔄_lines_in_gamescript_chapter || return 2

				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next subject."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					return 2 #STOPPED MANUALLY, break loop
				else
					return 0
				fi
			done
	else
		SESSION_NUMBER=$selected

		mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/"
		FILE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
		echo " === $FILE === "
		cp $FILE "$HOME/.PopUpLearn/tmp/session_content.tmp"
		cp $FILE "$HOME/.PopUpLearn/tmp/session_content_remove.tmp"

		LANGUAGE_1=$LANGUAGE
		LANGUAGE_2=$LANGUAGE
		SUBJECT=GameScript
		NUMBER=1
		LOOP_QUIZ=1
		⬚⬚⬚⬚⬚_🔄_lines_in_gamescript_chapter || return 2
	fi
}
function ⬚⬚⬚⬚⬚_🔄_lines_in_gamescript_chapter(){ 🔧 $FUNCNAME $@
	while read X; do
		⬚⬚⬚⬚⬚⬚_🚧_session_answers
		⬚⬚⬚⬚⬚⬚_🏗_my_line_tmp
		⬚⬚⬚⬚⬚⬚_🔄🌐_quiz $LOOP_QUIZ
		⬚⬚⬚⬚⬚⬚_💣_remove_answer_from_session_tmp
		⬚⬚⬚⬚⬚⬚_🛑_quiz || return 2
	done < "$HOME/.PopUpLearn/tmp/session_content.tmp"
}
function ⬚⬚⬚_🔄🔄_session(){ 🔧 $FUNCNAME $@
	FILE=${FILES[selected]}
	#SPLIT CONTENT FROM .pul FILE AND CONFIG + source
	cat $FILE | grep "^#!#" | sed 's/^#!#//' > $HOME/.PopUpLearn/tmp/session_specific_config.tmp

	#TEST IF CONTAINS AT LEAST THE MAIN 4 VARIABLES
	if [ ! `grep 'LANGUAGE_1=' $HOME/.PopUpLearn/tmp/session_specific_config.tmp` ] || [ ! `grep 'LANGUAGE_2=' $HOME/.PopUpLearn/tmp/session_specific_config.tmp` ] || [ ! `grep 'NUMBER=' $HOME/.PopUpLearn/tmp/session_specific_config.tmp` ] || [ ! `grep 'SUBJECT=' $HOME/.PopUpLearn/tmp/session_specific_config.tmp` ]; then
		echo
		echo " - This .pul file is invalid, it needs to contain values for at least the 4 variables : LANGUAGE_1, LANGUAGE_2, SUBJECT and NUMBER."
		echo
		return
	fi

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
			⬚⬚⬚⬚_📃_session
		fi
		if [[ "$selected" == "e" ]]; then
			break
		elif [[ "$selected" == "s" ]]; then
			ANSWER_BEFORE_QUIZ=0 #USE 's' INSTEAD TO DISPLAY ANSWER
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"
				⬚⬚⬚⬚_📗🔢_session_old $SESSION_NUMBER
				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next session."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					break #STOPPED MANUALLY, break loop
				fi
			done
		elif [[ "$selected" == "m" ]]; then
			ANSWER_BEFORE_QUIZ=0 #USE 'M' INSTEAD TO DISPLAY ANSWER
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"
				⬚⬚⬚⬚_📗🔢_session_old_mistakes_only $SESSION_NUMBER
				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next session."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					break #STOPPED MANUALLY, break loop
				fi
			done
		elif [[ "$selected" == "S" ]]; then
			ANSWER_BEFORE_QUIZ=1
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"
				⬚⬚⬚⬚_📗🔢_session_old $SESSION_NUMBER
				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next session."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					break #STOPPED MANUALLY, break loop
				fi
			done
		elif [[ "$selected" == "M" ]]; then
			ANSWER_BEFORE_QUIZ=1
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"
				⬚⬚⬚⬚_📗🔢_session_old_mistakes_only $SESSION_NUMBER
				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next session."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					break #STOPPED MANUALLY, break loop
				fi
			done
		elif [[ "$selected" == "b" ]]; then
			ANSWER_BEFORE_QUIZ=0
			ARRAY=()
			NB_SESSIONS=$SESSION_NUMBER
			#Prepare array with sessions numbers inside
			for (( i=1; i<$NB_SESSIONS; i++ )); do ARRAY+=($i); done
			#Shuffle the sessions numbers or a random result
			readarray -d '' SHUFFLED_SESSION_NUMBERS < <(printf "%s\0" "${ARRAY[@]}" | shuf -z)
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do echo " -- ${SHUFFLED_SESSION_NUMBERS[i]} -- "; done
			#LAUNCH ONE SESSION AFTER THE OTHER
			for (( i=0; i<`expr $NB_SESSIONS - 1`; i++ )); do
				SESSION_NUMBER=${SHUFFLED_SESSION_NUMBERS[i]}
				echo "----> SESSION_NUMBER=$SESSION_NUMBER"
				⬚⬚⬚⬚_📗🔢_session_old_blue_only $SESSION_NUMBER
				echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS before the next session."
				if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
					break #STOPPED MANUALLY, break loop
				fi
			done
		elif [[ "$selected" == "N" ]]; then
			⬚⬚⬚⬚_📗🌘_session_new
		elif [[ "$selected" == "n" ]]; then
			⬚⬚⬚⬚_📗🌘_session_new
			echo "SESSION_NUMBER = $SESSION_NUMBER"
			⬚⬚⬚⬚_📗🔢_session_old_with_answers $SESSION_NUMBER
		else
			⬚⬚⬚⬚_📗🔢_session_old $selected
		fi
	done
}
function ⬚⬚⬚⬚_📃_session(){ 🔧 $FUNCNAME $@
	echo
	echo " - Warning : dates are recorded but are not yet used to organize and optimize your learning experience. (In future versions, the text will change colors depending of when it was answered.)"

	echo -e "
	\e[4mCOLORS LEGEND :$ENDO
		\e[38;5;59mGREY$ENDO : Good 2+ times or Bad 0 (user can ignore knowledge in grey)
		\e[38;5;33mBLUE$ENDO : Good 0 (user need to do this session until \e[38;5;59mGREY$ENDO)
		\e[38;5;25mDARK_BLUE$ENDO : Good 1 time (user need to do this session until \e[38;5;59mGREY$ENDO)
		\e[38;5;184mYELLOW$ENDO : Bad 1 time
		\e[38;5;202mORANGE$ENDO : Bad 2 times
		\e[38;5;196mRED$ENDO : Bad 3+ times (user need to focus on this)
	"
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
	  echo -en "\t$COLOR_SELECTION $ARG) $COLOR_TITLE_SELECTED Session $ARG $ENDO "
	  #~ cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/session_content.pul" 2>/dev/null | sed 's/.*£//' | tr '\n' '|' | sed 's/^/|/' > "$HOME/.PopUpLearn/tmp/list_answers.tmp"
	  cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/session_content.pul" 2>/dev/null > "$HOME/.PopUpLearn/tmp/list_lines.tmp"
	  LAST_DAY=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null | sed 's/.*€//' | sort -n | tail -n 1`
	  TODAY=$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))
	  LAST_GOOD_ANSWER=""
	  if [[ "$LAST_DAY" != "" ]]; then
		LAST_GOOD_ANSWER="last good answer was `expr $TODAY - $LAST_DAY ` days ago (`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null|wc -l` bad, `cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null|wc -l` good)"
	  fi
	  echo -e $LAST_GOOD_ANSWER

	  ERROR_TEST=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad.date" 2>/dev/null | tail -n 1`
	  if [[ "$ERROR_TEST" != "" ]]; then
			cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.bad" 2> /dev/null > "$HOME/.PopUpLearn/tmp/list_mistakes.tmp"
			cat "$HOME/.PopUpLearn/tmp/list_lines.tmp" "$HOME/.PopUpLearn/tmp/list_mistakes.tmp" | sort | uniq -c | sed "s#^ \+1 \+\(.*\)#$GREY[\1]$END#" | sed "s#^ \+2 \+\(.*\)#$YELLOW[\1]$END#" | sed "s#^ \+3 \+\(.*\)#$ORANGE[\1]$END#" | sed "s#^ \+[0-9]\+ \+\(.*\)#$RED[\1]$END#" > "$HOME/.PopUpLearn/tmp/display_mistakes.tmp"
			echo -en "\t\t  BAD : "
			echo -e $(cat "$HOME/.PopUpLearn/tmp/display_mistakes.tmp" | sed 's/£/ :: /')
	  else
			echo -en "\t\t  BaD : "
			echo -e $(cat "$HOME/.PopUpLearn/tmp/list_lines.tmp" | sed "s#^\(.*\)#$GREY[\1]$END#" | sed 's/£/ :: /')
	  fi

	  GOOD_TEST=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good.date" 2>/dev/null | tail -n 1`
	  if [[ "$GOOD_TEST" != "" ]]; then
			SESSION_SIZE=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/session_content.pul"|sort|uniq|wc -l|sed 's/ .*//'`
			GOOD_SIZE=`cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good"|sort|uniq|wc -l|sed 's/ .*//'`
			ALL_GOOD=$(expr $SESSION_SIZE - $GOOD_SIZE)
			if [[ "$ALL_GOOD" != "0" ]]; then
				cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$ARG/answer.good" 2> /dev/null > "$HOME/.PopUpLearn/tmp/list_correct.tmp"
				cat "$HOME/.PopUpLearn/tmp/list_lines.tmp" "$HOME/.PopUpLearn/tmp/list_correct.tmp" | sort | uniq -c | sed "s#^ \+1 \+\(.*\)#$BLUE[\1]$END#" | sed "s#^ \+2 \+\(.*\)#$DARK_BLUE[\1]$END#" | sed "s#^ \+[0-9]\+ \+\(.*\)#$GREY[\1]$END#" > "$HOME/.PopUpLearn/tmp/display_correct.tmp"
				echo -en "\t\t GOOD : "
				echo -e $(cat "$HOME/.PopUpLearn/tmp/display_correct.tmp" | sed 's/£/ :: /')
			fi
	  else
			echo -en "\t\t GooD : "
			echo -e $(cat "$HOME/.PopUpLearn/tmp/list_lines.tmp" | sed "s#^\(.*\)#$BLUE[\1]$END#" | sed 's/£/ :: /')
	  fi
	done
	selected=99
	echo -e "\t$COLOR_SELECTION n) $ENDO New sessions (SHOW ANSWER and quiz - no points for good, log mistakes)"
	echo -e "\t$COLOR_SELECTION N) $ENDO New sessions (just create a new session, ask nothing)"
	echo -e "\t$COLOR_SELECTION s) $ENDO All questions from all current sessions (session random order) - NOT SHOW ANSWER"
	echo -e "\t$COLOR_SELECTION m) $ENDO All mistakes from all sessions (session random order) - NOT SHOW ANSWER"
	echo -e "\t$COLOR_SELECTION S) $ENDO All questions from all current sessions (session random order) - SHOW ANSWER FIRST"
	echo -e "\t$COLOR_SELECTION M) $ENDO All mistakes from all sessions (session random order) - SHOW ANSWER FIRST"
	echo -e "\t$COLOR_SELECTION b) $ENDO $COLOR_TITLE_SELECTED[Recommended]$ENDO Detect your knowledge by asking only blue questions. (chapter random order) - NOT SHOW ANSWER"
	#~ echo -e "\t\$COLOR_SELECTION q) $ENDO All questions from the .pul file \\e[38;5;196m[ not yet implemented... :( ]$ENDO" #MAYBE NOT... TRIGGER ANOTHER LOG...
	#~ echo -e "\t\$COLOR_SELECTION r) $ENDO All red mistakes from all sessions \\e[38;5;196m[ not yet implemented... :( ]$ENDO"
	echo -e "\t$COLOR_SELECTION a) $ENDO Automated infinite loop, Optimized by PopUpLearn \\e[38;5;196m[ not yet implemented... :( ]$ENDO"
	echo -e "\t$COLOR_SELECTION e) $ENDO Return"
	while :; do
		echo -en "\t\e[97;45m # $ENDO"
		read selected < /dev/tty
		case $selected in
			e) return ;;
			n) break ;;
			N) break ;;
			a) break ;;
			m) break ;;
			s) break ;;
			M) break ;;
			S) break ;;
			b) break ;;
			[0-9]*) SESSION_NUMBER=$selected; test "$selected" -le "`expr $NB_SESSION - 1`" && break ;;
		esac
	done
}
function ⬚⬚⬚⬚_📗🔢_session_old(){ 🔧 $FUNCNAME $@
	ANSWER_BEFORE_QUIZ=0
	⬚⬚⬚⬚⬚_🏗_session_specific_config
	⬚⬚⬚⬚⬚_🏗_session_content_tmp
	SESSION_NUMBER=$1
	LOOP_QUIZ=1 #IF OLD SESSION, ONLY ONE QUESTION ??? :P
	⬚⬚⬚⬚⬚_🔄_lines_in_session
	⬚⬚⬚⬚⬚_🛑_lines_in_session
}
function ⬚⬚⬚⬚_📗🔢_session_old_with_answers(){ 🔧 $FUNCNAME $@
	ANSWER_BEFORE_QUIZ=1
	⬚⬚⬚⬚⬚_🏗_session_specific_config
	⬚⬚⬚⬚⬚_🏗_session_content_tmp
	SESSION_NUMBER=$1
	LOOP_QUIZ=1 #IF OLD SESSION, ONLY ONE QUESTION ??? :P
	⬚⬚⬚⬚⬚_🔄_lines_in_session "IGNORE_GOOD"
	⬚⬚⬚⬚⬚_🛑_lines_in_session
}
function ⬚⬚⬚⬚_📗🔢_session_old_mistakes_only(){ 🔧 $FUNCNAME $@
	⬚⬚⬚⬚⬚_🏗_session_specific_config
	⬚⬚⬚⬚⬚_🏗_session_content_tmp_mistakes_only
	SESSION_NUMBER=$1
	LOOP_QUIZ=1 #IF OLD SESSION, ONLY ONE QUESTION ??? :P
	⬚⬚⬚⬚⬚_🔄_lines_in_session
	#~ ⬚⬚⬚⬚⬚_🛑_lines_in_session #Don't display end of session, not useful to know, useless spam
}
function ⬚⬚⬚⬚_📗🔢_session_old_blue_only(){ 🔧 $FUNCNAME $@
	⬚⬚⬚⬚⬚_🏗_session_specific_config
	⬚⬚⬚⬚⬚_🏗_session_content_tmp_blue_only
	SESSION_NUMBER=$1
	LOOP_QUIZ=1 #IF OLD SESSION, ONLY ONE QUESTION ??? :P
	⬚⬚⬚⬚⬚_🔄_lines_in_session
}
function ⬚⬚⬚⬚_📗🌘_session_new(){ 🔧 $FUNCNAME $@
	⬚⬚⬚⬚⬚_🏗🌘_session_folder #Newsession only
	⬚⬚⬚⬚⬚_🏗_session_specific_config
	⬚⬚⬚⬚⬚_🏗🌘_session_content_pul
	echo " --- NEW SESSION CREATED --- "
	# ⬚⬚⬚⬚⬚_🏗_session_content_tmp
	# ⬚⬚⬚⬚⬚_🔄_lines_in_session
	# ⬚⬚⬚⬚⬚_🛑_lines_in_session
}
function ⬚⬚⬚⬚⬚_🏗🌘_session_folder(){ 🔧 $FUNCNAME $@
	echo "mkdir $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/"
	mkdir -p "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/" 2> /dev/null
}
function ⬚⬚⬚⬚⬚_🏗🌘_session_content_pul(){ 🔧 $FUNCNAME $@
	echo "create : $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	if [ $SESSION_NUMBER -eq 1 ]; then
		cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' | head -n $SESSION_SIZE > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	else
		cat $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_*/session_content.pul > $HOME/.PopUpLearn/tmp/content_old_sessions.tmp
		cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' | grep -F -x -v -f $HOME/.PopUpLearn/tmp/content_old_sessions.tmp | head -n $SESSION_SIZE > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul"
	fi
}
function ⬚⬚⬚⬚⬚_🏗_session_specific_config(){ 🔧 $FUNCNAME $@
	echo "create : $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_specific_config.conf"
	#add identical configuration but without "ANSWER_BEFORE_QUIZ=1" because you are supposed to know this already...
	sed 's/ANSWER_BEFORE_QUIZ=1/ANSWER_BEFORE_QUIZ=0/' $HOME/.PopUpLearn/tmp/session_specific_config.tmp > "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_specific_config.conf"
}
function ⬚⬚⬚⬚⬚_🏗_session_content_tmp(){ 🔧 $FUNCNAME $@
	#double the content in session_content.tmp and session_content_remove.tmp or not ?
	# cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" > $HOME/.PopUpLearn/tmp/session_content.tmp
	cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" > $HOME/.PopUpLearn/tmp/session_content.tmp
	cat $HOME/.PopUpLearn/tmp/session_content.tmp > $HOME/.PopUpLearn/tmp/session_content_remove.tmp
}
function ⬚⬚⬚⬚⬚_🏗_session_content_tmp_mistakes_only(){ 🔧 $FUNCNAME $@
	#proportional to the number of mistakes i guess...
	cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.bad" > $HOME/.PopUpLearn/tmp/session_content.tmp
	cat $HOME/.PopUpLearn/tmp/session_content.tmp > $HOME/.PopUpLearn/tmp/session_content_remove.tmp
}
function ⬚⬚⬚⬚⬚_🏗_session_content_tmp_blue_only(){ 🔧 $FUNCNAME $@
	cat $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good | sort | uniq -d > "$HOME/.PopUpLearn/tmp/answer_good_at_least_2.tmp"
	cat $HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good | sort | uniq -u > "$HOME/.PopUpLearn/tmp/answer_good_only_1.tmp"

	cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" "$HOME/.PopUpLearn/tmp/answer_good_at_least_2.tmp" | sort | uniq -u > "$HOME/.PopUpLearn/tmp/good_removed_2_times.tmp"
	cat "$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/session_content.pul" "$HOME/.PopUpLearn/tmp/answer_good_at_least_2.tmp" "$HOME/.PopUpLearn/tmp/answer_good_only_1.tmp" | sort | uniq -u > "$HOME/.PopUpLearn/tmp/good_removed_1_time.tmp"

	cat "$HOME/.PopUpLearn/tmp/good_removed_1_time.tmp" "$HOME/.PopUpLearn/tmp/good_removed_2_times.tmp" > "$HOME/.PopUpLearn/tmp/good_removed.tmp"

	cp "$HOME/.PopUpLearn/tmp/good_removed.tmp" "$HOME/.PopUpLearn/tmp/session_content.tmp"
	cp "$HOME/.PopUpLearn/tmp/good_removed.tmp" "$HOME/.PopUpLearn/tmp/session_content_remove.tmp"
}
function ⬚⬚⬚⬚⬚_🔄_lines_in_session(){ 🔧 $FUNCNAME $@
	while read X; do
		if [[ "$X" == "" ]]; then break; fi
		⬚⬚⬚⬚⬚⬚_🚧_session_answers
		⬚⬚⬚⬚⬚⬚_🏗_my_line_tmp
		⬚⬚⬚⬚⬚⬚_🔀🌐_show_good_answer || return 2
		if [[ "$1" == "IGNORE_GOOD" ]];then
			⬚⬚⬚⬚⬚⬚_🔄🌐_quiz $LOOP_QUIZ "IGNORE_GOOD"
		else
			⬚⬚⬚⬚⬚⬚_🔄🌐_quiz $LOOP_QUIZ
		fi
		⬚⬚⬚⬚⬚⬚_💣_remove_answer_from_session_tmp
		⬚⬚⬚⬚⬚⬚_🛑_quiz || return 2
	done < "$HOME/.PopUpLearn/tmp/session_content.tmp"
}
function ⬚⬚⬚⬚⬚⬚_🚧_session_answers(){ 🔧 $FUNCNAME $@
	TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
	ANSWERED_GOOD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good"
	ANSWERED_GOOD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.good.date"
	TODAY="$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24)))"
	ANSWERED_BAD="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.bad"
	ANSWERED_BAD_DATE="$HOME/.PopUpLearn/logs/${LANGUAGE_1}/${LANGUAGE_2}/${SUBJECT}/${NUMBER}/$FILENAME/session_$SESSION_NUMBER/answer.bad.date"

	echo " -------> FILE = $FILE"
	cat $FILE | sed 's/ |=| /£/' | sed 's/^\t//g' | grep '£' > $HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp
	if [[ "$TYPE" == "BUTTON" ]];then
		rm $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON2.tmp 2> /dev/null
		while read line; do
			left=`echo $line | sed 's/£.*//'`
			right=`echo $line | sed 's/.*£//'`
			#~ if [[ "$left" != "$LEFT" ]] : BETTER FOR MULTIPLE ANSWERS POSSIBLE ???
			if [[ "$line" != "`cat $HOME/.PopUpLearn/tmp/current_line.tmp`" ]]; then
				echo "$right" >> $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON2.tmp
				#~ echo "---- $line != `cat $HOME/.PopUpLearn/tmp/current_line.tmp` ----"
			fi
		done < "$HOME/.PopUpLearn/tmp/file_content_BAD_answers.tmp"
		cat $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON2.tmp | sort | uniq > $HOME/.PopUpLearn/tmp/wrong_answers_BUTTON.tmp
	fi
	cat $HOME/.PopUpLearn/tmp/session_content_remove.tmp | sort -R | tail -n 1 > $HOME/.PopUpLearn/tmp/current_line.tmp
	LINE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
	LEFT=`echo "$LINE" | sed 's/£.*//'`
	RIGHT=`echo "$LINE" | sed 's/.*£//'`
	🔧 "$FUNCNAME : \$LINE=$LINE (RIGHT / LEFT)"
}
function ⬚⬚⬚⬚⬚⬚_🏗_my_line_tmp(){ 🔧 $FUNCNAME $@
	#~ echo "my_line.tmp : 0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}"
	echo "0£${SUBJECT}_${NUMBER}£${LEFT}£${RIGHT}£${LANGUAGE_1}£${LANGUAGE_2}£${TYPE}" > $HOME/.PopUpLearn/tmp/my_line.tmp
}
function ⬚⬚⬚⬚⬚⬚_🔀🌐_show_good_answer(){ 🔧 $FUNCNAME $@
	if [ $ANSWER_BEFORE_QUIZ -eq 1 ]; then
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
		echo "Press any key to exit, or wait $SEC_BEFORE_QUIZ SECONDS before the question."
		if read -r -N 1 -t $SEC_BEFORE_QUIZ EXIT < /dev/tty; then
			return 2 #STOPPED MANUALLY, break loop
		fi
	fi
}
function ⬚⬚⬚⬚⬚⬚_🔄🌐_quiz(){ 🔧 $FUNCNAME $@
	#PHP pages are using tmp/my_line.tmp
	quizzed=0
	while [ $1 -ne $quizzed ]; do
		quizzed=`expr $quizzed + 1`
		waited=1
		if [ $SIGSTOP_MPV -eq 1 ]; then
			sleep 5 && 💻_mpv_pause &> /dev/null &
		fi
		#Unknown if python3 is closed without answering
		echo unknown > $HOME/.PopUpLearn/tmp/result.tmp

		sleep 5 && i3-msg workspace "Learn" &
		💻_keyboard_language_change &
		surf -F http://127.0.0.1:9999/popup_quiz.php &> /dev/null
		#~ python3 $HOME/.PopUpLearn/html_popup.py 0 0 NO QUIZ &> /dev/null
		💻_keyboard_language_previous_one

		i3-msg workspace back_and_forth #What about others wm ?
		if [ $SIGSTOP_MPV -eq 1 ]; then 💻_mpv_play &> /dev/null; fi
		#$((($(date +%s)-$(date +%s --date '2018-01-01'))/(3600*24))) => Days since 1 january 2018
		#~ ANSWER= #real < can't be displayed by notify-send...
		if [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "good" ]]; then
			#??? UGLY
			notify-send -i $HOME/.PopUpLearn/img/good.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
			#IF CALLED ⬚⬚⬚⬚⬚⬚_🔄🌐_quiz $LOOP_QUIZ IGNORE_GOOD, DO NOT RECORD GOOD ANSWER
			if [[ "$2" != "IGNORE_GOOD" ]];then
				echo "$LINE" >> $ANSWERED_GOOD
				echo "$LINE€$TODAY" >> $ANSWERED_GOOD_DATE
			fi
		elif [[ "`cat $HOME/.PopUpLearn/tmp/result.tmp`" == "bad" ]]; then
			notify-send -i $HOME/.PopUpLearn/img/bad.png "$LEFT : `echo "$RIGHT"|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed 's/\\\\\\\\/\\\/'|sed "s/</𝈶/g"` ($quizzed/$LOOP_QUIZ)"
			echo "$LINE" >> $ANSWERED_BAD
			echo "$LINE€$TODAY" >> $ANSWERED_BAD_DATE
		else
			#~ notify-send -i $HOME/.PopUpLearn/img/unknown.png "$LEFT : $RIGHT ($quizzed/$LOOP_QUIZ)"
			notify-send -i $HOME/.PopUpLearn/img/unknown.png "You can't do that, you need to answer something..."
		fi
		if [ $1 -ne $quizzed ]; then
			sleep $SEC_BEFORE_QUIZ
		fi
	done
}
function ⬚⬚⬚⬚⬚⬚_🛑_quiz(){ 🔧 $FUNCNAME $@
	#NOT sleep if it was the last line in _remove.tmp
	LINES_LEFT=`wc -l /home/umen/.PopUpLearn/tmp/session_content_remove.tmp|sed 's/ .*//'`
	if [ $LINES_LEFT -ne 0 ];then
		echo "Press any key to exit, or wait $SEC_AFTER_QUIZ SECONDS ($LINES_LEFT lines left in session_remove.tmp)"
		if read -r -N 1 -t $SEC_AFTER_QUIZ EXIT < /dev/tty; then
			return 2 #STOPPED MANUALLY, break loop
		else
			return 0
		fi
	fi
	#~ sleep 1
}
function ⬚⬚⬚⬚⬚⬚_💣_remove_answer_from_session_tmp(){ 🔧 $FUNCNAME $@
	LINE_TO_DELETE=`cat $HOME/.PopUpLearn/tmp/current_line.tmp`
	#~ cp $HOME/.PopUpLearn/tmp/session_content_remove.tmp $HOME/.PopUpLearn/tmp/session_content_2.tmp
	#~ grep -m1 -F -x -v -f $HOME/.PopUpLearn/tmp/current_line.tmp $HOME/.PopUpLearn/tmp/session_content_2.tmp > $HOME/.PopUpLearn/tmp/session_content_remove.tmp
	#~ rm $HOME/.PopUpLearn/tmp/session_content_2.tmp
	LINE_TO_DELETE="$(<<< "$LINE_TO_DELETE" sed -e 's`[][\\/.*^$]`\\&`g')"
	echo "Line $LINE_TO_DELETE removed from session_content_remove.tmp"
	sed -i "0,/$LINE_TO_DELETE/{/$LINE_TO_DELETE/d;}" $HOME/.PopUpLearn/tmp/session_content_remove.tmp
}
function ⬚⬚⬚⬚⬚_🛑_lines_in_session(){ 🔧 $FUNCNAME $@
	notify-send -i $HOME/.PopUpLearn/img/unknown.png "End of session $SESSION_NUMBER"
}

command -v toilet &> /dev/null && toilet -f mono12 PopUpLearn -w 100
⬚_before_start
echo
echo " - Warning : This is an early release, it might not work as expected..."
echo " - Warning : PopUpLearn is been tested only on i3wm, some code is specific to i3. (All wms supported soon.)"
echo " - Warning : Dates are logged for all answers, but are not yet used by the system to optimize the learning process. (But it will)"
echo
if [ $1 ]; then TIME_DISPLAYED="$1"; else TIME_DISPLAYED=0; fi #0 for infinite
if [ $2 ]; then SEC_BEFORE_QUIZ="$2"; else SEC_BEFORE_QUIZ=30; fi
if [ $3 ]; then SEC_AFTER_QUIZ="$3"; else SEC_AFTER_QUIZ=60; fi
if [ $4 ]; then SIGSTOP_MPV="$4"; else SIGSTOP_MPV=1; fi
if [ $5 ]; then LANGUAGE_1="$5"; else LANGUAGE_1="xx"; fi
if [ $6 ]; then LANGUAGE_2="$6"; else LANGUAGE_2="xx"; fi
if [ $7 ]; then SUBJECT="$7"; else SUBJECT="unknown"; fi
if [ $8 ]; then NUMBER="$8"; else NUMBER="unknown"; fi
if [ $9 ]; then TYPE="$9"; else TYPE="TEXT"; fi
if [ $10 ]; then ANSWER_BEFORE_QUIZ="$10"; else ANSWER_BEFORE_QUIZ=1; fi
if [ $11 ]; then LOOP_QUIZ="$11"; else LOOP_QUIZ=3; fi
⬚_🔄🔄_start
