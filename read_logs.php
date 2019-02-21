<!--
TODO / ADD :
- TOP 10 worst errors in the last X days
- Detect automatically the current level based on real answer ??? (delete false "bad answer" but lvl stay low)
-->

<!DOCTYPE html>
<head>
  <script type="text/javascript" src="d3.v4.min.js"></script>
  <style>

  #menu_buttons{
    position:fixed;
    right:0px;
    width: 600px;
    top:380px;
    /* background-color:orange; */
  }

  .tooltip_right {
    position: relative;
    display: inline-block;
    border-bottom: 1px dotted black;
    border:1px solid black;
    /* to keep size after hover */
  }

  .tooltip_right:hover{
    border:1px solid white;
    background-color: #333;
  }

  .tooltip_right .tooltiptext_right {
    visibility: hidden;
    width: 120px;
    background-color: black;
    color: #fff;
    text-align: center;
    border-radius: 6px;
    padding: 5px 0;
    border:1px solid white;

    /* Position the tooltip */
    position: absolute;
    z-index: 1;
    top: -5px;
    left: 105%;
  }

  .tooltip_right:hover .tooltiptext_right {
    visibility: visible;
  }

  .tooltip {
    position: relative;
    display: inline-block;
    border-bottom: 1px dotted black;
    border:1px solid black;
    /* to keep size after hover */
  }

  .tooltip:hover{
    border:1px solid white;
    background-color: #333;
  }

  .tooltip .tooltiptext {
    visibility: hidden;
    width: 120px;
    background-color: #333;
    color: #fff;
    text-align: center;
    border-radius: 6px;
    padding: 5px 0;
    border: 1px solid white;

    /* Position the tooltip */
    position: absolute;
    z-index: 1;
    bottom: 100%;
    left: 50%;
    margin-left: -60px;
  }

  /* Show the tooltip text when you mouse over the tooltip container */
  .tooltip:hover .tooltiptext {
    visibility: visible;
  }

  .line_good {
     fill: none;
     stroke: #00FF00;
     stroke-width: 2px;
  }
  .line_bad {
     fill: none;
     stroke: red;
     stroke-width: 2px;
  }
  .my_svg text, .my_svg{
     fill: #FFF;
  }

  /* svg{background-color:white;} */

  /* body{
    margin-top:400px;
  } */

  .my_svg{
    position:fixed;
    top:0px;
    right:20px;
  }

  .grid-container {
    display: grid;
    grid-template-columns: 100%;
  }

  .grid-container > div {
    text-align: left;
    font-size: 18px !important;
  }

  *{background-color:black;color:gray;text-align:left;font-family:Arial;cursor: pointer;}

  .slidecontainer {
    width: 100%;
    top:300px;
    position:fixed;
    right:10px;
  }

  .slider {
    -webkit-appearance: none;
    width: 100%;
    height: 15px;
    background: #d3d3d3;
    outline: none;
    opacity: 0.7;
    -webkit-transition: .2s;
    transition: opacity .2s;
  }

  .slider:hover {
    opacity: 1;
  }

  .slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 25px;
    height: 25px;
    background: black;
    border:1px solid white;
    cursor: pointer;
  }

  .slider::-moz-range-thumb {
    width: 25px;
    height: 25px;
    background: #4CAF50;
    cursor: pointer;
  }

  .btn {
  display: inline-block;
  padding: 6px 12px;
margin:5px;
  font-size: 14px;
  font-weight: normal;
  line-height: 1.42857143;
  text-align: center;
  white-space: nowrap;
  vertical-align: middle;
  cursor: pointer;
  -webkit-user-select: none;
     -moz-user-select: none;
      -ms-user-select: none;
          user-select: none;
  background-image: none;
  border: 1px solid transparent;
  border-radius: 4px;
}
.btn:focus,
.btn:active:focus,
.btn.active:focus {
  outline: thin dotted;
  outline: 5px auto -webkit-focus-ring-color;
  outline-offset: -2px;
}
.btn:hover,
.btn:focus {
  color: #333;
  text-decoration: none;
}
.btn:active,
.btn.active {
  background-image: none;
  outline: 0;
  -webkit-box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125);
          box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125);
}
.btn.disabled,
.btn[disabled],
fieldset[disabled] .btn {
  pointer-events: none;
  cursor: not-allowed;
  filter: alpha(opacity=65);
  -webkit-box-shadow: none;
          box-shadow: none;
  opacity: .65;
}
.btn-default {
  color: #333;
  background-color: #fff;
  border-color: #ccc;
}
.btn-default:hover,
.btn-default:focus,
.btn-default:active,
.btn-default.active,
.open .dropdown-toggle.btn-default {
  color: #333;
  background-color: #ebebeb;
  border-color: #adadad;
}
.btn-default:active,
.btn-default.active,
.open .dropdown-toggle.btn-default {
  background-image: none;
}
.btn-default.disabled,
.btn-default[disabled],
fieldset[disabled] .btn-default,
.btn-default.disabled:hover,
.btn-default[disabled]:hover,
fieldset[disabled] .btn-default:hover,
.btn-default.disabled:focus,
.btn-default[disabled]:focus,
fieldset[disabled] .btn-default:focus,
.btn-default.disabled:active,
.btn-default[disabled]:active,
fieldset[disabled] .btn-default:active,
.btn-default.disabled.active,
.btn-default[disabled].active,
fieldset[disabled] .btn-default.active {
  background-color: #fff;
  border-color: #ccc;
}
.btn-default .badge {
  color: #fff;
  background-color: #333;
}
.btn-primary {
  color: #fff;
  background-color: #4b28ca;
  border-color: #357ebd;
}
.btn-primary:hover,
.btn-primary:focus,
.btn-primary:active,
.btn-primary.active,
.open .dropdown-toggle.btn-primary {
  color: #fff;
  background-color: #3276b1;
  border-color: #285e8e;
}
.btn-primary:active,
.btn-primary.active,
.open .dropdown-toggle.btn-primary {
  background-image: none;
}
.btn-primary.disabled,
.btn-primary[disabled],
fieldset[disabled] .btn-primary,
.btn-primary.disabled:hover,
.btn-primary[disabled]:hover,
fieldset[disabled] .btn-primary:hover,
.btn-primary.disabled:focus,
.btn-primary[disabled]:focus,
fieldset[disabled] .btn-primary:focus,
.btn-primary.disabled:active,
.btn-primary[disabled]:active,
fieldset[disabled] .btn-primary:active,
.btn-primary.disabled.active,
.btn-primary[disabled].active,
fieldset[disabled] .btn-primary.active {
  background-color: #428bca;
  border-color: #357ebd;
}
.btn-primary .badge {
  color: #428bca;
  background-color: #fff;
}
.btn-success {
  color: #fff;
  background-color: #5cb85c;
  border-color: #4cae4c;
}
.btn-success:hover,
.btn-success:focus,
.btn-success:active,
.btn-success.active,
.open .dropdown-toggle.btn-success {
  color: #fff;
  background-color: #47a447;
  border-color: #398439;
}
.btn-success:active,
.btn-success.active,
.open .dropdown-toggle.btn-success {
  background-image: none;
}
.btn-success.disabled,
.btn-success[disabled],
fieldset[disabled] .btn-success,
.btn-success.disabled:hover,
.btn-success[disabled]:hover,
fieldset[disabled] .btn-success:hover,
.btn-success.disabled:focus,
.btn-success[disabled]:focus,
fieldset[disabled] .btn-success:focus,
.btn-success.disabled:active,
.btn-success[disabled]:active,
fieldset[disabled] .btn-success:active,
.btn-success.disabled.active,
.btn-success[disabled].active,
fieldset[disabled] .btn-success.active {
  background-color: #5cb85c;
  border-color: #4cae4c;
}
.btn-success .badge {
  color: #5cb85c;
  background-color: #fff;
}
.btn-info {
  color: #fff;
  background-color: #5bc0de;
  border-color: #46b8da;
}
.btn-info:hover,
.btn-info:focus,
.btn-info:active,
.btn-info.active,
.open .dropdown-toggle.btn-info {
  color: #fff;
  background-color: #39b3d7;
  border-color: #269abc;
}
.btn-info:active,
.btn-info.active,
.open .dropdown-toggle.btn-info {
  background-image: none;
}
.btn-info.disabled,
.btn-info[disabled],
fieldset[disabled] .btn-info,
.btn-info.disabled:hover,
.btn-info[disabled]:hover,
fieldset[disabled] .btn-info:hover,
.btn-info.disabled:focus,
.btn-info[disabled]:focus,
fieldset[disabled] .btn-info:focus,
.btn-info.disabled:active,
.btn-info[disabled]:active,
fieldset[disabled] .btn-info:active,
.btn-info.disabled.active,
.btn-info[disabled].active,
fieldset[disabled] .btn-info.active {
  background-color: #5bc0de;
  border-color: #46b8da;
}
.btn-info .badge {
  color: #5bc0de;
  background-color: #fff;
}
.btn-warning {
  color: #fff;
  background-color: #f0ad4e;
  border-color: #eea236;
}
.btn-warning:hover,
.btn-warning:focus,
.btn-warning:active,
.btn-warning.active,
.open .dropdown-toggle.btn-warning {
  color: #fff;
  background-color: #ed9c28;
  border-color: #d58512;
}
.btn-warning:active,
.btn-warning.active,
.open .dropdown-toggle.btn-warning {
  background-image: none;
}
.btn-warning.disabled,
.btn-warning[disabled],
fieldset[disabled] .btn-warning,
.btn-warning.disabled:hover,
.btn-warning[disabled]:hover,
fieldset[disabled] .btn-warning:hover,
.btn-warning.disabled:focus,
.btn-warning[disabled]:focus,
fieldset[disabled] .btn-warning:focus,
.btn-warning.disabled:active,
.btn-warning[disabled]:active,
fieldset[disabled] .btn-warning:active,
.btn-warning.disabled.active,
.btn-warning[disabled].active,
fieldset[disabled] .btn-warning.active {
  background-color: #f0ad4e;
  border-color: #eea236;
}
.btn-warning .badge {
  color: #f0ad4e;
  background-color: #fff;
}
.btn-danger {
  color: #fff;
  background-color: #d9534f;
  border-color: #d43f3a;
}
.btn-danger:hover,
.btn-danger:focus,
.btn-danger:active,
.btn-danger.active,
.open .dropdown-toggle.btn-danger {
  color: #fff;
  background-color: #d2322d;
  border-color: #ac2925;
}
.btn-danger:active,
.btn-danger.active,
.open .dropdown-toggle.btn-danger {
  background-image: none;
}
.btn-danger.disabled,
.btn-danger[disabled],
fieldset[disabled] .btn-danger,
.btn-danger.disabled:hover,
.btn-danger[disabled]:hover,
fieldset[disabled] .btn-danger:hover,
.btn-danger.disabled:focus,
.btn-danger[disabled]:focus,
fieldset[disabled] .btn-danger:focus,
.btn-danger.disabled:active,
.btn-danger[disabled]:active,
fieldset[disabled] .btn-danger:active,
.btn-danger.disabled.active,
.btn-danger[disabled].active,
fieldset[disabled] .btn-danger.active {
  background-color: #d9534f;
  border-color: #d43f3a;
}
.btn-danger .badge {
  color: #d9534f;
  background-color: #fff;
}
.btn-link {
  font-weight: normal;
  color: #428bca;
  cursor: pointer;
  border-radius: 0;
}
.btn-link,
.btn-link:active,
.btn-link[disabled],
fieldset[disabled] .btn-link {
  background-color: transparent;
  -webkit-box-shadow: none;
          box-shadow: none;
}
.btn-link,
.btn-link:hover,
.btn-link:focus,
.btn-link:active {
  border-color: transparent;
}
.btn-link:hover,
.btn-link:focus {
  color: #2a6496;
  text-decoration: underline;
  background-color: transparent;
}
.btn-link[disabled]:hover,
fieldset[disabled] .btn-link:hover,
.btn-link[disabled]:focus,
fieldset[disabled] .btn-link:focus {
  color: #999;
  text-decoration: none;
}
.btn-lg,
.btn-group-lg > .btn {
  padding: 10px 16px;
  font-size: 18px;
  line-height: 1.33;
  border-radius: 6px;
}
.btn-sm,
.btn-group-sm > .btn {
  padding: 5px 10px;
  font-size: 12px;
  line-height: 1.5;
  border-radius: 3px;
}
.btn-xs,
.btn-group-xs > .btn {
  padding: 1px 5px;
  font-size: 12px;
  line-height: 1.5;
  border-radius: 3px;
}
.btn-block {
  display: block;
  width: 100%;
  padding-right: 0;
  padding-left: 0;
}
.btn-block + .btn-block {
  margin-top: 5px;
}
input[type="submit"].btn-block,
input[type="reset"].btn-block,
input[type="button"].btn-block {
  width: 100%;
}



