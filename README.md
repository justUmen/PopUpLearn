# PopUpLearn

Learning with popups and track down your knowledge by letting it run in the background.  

Made for GameScript but can be used to learn pretty much whatever you want, but you need a clean DB about it.  

Built and tested for linux desktop users, using `bash`. But will eventually be transfered to smartphone, AR glasses, VR headset...  

Technologies : PopUpLearn is using bash, html, php, js, css, nodejs and reactjs.  

The DB is text-based in a .pul file. Your personal .pul files must be stored in `~/.PopUpLearn/MYDB` (For example : `~/.PopUpLearn/MYDB/chemistry/elements.pul`).  

If the .pul file is outside of the `~/.PopUpLearn/MYDB` folder, you must give its full path of the .pul to the `~/.PopUpLearn/MYDB/my.list` file. (One per line)  

Content should be (or will be) compatible with "WallpaperGenerator" and "GameScript". (but .pul files can give specific configurations)  

Use `~/.PopUpLearn` folder to store scripts, data and logs.  

If you create a cool and useful .pul, share it with the rest of us ! :)  

# Dependencies (Debian family)

## Minimal dependencies

    sudo apt-get install php nodejs
    
## ALL dependencies (`dunst` will replace your notification system)

    sudo apt-get install php nodejs surf dunst toilet

## Web browser [surf]  

By default = usage of `surf` web browser to display the answer and the quiz. (can be changed with variable `WEB_BROWSER`)  
i3wm : Add in your i3 configuration to launch `surf` on "Learn" workspace : `assign [class="Surf"] workspace Learn`

## Notifications [dunst]  

PopUpLearn tested with `dunst` (https://github.com/dunst-project/dunst) for notifications - aka `notify-send`.  

Download and use my `dunstrc` configuration with :  

    mkdir -p ~/.config/dunst/;wget https://github.com/justUmen/PopUpLearn/blob/master/config/dunstrc -O ~/.config/dunst/dunstrc

# INSTALL

    git clone https://github.com/justUmen/PopUpLearn ~/.PopUpLearn
    echo 'alias popuplearn="cd ~/.PopUpLearn && git pull origin master && cd -;bash ~/.PopUpLearn/popup.sh"'>>~/.zshrc; source ~/.zshrc

# LAUNCH

    popuplearn

# System configuration (optional)

System configuration will overwrite all specific configurations and should be stored in file `~/.PopUpLearn/MYDB/my.config`.

## Real world example

    WEB_BROWSER="surf -F"
    SEC_AFTER_QUIZ=10
    SEC_BEFORE_QUIZ=10

# .pul files configuration

## Mandatory variables in .pul files

`LANGUAGE_1="en"` the language of the question.  

`LANGUAGE_2="fr"` the language of the answer.  

`SUBJECT="french_sentences"` the subject name. (avoid spaces)  

`NUMBER="1"` number used as a reference for the subject name.  

## Optional variables in .pul files

`TYPE="BUTTON"` enable the usage of buttons in quiz popup for multiple choices where you can simply click on the answer instead of typing it. (Default `TYPE="TEXT"` where you need to type the exact answer.) With this you can also confirm an answer if the good answer is the only one that is currently displayed (Buttons will vanish if they don't contain what you typed. Meaning if the answer is "example" you can type "ex" and confirm with 'Enter' if you see that only the button "example" is currently displayed.).

`SESSION_SIZE=0`, set number of element in a session. 0 for unlimited number of elements, result : the file is only one big session. (Default SESSION_SIZE=6)  

`KEYBOARD_AUTO_CHANGE=1` automatically change keyboard layout with `ibus` for typing the answer (need to be in language available, check source "popup.sh").  

## Real world example

.pul files can store their own specific configurations, but the configuration lines must starts with `#!#`, example with 2 optional variables (TYPE and SESSION_SIZE) :  

    #!#LANGUAGE_1=fr
    #!#LANGUAGE_2=fr
    #!#SUBJECT="french_sentences"
    #!#NUMBER="1"
    #!#TYPE=BUTTON
    #!#SESSION_SIZE=

# OPTIONS

- pause mpv if playing something when quiz popup arrives and unpause it afterwards  
PUL is using the socket /tmp/mpvsocket, so you need to use in your mpv configuration file : `input-ipc-server=/tmp/mpvsocket`)  

- change keyboard layout automaticaly for different languages (use `ibus` and variable `$LANGUAGE_2`).  
english: `xkb:us::eng`, thai: `libthai`, japanese: `anthy`, chinese: `pinyin`  
To use `ibus` : `sudo apt-get install ibus`
And then install the desired language, examples : `ibus-libthai` (thai), `ibus-pinyin` (chinese), `ibus-anthy` (japanese).  
Of course put `run_im ibus` in the file `~/.xinputrc`.  (`echo run_im ibus >> ~/.xinputrc` and you can restart Xorg)  

# LOGS

Todo : Record all errors and successes in logs/ with dates to organize and try to guess what the user know well, don't know, probably forgot, etc...
Simple first, then machine learning testing prediction system !?  

# .pul files restrictions and syntax

The format of each line is `question£answer`, "£" is used to separate the question from the answer.  

If presentation is an issue, you can use " |=| " as a delimiter instead of "£". (Notice the spaces.)  

Lines without " |=| " or "£" will be ignored !!! Use that to comment your .pul files if you want. (Or leave a line without these delimiters for a work in progress, question without answer, etc...)  

Tabulations and spaces at the beginning or end of the line can be used for presentation in the .pul file, they will be ignored.  

Line specific variables start with #!# , and they shouldn't contains spaces.  

.pul files are case sensitive, so be careful with uppercase letters...  

Avoid double \ ! (like in GameScript quizzes) need to transform into four \  

Maybe issues with ` ??? need testing, avoid them!  

# optional : LAUNCH WITH ARGUMENTS (3 variables that control time)

     bash ~/.PopUpLearn/popup.sh 0 30 60

0 => 0 means unlimited display of the answer (until user click and close), otherwise the answer closes after X seconds  
30 => Seconds to wait before displaying quiz after showing the answer  
60 => Seconds to wait between each quiz  

0, 30 and 60 are default variables so `bash ~/.PopUpLearn/popup.sh 0 30 60` and `bash ~/.PopUpLearn/popup.sh` are identical.

# TODO

- Stats : give an overall idea (visual graph) of how good you are with a specific .pul file, your progress, your work per day...  

- Force question if bad answer was X days ago and not followed by a recent good answer on the same question.  

- Clean reverse system for `question£answer` into `answer£question`, and special tracking system.  
