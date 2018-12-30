# PopUpLearn

Learn / memorize with popups + track down your knowledge and mistakes with PopUpLearn.  

Built and tested for linux desktop users, using `bash`. But it might eventually be transfered for compatibility with smartphones, AR glasses, VR headset...  

Made for GameScript but can be used to learn/remember about pretty much whatever you want, but you need a proper PUL FILE for it.  

The PUL FILE is a simple text file with the .pul extension. Your personal .pul files must be stored in `~/.PopUpLearn/MYDB` (For example : `~/.PopUpLearn/MYDB/chemistry/elements.pul`).  

<!-- If the .pul file is outside of the `~/.PopUpLearn/MYDB` folder, you must give its full path of the .pul to the `~/.PopUpLearn/MYDB/my.list` file. (One per line) -->  

Content should be (or will be) compatible with "WallpaperGenerator" and "GameScript". (but .pul files can give specific configurations)  

PopUpLearn is using the folder `~/.PopUpLearn` to store scripts, data and user logs.  

If you create a cool and useful PUL FILE, share it with the rest of us ! :)  

Technologies : PopUpLearn is using `bash`, `html`, `php`, `js`, `css`, `nodejs` and `reactjs`.  

# Dependencies (Debian family)

## Minimal dependencies

    sudo apt-get install php nodejs

## ALL dependencies (note that `dunst` will replace your notification system)

    sudo apt-get install php nodejs surf dunst toilet

## Web browser [surf]  

By default = usage of `surf` web browser to display the answer and the quiz. (can be changed with variable `WEB_BROWSER`)  
i3wm : Add in your i3 configuration to launch `surf` on "Learn" workspace : `assign [class="Surf"] workspace Learn`

## Notifications [dunst]  

PopUpLearn tested with `dunst` (https://github.com/dunst-project/dunst) for notifications - with `notify-send`.  

Download and use my personal `dunstrc` configuration with :  

    mkdir -p ~/.config/dunst/;wget https://github.com/justUmen/PopUpLearn/blob/master/config/dunstrc -O ~/.config/dunst/dunstrc

# INSTALL

    git clone --depth 1 https://github.com/justUmen/PopUpLearn ~/.PopUpLearn
    echo 'alias popuplearn="cd ~/.PopUpLearn && git pull --unshallow origin master && cd -;bash ~/.PopUpLearn/popup.sh"'>>~/.zshrc; source ~/.zshrc

# LAUNCH

    popuplearn

# System configuration (optional)

System configuration will overwrite ALL specific configurations and should be stored in file `~/.PopUpLearn/MYDB/my.config`.

## Real world example of a "my.config" file

    WEB_BROWSER="surf -F"
    SEC_AFTER_QUIZ=10
    SEC_BEFORE_QUIZ=10

# structure of .pul files

## Real world example of a .pul file

    #!#LANGUAGE_1=en
    #!#LANGUAGE_2=fr
    #!#SUBJECT="learn_french"
    #!#NUMBER="1"
    #!#TYPE=BUTTON
    #!#SESSION_SIZE=10
    house |=| maison
    boat |=| bateau

.pul files can store their own specific variables, but the variable lines must starts with `#!#`.

The path of this .pul file can be for example : `~/.PopUpLearn/MYDB/en/fr/whatever/stupid_name.pul`.  
The sub folders after `/MYDB/` are optional (`en`, `fr` and `whatever`) and even the name of the file (`stupid_name.pul`) makes no difference inside PopUpLearn.  
But you should use them to organize your .pul files the way you want.  

## Mandatory variables in .pul files

`LANGUAGE_1="en"` the language of the question. (always 2 letters - check language table below)  

`LANGUAGE_2="fr"` the language of the answer. (always 2 letters - check language table below)  

`SUBJECT="french_sentences"` the subject name. (avoid spaces)  

`NUMBER="1"` number used as a reference for the subject name.  

## Optional variables/values in .pul files or `my.config`

`TYPE="BUTTON"` enable the usage of buttons in quiz popup for multiple choices where you can simply click on the answer instead of typing it.  

`TYPE="TEXT"` where you need to type the exact answer.) With this you can also confirm an answer if the good answer is the only one that is currently displayed (Buttons will vanish if they don't contain what you typed. Meaning if the answer is "example" you can type "ex" and confirm with 'Enter' if you see that only the button "example" is currently displayed.). (Default value `TYPE="TEXT"`)  

`SESSION_SIZE=0`, set number of element in a session. 0 for unlimited number of elements. Result : the file is only one big session. (Default value `SESSION_SIZE=6`)  

`KEYBOARD_AUTO_CHANGE=1` automatically change keyboard layout to type the answer in another language. (more details in "Options" below)  

## .pul files restrictions and syntax

The format of each line is `question£answer`, "£" is used to separate the question from the answer.  

If presentation is an issue, you can also use " |=| " as a delimiter instead of "£". (Notice the spaces.)  

Only lines with a " |=| " or a "£" will be considered as valid content by PopUpLearn. The others lines (except variable lines) will be considered as comments. (You can use this for writing comments about your .pul file, a work in progress, a question without answer, etc...)  

Tabulations and spaces at the beginning or end of the line can be used for presentation in the .pul file, they will be ignored by PopUpLearn.  

.pul files are case sensitive, so be careful with uppercase letters...  

Avoid double \ ! (like in GameScript quizzes), need to transform them into four \  

Avoid special characters in general when you can.  

# Options

- pause mpv when the popup arrives and unpause it afterwards.  
PUL is pausing/unpausing mpv with the socket `/tmp/mpvsocket`, so if you want to use this functionality, you need to add in your mpv configuration file : `input-ipc-server=/tmp/mpvsocket`)  