.styled-select {
   border:2px solid #2a6496;
   /* width: 30px; */
   padding: 5px;
   font-size: 16px;
   line-height: 1;
   border-radius: 10px;
   height: 34px;

}


.session_title_number, .gray_lines{
  display:none;
}
  </style>
</head>

<?php
if(isset($_GET['DELAY'])){$DELAY=$_GET['DELAY'];}else{$DELAY=7;}
?>

<body onload="document.getElementById('myRange').focus();">
<!-- <body> -->
<div id="bodypre"></div>

      <?php

// ███████ ██      ██ ██████  ███████ ██████
// ██      ██      ██ ██   ██ ██      ██   ██
// ███████ ██      ██ ██   ██ █████   ██████
//      ██ ██      ██ ██   ██ ██      ██   ██
// ███████ ███████ ██ ██████  ███████ ██   ██

      ?>

<div class="slidecontainer" style="width:600px;">
  <input type="range" min="1" value="<?php echo $DELAY; ?>" class="slider" id="myRange">
  <p>Days delay : <span id="demo" style="color:cyan;"></span> (<var id="delay_recommended">X</var> is recommended - 10+ most recent mistakes)</p>
</div>

<pre style="font-family:Monospace;color:white;">

 ▄▄▄▄▄▄                        ▄▄    ▄▄            ▄▄
 ██▀▀▀▀█▄                      ██    ██            ██
 ██    ██   ▄████▄   ██▄███▄   ██    ██  ██▄███▄   ██         ▄████▄    ▄█████▄   ██▄████  ██▄████▄
 ██████▀   ██▀  ▀██  ██▀  ▀██  ██    ██  ██▀  ▀██  ██        ██▄▄▄▄██   ▀ ▄▄▄██   ██▀      ██▀   ██
 ██        ██    ██  ██    ██  ██    ██  ██    ██  ██        ██▀▀▀▀▀▀  ▄██▀▀▀██   ██       ██    ██
 ██        ▀██▄▄██▀  ███▄▄██▀  ▀██▄▄██▀  ███▄▄██▀  ██▄▄▄▄▄▄  ▀██▄▄▄▄█  ██▄▄▄███   ██       ██    ██
 ▀▀          ▀▀▀▀    ██ ▀▀▀      ▀▀▀▀    ██ ▀▀▀    ▀▀▀▀▀▀▀▀    ▀▀▀▀▀    ▀▀▀▀ ▀▀   ▀▀       ▀▀    ▀▀
                     ██                  ██

