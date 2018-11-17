# PopUpLearn (Work in progress)

Learning with popups !!  

Made for GameScript but can be used to learn pretty much whatever you want, but you need a clean DB about it.  

The DB is text-based in .pul files.  

Content should be / will be compatible with "WallpaperGenerator", "Brainz" and "GameScript quizzes". (but .pu files should give configurations)  

Content is moved from the folder "ToLearn" to the folder "Learned" ???

Use ~/.PopUpLearn to store scripts and data.

If you create a cool .pul, share it with the rest of us !  

# Dependencies

    sudo apt-get install python3-pyqt5 python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit php nodejs

`i3wm` desktop only for now (add to your configuration : `assign [class="html_popup.py"] workspace "Learn"` and `for_window [class="html_popup.py"] fullscreen enable`).  

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

     node ~/.PopUpLearn/node_server.js || nodejs ~/.PopUpLearn/node_server.js

3 - Launch client with for example :  

     bash ~/.PopUpLearn/launcher_html_popup.sh 0 30 60

0 => 0 means unlimited display, otherwise close after X seconds  
30 => Seconds to wait before displaying quiz after showing the answer  
60 => Seconds to wait between each quiz  

# Logs

Todo : Record all errors and success with dates to organize and try to guess what you know well, don't know, probably forgot, etc...
Simple first then machine learning testing.  

Types :  
1 - Answer + Quiz (Work in session)
2 - Quiz (For content the user already knows / should know)

Idea : Delay by 1 week / 2 weeks / 4 weeks / 8 weeks ...  

Stats : give an overall idea (visual) of how good you are with a specific .pul file  

# .pul files restrictions and syntax

The format of each line is `question£answer`, "£" is used to separate the two.  

If presentation is an issue, you can use " |=| " as a delimiter instead of "£".  

Lines without " |=| " or "£" will be ignored. Use that to comment your .pul files if you want. (Or leave a line with delimiter for a work in progress, question without answer, etc...)  

Tabulations and spaces at the beginning or end of the line can be use for presentation in the .pul file, they will be ignored.  

Line specific variables start with #!# , and they shouldn't contains spaces.   

Avoid double \ ! (like in GameScript quizzes) need to transform into four \  

.pul files are case sensitive, so be careful with capital letters  

Maybe issues with ` ??? need testing, avoid them!  
