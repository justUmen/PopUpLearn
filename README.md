# PopUpLearn (Work in progress)

Learning with popups.  
Made for GameScript but can be used to learn pretty much whatever you want.  

Content should be compatible with "WallpaperGenerator", "Brainz" and "GameScript quizzes".  

Everything is text-based in .pul files.  

Content is moved from the folder "ToLearn" to the folder "Learned" ???

Use ~/.PopUpLearn to store scripts and data.

# Dependencies

    sudo apt-get install python3-pyqt5 php dunst 

`i3wm` desktop only for now (add to your configuration : `assign [class="html_popup.py"] workspace "Learn"` and `for_window [class="html_popup.py"] fullscreen enable`).  

tested with `dunst` for notifications - aka `notify-send` (my config : `~/.PopUpLearn/config/dunstrc`)  

# Installation

    git clone https://github.com/justUmen/PopUpLearn ~/.PopUpLearn

# Update (Manual for now)

	cd ~/.PopUpLearn && git pull origin master && cd -

# Nodejs server

# Configuration

# Usage

1 - Launch server with :  

     php -S 127.0.0.1:9999 -t ~/.PopUpLearn

2 - Launch client with :  

     ~/.PopUpLearn/launcher_html_popup.sh

# Logs everything
