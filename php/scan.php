<?php
# Copyright 2013 martin.koegler@chello.at, published under the MIT license
# Usage: 
# cd <sample set directory = where the .organ file should be>
# php scan.php > dir.lst 


function scan($dir, $prefix)
{
	if (!is_dir($dir))
	{
		printf("%s\n", $prefix);
		return;
	}
	$h = opendir($dir);
	$n = readdir($h);
	while($n !== false)
	{
		if ($n != "." && $n != "..")
			scan($dir."/".$n, $prefix."\\".$n);
		$n = readdir($h);
	}
	closedir($h);
}

scan(".", ".");

?>
