<?php
# Copyright 2013 martin.koegler@chello.at, published under the MIT license

$filelist = array();

function loadFileList($name)
{
	global $filelist;
	$f = file($name);
	foreach($f as $f1)
	{
		$f1 = trim($f1);
		$filelist[strtolower($f1)]=$f1;
	}
}

function initList(&$entries)
{
	$entries=array();
}

function printList($entries)
{
	foreach($entries as $k=>$v)
		printf("%s=%s\n", $k, $v);
}

function pipePath($rankdir, $midi, $release = null)
{
	global $filelist;
	$parts = array("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B");
	$notepart = $parts[$midi % 12];
	if ($release == null)
		$releasepart = "";
	else
		$releasepart = sprintf("rel%05d\\", ($release == -1 ? 99999 : $release));
	$path = sprintf("%s\\%s%03d-%s.wav", $rankdir, $releasepart, $midi, $notepart);
	if (isset($filelist[strtolower($path)]))
		return $filelist[strtolower($path)];
	else
		return $path;
}

function addPipe(&$entries, $no, $rankdir, $midi, $release = array(), $pipeinfo)
{
	$entries[sprintf("Pipe%03d", $no)] = pipePath($rankdir, $midi, null);
	if ($pipeinfo["mainnorelease"])
		$entries[sprintf("Pipe%03dLoadRelease", $no)] = "N";
	if (count($release) > 0)
		$entries[sprintf("Pipe%03dReleaseCount", $no)] = sprintf("%d", count($release));
	for($i = 0; $i < count($release); $i++)
	{
		$entries[sprintf("Pipe%03dRelease%03d", $no, $i+1)] = pipePath($rankdir, $midi, $release[$i]);
		if ($pipeinfo["releasecuepoint"])
			$entries[sprintf("Pipe%03dRelease%03dCuePoint", $no, $i+1)] = "0";
		$entries[sprintf("Pipe%03dRelease%03dMaxKeyPressTime", $no, $i+1)] = sprintf("%d", $release[$i]);
	}
}

function addRank(&$entries, $startno, $count, $rankdir, $midi, $release = array(), $pipeinfo)
{
	for($i = 0; $i < $count; $i++)
		addPipe($entries, $startno + $i, $rankdir, $midi + $i, $release, $pipeinfo);
}

loadFileList("dir.lst");
?>
