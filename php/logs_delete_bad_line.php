<?php
function remove_line($file, $remove) {
    $lines = file($file, FILE_IGNORE_NEW_LINES);
    foreach($lines as $key => $line) {
        if($line === $remove) unset($lines[$key]);
    }
    $data = implode(PHP_EOL, $lines);
    file_put_contents($file, $data);
}
remove_line($_GET['FILE'],$_GET['LINE']);
// echo "{$_GET['FILE']} {$_GET['LINE']}";
header("Location: http://127.0.0.1:9999/read_logs.php");
?>
