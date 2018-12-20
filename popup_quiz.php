<html>
<head>
<title>popup_quiz.php</title>
<link href="bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<link href="popup.css" rel="stylesheet">
<script type="text/javascript">
//~ FOR NOW ONLY 1920x1080 and 1366x768 ??? NEEDED ???
//~ if(window.screen.availHeight==768){ document.write("<style>#content { width:1366px; }</style>"); }
//~ else{ document.write("<style>#content { width:1920px; }</style>"); }
</script>
<style>#content { width:100%; }</style>
<script>
function close_popup_good(){
	//record more stuff, date and how many time click to close ???
	//if click to close i saw it and need confirm + test + record :p
	var objReq = new XMLHttpRequest();
	objReq.open("GET", "http://localhost:8899" + "?type=close_PopUpLearn_good", false);
	objReq.send(null);
}
function close_popup_bad(){
	//record more stuff, date and how many time click to close ???
	//if click to close i saw it and need confirm + test + record :p
	var objReq = new XMLHttpRequest();
	objReq.open("GET", "http://localhost:8899" + "?type=close_PopUpLearn_bad", false);
	objReq.send(null);
}
</script>
</head>
<?php
//£ now
//$line example : 0:bash_1:Supprimer le fichier test dans le dossier /home:rm /home/test:fr:fr:BUTTON
$line = fgets(fopen("tmp/my_line.tmp", 'r'));
$e = explode("£", $line);
$FAMILY=$e[1];
$LEFT=$e[2];
$RIGHT=preg_replace("/\\\\\\\/","\\",$e[3]);
$LANGUAGE_TAG_1=$e[4];
$LANGUAGE_TAG_2=$e[5];
$TYPE=preg_replace("/\n/","",$e[6]); #TEXT OR BUTTON
?>
<script>
function good_answer(){
	console.log("function good_answer");
	//~ execute_with_node_server('echo "<?php echo $LEFT; ?>:<?php echo $RIGHT; ?>" >> ~/SyNc/Projects/wikiface_new/popup/LOGS/good_answer;');
	close_popup_good();
}
function bad_answer(){
//~ console.log("<?php echo $RIGHT; ?>");
//~ console.log("<?php echo $e[3]; ?>");
	close_popup_bad();
	//1 - Disable launcher_html_popup.sh
	//2 - kill html popup
	//3 - start again another question
	//execute_with_node_server('~/SyNc/Projects/wikiface_new/popup/toggle_popup.sh;pkill -f "python3 ~/SyNc/Projects/wikiface_new/popup/html_popup.py";sleep 2;~/SyNc/Projects/wikiface_new/popup/toggle_popup.sh');
	//~ return 0; //DO NOTHING FOR NOW
	//close_popup();
}
</script>
<body onload="document.getElementById('search-input').focus();">
<div id="on_click_close">
<div class='widget' id="content" style="top:10%;">
<?php echo "<div id='left_right'><img src='img/flags/{$LANGUAGE_TAG_1}.jpeg' /> : <img src='img/flags/{$LANGUAGE_TAG_2}.jpeg' /></div>"; ?><br>
<?php echo "<div id='left_right'>{$LEFT} : _____</div>"; ?>

<?php
//Array with 30 wrong answers (wrong_answers_BUTTON.tmp created by launcher_html_popup.sh)
$result=array();
//~ echo $TYPE;
if($TYPE=="BUTTON"){
	$lines_wrong=file("tmp/wrong_answers_BUTTON.tmp", FILE_IGNORE_NEW_LINES);
	//PB if file contains less than X lines :P infinite loop :D ???
	for ($i=0;$i!=20;$i++){
		$RAND=array_rand($lines_wrong);
		$line=$lines_wrong[$RAND];
		unset($lines_wrong[$RAND]);
		//~ echo " + ${line} + ";
		array_push($result,"{$line}");
	}
	echo "<div style='margin-top:10px;'>";
	$a=array();
	$b=array();
	//ADD BAD ANSWERS
	foreach($result as $row) {
		array_push($a,"<a style='background-color:black;margin:3px;' class='btn glyphicon' onclick='bad_answer();' href='#'>{$row}</a>");
		array_push($b,"{$row}");
	}
	//ADD GOOD ANSWER
	array_push($a,"<a style='background-color:black;margin:3px;' class='btn glyphicon' onclick='good_answer(\"{$LEFT}\",\"{$RIGHT}\");' href='#'>{$RIGHT}</a>");
	array_push($b,"{$RIGHT}");
	shuffle($a);
	shuffle($b);
	echo "</div>";
}
?>

