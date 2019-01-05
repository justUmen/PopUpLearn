//Enable/ disable launch from another computer on the network (disable by default)
//iptables -A INPUT -p tcp -s localhost --dport 8888 -j ACCEPT
//iptables -A INPUT -p tcp --dport 8888 -j DROP

//DOES this work if request come from another website ? link loclahost or ip ???
var http = require("http");
var sys = require('util')
var exec = require('child_process').exec;
var url = require("url");
var qs = require("querystring");

function log_and_run(section,command){
	console.log(section+" = "+command);
	exec(command);
}

function onRequest(request, response) {
	var params = url.parse(request.url,true).query;
	function puts(error, stdout, stderr) {sys.puts(stdout)}
	code=params.type;
	//ALLOWED COMMANDS IN THERE
	switch(code){
		//POPUPLEARN
		//~ case "close_PopUpLearn": log_and_run("POPUPLEARN","pkill -f \"python3 $HOME/.PopUpLearn/html_popup.py\"");response.end();break
		//~ case "close_PopUpLearn_good": log_and_run("POPUPLEARN","echo good > $HOME/.PopUpLearn/tmp/result.tmp;pkill -f \"python3 $HOME/.PopUpLearn/html_popup.py\"");response.end();break
		//~ case "close_PopUpLearn_bad": log_and_run("POPUPLEARN","echo bad > $HOME/.PopUpLearn/tmp/result.tmp;pkill -f \"python3 $HOME/.PopUpLearn/html_popup.py\"");response.end();break

		//~ case "close_PopUpLearn": log_and_run("POPUPLEARN","pkill -f \"surf -F http://127.0.0.1:9995/popup.php\"");response.end();break
		//~ case "close_PopUpLearn_good": log_and_run("POPUPLEARN","echo good > $HOME/.PopUpLearn/tmp/result.tmp;pkill -f \"surf -F http://127.0.0.1:9995/popup_quiz.php\"");response.end();break
		//~ case "close_PopUpLearn_bad": log_and_run("POPUPLEARN","echo bad > $HOME/.PopUpLearn/tmp/result.tmp;pkill -f \"surf -F http://127.0.0.1:9995/popup_quiz.php\"");response.end();break

		case "close_PopUpLearn": log_and_run("POPUPLEARN","if [ -f ~/.PopUpLearn/MYDB/my.config ]; then source ~/.PopUpLearn/MYDB/my.config; pkill -f \"$WEB_BROWSER http://127.0.0.1:9995/popup.php\"; else pkill -f \"surf -F http://127.0.0.1:9995/popup.php\"; fi");response.end();break
		case "close_PopUpLearn_good": log_and_run("POPUPLEARN","echo good > $HOME/.PopUpLearn/tmp/result.tmp;if [ -f ~/.PopUpLearn/MYDB/my.config ]; then source ~/.PopUpLearn/MYDB/my.config; pkill -f \"$WEB_BROWSER http://127.0.0.1:9995/popup_quiz.php\"; else pkill -f \"surf -F http://127.0.0.1:9995/popup_quiz.php\"; fi");response.end();break
		case "close_PopUpLearn_bad": log_and_run("POPUPLEARN","echo bad > $HOME/.PopUpLearn/tmp/result.tmp;if [ -f ~/.PopUpLearn/MYDB/my.config ]; then source ~/.PopUpLearn/MYDB/my.config; pkill -f \"$WEB_BROWSER http://127.0.0.1:9995/popup_quiz.php\"; else pkill -f \"surf -F http://127.0.0.1:9995/popup_quiz.php\"; fi");response.end();break

		case "PopUpLearn_bad": log_and_run("POPUPLEARN","echo bad > $HOME/.PopUpLearn/tmp/result.tmp;");response.end();break

	}
}
http.createServer(onRequest).listen(8899,'localhost');
