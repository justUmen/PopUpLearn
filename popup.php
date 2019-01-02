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
function openCity(evt, cityName) {
  // Declare all variables
  var i, tabcontent, tablinks;

  // Get all elements with class="tabcontent" and hide them
  tabcontent = document.getElementsByClassName("tabcontent");
  for (i = 0; i < tabcontent.length; i++) {
    tabcontent[i].style.display = "none";
  }

  // Get all elements with class="tablinks" and remove the class "active"
  tablinks = document.getElementsByClassName("tablinks");
  for (i = 0; i < tablinks.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Show the current tab, and add an "active" class to the button that opened the tab
  document.getElementById(cityName).style.display = "block";
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
//~ $e[6] not used in popup.php, only popup_quiz.php
?>
<body>

	<div id="left_arrow" onclick="document.getElementById('side_left').style.display='block';document.getElementById('left_arrow').style.display='none';">🡆</div>
	<div id="right_arrow" onclick="document.getElementById('side_right').style.display='block';document.getElementById('right_arrow').style.display='none';">🡄</div>
	<div id="side_left">
		<object data="https://en.wiktionary.org/wiki/<?php echo $LEFT; ?>" width="100%" height="100%">
      <embed src="https://en.wiktionary.org/wiki/<?php echo $LEFT; ?>" width="100%" height="100%"> </embed>
      Error: Embedded data could not be displayed.
    </object>
	</div>

	<div id="side_right">
		<div class="tab">
		  <button class="tablinks" onclick="openCity(event, 'wiktionary')">wiktionary</button>
		  <button class="tablinks" onclick="openCity(event, 'wikipedia')">wikipedia</button>
		  <button class="tablinks" onclick="openCity(event, 'wikipul')">wikipul</button>
		</div>

		<!-- Tab content -->
		<div id="wiktionary" class="tabcontent">
			<object data="https://en.wiktionary.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%">
	      <embed src="https://en.wiktionary.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%"> </embed>
	      Error: Embedded data could not be displayed.
	    </object>
		</div>

		<div id="wikipedia" class="tabcontent">
			<object data="https://<?php echo $LANGUAGE_TAG_2; ?>.wikipedia.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%">
	      <embed src="https://<?php echo $LANGUAGE_TAG_2; ?>.wikipedia.org/wiki/<?php echo $RIGHT; ?>" width="100%" height="100%"> </embed>
	      Error: Embedded data could not be displayed.
	    </object>
		</div>

		<div id="wikipul" class="tabcontent">
		  <h3>Tokyo</h3>
		  <p>Tokyo is the capital of Japan.</p>
		</div>
	</div>

<div id="on_click_close" onclick="close_popup();return false;">
	<div class='widget' id="content">
		<div><img src='img/flags/<?php echo $LANGUAGE_TAG_1; ?>.jpeg' /> <span class="bigfont"><?php echo $LEFT; ?></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="bigfont"><?php echo $RIGHT; ?></span> <img src='img/flags/<?php echo $LANGUAGE_TAG_2; ?>.jpeg' /></div>
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

//for audio.play() :p
//~ audio = new Audio("http://localhost/wikiface_new/soundDB/th/<?php echo $LEFT; ?>.mp3");
//~ audio.volume=1;
//~ function audio_play(arg){
	//~ console.log(arg);
	//~ var objReq = new XMLHttpRequest();
	//~ objReq.open("GET", "http://localhost:8888" + "?type=" + "mplayer \"~/SyNc/Projects/wikiface_new/soundDB/<?php echo $LANGUAGE_TAG_1; ?>/<?php echo $LEFT; ?>.mp3\" \"~/SyNc/Projects/wikiface_new/soundDB/<?php echo $LANGUAGE_TAG_2; ?>/<?php echo $RIGHT; ?>.mp3\"" , false);
	//~ objReq.send(null);
//~ }

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
