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

function initList(&$entries, $header = null, $no = null)
{
	$entries=array();
	if ($header != "")
		$entries["_header"] = sprintf($header, $no);
}

function printList($entries)
{
	if (isset($entries["_header"]))
	{
		printf("\n\n[%s]\n", $entries["_header"]);
		unset($entries["_header"]);
	}
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

function rankID($name)
{
	static $rankIDList = array();
	if (isset($rankIDList[$name]))
		return $rankIDList[$name];
	$no = count($rankIDList) + 1;
	$rankIDList[$name] = $no;
	return $no;
}

function switchID($name)
{
	static $switchIDList = array();
	if (isset($swtichIDList[$name]))
		return $switchIDList[$name];
	$no = count($switchIDList) + 1;
	$switchIDList[$name] = $no;
	return $no;
}

function initRank(&$list, $no, $name, $first, $pipes, $amplitude, $windchest, $harmonic = null)
{
	initList($list, "Rank%03d", rankID($no));
	$list["Name"]=$name;
	$list["FirstMidiNoteNumber"] = $first;
	$list["NumberOfLogicalPipes"] = $pipes;
	$list["AmplitudeLevel"] = $amplitude;
	$list["WindchestGroup"] = sprintf("%03d", $windchest);
	$list["Percussive"] = "N";
	$list["PitchTuning"] = 0;
	if (isset($harmonic))
	$list["HarmonicNumber"]=$harmonic;
}

loadFileList("dir.lst");
?>
;------------------------------------------------------------------------------
;     Organ definition file by (c) Michael P. Schmidt
;     Sampleset: Krzeszow surround for Hauptwerk 4 by Sonus Paradisi
;     Version: 1.00 11/19/2013 for GrandOrgue V. 0.3.1.1367 and higher
;------------------------------------------------------------------------------


;Lizenzvereinbarung für die GrandOrgue ODF-Dateien

;-------------------------------------------------

;Copyright (c) 2013 Michael.P.Schmidt  orgelseite(at)mps-net(dot)de  www.orgel.mps-net.de

;Hiermit wird unentgeltlich, jeder Person, die eine Kopie der Software und der zugehörigen Dokumentationen (die "Software")
;erhält, die Erlaubnis erteilt, sie uneingeschränkt zu benutzen, inklusive und ohne Ausnahme, dem Recht, sie zu verwenden,
;kopieren, ändern, fusionieren, verlegen, verbreiten, unterlizenzieren und/oder zu verkaufen, und Personen, die diese
;Software erhalten, diese Rechte zu geben, unter den folgenden Bedingungen:

;Der obige Urheberrechtsvermerk und dieser Erlaubnisvermerk sind in allen Kopien oder Teilkopien der Software beizulegen.

;DIE SOFTWARE WIRD OHNE JEDE AUSDRÜCKLICHE ODER IMPLIZIERTE GARANTIE BEREITGESTELLT,
;EINSCHLIESSLICH DER GARANTIE ZUR BENUTZUNG FÜR DEN VORGESEHENEN ODER EINEM BESTIMMTEN ZWECK SOWIE JEGLICHER RECHTSVERLETZUNG,
;JEDOCH NICHT DARAUF BESCHRÄNKT. IN KEINEM FALL SIND DIE AUTOREN ODER COPYRIGHTINHABER FÜR JEGLICHEN SCHADEN ODER SONSTIGE
;ANSPRÜCHE HAFTBAR ZU MACHEN, OB INFOLGE DER ERFÜLLUNG EINES VERTRAGES, EINES DELIKTES ODER ANDERS IM ZUSAMMENHANG MIT DER
;SOFTWARE ODER SONSTIGER VERWENDUNG DER SOFTWARE ENTSTANDEN.



;License agreement for the GrandOrgue ODF-Files

;----------------------------------------------

;Copyright (c) 2013 Michael.P.Schmidt   orgelseite(at)mps-net(dot)de   www.orgel.mps-net.de 

;Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
;(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
;merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:

;The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



;------------------------------------------------------------------------------
;     Organ section
;------------------------------------------------------------------------------

[Organ]
ChurchName=Klosterkirche Mariengnade
ChurchAddress=Krzeszow, Poland
OrganBuilder=Michael Engler
OrganBuildDate=1732-1736
OrganComments=
RecordingDetails=
InfoFilename=

NumberOfManuals=3
HasPedals=Y
NumberOfEnclosures=0
NumberOfTremulants=0
NumberOfWindchestGroups=5
NumberOfReversiblePistons=0
NumberOfGenerals=0
NumberOfDivisionalCouplers=0
NumberOfPanels=2
NumberOfRanks=106
NumberOfLabels=0
NumberOfImages=1
NumberOfSwitches=73

AmplitudeLevel=100
Gain=0
PitchTuning=0

DispScreenSizeHoriz=1500
DispScreenSizeVert=1000

DispDrawstopBackgroundImageNum=39
DispConsoleBackgroundImageNum=40
DispKeyHorizBackgroundImageNum=32
DispKeyVertBackgroundImageNum=20
DispDrawstopInsetBackgroundImageNum=31

DispControlLabelFont=Times New Roman
DispShortcutKeyLabelFont=Times New Roman
DispShortcutKeyLabelColour=BLACK
DispGroupLabelFont=Times New Roman

DispDrawstopCols=12
DispDrawstopRows=12
DispDrawstopColsOffset=N
DispDrawstopOuterColOffsetUp=N

DispPairDrawstopCols=N
DispExtraDrawstopRows=5
DispExtraDrawstopCols=6
DispButtonCols=10
DispExtraButtonRows=0

DispExtraPedalButtonRow=N
DispExtraPedalButtonRowOffset=Y
DispExtraPedalButtonRowOffsetRight=Y

DispButtonsAboveManuals=N
DispTrimAboveManuals=Y
DispTrimBelowManuals=N
DispTrimAboveExtraRows=N
DispExtraDrawstopRowsAboveExtraButtonRows=Y

DivisionalsStoreTremulants=Y
DivisionalsStoreIntermanualCouplers=Y
DivisionalsStoreIntramanualCouplers=Y
GeneralsStoreDivisionalCouplers=Y
CombinationsStoreNonDisplayedDrawstops=N



;------------------------------------------------------------------------------
;	Manual section
;------------------------------------------------------------------------------

[Manual000]
Name=Pedal
NumberOfLogicalKeys=30
FirstAccessibleKeyLogicalKeyNumber=001
FirstAccessibleKeyMIDINoteNumber=36
NumberOfAccessibleKeys=30
MIDIInputNumber=001
Displayed=Y
NumberOfStops=61
<?php
	initList($list);
	for($i = 0; $i < 21; $i++)
		$list[sprintf("Stop%03d", $i + 1)] = sprintf("%03d", $i + 1);
	for($i = 0; $i < 40; $i++)
		$list[sprintf("Stop%03d", $i + 22)] = sprintf("%03d", $i + 30);
	printList($list);
?>

NumberOfCouplers=0
NumberOfDivisionals=0
NumberOfTremulants=0
DispKeyColourInverted=N
PositionX=609
PositionY=675
ImageOn_FirstC=.\000870\pedal\natshdown.bmp
ImageOff_FirstC=.\000870\pedal\natshup.bmp
MaskOn_FirstC=.\000870\pedal\natshmask.bmp
MaskOff_FirstC=.\000870\pedal\natshmask.bmp
ImageOn_C=.\000870\pedal\natshdown.bmp
ImageOff_C=.\000870\pedal\natshup.bmp
MaskOn_C=.\000870\pedal\natshmask.bmp
MaskOff_C=.\000870\pedal\natshmask.bmp
ImageOn_Cis=.\000870\pedal\shdown.bmp
ImageOff_Cis=.\000870\pedal\shup.bmp
MaskOn_Cis=.\000870\pedal\shmask.bmp
MaskOff_Cis=.\000870\pedal\shmask.bmp
ImageOn_D=.\000870\pedal\natshdown.bmp
ImageOff_D=.\000870\pedal\natshup.bmp
MaskOn_D=.\000870\pedal\natshmask.bmp
MaskOff_D=.\000870\pedal\natshmask.bmp
ImageOn_Dis=.\000870\pedal\shdown.bmp
ImageOff_Dis=.\000870\pedal\shup.bmp
MaskOn_Dis=.\000870\pedal\shmask.bmp
MaskOff_Dis=.\000870\pedal\shmask.bmp
ImageOn_E=.\000870\pedal\natnodown.bmp
ImageOff_E=.\000870\pedal\natnoup.bmp
MaskOn_E=.\000870\pedal\natnomask.bmp
MaskOff_E=.\000870\pedal\natnomask.bmp
Width_E=16
ImageOn_F=.\000870\pedal\natshdown.bmp
ImageOff_F=.\000870\pedal\natshup.bmp
MaskOn_F=.\000870\pedal\natshmask.bmp
MaskOff_F=.\000870\pedal\natshmask.bmp
ImageOn_Fis=.\000870\pedal\shdown.bmp
ImageOff_Fis=.\000870\pedal\shup.bmp
MaskOn_Fis=.\000870\pedal\shmask.bmp
MaskOff_Fis=.\000870\pedal\shmask.bmp
ImageOn_G=.\000870\pedal\natshdown.bmp
ImageOff_G=.\000870\pedal\natshup.bmp
MaskOn_G=.\000870\pedal\natshmask.bmp
MaskOff_G=.\000870\pedal\natshmask.bmp
ImageOn_Gis=.\000870\pedal\shdown.bmp
ImageOff_Gis=.\000870\pedal\shup.bmp
MaskOn_Gis=.\000870\pedal\shmask.bmp
MaskOff_Gis=.\000870\pedal\shmask.bmp
ImageOn_A=.\000870\pedal\natshdown.bmp
ImageOff_A=.\000870\pedal\natshup.bmp
MaskOn_A=.\000870\pedal\natshmask.bmp
MaskOff_A=.\000870\pedal\natshmask.bmp
ImageOn_Ais=.\000870\pedal\shdown.bmp
ImageOff_Ais=.\000870\pedal\shup.bmp
MaskOn_Ais=.\000870\pedal\shmask.bmp
MaskOff_Ais=.\000870\pedal\shmask.bmp
ImageOn_B=.\000870\pedal\natnodown.bmp
ImageOff_B=.\000870\pedal\natnoup.bmp
MaskOn_B=.\000870\pedal\natnomask.bmp
MaskOff_B=.\000870\pedal\natnomask.bmp
Width_B=16
ImageOn_LastF=.\000870\pedal\natshdown.bmp
ImageOff_LastF=.\000870\pedal\natshup.bmp
MaskOn_LastF=.\000870\pedal\natshmask.bmp
MaskOff_LastF=.\000870\pedal\natshmask.bmp


[Manual001]
Name=Manual1
NumberOfLogicalKeys=54
FirstAccessibleKeyLogicalKeyNumber=001
FirstAccessibleKeyMIDINoteNumber=36
NumberOfAccessibleKeys=54
MIDIInputNumber=002
Displayed=Y
NumberOfStops=51
<?php
	initList($list);
	for($i = 0; $i < 21; $i++)
		$list[sprintf("Stop%03d", $i + 1)] = sprintf("%03d", $i + 101);
	for($i = 0; $i < 30; $i++)
		$list[sprintf("Stop%03d", $i + 22)] = sprintf("%03d", $i + 70);
	printList($list);
?>

NumberOfCouplers=1
Coupler001=021
NumberOfDivisionals=0
NumberOfTremulants=0
DispKeyColourInverted=N
PositionX=638
PositionY=497
ImageOn_FirstC=.\000870\manual\kl1\natdown.bmp
ImageOff_FirstC=.\000870\manual\kl1\natup.bmp
MaskOn_FirstC=.\000870\manual\kl1\cfmask.bmp
MaskOff_FirstC=.\000870\manual\kl1\cfmask.bmp
ImageOn_C=.\000870\manual\kl1\natdown.bmp
ImageOff_C=.\000870\manual\kl1\natup.bmp
MaskOn_C=.\000870\manual\kl1\cfmask.bmp
MaskOff_C=.\000870\manual\kl1\cfmask.bmp
ImageOn_Cis=.\000870\manual\kl1\sharpdown.bmp
ImageOff_Cis=.\000870\manual\kl1\sharpup.bmp
MaskOn_Cis=.\000870\manual\kl1\sharpmask.bmp
MaskOff_Cis=.\000870\manual\kl1\sharpmask.bmp
ImageOn_D=.\000870\manual\kl1\natdown.bmp
ImageOff_D=.\000870\manual\kl1\natup.bmp
MaskOn_D=.\000870\manual\kl1\dgmask.bmp
MaskOff_D=.\000870\manual\kl1\dgmask.bmp
ImageOn_Dis=.\000870\manual\kl1\sharpdown.bmp
ImageOff_Dis=.\000870\manual\kl1\sharpup.bmp
MaskOn_Dis=.\000870\manual\kl1\sharpmask.bmp
MaskOff_Dis=.\000870\manual\kl1\sharpmask.bmp
ImageOn_E=.\000870\manual\kl1\natdown.bmp
ImageOff_E=.\000870\manual\kl1\natup.bmp
MaskOn_E=.\000870\manual\kl1\ebmask.bmp
MaskOff_E=.\000870\manual\kl1\ebmask.bmp
ImageOn_F=.\000870\manual\kl1\natdown.bmp
ImageOff_F=.\000870\manual\kl1\natup.bmp
MaskOn_F=.\000870\manual\kl1\cfmask.bmp
MaskOff_F=.\000870\manual\kl1\cfmask.bmp
ImageOn_Fis=.\000870\manual\kl1\sharpdown.bmp
ImageOff_Fis=.\000870\manual\kl1\sharpup.bmp
MaskOn_Fis=.\000870\manual\kl1\sharpmask.bmp
MaskOff_Fis=.\000870\manual\kl1\sharpmask.bmp
ImageOn_G=.\000870\manual\kl1\natdown.bmp
ImageOff_G=.\000870\manual\kl1\natup.bmp
MaskOn_G=.\000870\manual\kl1\dgmask.bmp
MaskOff_G=.\000870\manual\kl1\dgmask.bmp
ImageOn_Gis=.\000870\manual\kl1\sharpdown.bmp
ImageOff_Gis=.\000870\manual\kl1\sharpup.bmp
MaskOn_Gis=.\000870\manual\kl1\sharpmask.bmp
MaskOff_Gis=.\000870\manual\kl1\sharpmask.bmp
ImageOn_A=.\000870\manual\kl1\natdown.bmp
ImageOff_A=.\000870\manual\kl1\natup.bmp
MaskOn_A=.\000870\manual\kl1\amask.bmp
MaskOff_A=.\000870\manual\kl1\amask.bmp
ImageOn_Ais=.\000870\manual\kl1\sharpdown.bmp
ImageOff_Ais=.\000870\manual\kl1\sharpup.bmp
MaskOn_Ais=.\000870\manual\kl1\sharpmask.bmp
MaskOff_Ais=.\000870\manual\kl1\sharpmask.bmp
ImageOn_B=.\000870\manual\kl1\natdown.bmp
ImageOff_B=.\000870\manual\kl1\natup.bmp
MaskOn_B=.\000870\manual\kl1\ebmask.bmp
MaskOff_B=.\000870\manual\kl1\ebmask.bmp
ImageOn_LastF=.\000870\manual\kl1\natdown.bmp
ImageOff_LastF=.\000870\manual\kl1\natup.bmp
MaskOn_LastF=.\000870\manual\kl1\wholemask.bmp
MaskOff_LastF=.\000870\manual\kl1\wholemask.bmp


[Manual002]
Name=Manual2
NumberOfLogicalKeys=54
FirstAccessibleKeyLogicalKeyNumber=1
FirstAccessibleKeyMIDINoteNumber=36
NumberOfAccessibleKeys=54
MIDIInputNumber=003
Displayed=Y
NumberOfStops=47
<?php
	initList($list);
	for($i = 0; $i < 15; $i++)
		$list[sprintf("Stop%03d", $i + 1)] = sprintf("%03d", $i + 201);
	for($i = 0; $i < 32; $i++)
		$list[sprintf("Stop%03d", $i + 16)] = sprintf("%03d", $i + 130);
	printList($list);
?>

NumberOfCouplers=1
Coupler001=032
NumberOfDivisionals=0
NumberOfTremulants=0
DispKeyColourInverted=N
PositionX=638
PositionY=464
ImageOn_FirstC=.\000870\manual\kl2\natdown.bmp
ImageOff_FirstC=.\000870\manual\kl2\natup.bmp
MaskOn_FirstC=.\000870\manual\kl2\cfmask.bmp
MaskOff_FirstC=.\000870\manual\kl2\cfmask.bmp
ImageOn_C=.\000870\manual\kl2\natdown.bmp
ImageOff_C=.\000870\manual\kl2\natup.bmp
MaskOn_C=.\000870\manual\kl2\cfmask.bmp
MaskOff_C=.\000870\manual\kl2\cfmask.bmp
ImageOn_Cis=.\000870\manual\kl2\sharpdown.bmp
ImageOff_Cis=.\000870\manual\kl2\sharpup.bmp
MaskOn_Cis=.\000870\manual\kl2\sharpmask.bmp
MaskOff_Cis=.\000870\manual\kl2\sharpmask.bmp
ImageOn_D=.\000870\manual\kl2\natdown.bmp
ImageOff_D=.\000870\manual\kl2\natup.bmp
MaskOn_D=.\000870\manual\kl2\dgmask.bmp
MaskOff_D=.\000870\manual\kl2\dgmask.bmp
ImageOn_Dis=.\000870\manual\kl2\sharpdown.bmp
ImageOff_Dis=.\000870\manual\kl2\sharpup.bmp
MaskOn_Dis=.\000870\manual\kl2\sharpmask.bmp
MaskOff_Dis=.\000870\manual\kl2\sharpmask.bmp
ImageOn_E=.\000870\manual\kl2\natdown.bmp
ImageOff_E=.\000870\manual\kl2\natup.bmp
MaskOn_E=.\000870\manual\kl2\ebmask.bmp
MaskOff_E=.\000870\manual\kl2\ebmask.bmp
ImageOn_F=.\000870\manual\kl2\natdown.bmp
ImageOff_F=.\000870\manual\kl2\natup.bmp
MaskOn_F=.\000870\manual\kl2\cfmask.bmp
MaskOff_F=.\000870\manual\kl2\cfmask.bmp
ImageOn_Fis=.\000870\manual\kl2\sharpdown.bmp
ImageOff_Fis=.\000870\manual\kl2\sharpup.bmp
MaskOn_Fis=.\000870\manual\kl2\sharpmask.bmp
MaskOff_Fis=.\000870\manual\kl2\sharpmask.bmp
ImageOn_G=.\000870\manual\kl2\natdown.bmp
ImageOff_G=.\000870\manual\kl2\natup.bmp
MaskOn_G=.\000870\manual\kl2\dgmask.bmp
MaskOff_G=.\000870\manual\kl2\dgmask.bmp
ImageOn_Gis=.\000870\manual\kl2\sharpdown.bmp
ImageOff_Gis=.\000870\manual\kl2\sharpup.bmp
MaskOn_Gis=.\000870\manual\kl2\sharpmask.bmp
MaskOff_Gis=.\000870\manual\kl2\sharpmask.bmp
ImageOn_A=.\000870\manual\kl2\natdown.bmp
ImageOff_A=.\000870\manual\kl2\natup.bmp
MaskOn_A=.\000870\manual\kl2\amask.bmp
MaskOff_A=.\000870\manual\kl2\amask.bmp
ImageOn_Ais=.\000870\manual\kl2\sharpdown.bmp
ImageOff_Ais=.\000870\manual\kl2\sharpup.bmp
MaskOn_Ais=.\000870\manual\kl2\sharpmask.bmp
MaskOff_Ais=.\000870\manual\kl2\sharpmask.bmp
ImageOn_B=.\000870\manual\kl2\natdown.bmp
ImageOff_B=.\000870\manual\kl2\natup.bmp
MaskOn_B=.\000870\manual\kl2\ebmask.bmp
MaskOff_B=.\000870\manual\kl2\ebmask.bmp
ImageOn_LastF=.\000870\manual\kl2\natdown.bmp
ImageOff_LastF=.\000870\manual\kl2\natup.bmp
MaskOn_LastF=.\000870\manual\kl2\wholemask.bmp
MaskOff_LastF=.\000870\manual\kl2\wholemask.bmp


[Manual003]
Name=Manual3
NumberOfLogicalKeys=54
FirstAccessibleKeyLogicalKeyNumber=1
FirstAccessibleKeyMIDINoteNumber=36
NumberOfAccessibleKeys=54
MIDIInputNumber=004
Displayed=Y
NumberOfStops=51
<?php
	initList($list);
	for($i = 0; $i < 13; $i++)
		$list[sprintf("Stop%03d", $i + 1)] = sprintf("%03d", $i + 301);
	for($i = 0; $i < 38; $i++)
		$list[sprintf("Stop%03d", $i + 14)] = sprintf("%03d", $i + 162);
	printList($list);
?>

NumberOfCouplers=0
NumberOfDivisionals=0
NumberOfTremulants=0
DispKeyColourInverted=N
PositionX=638
PositionY=439
ImageOn_FirstC=.\000870\manual\kl3\natdown.bmp
ImageOff_FirstC=.\000870\manual\kl3\natup.bmp
MaskOn_FirstC=.\000870\manual\kl3\cfmask.bmp
MaskOff_FirstC=.\000870\manual\kl3\cfmask.bmp
ImageOn_C=.\000870\manual\kl3\natdown.bmp
ImageOff_C=.\000870\manual\kl3\natup.bmp
MaskOn_C=.\000870\manual\kl3\cfmask.bmp
MaskOff_C=.\000870\manual\kl3\cfmask.bmp
ImageOn_Cis=.\000870\manual\kl3\sharpdown.bmp
ImageOff_Cis=.\000870\manual\kl3\sharpup.bmp
MaskOn_Cis=.\000870\manual\kl3\sharpmask.bmp
MaskOff_Cis=.\000870\manual\kl3\sharpmask.bmp
ImageOn_D=.\000870\manual\kl3\natdown.bmp
ImageOff_D=.\000870\manual\kl3\natup.bmp
MaskOn_D=.\000870\manual\kl3\dgmask.bmp
MaskOff_D=.\000870\manual\kl3\dgmask.bmp
ImageOn_Dis=.\000870\manual\kl3\sharpdown.bmp
ImageOff_Dis=.\000870\manual\kl3\sharpup.bmp
MaskOn_Dis=.\000870\manual\kl3\sharpmask.bmp
MaskOff_Dis=.\000870\manual\kl3\sharpmask.bmp
ImageOn_E=.\000870\manual\kl3\natdown.bmp
ImageOff_E=.\000870\manual\kl3\natup.bmp
MaskOn_E=.\000870\manual\kl3\ebmask.bmp
MaskOff_E=.\000870\manual\kl3\ebmask.bmp
ImageOn_F=.\000870\manual\kl3\natdown.bmp
ImageOff_F=.\000870\manual\kl3\natup.bmp
MaskOn_F=.\000870\manual\kl3\cfmask.bmp
MaskOff_F=.\000870\manual\kl3\cfmask.bmp
ImageOn_Fis=.\000870\manual\kl3\sharpdown.bmp
ImageOff_Fis=.\000870\manual\kl3\sharpup.bmp
MaskOn_Fis=.\000870\manual\kl3\sharpmask.bmp
MaskOff_Fis=.\000870\manual\kl3\sharpmask.bmp
ImageOn_G=.\000870\manual\kl3\natdown.bmp
ImageOff_G=.\000870\manual\kl3\natup.bmp
MaskOn_G=.\000870\manual\kl3\dgmask.bmp
MaskOff_G=.\000870\manual\kl3\dgmask.bmp
ImageOn_Gis=.\000870\manual\kl3\sharpdown.bmp
ImageOff_Gis=.\000870\manual\kl3\sharpup.bmp
MaskOn_Gis=.\000870\manual\kl3\sharpmask.bmp
MaskOff_Gis=.\000870\manual\kl3\sharpmask.bmp
ImageOn_A=.\000870\manual\kl3\natdown.bmp
ImageOff_A=.\000870\manual\kl3\natup.bmp
MaskOn_A=.\000870\manual\kl3\amask.bmp
MaskOff_A=.\000870\manual\kl3\amask.bmp
ImageOn_Ais=.\000870\manual\kl3\sharpdown.bmp
ImageOff_Ais=.\000870\manual\kl3\sharpup.bmp
MaskOn_Ais=.\000870\manual\kl3\sharpmask.bmp
MaskOff_Ais=.\000870\manual\kl3\sharpmask.bmp
ImageOn_B=.\000870\manual\kl3\natdown.bmp
ImageOff_B=.\000870\manual\kl3\natup.bmp
MaskOn_B=.\000870\manual\kl3\ebmask.bmp
MaskOff_B=.\000870\manual\kl3\ebmask.bmp
ImageOn_LastF=.\000870\manual\kl3\natdown.bmp
ImageOff_LastF=.\000870\manual\kl3\natup.bmp
MaskOn_LastF=.\000870\manual\kl3\wholemask.bmp
MaskOff_LastF=.\000870\manual\kl3\wholemask.bmp




;------------------------------------------------------------------------------
;     Generals sections
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
;     Windchest group section
;------------------------------------------------------------------------------

[WindchestGroup001]
Name=Pedal
NumberOfEnclosures=0
NumberOfTremulants=0

[WindchestGroup002]
Name=Manual 1
NumberOfEnclosures=0
NumberOfTremulants=0

[WindchestGroup003]
Name=Manual 2
NumberOfEnclosures=0
NumberOfTremulants=0

[WindchestGroup004]
Name=Manual 3
NumberOfEnclosures=0
NumberOfTremulants=0

[WindchestGroup005]
Name=Effects
NumberOfEnclosures=0
NumberOfTremulants=0



;------------------------------------------------------------------------------
;     Enclosure section
;------------------------------------------------------------------------------



;------------------------------------------------------------------------------
;     Tremulant section
;------------------------------------------------------------------------------



;------------------------------------------------------------------------------
;     Coupler section
;------------------------------------------------------------------------------


[Coupler021]
Name=I+II 
Function=And
SwitchCount=1
Switch001=<?php printf("%03d\n", switchID(57));?>
UnisonOff=N
DestinationManual=002
DestinationKeyshift=0
CoupleToSubsequentUnisonIntermanualCouplers=Y
CoupleToSubsequentUpwardIntermanualCouplers=N
CoupleToSubsequentDownwardIntermanualCouplers=N
CoupleToSubsequentUpwardIntramanualCouplers=N
CoupleToSubsequentDownwardIntramanualCouplers=N
Displayed=N


[Coupler032]
Name=II+III 
Function=And
SwitchCount=1
Switch001=<?php printf("%03d\n", switchID(58));?>
UnisonOff=N
DestinationManual=003
DestinationKeyshift=0
CoupleToSubsequentUnisonIntermanualCouplers=N
CoupleToSubsequentUpwardIntermanualCouplers=N
CoupleToSubsequentDownwardIntermanualCouplers=N
CoupleToSubsequentUpwardIntramanualCouplers=N
CoupleToSubsequentDownwardIntramanualCouplers=N
Displayed=N



;------------------------------------------------------------------------------
;     Stop sections
;------------------------------------------------------------------------------



;------------------------------------------------------------------------------
;     Pedal Stop section
;------------------------------------------------------------------------------


<?php
function s($no, $name, $sw, $pipes, $rank, $shift = null)
{
	initList($list, "Stop%03d", $no);
	$list["Name"]=$name;
	$list["Function"]="And";
	$list["SwitchCount"]=count($sw);
	for($i = 0; $i < count($sw); $i++)
		$list[sprintf("Switch%03d", $i + 1)] = sprintf("%03d", switchID($sw[$i]));
	$list["NumberOfRanks"]=count($rank);
	$list["NumberOfAccessiblePipes"]=$pipes;
	$list["FirstAccessiblePipeLogicalKeyNumber"]="001";
	$list["Displayed"]="N";
	for($i = 0; $i < count($rank); $i++)
		$list[sprintf("Rank%03d", $i + 1)] = sprintf("%03d", rankID($rank[$i]));
	if ($shift != null)
		for($i = 0; $i < count($rank); $i++)
			$list[sprintf("Rank%03dFirstPipeNumber", $i + 1)] = sprintf("%03d", $shift);
	printList($list);
}

s(1, "Principal 16'", array(1, 63, 64), 30, array(1, 51));
s(2, "Major Bass 32'", array(2, 63, 64), 30, array(2, 52));
s(3, "Violon Bass 16'", array(3, 63, 64), 30, array(3, 53));
s(4, "Sub Bass 16'", array(4, 63, 64), 30, array(4, 54), 3);
s(5, "Salicet Bass 16'", array(5, 63, 64), 30, array(5, 55), 3);
s(6, "Quintaden Bass 16'", array(6, 63, 64), 30, array(6, 56), 3);
s(7, "Octav Bass 8'", array(7, 63, 64), 30, array(7, 57), 3);
s(8, "Flaut Bass 8'", array(8, 63, 64), 30, array(8, 58));
s(9, "Gemshorn Quinta 6'", array(9, 63, 64), 30, array(9, 59));
s(10, "Super Octava 4'", array(10, 63, 64), 30, array(10, 60));
s(11, "Mixtura (VI ranks)", array(11, 63, 64), 30, array(11, 61));
s(12, "Posaunen Bass 32'", array(12, 63, 64, 69, 70), 30, array(12, 62));
s(13, "Posaunen Bass 16'", array(13, 63, 64, 69, 70), 30, array(13, 63));
s(14, "Trompet Bass 8'", array(14, 63, 64, 69, 70), 30, array(14, 64));
s(15, "Sub Bass 16' Camer-Ton", array(15, 63, 64), 30, array(4, 54));
s(16, "Salicet Bass 16' Camer-Ton", array(16, 63, 64), 30, array(5, 55));
s(17, "Quintaden Bass 16' Camer-Ton", array(17, 63, 64), 30, array(6, 56));
s(18, "Octav Bass 8' Camer-Ton", array(18, 63, 64), 30, array(7, 57));
s(19, "Calcantengloeckel", array(55), 30, array(101));
s(20, "Blower noise", array(71), 1, array(102));
s(21, "Tracker noise Pedal", array(72), 30, array(103));
?>

;------------------------------------------------------------------------------
;     Manual 1 Stop section
;------------------------------------------------------------------------------


<?php
s(101,"Principal 8'", array(19,67,68,59), 54, array(15,65),3);
s(102,"Flaut amabile 8'", array(20,67,68,59), 54, array(16,66),3);
s(103,"Flaut allemande 8'", array(21,67,68,59), 54, array(17,67),3);
s(104,"Quintadena 8'", array(22,67,68,59), 54, array(18,68),3);
s(105,"Octava 4'", array(23,67,68,59), 54, array(19,69),3);
s(106,"Quinta 3'", array(24,67,68,59), 54, array(20,70),3);
s(107,"Superoctava 2'", array(25,67,68,59), 54, array(21,71),3);
s(108,"Sedecima 1'", array(26,67,68,59), 54, array(22,72),3);
s(109,"Mixtura (III ranks)", array(27,67,68,59), 54, array(23,73),3);
s(110,"Hautbois 8'", array(28,67,68,59), 54, array(24,74),3);
s(111,"Principal 8' Camer-Ton", array(19,67,68,60), 54, array(15,65));
s(112,"Flaut amabile 8' Camer-Ton", array(20,67,68,60), 54, array(16,66));
s(113,"Flaut allemande 8' Camer-Ton", array(21,67,68,60), 54, array(17,67));
s(114,"Quintadena 8' Camer-Ton", array(22,67,68,60), 54, array(18,68));
s(115,"Octava 4' Camer-Ton", array(23,67,68,60), 54, array(19,69));
s(116,"Quinta 3' Camer-Ton", array(24,67,68,60), 54, array(20,70));
s(117,"Superoctava 2' Camer-Ton", array(25,67,68,60), 54, array(21,71));
s(118,"Sedecima 1' Camer-Ton", array(26,67,68,60), 54, array(22,72));
s(119,"Mixtura (III ranks) Camer-Ton", array(27,67,68,60), 54, array(23,73));
s(120,"Hautbois 8' Camer-Ton", array(28,67,68,60), 54, array(24,74));
s(121,"Tracker noise Manual1", array(72), 54, array(104));
?>

;------------------------------------------------------------------------------
;     Manual 2 Stop section
;------------------------------------------------------------------------------


<?php
s(201,"Principal 8'", array(29,65,66), 54, array(25,75));
s(202,"Burdon Flaut 16'", array(30,65,66), 54, array(26,76));
s(203,"Quintadena 16'", array(31,65,66), 54, array(27,77));
s(204,"Viola di Gamba 16'", array(32,65,66), 54, array(28,78));
s(205,"Flaut major 8'", array(33,65,66), 54, array(29,79));
s(206,"Gemshorn 8'", array(34,65,66), 54, array(30,80));
s(207,"Flaut traveur 8'", array(35,65,66), 54, array(31,81));
s(208,"Octava 4'", array(36,65,66), 54, array(32,82));
s(209,"Nachthorn 4'", array(37,65,66), 54, array(33,83));
s(210,"Gemshorn Quinta 3'", array(38,65,66), 54, array(34,84));
s(211,"Superoctava 2'", array(39,65,66), 54, array(35,85));
s(212,"Mixtura (VI ranks)", array(40,65,66), 54, array(36,86));
s(213,"Cimbel (II ranks)", array(41,65,66), 54, array(37,87));
s(214,"Unda maris 8'", array(42,65,66), 54, array(38,88));
s(215,"Tracker noise Manual2", array(72), 54, array(105));
?>

;------------------------------------------------------------------------------
;     Manual 3 Stop section
;------------------------------------------------------------------------------

<?php
s(301,"Principal 8'", array(43,61, 62), 54, array(39,89));
s(302,"Rohrflaut 8'", array(44,61, 62), 54, array(40,90));
s(303,"Salicet 8'", array(45,61, 62), 54, array(41,91));
s(304,"Octava 4'", array(46,61, 62), 54, array(42,92));
s(305,"Flaut minor 4'", array(47,61, 62), 54, array(43,93));
s(306,"Quinta 3'", array(48,61, 62), 54, array(44,94));
s(307,"Superoctava 2'", array(49,61, 62), 54, array(45,95));
s(308,"Quinta 1 1/2'", array(50,61, 62), 54, array(46,96));
s(309,"Sedecima 1'", array(51,61, 62), 54, array(47,97));
s(310,"Mixtura (IV ranks)", array(52,61, 62), 54, array(48,98));
s(311,"Trompet 8'", array(53,61, 62), 54, array(49,99));
s(312,"Vox humana 8'", array(54,61, 62), 54, array(50,100));
s(313,"Tracker noise Manual3", array(72), 54, array(106));
?>

;------------------------------------------------------------------------------
;     Stop noises Stop section
;------------------------------------------------------------------------------


<?php
function n($no, $func, $sw, $path)
{
	initList($list, "Stop%03d", $no);
	$list["Name"]="Stop noise";
	$list["Function"]=$func;
	$list["SwitchCount"]=count($sw);
	for($i = 0; $i < count($sw); $i++)
		$list[sprintf("Switch%03d", $i + 1)] = sprintf("%03d", $sw[$i]);
	$list["NumberOfLogicalPipes"]=1;
	$list["NumberOfAccessiblePipes"]=1;
	$list["FirstAccessiblePipeLogicalPipeNumber"]="001";
	$list["FirstAccessiblePipeLogicalKeyNumber"]="001";
	$list["WindchestGroup"]="005";
	$list["Percussive"]="N";
	$list["Displayed"]="N";
	$list["AmplitudeLevel"]="28";
	$list["Pipe001"]=".\\000870\\pipe\\r\\".$path;
	printList($list);
}

for($i = 0; $i < 30; $i++)
       n(30 + $i, "And", array($i + 1, 73), sprintf("TahlaPravoAtk\\%02d.wav", $i + 1));
for($i = 0; $i < 28; $i++)
       n(60 + $i, "And", array($i + 31, 73), sprintf("TahlaVlevoAtk\\%02d.wav", $i + 1));
for($i = 0; $i < 6; $i++)
       n(88 + $i, "And", array($i + 59, 73), sprintf("PozitivPravoAtk\\%02d.wav", $i + 1));
for($i = 0; $i < 6; $i++)
       n(94 + $i, "And", array($i + 65, 73), sprintf("PozitivVlevoAtk\\%02d.wav", $i + 1));

for($i = 0; $i < 30; $i++)
       n(130 + $i, "Nand", array($i + 1, 73), sprintf("TahlaPravoRel\\%02d.wav", $i + 1));
for($i = 0; $i < 28; $i++)
       n(160 + $i, "Nand", array($i + 31, 73), sprintf("TahlaVlevoRel\\%02d.wav", $i + 1));
for($i = 0; $i < 6; $i++)
       n(188 + $i, "Nand", array($i + 59, 73), sprintf("PozitivPravoRel\\%02d.wav", $i + 1));
for($i = 0; $i < 6; $i++)
       n(194 + $i, "Nand", array($i + 65, 73), sprintf("PozitivVlevoRel\\%02d.wav", $i + 1));
?>




;------------------------------------------------------------------------------
;     Switches section
;------------------------------------------------------------------------------


<?php
function sw($no, $typ, $label, $x, $y, $on = false)
{
	initList($list, "Switch%03d", switchID($no));
	$list["Name"]=$label;
	if (isset($x))
	{
		$list["DispLabelText"]="";
		$list["DefaultToEngaged"]=$on ? "Y" : "N";
		$list["Displayed"]="Y";
		$list["ImageOn"]=".\\000870\\stops1\\".$typ."_out.bmp";
		$list["ImageOff"]=".\\000870\\stops1\\".$typ."_in.bmp";
		$list["MaskOn"]=".\\000870\\stops1\\mask.bmp";
		$list["MaskOff"]=".\\000870\\stops1\\mask.bmp";
		$list["PositionX"]=$x;
		$list["PositionY"]=$y;
	}
	else
	{
		$list["DefaultToEngaged"]=$on ? "Y" : "N";
		$list["Displayed"]="N";
	}
	printList($list);
}

sw(1, "ped_principal16", "Principal 16'", 100, 210);
sw(2, "ped_majorbass32", "Major Bass 32'", 200, 210);
sw(3, "ped_violonbass16", "Violon Bass 16'", 1200, 210);
sw(4, "ped_subbas16", "Sub Bass 16'", 1300, 318);
sw(5, "ped_salicetbass16", "Salicet Bass 16'", 1300, 426);
sw(6, "ped_quintadenbass16", "Quintaden Bass 16'", 1300, 534);
sw(7, "ped_octavbass8", "Octav Bass 8'", 100, 318);
sw(8, "ped_flautbass8", "Flaut Bass 8'", 1300, 642);
sw(9, "ped_gemshornquinta6", "Gemshorn Quinta 6'", 100, 534);
sw(10, "ped_superoctava4", "Super Octava 4'", 100, 426);
sw(11, "ped_mixtura", "Mixtura (VI ranks)", 1200, 534);
sw(12, "ped_posaunenbass32", "Posaunen Bass 32'", 1300, 210);
sw(13, "ped_posaunenbass16", "Posaunen Bass 16'", 1200, 318);
sw(14, "ped_trompetbass8", "Trompet Bass 8'", 1200, 426);
sw(15, "ped_subbas16ct", "Sub Bass 16' Camer-Ton", 200, 318);
sw(16, "ped_salicetbass16ct", "Salicet Bass 16' Camer-Ton", 200, 426);
sw(17, "ped_quintadenbass16ct", "Quintaden Bass 16' Camer-Ton", 200, 534);
sw (18, "ped_octavbass8ct", "Octav Bass 8' Camer-Ton", 200, 642);
sw (19, "rp_principal8", "Principal 8'", 950, 892);
sw (20, "rp_flautamabile8", "Flaut amabile 8'", 450, 892);
sw (21, "rp_flautallemande8", "Flaut allemande 8'", 350, 892);
sw (22, "rp_quintadena8", "Quintadena 8'", 250, 892);
sw (23, "rp_octava4", "Octava 4'", 1050, 892);
sw (24, "rp_quinta3", "Quinta 3'", 150, 892);
sw (25, "rp_superoctava2", "Superoctava 2'", 1150, 892);
sw (26, "rp_sedecima1", "Sedecima 1'", 50, 892);
sw (27, "rp_mixtura", "Mixtura (III ranks)", 1350, 892);
sw (28, "rp_hautbois8", "Hautbois 8'", 1250, 892);
sw (29, "hw_principal8", "Principal 8'", 1100, 210);
sw (30, "hw_burdonflaut16", "Burdon Flaut 16'", 300, 318);
sw (31, "hw_quintadena16", "Quintadena 16'", 300, 210);
sw (32, "hw_violadigambe16", "Viola di Gamba 16'", 1000, 534);
sw (33, "hw_flautmajor8", "Flaut major 8'", 300, 534);
sw (34, "hw_gemshorn8", "Gemshorn 8'", 300, 426);
sw (35, "hw_traveur8", "Flaut traveur 8'", 1000, 642);
sw (36, "hw_octava4", "Octava 4'", 1100, 426);
sw (37, "hw_nachthorn4", "Nachthorn 4'", 1100, 534);
sw (38, "hw_gemshornquinta3", "Gemshorn Quinta 3'", 400, 534);
sw (39, "hw_superoctava2", "Superoctava 2'", 400, 642);
sw (40, "hw_mixtura", "Mixtura (VI ranks)", 300, 642);
sw (41, "hw_cimbel", "Cimbel (II ranks)", 1100, 642);
sw (42, "hw_undamaris8", "Unda maris 8'", 1100, 318);
sw (43, "bw_principal8", "Principal 8'", 900, 210);
sw (44, "bw_rohrflaut8", "Rohrflaut 8'", 1000, 210);
sw (45, "bw_salicet8", "Salicet 8'", 400, 210);
sw (46, "bw_octava4", "Octava 4'", 900, 318);
sw (47, "bw_flautminor4", "Flaut minor 4'", 1000, 318);
sw (48, "bw_quinta3", "Quinta 3'", 400, 426);
sw (49, "bw_superoctava2", "Superoctava 2'", 500, 318);
sw (50, "bw_quinta112", "Quinta 1 1/2'", 1000, 426);
sw (51, "bw_sedecima1", "Sedecima 1'", 500, 426);
sw (52, "bw_mixtura", "Mixtura (IV ranks)", 900, 426);
sw (53, "bw_trompet8", "Trompet 8'", 400, 318);
sw (54, "bw_voxhumana8", "Vox humana 8'", 500, 210);
sw (55, "calcantenglockel", "Calcantengloeckel", 100, 642);
sw (56, "calcantenglockel", "Windablaß", 100, 642);
sw (57, "copula2", "Copula 2 Clavier", 900, 534);
sw (58, "copula3", "Copula 3 Clavier", 500, 642);
sw (59, "copula1ct", "Copula 1 Camer Ton", 900, 642, true);
sw (60, "copula2ct", "Copula 2 Camer Ton", 500, 534);
sw (61, "sperventilbrustL", "Sperrventil Brust L", 0, 210, true);
sw (62, "sperventilbrustR", "Sperrventil Brust R", 1400, 210, true);
sw (63, "pedalventilL", "Pedal Ventil L", 0, 318, true);
sw (64, "pedalventilL", "Pedal Ventil R", 1400, 318, true);
sw (65, "sperventilmanualL", "Sperrventil Manual L", 0, 426, true);
sw (66, "sperventilmanualR", "Sperrventil Manual R", 1400, 426, true);
sw (67, "sperventilruckpositivL", "Sperrventil Rück Positiv L", 0, 534, true);
sw (68, "sperventilruckpositivR", "Sperrventil Rück Positiv R", 1400, 534, true);
sw (69, "rohrwerkventilL", "Rohrwerk Ventil L", 0, 642, true);
sw (70, "rohrwerkventilR", "Rohrwerk Ventil R", 1400, 642, true);
sw (71, "", "Wind", null, null, true);
sw (72, "", "Spiel- Traktur", null, null, true);
sw (73, "", "Register- Traktur", null, null, true);
?>




;------------------------------------------------------------------------------
;     Label section
;------------------------------------------------------------------------------



;------------------------------------------------------------------------------
;     Images section
;------------------------------------------------------------------------------

[Image001]
Image=.\000870\backgrounds\Console.bmp
Mask=.\000870\backgrounds\Consolemask.bmp
PositionX=0
PositionY=0
Width=1500
Height=1000
TileOffsetX=0
TileOffsetY=0




;------------------------------------------------------------------------------
;     Panels section
;------------------------------------------------------------------------------


[Panel001]
Name=Control Panel
Group=
DispScreenSizeHoriz=375
DispScreenSizeVert=450
DispDrawstopBackgroundImageNum=55
DispConsoleBackgroundImageNum=56
DispKeyHorizBackgroundImageNum=58
DispKeyVertBackgroundImageNum=62
DispDrawstopInsetBackgroundImageNum=57
DispControlLabelFont=Arial
DispShortcutKeyLabelFont=Arial
DispShortcutKeyLabelColour=Black
DispGroupLabelFont=Arial
DispDrawstopCols=2
DispDrawstopRows=2
DispDrawstopColsOffset=N
DispPairDrawstopCols=N
DispExtraDrawstopRows=0
DispExtraDrawstopCols=0
DispButtonCols=1
DispExtraButtonRows=1
DispExtraPedalButtonRow=N
DispButtonsAboveManuals=N
DispExtraDrawstopRowsAboveExtraButtonRows=N
DispTrimAboveManuals=N
DispTrimBelowManuals=N
DispTrimAboveExtraRows=Y
NumberOfManuals=0
HasPedals=N
NumberOfEnclosures=0
NumberOfTremulants=0
NumberOfReversiblePistons=0
NumberOfSwitches=3
Switch001=071
Switch002=072
Switch003=073
NumberOfGenerals=0
NumberOfDivisionals=0
NumberOfDivisionalCouplers=0
NumberOfStops=0
NumberOfCouplers=0
NumberOfLabels=4
NumberOfImages=1

[Panel001Image001]
Image=.\000870\html\krz1.jpg
PositionX=0
PositionY=0
Width=375
Height=450
TileOffsetX=0
TileOffsetY=0

[Panel001Switch071]
;Blower noise
PositionX=60
PositionY=150
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=6

[Panel001Switch072]
;Tracker noise
PositionX=60
PositionY=250
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=6

[Panel001Switch073]
;Stop noise
PositionX=60
PositionY=350
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=6

[Panel001Label001]
Name=Control Panel
FreeXPlacement=Y
FreeYPlacement=Y
DispXpos=80
DispYpos=50
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=5

[Panel001Label002]
Name=Blower Noise
FreeXPlacement=Y
FreeYPlacement=Y
DispXpos=150
DispYpos=170
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=4

[Panel001Label003]
Name=Tracker Noise
FreeXPlacement=Y
FreeYPlacement=Y
DispXpos=150
DispYpos=270
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=4

[Panel001Label004]
Name=Stop Noise
FreeXPlacement=Y
FreeYPlacement=Y
DispXpos=150
DispYpos=370
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=4



[Panel002]
Name=Organ view
Group=
DispScreenSizeHoriz=1000
DispScreenSizeVert=694
DispDrawstopBackgroundImageNum=55
DispConsoleBackgroundImageNum=56
DispKeyHorizBackgroundImageNum=58
DispKeyVertBackgroundImageNum=62
DispDrawstopInsetBackgroundImageNum=57
DispControlLabelFont=Arial
DispShortcutKeyLabelFont=Arial
DispShortcutKeyLabelColour=Black
DispGroupLabelFont=Arial
DispDrawstopCols=2
DispDrawstopRows=2
DispDrawstopColsOffset=N
DispPairDrawstopCols=N
DispExtraDrawstopRows=0
DispExtraDrawstopCols=0
DispButtonCols=1
DispExtraButtonRows=1
DispExtraPedalButtonRow=N
DispButtonsAboveManuals=N
DispExtraDrawstopRowsAboveExtraButtonRows=N
DispTrimAboveManuals=N
DispTrimBelowManuals=N
DispTrimAboveExtraRows=Y
NumberOfManuals=0
HasPedals=N
NumberOfEnclosures=0
NumberOfTremulants=0
NumberOfReversiblePistons=0
NumberOfSwitches=0
NumberOfGenerals=0
NumberOfDivisionals=0
NumberOfDivisionalCouplers=0
NumberOfStops=0
NumberOfCouplers=0
NumberOfLabels=0
NumberOfImages=1

[Panel002Image001]
Image=.\000870\html\Krzm.jpg
PositionX=0
PositionY=0
Width=1000
Height=694
TileOffsetX=0
TileOffsetY=0







;------------------------------------------------------------------------------
;     Ranks section
;------------------------------------------------------------------------------
<?php
initRank($list, 1, "Front: Principal 16'", 36, 30, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\principbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 2, "Front: Major Bass 32'", 36, 30, 100, 1, 2);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\majorbass32", 36, array(480, -1), $pipeinfo);
printList($list);

initRank($list, 3, "Front: Violon Bass 16'", 36, 30, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\violonbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 4, "Front: Sub Bass 16'", 34, 32, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000871\\pipe_atk\\pedal\\subbass16", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000871\\pipe_atk\\pedal\\subbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 5, "Front: Salicet Bass 16'", 34, 32, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000871\\pipe_atk\\pedal\\salicet16", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000871\\pipe_atk\\pedal\\salicet16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 6, "Front: Quintaden Bass 16'", 34, 32, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000871\\pipe_atk\\pedal\\quintadenbass16", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000871\\pipe_atk\\pedal\\quintadenbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 7, "Front: Octav Bass 8'", 34, 32, 100, 1, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000871\\pipe_atk\\pedal\\octavbass8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000871\\pipe_atk\\pedal\\octavbass8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 8, "Front: Flaut Bass 8'", 36, 30, 100, 1, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\flautbass8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 9, "Front: Gemshorn Quinta 6'", 36, 30, 100, 1, 12);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\gemshornquint6", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 10, "Front: Super Octava 4'", 36, 30, 100, 1, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\superoctava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 11, "Front: Mixtura (VI ranks)", 36, 30, 100, 1, 24);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 12, "Front: Posaunen Bass 32'", 36, 30, 100, 1, 2);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\posaunenbass32", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 13, "Front: Posaunen Bass 16'", 36, 30, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\posaunenbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 14, "Front: Trompet Bass 8'", 36, 30, 100, 1, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000871\\pipe_atk\\pedal\\trompetbass8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 15, "Front: Principal 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\principal8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\principal8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 16, "Front: Flaut amabile 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\flautamabile8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\flautamabile8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 17, "Front: Flaut allemande 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\flautallemande8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\flautallemande8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 18, "Front: Quintadena 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\quintadena8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\quintadena8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 19, "Front: Octava 4'", 34, 56, 100, 2, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\octava4", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\octava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 20, "Front: Quinta 3'", 34, 56, 100, 2, 24);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\quinta3", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\quinta3", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 21, "Front: Superoctava 2'", 34, 56, 100, 2, 32);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\superoctava2", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\superoctava2", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 22, "Front: Sedecima 1'", 34, 56, 100, 2, 64);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\sedecima1", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\sedecima1", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 23, "Front: Mixtura (III ranks)", 34, 56, 100, 2, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\mixtura", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=48
Pipe002HarmonicNumber=48
Pipe003HarmonicNumber=48
Pipe004HarmonicNumber=48
Pipe005HarmonicNumber=48
Pipe006HarmonicNumber=48
Pipe007HarmonicNumber=48
Pipe008HarmonicNumber=48
Pipe009HarmonicNumber=48
Pipe010HarmonicNumber=48
Pipe011HarmonicNumber=48
Pipe012HarmonicNumber=48
Pipe013HarmonicNumber=48
Pipe014HarmonicNumber=48
Pipe015HarmonicNumber=48
Pipe016HarmonicNumber=48
Pipe017HarmonicNumber=48
Pipe018HarmonicNumber=48
Pipe019HarmonicNumber=48
Pipe020HarmonicNumber=48
Pipe021HarmonicNumber=48
Pipe022HarmonicNumber=48
Pipe023HarmonicNumber=48
Pipe024HarmonicNumber=48
Pipe025HarmonicNumber=32
Pipe026HarmonicNumber=32
Pipe027HarmonicNumber=32
Pipe028HarmonicNumber=32
Pipe029HarmonicNumber=32
Pipe030HarmonicNumber=32
Pipe031HarmonicNumber=32
Pipe032HarmonicNumber=32
Pipe033HarmonicNumber=32
Pipe034HarmonicNumber=32
Pipe035HarmonicNumber=32
Pipe036HarmonicNumber=32
Pipe037HarmonicNumber=16
Pipe038HarmonicNumber=16
Pipe039HarmonicNumber=16
Pipe040HarmonicNumber=16
Pipe041HarmonicNumber=16
Pipe042HarmonicNumber=16
Pipe043HarmonicNumber=16
Pipe044HarmonicNumber=16
Pipe045HarmonicNumber=16
Pipe046HarmonicNumber=16
Pipe047HarmonicNumber=16
Pipe048HarmonicNumber=16
Pipe049HarmonicNumber=16
Pipe050HarmonicNumber=16
Pipe051HarmonicNumber=16
Pipe052HarmonicNumber=16
Pipe053HarmonicNumber=16
Pipe054HarmonicNumber=16
Pipe055HarmonicNumber=16
Pipe056HarmonicNumber=16
<?php
initRank($list, 24, "Front: Hautbois 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000872\\pipe_atk\\pos\\hautbois8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000872\\pipe_atk\\pos\\hautbois8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 25, "Front: Principal 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\principal8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 26, "Front: Burdon Flaut 16'", 36, 54, 100, 3, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\burdon16", 36, array(480, -1), $pipeinfo);
printList($list);

initRank($list, 27, "Front: Quintadena 16'", 36, 54, 100, 3, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\quintadena16", 36, array(480, -1), $pipeinfo);
printList($list);

initRank($list, 28, "Front: Viola di Gamba 16'", 36, 54, 100, 3, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\gamba16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 29, "Front: Flaut major 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\flautmajor8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 30, "Front: Gemshorn 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\gemshorn8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 31, "Front: Flaut traveur 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\traveur8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 32, "Front: Octava 4'", 36, 54, 100, 3, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\octava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 33, "Front: Nachthorn 4'", 36, 54, 100, 3, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\nachthorn4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 34, "Front: Gemshorn Quinta 3'", 36, 54, 100, 3, 12);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\gemshornquinta3", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 35, "Front: Superoctava 2'", 36, 54, 100, 3, 32);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\superoctava2", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 36, "Front: Mixtura (VI ranks)", 36, 54, 100, 3, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=32
Pipe002HarmonicNumber=32
Pipe003HarmonicNumber=32
Pipe004HarmonicNumber=32
Pipe005HarmonicNumber=32
Pipe006HarmonicNumber=32
Pipe007HarmonicNumber=32
Pipe008HarmonicNumber=32
Pipe009HarmonicNumber=32
Pipe010HarmonicNumber=32
Pipe011HarmonicNumber=32
Pipe012HarmonicNumber=32
Pipe013HarmonicNumber=32
Pipe014HarmonicNumber=32
Pipe015HarmonicNumber=32
Pipe016HarmonicNumber=32
Pipe017HarmonicNumber=32
Pipe018HarmonicNumber=32
Pipe019HarmonicNumber=32
Pipe020HarmonicNumber=32
Pipe021HarmonicNumber=32
Pipe022HarmonicNumber=32
Pipe023HarmonicNumber=32
Pipe024HarmonicNumber=32
Pipe025HarmonicNumber=32
Pipe026HarmonicNumber=32
Pipe027HarmonicNumber=32
Pipe028HarmonicNumber=32
Pipe029HarmonicNumber=32
Pipe030HarmonicNumber=32
Pipe031HarmonicNumber=32
Pipe032HarmonicNumber=32
Pipe033HarmonicNumber=32
Pipe034HarmonicNumber=32
Pipe035HarmonicNumber=32
Pipe036HarmonicNumber=32
Pipe037HarmonicNumber=16
Pipe038HarmonicNumber=16
Pipe039HarmonicNumber=16
Pipe040HarmonicNumber=16
Pipe041HarmonicNumber=16
Pipe042HarmonicNumber=16
Pipe043HarmonicNumber=16
Pipe044HarmonicNumber=16
Pipe045HarmonicNumber=16
Pipe046HarmonicNumber=16
Pipe047HarmonicNumber=16
Pipe048HarmonicNumber=16
Pipe049HarmonicNumber=16
Pipe050HarmonicNumber=16
Pipe051HarmonicNumber=16
Pipe052HarmonicNumber=16
Pipe053HarmonicNumber=16
Pipe054HarmonicNumber=16
<?php
initRank($list, 37, "Front: Cimbel (II ranks)", 36, 54, 100, 3, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\cimbel", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=48
Pipe002HarmonicNumber=48
Pipe003HarmonicNumber=48
Pipe004HarmonicNumber=48
Pipe005HarmonicNumber=48
Pipe006HarmonicNumber=48
Pipe007HarmonicNumber=48
Pipe008HarmonicNumber=48
Pipe009HarmonicNumber=48
Pipe010HarmonicNumber=48
Pipe011HarmonicNumber=48
Pipe012HarmonicNumber=48
Pipe013HarmonicNumber=48
Pipe014HarmonicNumber=48
Pipe015HarmonicNumber=48
Pipe016HarmonicNumber=48
Pipe017HarmonicNumber=48
Pipe018HarmonicNumber=48
Pipe019HarmonicNumber=48
Pipe020HarmonicNumber=48
Pipe021HarmonicNumber=48
Pipe022HarmonicNumber=48
Pipe023HarmonicNumber=48
Pipe024HarmonicNumber=48
Pipe025HarmonicNumber=48
Pipe026HarmonicNumber=48
Pipe027HarmonicNumber=48
Pipe028HarmonicNumber=48
Pipe029HarmonicNumber=48
Pipe030HarmonicNumber=48
Pipe031HarmonicNumber=48
Pipe032HarmonicNumber=48
Pipe033HarmonicNumber=48
Pipe034HarmonicNumber=48
Pipe035HarmonicNumber=48
Pipe036HarmonicNumber=48
Pipe037HarmonicNumber=32
Pipe038HarmonicNumber=32
Pipe039HarmonicNumber=32
Pipe040HarmonicNumber=32
Pipe041HarmonicNumber=32
Pipe042HarmonicNumber=24
Pipe043HarmonicNumber=24
Pipe044HarmonicNumber=24
Pipe045HarmonicNumber=24
Pipe046HarmonicNumber=24
Pipe047HarmonicNumber=24
Pipe048HarmonicNumber=24
Pipe049HarmonicNumber=24
Pipe050HarmonicNumber=24
Pipe051HarmonicNumber=24
Pipe052HarmonicNumber=24
Pipe053HarmonicNumber=24
Pipe054HarmonicNumber=24
<?php
initRank($list, 38, "Front: Unda maris 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000871\\pipe_atk\\hw\\undamaris", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 39, "Front: Principal 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\principal8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 40, "Front: Rohrflaut 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\rohrflaut8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 41, "Front: Salicet 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\salicet8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 42, "Front: Octava 4'", 36, 54, 100, 4, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\octava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 43, "Front: Flaut minor 4'", 36, 54, 100, 4, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\flautminor4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 44, "Front: Quinta 3'", 36, 54, 100, 4, 24);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\quinta3", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 45, "Front: Superoctava 2'", 36, 54, 100, 4, 32);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\superoctava2", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 46, "Front: Quinta 1 1/2'", 36, 54, 100, 4, 36);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\quinta112", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 47, "Front: Sedecima 1'", 36, 54, 100, 4, 64);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\sedecima1", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 48, "Front: Mixtura (IV ranks)", 36, 54, 100, 4, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=48
Pipe002HarmonicNumber=48
Pipe003HarmonicNumber=48
Pipe004HarmonicNumber=48
Pipe005HarmonicNumber=48
Pipe006HarmonicNumber=48
Pipe007HarmonicNumber=48
Pipe008HarmonicNumber=48
Pipe009HarmonicNumber=48
Pipe010HarmonicNumber=48
Pipe011HarmonicNumber=48
Pipe012HarmonicNumber=48
Pipe013HarmonicNumber=48
Pipe014HarmonicNumber=48
Pipe015HarmonicNumber=48
Pipe016HarmonicNumber=48
Pipe017HarmonicNumber=48
Pipe018HarmonicNumber=48
Pipe019HarmonicNumber=48
Pipe020HarmonicNumber=48
Pipe021HarmonicNumber=48
Pipe022HarmonicNumber=48
Pipe023HarmonicNumber=48
Pipe024HarmonicNumber=48
Pipe025HarmonicNumber=32
Pipe026HarmonicNumber=32
Pipe027HarmonicNumber=32
Pipe028HarmonicNumber=32
Pipe029HarmonicNumber=32
Pipe030HarmonicNumber=32
Pipe031HarmonicNumber=32
Pipe032HarmonicNumber=32
Pipe033HarmonicNumber=32
Pipe034HarmonicNumber=32
Pipe035HarmonicNumber=32
Pipe036HarmonicNumber=32
Pipe037HarmonicNumber=32
Pipe038HarmonicNumber=16
Pipe039HarmonicNumber=16
Pipe040HarmonicNumber=16
Pipe041HarmonicNumber=16
Pipe042HarmonicNumber=16
Pipe043HarmonicNumber=16
Pipe044HarmonicNumber=16
Pipe045HarmonicNumber=16
Pipe046HarmonicNumber=16
Pipe047HarmonicNumber=16
Pipe048HarmonicNumber=16
Pipe049HarmonicNumber=16
Pipe050HarmonicNumber=16
Pipe051HarmonicNumber=16
Pipe052HarmonicNumber=16
Pipe053HarmonicNumber=16
Pipe054HarmonicNumber=16
<?php
initRank($list, 49, "Front: Trompet 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\trompet8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 50, "Front: Vox humana 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000872\\pipe_atk\\brust\\voxhumana8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 51, "Rear: Principal 16'", 36, 30, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_principbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 52, "Rear: Major Bass 32'", 36, 30, 100, 1, 2);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_majorbass32", 36, array(180, -1), $pipeinfo);
printList($list);

initRank($list, 53, "Rear: Violon Bass 16'", 36, 30, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_violonbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 54, "Rear: Sub Bass 16'", 34, 32, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000873\\pipe_re\\pedal\\re_subbass16", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000873\\pipe_re\\pedal\\re_subbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 55, "Rear: Salicet Bass 16'", 34, 32, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000873\\pipe_re\\pedal\\re_salicet16", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000873\\pipe_re\\pedal\\re_salicet16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 56, "Rear: Quintaden Bass 16'", 34, 32, 100, 1, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000873\\pipe_re\\pedal\\re_quintadenbass16", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000873\\pipe_re\\pedal\\re_quintadenbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 57, "Rear: Octav Bass 8'", 34, 32, 100, 1, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000873\\pipe_re\\pedal\\re_octavbass8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 30, ".\\000873\\pipe_re\\pedal\\re_octavbass8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 58, "Rear: Flaut Bass 8'", 36, 30, 100, 1, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_flautbass8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 59, "Rear: Gemshorn Quinta 6'", 36, 30, 100, 1, 12);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_gemshornquint6", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 60, "Rear: Super Octava 4'", 36, 30, 100, 1, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_superoctava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 61, "Rear: Mixtura (VI ranks)", 36, 30, 100, 1, 24);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 62, "Rear: Posaunen Bass 32'", 36, 30, 100, 1, 2);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_posaunenbass32", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 63, "Rear: Posaunen Bass 16'", 36, 30, 100, 1, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_posaunenbass16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 64, "Rear: Trompet Bass 8'", 36, 30, 100, 1, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 30, ".\\000873\\pipe_re\\pedal\\re_trompetbass8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 65, "Rear: Principal 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_principal8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_principal8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 66, "Rear: Flaut amabile 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_flautamabile8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_flautamabile8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 67, "Rear: Flaut allemande 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_flautallemande8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_flautallemande8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 68, "Rear: Quintadena 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_quintadena8", 34, array(180, 680, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_quintadena8", 36, array(180, 680, -1), $pipeinfo);
printList($list);

initRank($list, 69, "Rear: Octava 4'", 34, 56, 100, 2, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_octava4", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_octava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 70, "Rear: Quinta 3'", 34, 56, 100, 2, 24);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_quinta3", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_quinta3", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 71, "Rear: Superoctava 2'", 34, 56, 100, 2, 32);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_superoctava2", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_superoctava2", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 72, "Rear: Sedecima 1'", 34, 56, 100, 2, 64);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_sedecima1", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_sedecima1", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 73, "Rear: Mixtura (III ranks)", 34, 56, 100, 2, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_mixtura", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=48
Pipe002HarmonicNumber=48
Pipe003HarmonicNumber=48
Pipe004HarmonicNumber=48
Pipe005HarmonicNumber=48
Pipe006HarmonicNumber=48
Pipe007HarmonicNumber=48
Pipe008HarmonicNumber=48
Pipe009HarmonicNumber=48
Pipe010HarmonicNumber=48
Pipe011HarmonicNumber=48
Pipe012HarmonicNumber=48
Pipe013HarmonicNumber=48
Pipe014HarmonicNumber=48
Pipe015HarmonicNumber=48
Pipe016HarmonicNumber=48
Pipe017HarmonicNumber=48
Pipe018HarmonicNumber=48
Pipe019HarmonicNumber=48
Pipe020HarmonicNumber=48
Pipe021HarmonicNumber=48
Pipe022HarmonicNumber=48
Pipe023HarmonicNumber=48
Pipe024HarmonicNumber=48
Pipe025HarmonicNumber=32
Pipe026HarmonicNumber=32
Pipe027HarmonicNumber=32
Pipe028HarmonicNumber=32
Pipe029HarmonicNumber=32
Pipe030HarmonicNumber=32
Pipe031HarmonicNumber=32
Pipe032HarmonicNumber=32
Pipe033HarmonicNumber=32
Pipe034HarmonicNumber=32
Pipe035HarmonicNumber=32
Pipe036HarmonicNumber=32
Pipe037HarmonicNumber=16
Pipe038HarmonicNumber=16
Pipe039HarmonicNumber=16
Pipe040HarmonicNumber=16
Pipe041HarmonicNumber=16
Pipe042HarmonicNumber=16
Pipe043HarmonicNumber=16
Pipe044HarmonicNumber=16
Pipe045HarmonicNumber=16
Pipe046HarmonicNumber=16
Pipe047HarmonicNumber=16
Pipe048HarmonicNumber=16
Pipe049HarmonicNumber=16
Pipe050HarmonicNumber=16
Pipe051HarmonicNumber=16
Pipe052HarmonicNumber=16
Pipe053HarmonicNumber=16
Pipe054HarmonicNumber=16
Pipe055HarmonicNumber=16
Pipe056HarmonicNumber=16
<?php
initRank($list, 74, "Rear: Hautbois 8'", 34, 56, 100, 2, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 1, ".\\000874\\pipe_re\\pos\\re_hautbois8", 34, array(180, 380, -1), $pipeinfo);
$list["Pipe002"] = ".\\000870\\pipe\\mech\\mech_null.wav";
addRank($list, 3, 54, ".\\000874\\pipe_re\\pos\\re_hautbois8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 75, "Rear: Principal 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_principal8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 76, "Rear: Burdon Flaut 16'", 36, 54, 100, 3, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_burdon16", 36, array(480, -1), $pipeinfo);
printList($list);

initRank($list, 77, "Rear: Quintadena 16'", 36, 54, 100, 3, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_quintadena16", 36, array(480, -1), $pipeinfo);
printList($list);

initRank($list, 78, "Rear: Viola di Gamba 16'", 36, 54, 100, 3, 4);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_gamba16", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 79, "Rear: Flaut major 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_flautmajor8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 80, "Rear: Gemshorn 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_gemshorn8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 81, "Rear: Flaut traveur 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_traveur8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 82, "Rear: Octava 4'", 36, 54, 100, 3, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_octava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 83, "Rear: Nachthorn 4'", 36, 54, 100, 3, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_nachthorn4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 84, "Rear: Gemshorn Quinta 3'", 36, 54, 100, 3, 24);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_gemshornquinta3", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 85, "Rear: Superoctava 2'", 36, 54, 100, 3, 32);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_superoctava2", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 86, "Rear: Mixtura (VI ranks)", 36, 54, 100, 3, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=32
Pipe002HarmonicNumber=32
Pipe003HarmonicNumber=32
Pipe004HarmonicNumber=32
Pipe005HarmonicNumber=32
Pipe006HarmonicNumber=32
Pipe007HarmonicNumber=32
Pipe008HarmonicNumber=32
Pipe009HarmonicNumber=32
Pipe010HarmonicNumber=32
Pipe011HarmonicNumber=32
Pipe012HarmonicNumber=32
Pipe013HarmonicNumber=32
Pipe014HarmonicNumber=32
Pipe015HarmonicNumber=32
Pipe016HarmonicNumber=32
Pipe017HarmonicNumber=32
Pipe018HarmonicNumber=32
Pipe019HarmonicNumber=32
Pipe020HarmonicNumber=32
Pipe021HarmonicNumber=32
Pipe022HarmonicNumber=32
Pipe023HarmonicNumber=32
Pipe024HarmonicNumber=32
Pipe025HarmonicNumber=32
Pipe026HarmonicNumber=32
Pipe027HarmonicNumber=32
Pipe028HarmonicNumber=32
Pipe029HarmonicNumber=32
Pipe030HarmonicNumber=32
Pipe031HarmonicNumber=32
Pipe032HarmonicNumber=32
Pipe033HarmonicNumber=32
Pipe034HarmonicNumber=32
Pipe035HarmonicNumber=32
Pipe036HarmonicNumber=32
Pipe037HarmonicNumber=16
Pipe038HarmonicNumber=16
Pipe039HarmonicNumber=16
Pipe040HarmonicNumber=16
Pipe041HarmonicNumber=16
Pipe042HarmonicNumber=16
Pipe043HarmonicNumber=16
Pipe044HarmonicNumber=16
Pipe045HarmonicNumber=16
Pipe046HarmonicNumber=16
Pipe047HarmonicNumber=16
Pipe048HarmonicNumber=16
Pipe049HarmonicNumber=16
Pipe050HarmonicNumber=16
Pipe051HarmonicNumber=16
Pipe052HarmonicNumber=16
Pipe053HarmonicNumber=16
Pipe054HarmonicNumber=16
<?php
initRank($list, 87, "Rear: Cimbel (II ranks)", 36, 54, 100, 3, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_cimbel", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=48
Pipe002HarmonicNumber=48
Pipe003HarmonicNumber=48
Pipe004HarmonicNumber=48
Pipe005HarmonicNumber=48
Pipe006HarmonicNumber=48
Pipe007HarmonicNumber=48
Pipe008HarmonicNumber=48
Pipe009HarmonicNumber=48
Pipe010HarmonicNumber=48
Pipe011HarmonicNumber=48
Pipe012HarmonicNumber=48
Pipe013HarmonicNumber=48
Pipe014HarmonicNumber=48
Pipe015HarmonicNumber=48
Pipe016HarmonicNumber=48
Pipe017HarmonicNumber=48
Pipe018HarmonicNumber=48
Pipe019HarmonicNumber=48
Pipe020HarmonicNumber=48
Pipe021HarmonicNumber=48
Pipe022HarmonicNumber=48
Pipe023HarmonicNumber=48
Pipe024HarmonicNumber=48
Pipe025HarmonicNumber=48
Pipe026HarmonicNumber=48
Pipe027HarmonicNumber=48
Pipe028HarmonicNumber=48
Pipe029HarmonicNumber=48
Pipe030HarmonicNumber=48
Pipe031HarmonicNumber=48
Pipe032HarmonicNumber=48
Pipe033HarmonicNumber=48
Pipe034HarmonicNumber=48
Pipe035HarmonicNumber=48
Pipe036HarmonicNumber=48
Pipe037HarmonicNumber=32
Pipe038HarmonicNumber=32
Pipe039HarmonicNumber=32
Pipe040HarmonicNumber=32
Pipe041HarmonicNumber=32
Pipe042HarmonicNumber=24
Pipe043HarmonicNumber=24
Pipe044HarmonicNumber=24
Pipe045HarmonicNumber=24
Pipe046HarmonicNumber=24
Pipe047HarmonicNumber=24
Pipe048HarmonicNumber=24
Pipe049HarmonicNumber=24
Pipe050HarmonicNumber=24
Pipe051HarmonicNumber=24
Pipe052HarmonicNumber=24
Pipe053HarmonicNumber=24
Pipe054HarmonicNumber=24
<?php
initRank($list, 88, "Rear: Unda maris 8'", 36, 54, 100, 3, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000873\\pipe_re\\hw\\re_undamaris", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 89, "Rear: Principal 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_principal8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 90, "Rear: Rohrflaut 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_rohrflaut8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 91, "Rear: Salicet 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_salicet8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 92, "Rear: Octava 4'", 36, 54, 100, 4, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_octava4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 93, "Rear: Flaut minor 4'", 36, 54, 100, 4, 16);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_flautminor4", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 94, "Rear: Quinta 3'", 36, 54, 100, 4, 24);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_quinta3", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 95, "Rear: Superoctava 2'", 36, 54, 100, 4, 32);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_superoctava2", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 96, "Rear: Quinta 1 1/2'", 36, 54, 100, 4, 36);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_quinta112", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 97, "Rear: Sedecima 1'", 36, 54, 100, 4, 64);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_sedecima1", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 98, "Rear: Mixtura (IV ranks)", 36, 54, 100, 4, null);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_mixtura", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=48
Pipe002HarmonicNumber=48
Pipe003HarmonicNumber=48
Pipe004HarmonicNumber=48
Pipe005HarmonicNumber=48
Pipe006HarmonicNumber=48
Pipe007HarmonicNumber=48
Pipe008HarmonicNumber=48
Pipe009HarmonicNumber=48
Pipe010HarmonicNumber=48
Pipe011HarmonicNumber=48
Pipe012HarmonicNumber=48
Pipe013HarmonicNumber=48
Pipe014HarmonicNumber=48
Pipe015HarmonicNumber=48
Pipe016HarmonicNumber=48
Pipe017HarmonicNumber=48
Pipe018HarmonicNumber=48
Pipe019HarmonicNumber=48
Pipe020HarmonicNumber=48
Pipe021HarmonicNumber=48
Pipe022HarmonicNumber=48
Pipe023HarmonicNumber=48
Pipe024HarmonicNumber=48
Pipe025HarmonicNumber=32
Pipe026HarmonicNumber=32
Pipe027HarmonicNumber=32
Pipe028HarmonicNumber=32
Pipe029HarmonicNumber=32
Pipe030HarmonicNumber=32
Pipe031HarmonicNumber=32
Pipe032HarmonicNumber=32
Pipe033HarmonicNumber=32
Pipe034HarmonicNumber=32
Pipe035HarmonicNumber=32
Pipe036HarmonicNumber=32
Pipe037HarmonicNumber=32
Pipe038HarmonicNumber=16
Pipe039HarmonicNumber=16
Pipe040HarmonicNumber=16
Pipe041HarmonicNumber=16
Pipe042HarmonicNumber=16
Pipe043HarmonicNumber=16
Pipe044HarmonicNumber=16
Pipe045HarmonicNumber=16
Pipe046HarmonicNumber=16
Pipe047HarmonicNumber=16
Pipe048HarmonicNumber=16
Pipe049HarmonicNumber=16
Pipe050HarmonicNumber=16
Pipe051HarmonicNumber=16
Pipe052HarmonicNumber=16
Pipe053HarmonicNumber=16
Pipe054HarmonicNumber=16
<?php
initRank($list, 99, "Rear: Trompet 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_trompet8", 36, array(180, 380, -1), $pipeinfo);
printList($list);

initRank($list, 100, "Rear: Vox humana 8'", 36, 54, 100, 4, 8);
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
addRank($list, 1, 54, ".\\000874\\pipe_re\\brust\\re_voxhumana8", 36, array(180, 380, -1), $pipeinfo);
printList($list);
?>


[Rank101]
Name=Calcant
FirstMidiNoteNumber=36
NumberOfLogicalPipes=1
AmplitudeLevel=100
WindchestGroup=005
Percussive=N
PitchTuning=0
Pipe001=.\000870\pipe\r\CalcantAtk\01.wav
Pipe001AttackCount=3
Pipe001Attack001=.\000870\pipe\r\CalcantAtk\02.wav
Pipe001Attack002=.\000870\pipe\r\CalcantAtk\03.wav
Pipe001Attack003=.\000870\pipe\r\CalcantAtk\04.wav
<?php
initRank($list, 102, "Blower noise", 36, 1, 50, 5, null);
$list["Pipe001"] = ".\\000870\\pipe\\mech\\mech.wav";
printList($list);

initRank($list, 103, "Tracker Pedal", 36, 30, 100, 5, null);
$pipeinfo = array("mainnorelease"=> false, "releasecuepoint" => false);
addRank($list, 1, 22, ".\\000870\\pipe\\ped_mokry\\atk", 36, array(), $pipeinfo);
printList($list);
?>
Pipe023=.\000870\pipe\ped_mokry\atk\058-A#__2.wav
Pipe024=.\000870\pipe\ped_mokry\atk\059-B__2.wav
Pipe025=.\000870\pipe\ped_mokry\atk\060-C__2.wav
Pipe026=.\000870\pipe\ped_mokry\atk\061-C#__2.wav
Pipe027=.\000870\pipe\ped_mokry\atk\062-D__2.wav
Pipe028=.\000870\pipe\ped_mokry\atk\063-D#__4.wav
Pipe029=.\000870\pipe\ped_mokry\atk\064-E__4.wav
Pipe030=.\000870\pipe\ped_mokry\atk\065-F__4.wav
<?php
initRank($list, 104, "Tracker Manual1", 36, 54, 28, 5, null);
$pipeinfo = array("mainnorelease"=> false, "releasecuepoint" => false);
addRank($list, 1, 54, ".\\000870\\pipe\\kl1_mokry\\atk", 36, array(), $pipeinfo);
printList($list);

initRank($list, 105, "Tracker Manual2", 36, 54, 28, 5, null);
$pipeinfo = array("mainnorelease"=> false, "releasecuepoint" => false);
addRank($list, 1, 54, ".\\000870\\pipe\\kl2_mokry\\atk", 36, array(), $pipeinfo);
printList($list);

initRank($list, 106, "Tracker Manual3", 36, 54, 28, 5, null);
$pipeinfo = array("mainnorelease"=> false, "releasecuepoint" => false);
addRank($list, 1, 54, ".\\000870\\pipe\\kl3_mokry\\atk", 36, array(), $pipeinfo);
printList($list);
?>