</pre>

<?php
// $PUL="logs/cnPI/en/hsk/1/HSK1_cnPI_en.pul";
if(isset($_GET['PUL'])){$PUL=$_GET['PUL'];}else{$PUL="logs/cnPI/en/hsk/1/HSK1_cnPI_en.pul";}
function rsearch($folder, $pattern, $pul) {
    $iti = new RecursiveDirectoryIterator($folder);
    foreach(new RecursiveIteratorIterator($iti) as $file){
         if(strpos($file , $pattern) !== false){
           $change=str_replace("/session_1/session_content.pul","",$file);
           if($pul==$change){
             echo "<option value=\"$change\" selected>$change</option>";
           }
           else{
             echo "<option value=\"$change\">$change</option>";
           }
            // return $file;
         }
    }
    // return false;
}

// answer.bad  answer.bad.date  answer.good  answer.good.date  answer.level  session_content.pul  session_specific_config.conf
$ALL_BAD_DATES_LINES=array();
$ALL_GOOD_DATES_LINES=array();

$today = new DateTime();
$ref = new DateTime("2018-01-01");
$diff = $today->diff($ref);
$TODAY=$diff->days; //398
// echo "today is $TODAY";
$DELAY_DAYS_ERRORS=$TODAY-$DELAY; //If error was long time ago, ignore it

