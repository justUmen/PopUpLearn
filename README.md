# PopUpLearn

Learn / memorize with popups and track down your knowledge with PopUpLearn.  

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

    sudo apt-get install php nodejs bc

## ALL dependencies (note that `dunst` will replace your notification system)

    sudo apt-get install php nodejs bc surf dunst toilet

## Web browser [surf]  

By default = usage of `surf` web browser to display the answer and the quiz. (can be changed with variable `WEB_BROWSER`)  
i3wm : Add in your i3 configuration to launch `surf` on "Learn" workspace : `assign [class="Surf"] workspace Learn`

## Notifications [dunst]  

PopUpLearn tested with `dunst` (https://github.com/dunst-project/dunst) for notifications - with `notify-send`.  

Download and use my personal `dunstrc` configuration with :  

    mkdir -p ~/.config/dunst/;wget https://raw.githubusercontent.com/justUmen/PopUpLearn/master/config/dunstrc -O ~/.config/dunst/dunstrc

# INSTALL

    git clone https://github.com/justUmen/PopUpLearn ~/.PopUpLearn
    echo 'alias popuplearn="cd ~/.PopUpLearn && git pull origin master && cd -;bash ~/.PopUpLearn/popup.sh"'>>~/.bashrc; source ~/.bashrc

# LAUNCH

    popuplearn

# System configuration (optional)

System configuration will overwrite ALL specific configurations and should be stored in file `~/.PopUpLearn/MYDB/my.config`.

## Real world example of a "my.config" file

    WEB_BROWSER="surf -F"
    SEC_AFTER_QUIZ=10
    SEC_BEFORE_QUIZ=10
    X_DAYS_RECORD_ERRORS=7

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

`X_DAYS_RECORD_ERRORS=7` just ignore the errors if they happened more than 7 days ago. (Colors and 'm', 'M' and 'r' menu selection) (Default value `X_DAYS_RECORD_ERRORS=14`)  

## .pul files options

- If a question or answer has an additional text between `[]`, this one will be ignored to play the audio file.

Example with :  

    #!#LANGUAGE_1="cnPI"
    好[hǎo] |=| good

Here, the audio file will be `好.mp3` and the language spoken will change to `cn`. (`PI` is the language for the text between `[]`).  

`[]` can also be used to comment or add informations.  

## .pul files restrictions and syntax

The format of each line is `question |=| answer`, " |=| " is used to separate the question from the answer. (Notice the spaces.)  

Only lines with a " |=| " will be considered as valid content by PopUpLearn. The others lines (except variable lines) will be considered as comments. (You can use this for writing comments about your .pul file, a work in progress, a question without answer, etc...)  

Tabulations and spaces at the beginning or end of the line can be used for presentation in the .pul file, they will be ignored by PopUpLearn.  

.pul files are case sensitive, so be careful with uppercase letters...  

Avoid double \ ! (like in GameScript quizzes), need to transform them into four \  

Avoid special characters in general when you can.  

# Options

- pause / unpause mpv during popup.  
PUL is pausing/unpausing mpv with the socket `/tmp/mpvsocket`, so if you want to use this functionality, you need to add in your mpv configuration file : `input-ipc-server=/tmp/mpvsocket`)  