- change keyboard layout automatically for different languages (uses `ibus` and variable `$LANGUAGE_2`). (The language need to be available in PopUpLearn, check source "popup.sh" for more details - or ask for another language support here.).  
Available now => english: `xkb:us::eng`, thai: `libthai`, japanese: `anthy`, chinese: `pinyin`  
To install `ibus` : `sudo apt-get install ibus`, then install the desired languages, like : `ibus-libthai` (thai), `ibus-pinyin` (chinese), `ibus-anthy` (japanese).  
Of course put `run_im ibus` in the file `~/.xinputrc` to use it with your system. (`echo run_im ibus >> ~/.xinputrc` and you can restart Xorg)  

# LOGS

Todo : Record all errors and successes in logs/ with dates to organize and try to guess what the user know well, don't know, probably forgot, etc...
Simple first, then machine learning testing prediction system !?  

# Optional : LAUNCH WITH ARGUMENTS (3 variables that control time)

     bash ~/.PopUpLearn/popup.sh 0 30 60

Argument 1 : 0 => 0 means unlimited display of the answer (until user answer or close), otherwise the popup closes after X seconds. Useful if you can't or don't want to interact with PopUpLearn. (Not answering doesn't count as a wrong answer)  
Argument 2 : 30 => Seconds to wait before displaying quiz after showing the answer  
Argument 3 : 60 => Seconds to wait between each quiz  

0, 30 and 60 are default variables so `bash ~/.PopUpLearn/popup.sh 0 30 60` and `bash ~/.PopUpLearn/popup.sh` are identical.

# Todo

- Stats : give an overall idea (visual graph) of how good you are with a specific .pul file, your progress, your work per day...  

- Force question if bad answer was X days ago and not followed by a recent good answer on the same question.  

- Clean reverse system for `question£answer` into `answer£question`, and special tracking system.  

- One of the goal is to track down what you learned and create personalised .pul files for you. (Require community effort to link a piece of knowledge to a precise .pul file. For example a .pul file per wikipedia page, a .pul file per online teaching video, etc...)  

# Language table

Language table for `LANGUAGE_1` and `LANGUAGE_2` variables.  

If the language is uppercase, it means the language is not a "normal" one, like here "RO" for romaji and "PI" for pinyin.  

|french|english|chinese|chinese(pinyin)|thai|japanese|japanese(romaji)|IMAGE|
|------|-------|-------|---------------|----|--------|----------------|-----|
|fr|en|cn|PI|th|jp|RO|IM|

In PopUpLearn, an answer can also be an image. In this case, you should use the special value "IM". For example if the answer is an image `LANGUAGE_2="IM"`