?>

<h3 style="font-family:Monospace;color:white;">Pul file :
<select onchange="window.location='read_logs.php?PUL=' + document.getElementById('select_pul').value;" id="select_pul" class="styled-select">
<?php
rsearch('logs/', "/session_1/session_content.pul",$PUL);
?>
<select>
</h3>

<?php
// FIND MAXIMUM SESSION WITH if (!is_dir($dir))
//FOR EACH SESSIONS
$THE_GRID="";
for($i=1;$i!=100;$i++){
  if(file_exists("$PUL/session_$i")){
    $PUL_NB_SESSIONS=$i;
  }
  else{
    break;
  }
}

for($i=$PUL_NB_SESSIONS;$i!=0;$i--){
// for($i=1;$i!=18;$i++){
  $PATH="http://localhost:9995/$PUL/session_$i";
  $THE_GRID.="<button type='button' class='session_title_number btn btn-primary'>⮮ session_$i ⮯</button>";
  // 1echo "----- $PATH -----";
  // $PATH2="$PUL/session_$i";

  // ██████   █████  ██████          ██████   █████  ████████ ███████ ███████         ██      ██ ███    ██ ███████ ███████
  // ██   ██ ██   ██ ██   ██         ██   ██ ██   ██    ██    ██      ██              ██      ██ ████   ██ ██      ██
  // ██████  ███████ ██   ██         ██   ██ ███████    ██    █████   ███████         ██      ██ ██ ██  ██ █████   ███████
  // ██   ██ ██   ██ ██   ██         ██   ██ ██   ██    ██    ██           ██         ██      ██ ██  ██ ██ ██           ██
  // ██████  ██   ██ ██████  ███████ ██████  ██   ██    ██    ███████ ███████ ███████ ███████ ██ ██   ████ ███████ ███████

  // $bad_dates_lines
  // (
  //     [0] => Array
  //         (
  //             [0] => 医生[yīshēng] |=| doctor
  //             [1] => 393
  //         )

  $bad_dates_lines=array(); $fn = fopen("$PATH/answer.bad.date", FILE_IGNORE_NEW_LINES);// or die("fail to open file answer.bad.date - session $i");
  while($row = fgets($fn)) { $row="{$row}€B"; array_push($bad_dates_lines, explode('€', $row)); }
  // echo '<pre>'; print_r($bad_dates_lines); echo '</pre>';
  // $ALL_BAD_DATES_LINES=array();
  $ALL_BAD_DATES_LINES=array_merge($ALL_BAD_DATES_LINES,$bad_dates_lines);
  // echo '<pre>'; print_r($ALL_BAD_DATES_LINES); echo '</pre>';

  //  ██████   ██████   ██████  ██████          ██████   █████  ████████ ███████ ███████         ██      ██ ███    ██ ███████ ███████
  // ██       ██    ██ ██    ██ ██   ██         ██   ██ ██   ██    ██    ██      ██              ██      ██ ████   ██ ██      ██
  // ██   ███ ██    ██ ██    ██ ██   ██         ██   ██ ███████    ██    █████   ███████         ██      ██ ██ ██  ██ █████   ███████
  // ██    ██ ██    ██ ██    ██ ██   ██         ██   ██ ██   ██    ██    ██           ██         ██      ██ ██  ██ ██ ██           ██
  //  ██████   ██████   ██████  ██████  ███████ ██████  ██   ██    ██    ███████ ███████ ███████ ███████ ██ ██   ████ ███████ ███████

  // $good_dates_lines
  // (
  //     [0] => Array
  //         (
  //             [0] => 小姐[xiǎojiě] |=| Miss
  //             [1] => 393
  //         )

  $good_dates_lines=array(); $fn = fopen("$PATH/answer.good.date", FILE_IGNORE_NEW_LINES);// or die("fail to open file answer.good.date - session $i");
  while($row = fgets($fn)) { $row="{$row}€G"; array_push($good_dates_lines, explode('€', $row)); }
  // echo '<pre>'; print_r($good_dates_lines); echo '</pre>';
  // $ALL_GOOD_DATES_LINES=array();
  $ALL_GOOD_DATES_LINES=array_merge($ALL_GOOD_DATES_LINES,$good_dates_lines);
  // echo '<pre>'; print_r($ALL_GOOD_DATES_LINES); echo '</pre>';

  $good_bad_dates_lines=array_merge($bad_dates_lines,$good_dates_lines);
  // echo '<pre>'; print_r($good_bad_dates_lines); echo '</pre>';

  // ███████ ███████ ███████ ███████ ██  ██████  ███    ██         ██      ██ ███    ██ ███████ ███████
  // ██      ██      ██      ██      ██ ██    ██ ████   ██         ██      ██ ████   ██ ██      ██
  // ███████ █████   ███████ ███████ ██ ██    ██ ██ ██  ██         ██      ██ ██ ██  ██ █████   ███████
  //      ██ ██           ██      ██ ██ ██    ██ ██  ██ ██         ██      ██ ██  ██ ██ ██           ██
  // ███████ ███████ ███████ ███████ ██  ██████  ██   ████ ███████ ███████ ██ ██   ████ ███████ ███████

  // $session_lines
  // (
  //     [0] => 医生[yīshēng] |=| doctor

  $session_lines = file("$PATH/session_content.pul", FILE_IGNORE_NEW_LINES);
  // echo '<pre>'; print_r($session_lines); echo '</pre>';

  // ███████ ███████ ███████ ███████ ██  ██████  ███    ██ ███████         ██      ██ ███    ██ ███████ ███████         ██      ███████ ██    ██ ███████ ██
  // ██      ██      ██      ██      ██ ██    ██ ████   ██ ██              ██      ██ ████   ██ ██      ██              ██      ██      ██    ██ ██      ██
  // ███████ █████   ███████ ███████ ██ ██    ██ ██ ██  ██ ███████         ██      ██ ██ ██  ██ █████   ███████         ██      █████   ██    ██ █████   ██
  //      ██ ██           ██      ██ ██ ██    ██ ██  ██ ██      ██         ██      ██ ██  ██ ██ ██           ██         ██      ██       ██  ██  ██      ██
  // ███████ ███████ ███████ ███████ ██  ██████  ██   ████ ███████ ███████ ███████ ██ ██   ████ ███████ ███████ ███████ ███████ ███████   ████   ███████ ███████

  // $session_lines_level
  // (
  //     [0] => Array
  //         (
  //             [0] => 少[shǎo] |=| few, little
  //             [1] => 12
  //         )

  $session_lines_level=array(); $fn = fopen("$PATH/answer.level", FILE_IGNORE_NEW_LINES);// or die("fail to open file session_lines_level - session $i");
  while($row = fgets($fn)) { array_push($session_lines_level, explode('€', $row)); }
  // echo '<pre>'; print_r($session_lines_level); echo '</pre>';

  // ██████  ██ ███████ ██████  ██       █████  ██    ██
  // ██   ██ ██ ██      ██   ██ ██      ██   ██  ██  ██
  // ██   ██ ██ ███████ ██████  ██      ███████   ████
  // ██   ██ ██      ██ ██      ██      ██   ██    ██
  // ██████  ██ ███████ ██      ███████ ██   ██    ██

  //??? instead of VARIABLE, why not store in another array ??? (display later)
  //??? make this in javascript so i can use a slider for values of variables ???

  //FOR EACH TEXT IN SESSION
  // echo "<div>session_$i</div>\n";

  $THE_GRID.="<div class='grid-container'>\n";

  foreach(array_reverse($session_lines) as $line){
  // foreach($session_lines as $line){

    //FIND LEVEL
    foreach($session_lines_level as $session_line_level){
      if($session_line_level[0]==$line){
        $LEVEL=$session_line_level[1];
      }
    }

    //FIND WHEN WAS LAST GOOD
    $LAST_GOOD_PINK=0;
    $THE_GOOD_GRID="";
    foreach($good_dates_lines as $good_line){
      if($good_line[0]=="$line"){
        // if($good_line[1]>$DELAY_DAYS_ERRORS){
        //   $THE_GOOD_GRID.="<span style='color:#49f149;'>✔</span>";
        // }
        // else{
        //   $THE_GOOD_GRID.="<span style='color:grey;'>✔</span>";
        // }
        //IGNORE GOOD ANSWER IF TOO EARLY :P (not pink yet)
        // - GOOD need to be > $LAST_BAD
        // - GOOD need to be > a level * 2
        $GOOD=(int)$good_line[1];
        // echo " --- $GOOD>$TODAY-$LAST_GOOD_PINK+$LEVEL --- ";
        if($LAST_GOOD_PINK==0){
          $LAST_GOOD_PINK=$TODAY-$GOOD;
        }
        else{
          // echo "--- $LAST_GOOD_PINK<$GOOD && $GOOD<$TODAY-$LAST_BAD && $GOOD>$TODAY-$LAST_GOOD_PINK-$LEVEL ---<br>";
          if($LAST_GOOD_PINK<$GOOD){
            $LAST_GOOD_PINK=$TODAY-$GOOD;
          }
        }
      }
    }


    $NB_ERROR=0;
    //FOR EACH ERROR RAISE LEVEL ERROR BY 1 OF THIS TEXT
    $LAST_BAD="99999";
    $THE_BAD_GRID="";
    foreach($bad_dates_lines as $bad_line){
      if($bad_line[0]=="$line"){
        // echo "$bad_line[0]==$line<br>";
        //If error was long time ago, ignore it
        if($bad_line[1]>$DELAY_DAYS_ERRORS){
          // $THE_BAD_GRID.="<span style='color:red;'>❌</span>";
          if($LAST_BAD>$bad_line[1]){
            $LAST_BAD=$TODAY-(int)$bad_line[1];
          }
          $NB_ERROR++;
        }
        // else{
        //   $THE_BAD_GRID.="<span style='color:grey;'>❌</span>";
        // }
      }
    }

    //DISPLAY ERROR
    $CLASS="";
    if($NB_ERROR>2){$COLOR="red";}
    else if($NB_ERROR==2){$COLOR="orange";}
    else if ($NB_ERROR==1){$COLOR="yellow";}
    else{$COLOR="gray";$CLASS=" gray_lines";}

    $THE_GRID.="<div class='grid-item$CLASS'>";
    switch ($LEVEL) {
      case 3: $level="<span class='tooltip_right' style='color:white;'>⚀<span class='tooltiptext_right'>3+ days streak</span></span>";break;
      case 6: $level="<span class='tooltip_right' style='color:white;'>⚀⚁<span class='tooltiptext_right'>6+ days streak</span></span>";break;
      case 12: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂<span class='tooltiptext_right'>12+ days streak</span></span>";break;
      case 24: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃<span class='tooltiptext_right'>24+ days streak</span></span>";break;
      case 48: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄<span class='tooltiptext_right'>48+ days streak</span></span>";break;
      case 96: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄⚅<span class='tooltiptext_right'>96+ days streak</span></span>";break; //~3 months
      case 192: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄⚅⚀<span class='tooltiptext_right'>192+ days streak</span></span>";break;
      case 384: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄⚅⚀⚁<span class='tooltiptext_right'>384+ days streak</span></span>";break;
      case 768: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄⚅⚀⚁⚂<span class='tooltiptext_right'>768+ days streak</span></span>";break;
      case 1536: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄⚅⚀⚁⚂⚃<span class='tooltiptext_right'>1536+ days streak</span></span>";break;
      case 3072: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄⚅⚀⚁⚂⚃⚄<span class='tooltiptext_right'>3072+ days streak</span></span>";break;
      case 6144: $level="<span class='tooltip_right' style='color:white;'>⚀⚁⚂⚃⚄⚅⚀⚁⚂⚃⚄⚅<span class='tooltiptext_right'>6144+ days streak</span></span>";break; //~16 years
    }

    $THE_GRID.=" $level <span style='color:gray'> ➔ </span> <span style='color:$COLOR'>$line</span> <span style='color:gray'> ➔ </span> "; // ($NB_ERROR)
    // $THE_GRID.="<span style='color:#DDD'>$THE_GOOD_GRID</span>";
    // $THE_GRID.="<span style='color:#555'>$THE_BAD_GRID</span>";
    asort($good_bad_dates_lines);
    $color_bad="yellow"; //Yelow before first answer (not yet learned) and switch to red

    $LAST_DATE="";

    foreach($good_bad_dates_lines as $good_bad_dates_line){
      $good_bad_dates_line[1] = str_replace("\n", '', $good_bad_dates_line[1]);
      if($good_bad_dates_line[0]=="$line"){
        $DAYS_AGO=$TODAY-$good_bad_dates_line[1];
        if($good_bad_dates_line[2]=="B"){
          if($good_bad_dates_line[1]>$DELAY_DAYS_ERRORS){
            $THE_GRID.="<span class='tooltip' style='color:$color_bad;'>❌<span class='tooltiptext' style='color:$color_bad;'><a onclick='if (confirm(\"Are you sure you want to delete the line(s) : {$line}€{$good_bad_dates_line[1]} ?\")) { window.location.href=\"http://127.0.0.1:9995/php/logs_delete_good_line.php?FILE=../$PATH2/answer.bad.date&LINE={$line}€{$good_bad_dates_line[1]}\"; }'>remove log</a><br>day $TODAY - {$good_bad_dates_line[1]} = $DAYS_AGO days ago</span></span>";
          }
          else{
            $THE_GRID.="<span class='tooltip' style='color:grey;'>❌<span class='tooltiptext' style='color:grey;'>day $TODAY - {$good_bad_dates_line[1]} = $DAYS_AGO days ago</span></span>";
          }
        }
        else{
          if ($good_bad_dates_line[1]!=$LAST_DATE){
            $color_bad="red"; //After first good bad is red (red = forgotten ???)
            if($good_bad_dates_line[1]>$DELAY_DAYS_ERRORS){
              $THE_GRID.="<span class='tooltip' style='color:#49f149;'>✔<span class='tooltiptext' style='color:#49f149;'><a onclick='if (confirm(\"Are you sure you want to delete the line(s) : {$line}€{$good_bad_dates_line[1]} ?\")) { window.location.href=\"http://127.0.0.1:9995/php/logs_delete_good_line.php?FILE=../$PATH2/answer.bad.date&LINE={$line}€{$good_bad_dates_line[1]}\"; }'>remove log</a><br>day $TODAY - {$good_bad_dates_line[1]} = $DAYS_AGO days ago</span></span>";
            }
            else{
              $THE_GRID.="<span class='tooltip' style='color:grey;'>✔<span class='tooltiptext' style='color:grey;'>day $TODAY - {$good_bad_dates_line[1]} = $DAYS_AGO days ago</span></span>";
            }
          }
          $LAST_DATE=$good_bad_dates_line[1];
        }
      }
    }
    if($NB_ERROR!=0) $THE_GRID.="<span style='color:#555'> ($NB_ERROR)</span>";
    $THE_GRID.="</span></div>";

    //???? not working yet show how many days before becomes pink ??????????????????????????????

    // ($LAST_BAD) $LAST_GOOD_PINK/
    // if($LAST_GOOD_PINK>$LEVEL){
    //   echo "<div class='grid-item' style='color:white'><span style='color:magenta;'>$LEVEL</span> $line</div>\n"; // ($NB_ERROR)
    // }
    // else{
    // }
  }
  $THE_GRID.="</div>\n";

}

