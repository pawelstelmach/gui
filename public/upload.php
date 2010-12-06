<?php 
$uploaddir = 'C:\\\\xampp\\htdocs\\s_o_a\\';
foreach ($_FILES as $file){
var_dump($file);
$uploadfile = $uploaddir . basename($file['name']);

echo '<pre>';
if (move_uploaded_file($file['tmp_name'], $uploadfile)) {
    echo "File is valid, and was successfully uploaded.\n";
} else {
    echo "Possible file upload attack!\n";
}

echo 'Here is some more debugging info:';
print_r($file);

print "</pre>";
}
foreach($_REQUEST as $line){
echo $line;
$stringData .= $line."\n";
}

fwrite($fh, $stringData);
fclose($fh);


?>