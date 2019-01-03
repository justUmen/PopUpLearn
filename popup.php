<html>
<head>
<title>popup.php</title>
<link href="bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<link href="popup.css" rel="stylesheet">
<script type="text/javascript">
//~ FOR NOW ONLY 1920x1080 and 1366x768 ??? NEEDED ???
//~ if(window.screen.availHeight==768){ document.write("<style>#content { width:1366px; }</style>"); }
//~ else{ document.write("<style>#content { width:1920px; }</style>"); }
</script>
<style>#content { width:100%; }</style>
<script>
function close_popup(){
	//record more stuff, date and how many time click to close ???
	//if click to close i saw it and need confirm + test + record :p
	var objReq = new XMLHttpRequest();
	objReq.open("GET", "http://localhost:8899" + "?type=close_PopUpLearn", false);
	objReq.send(null);
}
function openCity_1(evt, tabName) {
  // Declare all variables
  var i, tabcontent_1, tablinks_1;
  // Get all elements with class="tabcontent" and hide them
  tabcontent_1 = document.getElementsByClassName("tabcontent_1");
  for (i = 0; i < tabcontent_1.length; i++) {
    tabcontent_1[i].style.display = "none";
  }
  // Get all elements with class="tablinks" and remove the class "active"
  tablinks_1 = document.getElementsByClassName("tablinks_1");
  for (i = 0; i < tablinks_1.length; i++) {
    tablinks_1[i].className = tablinks_1[i].className.replace(" active", "");
  }
  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(tabName).style.display = "block";
  evt.currentTarget.className += " active";
}
function openCity_2(evt, tabName) {
  // Declare all variables
  var i, tabcontent_2, tablinks_2;
  // Get all elements with class="tabcontent" and hide them
  tabcontent_2 = document.getElementsByClassName("tabcontent_2");
  for (i = 0; i < tabcontent_2.length; i++) {
    tabcontent_2[i].style.display = "none";
  }
  // Get all elements with class="tablinks" and remove the class "active"
  tablinks_2 = document.getElementsByClassName("tablinks_2");
  for (i = 0; i < tablinks_2.length; i++) {
    tablinks_2[i].className = tablinks_2[i].className.replace(" active", "");
  }
  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(tabName).style.display = "block";
  evt.currentTarget.className += " active";
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
$RIGHT=$e[3];
$LANGUAGE_TAG_1=$e[4];
$LANGUAGE_TAG_2=$e[5];

$LANGUAGE_WIKIPEDIA_1=$LANGUAGE_TAG_1;
$LANGUAGE_WIKIPEDIA_2=$LANGUAGE_TAG_2;
//If chinese, use zh.wikipedia.org
if("$LANGUAGE_WIKIPEDIA_1"=="cn"){$LANGUAGE_WIKIPEDIA_1="zh";}
if("$LANGUAGE_WIKIPEDIA_2"=="cn"){$LANGUAGE_WIKIPEDIA_2="zh";}
//~ $e[6] not used in popup.php, only popup_quiz.php
?>
<body>

	<div id="left_arrow" onclick="document.getElementById('side_left').style.display='block'; document.getElementById('left_arrow').style.display='none';">🡆</div>
	<div id="right_arrow" onclick="document.getElementById('side_right').style.display='block'; document.getElementById('right_arrow').style.display='none';">🡄</div>

	<div id="left_arrow_hide" onclick="document.getElementById('side_left').style.display='none'; document.getElementById('left_arrow').style.display='block';">X</div>
	<div id="right_arrow_hide" onclick="document.getElementById('side_right').style.display='none'; document.getElementById('right_arrow').style.display='block';">X</div>

	<div id="side_left">
		<div class="tab_1">
		  <button class="tablinks_1" onclick="openCity_1(event, 'wiktionary_1')">wiktionary</button>
		  <button class="tablinks_1" onclick="openCity_1(event, 'wikipedia_1')">wikipedia</button>
		  <button class="tablinks_1" onclick="openCity_1(event, 'wikipul_1')">wikipul</button>
		</div>

		<!-- Tab content -->
		<div id="wiktionary_1" class="tabcontent_1">
			<object data="https://en.wiktionary.org/wiki/<?php echo $LEFT; ?>" width="100%" height="100%">
	      <embed src="https://en.wiktionary.org/wiki/<?php echo $LEFT; ?>" width="100%" height="100%"> </embed>
	      Error: Embedded data could not be displayed.
	    </object>
		</div>

		<div id="wikipedia_1" class="tabcontent_1">
			<object data="https://<?php echo $LANGUAGE_WIKIPEDIA_1; ?>.wikipedia.org/wiki/<?php echo $LEFT; ?>" width="100%" height="100%">
	      <embed src="https://<?php echo $LANGUAGE_WIKIPEDIA_1; ?>.wikipedia.org/wiki/<?php echo $LEFT; ?>" width="100%" height="100%"> </embed>
	      Error: Embedded data could not be displayed.
	    </object>
		</div>

		<div id="wikipul_1" class="tabcontent_1">
		  <h3>wikipul</h3>
		  <p>Not yet implemented.... :(</p>
		</div>
	</div>

	<div id="side_right">
		<div class="tab_2">
		  <button class="tablinks_2" onclick="openCity_2(event, 'wiktionary_2')">wiktionary</button>
		  <button class="tablinks_2" onclick="openCity_2(event, 'wikipedia_2')">wikipedia</button>
		  <button class="tablinks_2" onclick="openCity_2(event, 'wikipul_2')">wikipul</button>
		</div>

		<!-- Tab content -->
		<div id="wiktionary_2" class="tabcontent_2">
			<object data="https://en.wiktionary.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%">
	      <embed src="https://en.wiktionary.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%"> </embed>
	      Error: Embedded data could not be displayed.
	    </object>
		</div>

		<div id="wikipedia_2" class="tabcontent_2">
			<object data="https://<?php echo $LANGUAGE_WIKIPEDIA_2; ?>.wikipedia.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%">
	      <embed src="https://<?php echo $LANGUAGE_WIKIPEDIA_2; ?>.wikipedia.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%"> </embed>
	      Error: Embedded data could not be displayed.
	    </object>
		</div>

		<div id="wikipul_2" class="tabcontent_2">
		  <h3>wikipul</h3>
		  <p>Not yet implemented.... :(</p>
		</div>
	</div>

<div id="on_click_close">
	<div class='widget' id="content">
		<div class="align-center">
			<table style="text-align: center;width: 100%;"><tr><td style="width:45%;text-align:right;">
			<img src='img/flags/<?php echo $LANGUAGE_TAG_1; ?>.jpeg' />
			<span class="bigfont"><?php echo $LEFT; ?></span>
		</td><td style="width:5%">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</td><td style="width:45%;text-align:left;">
			<span class="bigfont"><?php echo $RIGHT; ?></span>
			<img src='img/flags/<?php echo $LANGUAGE_TAG_2; ?>.jpeg' />
		</td></tr></table>
		</div>
		<div class="align-center">
			<a class='play-icon btn glyphicon glyphicon-volume-up' onclick='audio_play_1();return false' href='#' title='Play sound'></a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a class='play-icon btn glyphicon glyphicon-volume-up' onclick='audio_play_2();return false' href='#' title='Play sound'></a>
		</div>
	</div>
	<div class="align-center">
		<a class='btn glyphicon glyphicon-remove' onclick="close_popup();return false;" href='#' title='close popup'></a>
	</div>
	<?php
	if(isset($_GET['img'])){
		echo "<div id='Image1' class='widget'><img src='imgDB/{$LANG}/{$FAMILY}/{$LEFT}_{$RIGHT}.png' /></div>";
		echo "<div id='Image2' class='widget'><img src='imgDB/{$LANG}/{$FAMILY}/{$LEFT}_{$RIGHT}.png' /></div>";
	}
	?>
</div>
<?php
//MENU BAR : out of #on_click_close so onclick don't close ??? TODO
// echo "<div id='bottom_bar'>";
// echo "	<a class='btn glyphicon glyphicon-random' onclick='new_random_error();' href='#' title='New random error'></a>";
// echo "	<a class='btn glyphicon glyphicon-headphones' onclick='audio_play();return false' href='#' title='Play sound'></a>";
// echo "	<a class='btn glyphicon glyphicon-list' onclick='return false' href='#' title='List all'></a>";
// echo "	<a class='btn glyphicon glyphicon-stats' onclick='return false' href='#' title='My stats'></a>";
// echo "	<a class='btn glyphicon glyphicon-volume-up' onclick='return false' href='#' title='Toggle Sound'></a>";
// echo "	<a class='btn glyphicon glyphicon-edit' onclick='return false' href='#' title='Edit this page'></a>";
// echo "	<a class='btn glyphicon glyphicon-trash' onclick='return false' href='#' title='Delete this link'></a>";
// echo "</div>";
?>
</body>
<script>

//Play touch keyboard
//~ document.onkeypress = function(){
	//~ audio_play();
//~ };

function audio_play_1() {
  var audio = new Audio("http://127.0.0.1:9092/soundDB/<?php echo $LANGUAGE_TAG_1; ?>/<?php echo $LEFT; ?>.mp3");
  audio.type = 'audio/mp3';

  var playPromise = audio.play();

  if (playPromise !== undefined) {
      playPromise.then(function () {
          console.log('Playing....');
      }).catch(function (error) {
          console.log('Failed to play....' + error);
      });
  }
}


function audio_play_2() {
  var audio = new Audio("http://127.0.0.1:9092/soundDB/<?php echo $LANGUAGE_TAG_2; ?>/<?php echo $RIGHT; ?>.mp3");
  audio.type = 'audio/mp3';

  var playPromise = audio.play();

  if (playPromise !== undefined) {
      playPromise.then(function () {
          console.log('Playing....');
      }).catch(function (error) {
          console.log('Failed to play....' + error);
      });
  }
}


//for audio.play() :p
// audio_1 = new Audio("http://127.0.0.1/soundDB/<?php echo $LANGUAGE_TAG_1; ?>/<?php echo $LEFT; ?>.mp3");
// audio_1.volume=1;
// function audio_play_1(arg){
// 	console.log(arg);
// 	var objReq = new XMLHttpRequest();
// 	objReq.open("GET", "http://localhost:8888" + "?type=" + "mplayer \"~/SyNc/Projects/wikiface_new/soundDB/<?php echo $LANGUAGE_TAG_1; ?>/<?php echo $LEFT; ?>.mp3\" \"~/SyNc/Projects/wikiface_new/soundDB/<?php echo $LANGUAGE_TAG_2; ?>/<?php echo $RIGHT; ?>.mp3\"" , false);
// 	objReq.send(null);
// }

//~ window.onload = function(){
 //~ setTimeout(function(){
   //~ audio_play();
 //~ }, 1000);
//~ };
	document.addEventListener('keydown', function(evt) {
		if(evt.keyCode == 32) {
			close_popup();
		}
	});
</script>

</html>