//  ██████  ██████   █████  ██████  ██   ██
// ██       ██   ██ ██   ██ ██   ██ ██   ██
// ██   ███ ██████  ███████ ██████  ███████
// ██    ██ ██   ██ ██   ██ ██      ██   ██
//  ██████  ██   ██ ██   ██ ██      ██   ██


// NB OF ERRORS PER DAYS
$DAYS_ERRORS=array_fill($DELAY_DAYS_ERRORS, $DELAY, 0);
$FIRST_BAD=$ALL_BAD_DATES_LINES[0][1];
foreach($ALL_BAD_DATES_LINES as $bad_line){
  if($FIRST_BAD>$bad_line[1]){
    $FIRST_BAD=$bad_line[1];
  }
  if($bad_line[1]>$DELAY_DAYS_ERRORS){
    // echo "{$bad_line[1]} -- ";
    $NUM=(int)$bad_line[1];
    $DAYS_ERRORS[$NUM]++;
  }
}
// echo "--- $FIRST_BAD ---"; //374 ?
// echo '<pre>'; print_r($DAYS_ERRORS); echo '</pre>';
$fp = fopen('tmp/data_bad.csv', 'w');
fwrite($fp, "this_day,my_errors\n");
for($j=$DELAY_DAYS_ERRORS;$j!=$TODAY;$j++){
  $k=$TODAY-$j;
  fwrite($fp, "$k,$DAYS_ERRORS[$j]\n");
}
fclose($fp);

