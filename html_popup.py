from PyQt5.QtCore import QUrl 
from PyQt5.QtWidgets import QApplication 
from PyQt5.QtWebKitWidgets import QWebView 
import sys

#Third argument is 1 = have image to display !
if sys.argv[3] == "IMG":
	img="?img="+sys.argv[3]
else:
	img=""
#have a fourth argument = use quiz instead of popup :p
if sys.argv[4] == "QUIZ":
	DEFAULT_URL = 'http://127.0.0.1:9999/popup_quiz.php'+img
else:
	DEFAULT_URL = 'http://127.0.0.1:9999/popup.php'+img

app = QApplication(sys.argv) 
view = QWebView() 
view.show() 
view.setUrl(QUrl(DEFAULT_URL)) 
app.exec()

# ~ app = QApplication(sys.argv)
 
# ~ web = QWebView()
# ~ web.load(QUrl(DEFAULT_URL))

# ~ web.setWindowFlags(QtCore.Qt.FramelessWindowHint)
#web.setAttribute(QtCore.Qt.WA_TranslucentBackground)
#web.setStyleSheet("background:transparent;")
# ~ web.showMaximized()
 
# ~ sys.exit(app.exec_())

#LAUNCHED AUTOMATICLY BY launcher_html_popup.sh with for example :
#~/SyNc/Projects/wikiface_new/popup/html_popup.py 0 0 NO QUIZ
