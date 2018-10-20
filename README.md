# PopUpLearn (Work in progress)

Learning with popups !!  

Made for GameScript but can be used to learn pretty much whatever you want, but you need a clean DB about it.  

The DB is text-based in .pul files.  

Content should be / will be compatible with "WallpaperGenerator", "Brainz" and "GameScript quizzes".  

Content is moved from the folder "ToLearn" to the folder "Learned" ???

Use ~/.PopUpLearn to store scripts and data.

# Dependencies

    sudo apt-get install python3-pyqt5 php dunst nodejs

`i3wm` desktop only for now (add to your configuration : `assign [class="html_popup.py"] workspace "Learn"` and `for_window [class="html_popup.py"] fullscreen enable`).  

tested with `dunst` for notifications - aka `notify-send` (my config : `~/.PopUpLearn/config/dunstrc`)  

# Installation

    git clone https://github.com/justUmen/PopUpLearn ~/.PopUpLearn

# Update (Manual update for now)

	cd ~/.PopUpLearn && git pull origin master && cd -

# Configuration

# Usage

1 - Launch php server with :  

     php -S 127.0.0.1:9999 -t ~/.PopUpLearn

2 - Launch nodejs server with :  

     node ~/.PopUpLearn/node_server.js || nodejs ~/.PopUpLearn/node_server.js

Maybe you should only authorize port 8888 on localhost with : `iptables -A INPUT -p tcp --dport 8888 -j DROP` and `iptables -A INPUT -p tcp -s localhost --dport 8888 -j ACCEPT`  

3 - Launch client with for example :  

     bash ~/.PopUpLearn/launcher_html_popup.sh 0 30 60

0 => 0 means unlimited display, otherwise close after X seconds  
30 => Seconds to wait before displaying quiz after showing the answer  
60 => Seconds to wait between each quiz  

# Logs everything

...

# .pul files restrictions

The format of each line is `question£answer`, £ is used to separate the two  

Avoid double \ ! (\\ like in GameScript quizzes) need to transform into four \\\\  

Maybe issues with ` ??? need testing, avoid them!  