- pause / unpause netflix during popup, but netflix need to be launched with chrome and the following alias : `alias netflix="google-chrome-stable --app=\"http://netflix.com\" --user-data-dir=\"$HOME/.config/google-chrome-netflix\""` (Download google-chrome from https://www.google.com/chrome/ and install with `sudo dpkg -i google-chrome-stable_current_amd64.deb`)

- change keyboard layout automatically for different languages (uses `ibus` and variable `$LANGUAGE_2`). (The language need to be available in PopUpLearn, check source "popup.sh" for more details - or ask for another language support here.).  
Available now => english: `xkb:us::eng`, thai: `libthai`, japanese: `anthy`, chinese: `pinyin`  
To install `ibus` : `sudo apt-get install ibus`, then install the desired languages, like : `ibus-libthai` (thai), `ibus-pinyin` (chinese), `ibus-anthy` (japanese).  
Of course put `run_im ibus` in the file `~/.xinputrc` to use it with your system. (`echo run_im ibus >> ~/.xinputrc` and you can restart Xorg)  

# LOGS

Todo : Using existing logs, PUL should try to guess what the user know well, don't know, probably forgot, etc...
Simple first, then machine learning future prediction system !?  

# Optional : LAUNCH WITH ARGUMENTS (2 variables that control time)

     popuplearn 0 60

Argument 1 : 0 => 0 means unlimited display of the answer (until user answer or close), otherwise the popup closes after X seconds. Useful if you can't or don't want to interact with PopUpLearn. (Not answering doesn't count as a wrong answer)  
Argument 2 : 60 => Seconds to wait before the next popup  

0 and 60 are default variables, so `popuplearn 0 60` and `popuplearn` are identical.

# Language table

Language table for `LANGUAGE_1` and `LANGUAGE_2` variables.  

If the language is uppercase, it means the language is not a "normal" one, like here "RO" for romaji and "PI" for pinyin.  

|french|english|chinese|chinese[pinyin]|chinese(pinyin only)|thai|japanese|japanese[romaji]|japanese(romaji only)|IMAGE|
|------|-------|-------|---------------|--------------------|----|--------|----------------|---------------------|-----|
|fr|en|cn|cnPI|PI|th|jp|jpRO|RO|IM|

In PopUpLearn, an answer can also be an image. In this case, you should use the special value "IM". For example if the answer is an image `LANGUAGE_2="IM"`

# Details and recommandations :

PopUpLearn is for now just a Proof Of Concept of constantly changing principles, not yet a perfect system. (I probably need your advices and opinions.)  

PopUpLearn is created as a PASSIVE learning system, use time and repetition intelligently !  

DO NOT avoid making mistakes. Making mistakes is necessary for PUL to learn more about you. The goal is NOT to avoid mistakes.  

There is nothing wrong about being wrong 20 times in a row. Do not waste your time in the quiz, you should know the answer in seconds or you don't. If so, just move on and let the system record your "mistake".  

Do NOT let your brain use an elimination system to come up with the correct answer. The goal is for your brain to remember the answer, being "correct" is not always useful and can sometimes be counter-productive.  

I do NOT recommend you to try to remember the same thing over and over again the same day, just read the answer, try to rememeber it but don't force it on yourself. Have a good night of sleep and come back to PopUpLearn, your brain will remember it. If not, try again the day after.  

# Todo

- Stats : give an overall idea (visual graph) of how good you are with a specific .pul file, your progress, your work per day...  

- Force question if bad answer was X days ago and not followed by a recent good answer on the same question.  

- Clean reverse system for `question |=| answer` into `answer |=| question`, and special tracking system.  

- One of the goal is to track down what you learned and create personalised .pul files for you. (Require community effort to link a piece of knowledge to a precise .pul file. For example a .pul file per wikipedia page, a .pul file per online teaching video, etc...)  

- video content generation based on your knowledge. (Find material online automatically.)  

- where to store logs ? local machine for now. Server ? Github repo ? ...  

- implement a way for instant personal recall of information (paraphrasing, multiple meanings if possible... in the user's head ?)  

- should all information have different level ? All information have quality / level ?  

- implement a way to put every piece of knowledge into another context for a better understanding.  

# Todo (Language learning specifc)

- use .srt files as a way to learn with movies. (automatic conversion from an .srt to a valid .pul)  

- colorize subtitles of the new language with the words you know. (With .srt file, the system will be able to tell you how many words you know from the movie/file with your current knowledge.)  

- find a way to create automatically a list of knowledge based on what the user is doing. (chatting, browsing, watching movie...)  

- find a way to quickly make a word into context. (sentence, video, ...)  

- prepare a script than can extract a sentence from subtitles file from movie and create a very short video with the word in a context. (+ translation) - several if possible (use tv show for multiple videos or specific theme)   how many different words in a movie ?...  

- take a movie/video + subtitles to generate a .pul file. (At least a draft, words + sentences) - same for website, article, book, manga...

- take a movie / video / text and predict the level of difficulty (points based on hsk level type for chinese, or % used in list)    