// NB OF GOOD PER DAYS
$DAYS_GOODS=array_fill($DELAY_DAYS_ERRORS, $DELAY, 0);
foreach($ALL_GOOD_DATES_LINES as $good_line){
  if($good_line[1]>$DELAY_DAYS_ERRORS){
    // echo "{$bad_line[1]} -- ";
    $NUM=(int)$good_line[1];
    $DAYS_GOODS[$NUM]++;
  }
}
// echo '<pre>'; print_r($DAYS_ERRORS); echo '</pre>';
$fp = fopen('tmp/data_good.csv', 'w');
fwrite($fp, "this_day,my_errors\n");
for($j=$DELAY_DAYS_ERRORS;$j!=$TODAY;$j++){
  $k=$TODAY-$j;
  fwrite($fp, "$k,$DAYS_GOODS[$j]\n");
}
fclose($fp);
?>
<br>
      <script>
         // set the dimensions and margins of the graph
         var margin = {top: 20, right: 20, bottom: 30, left: 50},
         width = 600 - margin.left - margin.right,
         height = 300 - margin.top - margin.bottom;

         // set the ranges
         var x = d3.scaleLinear().range([0, width]);
         var y = d3.scaleLinear().range([height, 0]);

         // define the line
         var valueline = d3.line()
            .x(function(d) { return x(d.this_day); })
            .y(function(d) { return y(d.my_errors); });

         // append the svg obgect to the body of the page
         // appends a 'group' element to 'svg'
         // moves the 'group' element to the top left margin
         var svg = d3.select("#bodypre").append("svg").attr("class","my_svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g").attr("transform",
               "translate(" + margin.left + "," + margin.top + ")");

         // Get the data
         d3.csv("tmp/data_good.csv", function(error, data) {
            if (error) throw error;
            // format the data
            data.forEach(function(d) {
               d.this_day = d.this_day;
               d.my_errors = +d.my_errors;
            });

            // Scale the range of the data
            x.domain([<?php echo $DELAY; ?>,1]);
            y.domain([0,200]);
            // x.domain(d3.extent(data, function(d) { return d.this_day; }));
            // y.domain([0, d3.max(data, function(d) { return d.my_errors; })]);

            // Add the valueline path.
            svg.append("path")
               .data([data])
               .attr("class", "line_good")
               .attr("d", valueline);

            // Add the X Axis
            svg.append("g")
               .attr("transform", "translate(0," + height + ")")
               .call(d3.axisBottom(x));

            // Add the Y Axis
            svg.append("g")
               .call(d3.axisLeft(y));
         });
         d3.csv("tmp/data_bad.csv", function(error, data) {
            if (error) throw error;
            // format the data
            data.forEach(function(d) {
               d.this_day = d.this_day;
               d.my_errors = +d.my_errors;
            });

            // Scale the range of the data
            // x.domain(d3.extent(data, function(d) { return d.this_day; }));
            // y.domain([0, d3.max(data, function(d) { return d.my_errors; })]);

            // Add the valueline path.
            svg.append("path")
               .data([data])
               .attr("class", "line_bad")
               .attr("d", valueline);

            // Add the X Axis
            svg.append("g")
               .attr("transform", "translate(0," + height + ")")
               .call(d3.axisBottom(x));

            // Add the Y Axis
            svg.append("g")
               .call(d3.axisLeft(y));
         });
      </script>

      <?php

