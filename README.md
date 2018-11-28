# PopUpLearn (Work in progress)

Learning with popups !!  

Made for GameScript but can be used to learn pretty much whatever you want, but you need a clean DB about it.  

The DB is text-based in .pul files.  

Content should be / will be compatible with "WallpaperGenerator", "Brainz" and "GameScript quizzes". (but .pul files should give configurations)  

Use ~/.PopUpLearn to store scripts and data.

If you create a cool and useful .pul, share it with the rest of us !  

# Dependencies

    sudo apt-get install php nodejs surf

## Window manager

Testing : Only with `i3` window manager for now : `sudo apt-get i3`
Usage of i3 specific commands that need to be replaced for other wm : `i3-msg workspace back_and_forth` and  

## Web browser  

Usage of `surf` web browser to display the answer and the quiz  
Recommended : Add to your i3 configuration to launch `surf` on "Learn" workspace : `assign [class="Surf"] workspace Learn`

## Notifications  

Tested with `dunst` for notifications - aka `notify-send` (my config : `https://github.com/justUmen/PopUpLearn/blob/master/config/dunstrc`)  

# Installation

    git clone https://github.com/justUmen/PopUpLearn ~/.PopUpLearn

# Update (Manual update for now)

	cd ~/.PopUpLearn && git pull origin master && cd -

# Configuration

.pul files should store their own specific configurations, but the configuration lines must starts with #!# (see example https://github.com/justUmen/PopUpLearn/blob/master/DB/fr/GS/bash/_1-11.pul)  

# Usage

1 - Launch php server with :  

     php -S 127.0.0.1:9999 -t ~/.PopUpLearn

2 - Launch nodejs server with :  

     node ~/.PopUpLearn/node_server_popup.js || nodejs ~/.PopUpLearn/node_server_popup.js

3 - Launch user interface :  

     bash ~/.PopUpLearn/popup.sh

# OPTIONS

- pause mpv if playing something when quiz popup arrives and unpause it afterwards  
PUL is using the socket /tmp/mpvsocket, so you need to use in your mpv configuration file : `input-ipc-server=/tmp/mpvsocket`)  

- change keyboard layout automaticaly for different languages (use `ibus` and variable `$LANGUAGE_2`).  
english: `xkb:us::eng`, thai: `libthai`, japanese: `anthy`, chinese: `pinyin`  
To use `ibus` : `sudo apt-get install ibus ibus-libthai ibus-pinyin ibus-anthy`  
Of course put `run_im ibus` in the file `~/.xinputrc`.  (`echo run_im ibus >> ~/.xinputrc` and you can restart Xorg)  

# LOGS

Todo : Record all errors and successes in logs/ with dates to organize and try to guess what the user know well, don't know, probably forgot, etc...
Simple first, then machine learning testing prediction system !?  

# TYPES OF POPUP

1 - Answer + Quiz (Work in session) `ANSWER_BEFORE_QUIZ=1`
2 - Quiz (For content the user already knows / should know) `ANSWER_BEFORE_QUIZ=0`

# .pul files restrictions and syntax

The format of each line is `question£answer`, "£" is used to separate the question from the answer.  

If presentation is an issue, you can use " |=| " as a delimiter instead of "£". (Notice the spaces.)  

Lines without " |=| " or "£" will be ignored !!! Use that to comment your .pul files if you want. (Or leave a line without these delimiters for a work in progress, question without answer, etc...)  

Tabulations and spaces at the beginning or end of the line can be used for presentation in the .pul file, they will be ignored.  

Line specific variables start with #!# , and they shouldn't contains spaces.  

.pul files are case sensitive, so be careful with capital letters  

Avoid double \ ! (like in GameScript quizzes) need to transform into four \  

Maybe issues with ` ??? need testing, avoid them!  

# VARIABLES NEEDED IN .pul FILES

`LANGUAGE_1="en"` the language of the question.  

`LANGUAGE_2="fr"` the language of the answer.  

`SUBJECT="french_sentences"` the subject name. (avoid spaces)  

`NUMBER="1"` number used as a reference for the subject name.  

# ADDITIONAL VARIABLES AVAILABLE IN .pul FILES

`TYPE="BUTTON"` enable the usage of buttons in quiz popup for multiple choices where you can simply click on the answer instead of typing it. (Default `TYPE=TEXT` where you need to type the exact answer.)  

`LOOP_QUIZ=1` set the number of quiz about the same question to 1, before asking another question.  

`SESSION_SIZE=0` for unlimited size of session, the file is only one big session. (Default SESSION_SIZE=6)  

`ANSWER_BEFORE_QUIZ=1` to display answer before asking for it. Used to learn something the user don't know anything about. (Default ANSWER_BEFORE_QUIZ=0)  

`KEYBOARD_AUTO_CHANGE=1` automatically change keyboard layout with `ibus` for typing the answer (need to be in language available, check source "popup.sh").  

# LAUNCH WITH ARGUMENTS (3 variables that control time)

     bash ~/.PopUpLearn/popup.sh 0 30 60

0 => 0 means unlimited display of the answer (until user click and close), otherwise the answer closes after X seconds  
30 => Seconds to wait before displaying quiz after showing the answer  
60 => Seconds to wait between each quiz  

0, 30 and 60 are default variables so `bash ~/.PopUpLearn/popup.sh 0 30 60` and `bash ~/.PopUpLearn/popup.sh` are identical.

# TODO

- Stats : give an overall idea (visual) of how good you are with a specific .pul file  

- Force question if bad answer was X days ago and not followed by a recent good answer on the same question.  

- Clean reverse system for `question£answer` into `answer£question`, and special tracking system  