<script src="react_search/react.min.js"></script>
<script src="react_search/react-search-input.js"></script>
<div id="app"></div>

<script>
NB_OF_BUTTON=0;
ONLY_GOOD_ANSWER=0;
//~ if("<?php echo $TYPE; ?>" == "TEXT"){


var App = React.createClass({
	displayName: "App",
	render: function render(){
		var mails = [
		<?php
		if(!empty($b)) for ($i = 0; $i < count($b); $i++) {
			$elem=$b[$i];
//~ $elem=preg_replace("/\\/", "\\\\", $b[$i]);
//~ $elem=preg_replace('/\\\\/','_',$elem);
//~ $elem=preg_replace('/\\\\\\/','_',$elem);
//~ $elem_CLEAN=$elem;
			if($elem==$RIGHT){
			echo <<<END
				{
				  user: {
					name: `$elem`,
					LEFT: `$LEFT`,
					answer: 'good'
				  },
				},
END;
			}
			else {
			echo <<<END
				{
				  user: {
					name: `$elem`,
					answer: 'bad'
				  },
				},
END;
			}
		}
		?>
		];
		if (this.refs.search) {
			var filters = ['user.name'];
			mails = mails.filter(this.refs.search.filter(filters));
			//console.log(mails.length);
			//console.log(mails[0].user.answer);
			NB_OF_BUTTON=mails.length;
			if(NB_OF_BUTTON == 1){
				if(mails[0].user.answer == "good"){
					ONLY_GOOD_ANSWER=1;
				}
			}
		}
		if("<?php echo $TYPE; ?>" == "BUTTON"){
			return (
				React.createElement("div", null,
					React.createElement(SearchInput, {id: 'focus_search',ref: "search", onChange: this.searchUpdated}),
					mails.map(function(mail) {
						if(<?php if("$LANGUAGE_TAG_2"=="IM"){echo "1";}else{echo "0";} ?>){ //IF image
							if (mail.user.answer=="good") return (
									React.createElement("div", { onClick : good_answer, className: "btn glyphicon",style: {margin: "3px", backgroundColor: "black"}}).createElement("img", { onClick : good_answer, src: mail.user.name, className: "btn glyphicon",style: {margin: "3px"}})
							);
							else return (
								React.createElement("img", { onClick : bad_answer, src: mail.user.name, className: "btn glyphicon",style: {margin: "3px"}})
							);
						}
						else{
							if (mail.user.answer=="good") return (
									React.createElement("div", { onClick : good_answer, className: "btn glyphicon",style: {margin: "3px", backgroundColor: "black"}}, mail.user.name)
							);
							else return (
								React.createElement("div", { onClick : bad_answer, className: "btn glyphicon",style: {margin: "3px", backgroundColor: "black"}}, mail.user.name)
							);
						}
					})
				)
			);
		}
		else{
			return (
				React.createElement("div", null,
					React.createElement(SearchInput, {id: 'focus_search',ref: "search", onChange: this.searchUpdated})
				)
			);
		}
	},
	searchUpdated: function searchUpdated(term) {
		this.setState({searchTerm: term}); // needed to force re-render
	}
});
	React.render(React.createElement(App, null), document.getElementById("app"));

	document.addEventListener('keydown', function(evt) {
		if(window.event.keyCode == 13){
			if (document.getElementById("search-input").value == `<?php echo $RIGHT; ?>`){
				console.log("Exact answer typed");
				good_answer();
			}
			else if(NB_OF_BUTTON == 1 && ONLY_GOOD_ANSWER == 1) {
				console.log(window.event.keyCode+" "+NB_OF_BUTTON);
				good_answer();
			}
			else{
				bad_answer();
			}
		}
	});
</script>
</div> <!-- content -->
</div> <!-- on_click_close -->

<?php
//MENU BAR : out of #on_click_close so onclick don't close
echo "<div id='bottom_bar' style='text-align:center;'>";
echo "<a class='btn glyphicon glyphicon-trash' onclick='close_popup();' href='#' title='$RIGHT'></a>";
echo "</div>";
?>
</body>
</html>