// ███████ ██      ██ ██████  ███████ ██████
// ██      ██      ██ ██   ██ ██      ██   ██
// ███████ ██      ██ ██   ██ █████   ██████
//      ██ ██      ██ ██   ██ ██      ██   ██
// ███████ ███████ ██ ██████  ███████ ██   ██

      ?>

      <script>
      var slider = document.getElementById("myRange");
      var output = document.getElementById("demo");
      output.innerHTML = slider.value;
      slider.max="<?php echo $TODAY-(int)$FIRST_BAD+3; ?>";
      // slider.value="<?php echo $TODAY-(int)$FIRST_BAD+3; ?>";
      slider.onchange = function() {
        document.location.href="read_logs.php?PUL=<?php echo $PUL; ?>&DELAY=" + this.value;
      }
      slider.oninput = function() {
        output.innerHTML = this.value;
      }
      </script>

<?php
echo $THE_GRID;
?>

<div id="menu_buttons">

  <!-- <select id="select_number_of_elements" class="styled-select" onchange="document.getElementById('number_of_elements').innerHTML = document.getElementById('select_number_of_elements').value;">
    <option value="5" selected>5</option>
    <option value="6">6</option>
    <option value="7">7</option>
    <option value="8">8</option>
    <option value="9">9</option>
    <option value="10">10</option>
  </select> -->

  <!-- <button onclick="alert('Add '+document.getElementById('select_number_of_elements').value+' elements');" type="button" class="btn btn-primary">Add <var id="number_of_elements" style="color: inherit;background-color: inherit;font-style: inherit;">4</var> new elements</button><br> -->

  <button onclick="alert('Add '+document.getElementById('select_number_of_elements').value+' elements');" type="button" class="btn btn-primary">Add a new session (<var id="number_of_elements" style="color: inherit;background-color: inherit;font-style: inherit;">5</var> new elements)</button><br>


  <h3>PopUpLearn launchers :</h3>

  <button type="button" style="background-color:white;color:black;" class="btn btn-primary">All my elements (x)</button>
  <button type="button" style="background-color:yellow;color:black;" class="btn btn-primary">Mistakes (x)</button>
  <button type="button" style="background-color:red;color:black;" class="btn btn-primary">Mistakes (x)</button>
  <button type="button" style="background-color:cyan;color:black;" class="btn btn-primary">Unlearned (x)</button>
  <button type="button" style="background-color:magenta;color:black;" class="btn btn-primary">Relearn (x)</button>
  <button type="button" style="color:black;" class="btn btn-primary">Last X sessions (x)</button>

  <h3>PopUpLearn toggles :</h3>

<script>
function toggle_visibility(className) {
    elements = document.getElementsByClassName(className);
    for (var i = 0; i < elements.length; i++) {
        elements[i].style.display = elements[i].style.display == 'inline' ? 'none' : 'inline';
    }
}
<?php
if(isset($_GET['HIDE_SESSION'])){
  echo "toggle_visibility('session_title_number');";
}
?>
</script>

  <button type="button" style="color:black;" class="btn btn-primary" onclick="toggle_visibility('session_title_number')">Toggle session number</button>
  <button type="button" style="color:black;" class="btn btn-primary" onclick="toggle_visibility('gray_lines')">Toggle gray lines</button>

</div>

<script>
// if (confirm("Do you want to delete!")) {
//   txt = "You pressed OK!";
// } else {
//   txt = "You pressed Cancel!";
// }
</script>

</body>
</html>
