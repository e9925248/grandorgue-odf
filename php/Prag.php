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
;------------------------------------------------------------------------------
;     Organ definition file by (c) Michael P. Schmidt
;     Sampleset: Prague Baroque wet for Hauptwerk 4 by Sonus Paradisi
;     Version: 1.00 12/13/2013 for GrandOrgue V. 0.3.xx
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
ChurchName=Tyn
ChurchAddress=Prag
OrganBuilder=
OrganBuildDate=
OrganComments=
RecordingDetails=
InfoFilename=

NumberOfManuals=2
HasPedals=Y
NumberOfEnclosures=0
NumberOfTremulants=1
NumberOfWindchestGroups=3
NumberOfReversiblePistons=0
NumberOfGenerals=0
NumberOfDivisionalCouplers=0
NumberOfPanels=0
NumberOfRanks=4

NumberOfLabels=2
AmplitudeLevel=100
Gain=0
PitchTuning=0

DispScreenSizeHoriz=Medium
DispScreenSizeVert=Small

DispDrawstopBackgroundImageNum=33
DispConsoleBackgroundImageNum=33
DispKeyHorizBackgroundImageNum=34
DispKeyVertBackgroundImageNum=34
DispDrawstopInsetBackgroundImageNum=34

DispControlLabelFont=Times New Roman
DispShortcutKeyLabelFont=Times New Roman
DispShortcutKeyLabelColour=BLACK
DispGroupLabelFont=Times New Roman

DispDrawstopCols=6
DispDrawstopRows=7
DispDrawstopColsOffset=N
DispDrawstopOuterColOffsetUp=N

DispPairDrawstopCols=n
DispExtraDrawstopRows=0
DispExtraDrawstopCols=0
DispButtonCols=10
DispExtraButtonRows=0

DispExtraPedalButtonRow=N
DispExtraPedalButtonRowOffset=N
DispExtraPedalButtonRowOffsetRight=N

DispButtonsAboveManuals=N
DispTrimAboveManuals=N
DispTrimBelowManuals=N
DispTrimAboveExtraRows=N
DispExtraDrawstopRowsAboveExtraButtonRows=N

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
NumberOfLogicalKeys=29
FirstAccessibleKeyLogicalKeyNumber=001
FirstAccessibleKeyMIDINoteNumber=36
NumberOfAccessibleKeys=29
MIDIInputNumber=001
Displayed=Y
NumberOfStops=9
;Subbass gedeckt 16'
Stop001=001
;Subbass offen 16'
Stop002=002
;Octavbass 8'
Stop003=003
;Superoctavbass 4'
Stop004=004
;Quintbass 6'
Stop005=005
;Mixtur 2-4fach
Stop006=006
;Posaunbass 8' 
Stop007=007
;GrossPusaun 16'
Stop008=008
;OctavPusaun 8'
Stop009=009
NumberOfCouplers=1
;Coupler HW-Ped
Coupler001=001
NumberOfDivisionals=0
NumberOfTremulants=0
DispKeyColourInverted=N


[Manual001]
Name=Rückpositiv
NumberOfLogicalKeys=54
FirstAccessibleKeyLogicalKeyNumber=001
FirstAccessibleKeyMIDINoteNumber=36
NumberOfAccessibleKeys=54
MIDIInputNumber=002
Displayed=Y
NumberOfStops=10
;Copula major 8'
Stop001=101
;Principal 4'
Stop002=102
;Flauta amabilis 4'
Stop003=103
;Octava 2'
Stop004=104
;Quinta 1 1/2'
Stop005=105
;Quintadecima 9+ (=1')
Stop006=106
;Mixtura 3fach
Stop007=107
;Rauschquint 2fach
Stop008=108
;Crumbhorn 8'
Stop009=109
;Regal 8'
Stop010=110
NumberOfCouplers=0
NumberOfDivisionals=0
NumberOfTremulants=0
DispKeyColourInverted=Y


[Manual002]
Name=Hauptwerk
NumberOfLogicalKeys=54
FirstAccessibleKeyLogicalKeyNumber=1
FirstAccessibleKeyMIDINoteNumber=36
NumberOfAccessibleKeys=54
MIDIInputNumber=003
Displayed=Y
NumberOfStops=20
;Bourdunflauta 16'
Stop001=201
;Principal 8'
Stop002=202
;Flauta dulcis 8'
Stop003=203
;Quintatöne 8'
Stop004=204
;Salicional 8'
Stop005=205
;Copula major 8'
Stop006=206
;Copula minor 4'
Stop007=207
;Octava 4'
Stop008=208
;Quinta major 3'
Stop009=209
;Superoctava 2'
Stop010=210
;Quinta minor 1 1/2'
Stop011=211
;Sedecima 1'
Stop012=212
;Mixtura 1' 6fach
Stop013=213
;Cembalo 4fach
Stop014=214
;Dulzian 16'
Stop015=215
;Pusaun 8'
Stop016=216
;Zimbelstern links
Stop017=217
;Zimbelstern rechts
Stop018=218
;Calcant
Stop019=219
;Motor
Stop020=220
NumberOfCouplers=1
;Coupler RP - HW
Coupler001=021
NumberOfDivisionals=0
NumberOfTremulants=0
DispKeyColourInverted=Y




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
Name=Rückpositiv
NumberOfEnclosures=0
NumberOfTremulants=1
Tremulant001=001

[WindchestGroup003]
Name=Hauptwerk
NumberOfEnclosures=0
NumberOfTremulants=0




;------------------------------------------------------------------------------
;     Enclosure section
;------------------------------------------------------------------------------



;------------------------------------------------------------------------------
;     Tremulant section
;------------------------------------------------------------------------------

[Tremulant001]
Name=Trem. Rückpositiv
DispLabelText=Trem. Rückpo- sitiv
Period=235
AmpModDepth=12
StartRate=80
StopRate=80
DispDrawstopCol=6
DispDrawstopRow=1
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
DefaultToEngaged=N
DisplayInInvertedState=N
DispKeyLabelOnLeft=N



;------------------------------------------------------------------------------
;     Coupler section
;------------------------------------------------------------------------------

[Coupler001]
Name=Coupler HW-Ped
DispLabelText=Coupler   HW-Ped
UnisonOff=N
DestinationManual=002
DestinationKeyshift=0
CoupleToSubsequentUnisonIntermanualCouplers=N
CoupleToSubsequentUpwardIntermanualCouplers=N
CoupleToSubsequentDownwardIntermanualCouplers=N
CoupleToSubsequentUpwardIntramanualCouplers=N
CoupleToSubsequentDownwardIntramanualCouplers=N
DispDrawstopCol=2
DispDrawstopRow=7
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
DefaultToEngaged=N
DisplayInInvertedState=N
DispKeyLabelOnLeft=N


[Coupler021]
Name=Coupler RP - HW 
DispLabelText=Coupler      RP-HW
UnisonOff=N
DestinationManual=001
DestinationKeyshift=0
CoupleToSubsequentUnisonIntermanualCouplers=N
CoupleToSubsequentUpwardIntermanualCouplers=N
CoupleToSubsequentDownwardIntermanualCouplers=N
CoupleToSubsequentUpwardIntramanualCouplers=N
CoupleToSubsequentDownwardIntramanualCouplers=N
DispDrawstopCol=5
DispDrawstopRow=1
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
DefaultToEngaged=N
DisplayInInvertedState=N
DispKeyLabelOnLeft=N



;------------------------------------------------------------------------------
;     Stop sections
;------------------------------------------------------------------------------



;------------------------------------------------------------------------------
;     Pedal Stop section
;------------------------------------------------------------------------------

;----- Pedal ----- Subbass gedeckt 16'
[Stop001]
Name=Subbass gedeckt 16' 
DispLabelText=Subbass gedeckt 16'
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=6
DispDrawstopRow=7
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=4
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 22, ".\\000373\\pipe\\gedackt16st", 36, array(312, -1), $pipeinfo);
addRank($list, 23, 7, ".\\000373\\pipe\\gedackt16st", 46, array(312, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=0
Pipe009PitchTuning=0
Pipe019PitchTuning=100
Pipe021PitchTuning=100
;extended
Pipe023PitchTuning=1200
Pipe024PitchTuning=1200
Pipe025PitchTuning=1200
Pipe026PitchTuning=1200
Pipe027PitchTuning=1200
Pipe028PitchTuning=1200
Pipe029PitchTuning=1200



;----- Pedal ----- Subbass offen 16'
[Stop002]
Name=Subbass offen 16'
DispLabelText=Subbass offen 16'
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=5
DispDrawstopRow=6
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=4
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 22, ".\\000373\\pipe\\subbasoffen16st", 36, array(400, -1), $pipeinfo);
addRank($list, 23, 7, ".\\000373\\pipe\\subbasoffen16st", 46, array(400, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=0
Pipe009PitchTuning=0
Pipe019PitchTuning=100
Pipe021PitchTuning=100
;extended
Pipe023PitchTuning=1200
Pipe024PitchTuning=1200
Pipe025PitchTuning=1200
Pipe026PitchTuning=1200
Pipe027PitchTuning=1200
Pipe028PitchTuning=1200
Pipe029PitchTuning=1200



;----- Pedal ----- Octavbass 8'
[Stop003]
Name=Octavbass 8'
DispLabelText=Octavbass 8'
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=3
DispDrawstopRow=6
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 22, ".\\000373\\pipe\\octavbas8st", 36, array(180, 300, -1), $pipeinfo);
addRank($list, 23, 7, ".\\000373\\pipe\\octavbas8st", 46, array(180, 300, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=0
Pipe009PitchTuning=0
Pipe019PitchTuning=100
Pipe021PitchTuning=100
;extended
Pipe023PitchTuning=1200
Pipe024PitchTuning=1200
Pipe025PitchTuning=1200
Pipe026PitchTuning=1200
Pipe027PitchTuning=1200
Pipe028PitchTuning=1200
Pipe029PitchTuning=1200




;----- Pedal ----- Superoctavbass 4'
[Stop004]
Name=Superoctavbass 4' 
DispLabelText=Super- octavbass 4'
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=1
DispDrawstopRow=7
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=16
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 22, ".\\000373\\pipe\\superoctavbas4st", 36, array(180, 300, -1), $pipeinfo);
addRank($list, 23, 7, ".\\000373\\pipe\\superoctavbas4st", 46, array(180, 300, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=0
Pipe009PitchTuning=0
Pipe019PitchTuning=100
Pipe021PitchTuning=100
;extended
Pipe023PitchTuning=1200
Pipe024PitchTuning=1200
Pipe025PitchTuning=1200
Pipe026PitchTuning=1200
Pipe027PitchTuning=1200
Pipe028PitchTuning=1200
Pipe029PitchTuning=1200



;----- Pedal ----- Quintbass 6'
[Stop005]
Name=Quintbass 6'
DispLabelText=Quintbass 6'
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=4
DispDrawstopRow=6
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=12
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 22, ".\\000373\\pipe\\quintbas6st", 36, array(370, -1), $pipeinfo);
addRank($list, 23, 7, ".\\000373\\pipe\\quintbas6st", 46, array(370, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=0
Pipe009PitchTuning=0
Pipe019PitchTuning=100
Pipe021PitchTuning=100
;extended
Pipe023PitchTuning=1200
Pipe024PitchTuning=1200
Pipe025PitchTuning=1200
Pipe026PitchTuning=1200
Pipe027PitchTuning=1200
Pipe028PitchTuning=1200
Pipe029PitchTuning=1200



;----- Pedal ----- Mixtur 2-4fach
[Stop006]
Name=Mixtur 2-4fach
DispLabelText=Mixtur 2-4fach
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=2
DispDrawstopRow=6
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 22, ".\\000373\\pipe\\mixtur3xst", 36, array(140, 370, -1), $pipeinfo);
addRank($list, 23, 7, ".\\000373\\pipe\\mixtur3xst", 46, array(140, 370, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=24
Pipe002PitchTuning=100
Pipe002HarmonicNumber=24
Pipe003HarmonicNumber=24
Pipe004PitchTuning=100
Pipe004HarmonicNumber=24
Pipe005HarmonicNumber=24
Pipe006HarmonicNumber=24
Pipe007PitchTuning=0
Pipe007HarmonicNumber=24
Pipe008HarmonicNumber=24
Pipe009PitchTuning=0
Pipe009HarmonicNumber=24
Pipe010HarmonicNumber=24
Pipe011HarmonicNumber=24
Pipe012HarmonicNumber=24
Pipe013HarmonicNumber=24
Pipe014HarmonicNumber=24
Pipe015HarmonicNumber=24
Pipe016HarmonicNumber=24
Pipe017HarmonicNumber=24
Pipe018HarmonicNumber=24
Pipe019PitchTuning=100
Pipe019HarmonicNumber=24
Pipe020HarmonicNumber=24
Pipe021PitchTuning=100
Pipe021HarmonicNumber=24
Pipe022HarmonicNumber=24
;extended
Pipe023HarmonicNumber=24
Pipe023PitchTuning=1200
Pipe024HarmonicNumber=24
Pipe024PitchTuning=1200
Pipe025HarmonicNumber=24
Pipe025PitchTuning=1200
Pipe026HarmonicNumber=24
Pipe026PitchTuning=1200
Pipe027HarmonicNumber=24
Pipe027PitchTuning=1200
Pipe028HarmonicNumber=24
Pipe028PitchTuning=1200
Pipe029HarmonicNumber=24
Pipe029PitchTuning=1200



;----- Pedal ----- Posaunbass 8' 
[Stop007]
Name=Posaunbass 8' 
DispLabelText=Fagott 16' 
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=5
DispDrawstopRow=7
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=4
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 22, ".\\000373\\pipe\\schnarrbas8st", 36, array(180, 360, -1), $pipeinfo);
addRank($list, 23, 7, ".\\000373\\pipe\\schnarrbas8st", 46, array(180, 360, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=0
Pipe009PitchTuning=0
Pipe019PitchTuning=100
Pipe021PitchTuning=100
;extended
Pipe023PitchTuning=1200
Pipe024PitchTuning=1200
Pipe025PitchTuning=1200
Pipe026PitchTuning=1200
Pipe027PitchTuning=1200
Pipe028PitchTuning=1200
Pipe029PitchTuning=1200




;----- Pedal ----- GrossPusaun 16'
[Stop008]
Name=GrossPusaun 16'
DispLabelText=Gross- Pusaun 16'
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=4
DispDrawstopRow=7
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
PitchTuning=0
HarmonicNumber=4
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 24, ".\\000373\\pipe\\_GrosPusaun16", 36, array(160, 380, -1), $pipeinfo);
addRank($list, 25, 5, ".\\000373\\pipe\\_GrosPusaun16", 48, array(160, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001PitchTuning=-145
Pipe002PitchTuning=-65
Pipe003PitchTuning=-155
Pipe004PitchTuning=-165
Pipe005PitchTuning=-174
Pipe006PitchTuning=-65
Pipe007PitchTuning=-61
Pipe008PitchTuning=-145
Pipe009PitchTuning=-55
Pipe010PitchTuning=-149
Pipe011PitchTuning=-61
Pipe012PitchTuning=-73
Pipe013PitchTuning=-45
Pipe014PitchTuning=-65
Pipe015PitchTuning=-55
Pipe016PitchTuning=-65
Pipe017PitchTuning=-74
Pipe018PitchTuning=-65
Pipe019PitchTuning=-61
Pipe020PitchTuning=-45
Pipe021PitchTuning=-55
Pipe022PitchTuning=-49
Pipe023PitchTuning=-61
Pipe024PitchTuning=-73
;extended
Pipe025PitchTuning=1155
Pipe026PitchTuning=1135
Pipe027PitchTuning=1145
Pipe028PitchTuning=1135
Pipe029PitchTuning=1126



;----- Pedal ----- OctavPusaun 8'
[Stop009]
Name=OctavPusaun 8'
DispLabelText=Octav- Pusaun 8'
NumberOfLogicalPipes=29
NumberOfAccessiblePipes=29
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=001
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=3
DispDrawstopRow=7
DispLabelColour=DARK RED
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
PitchTuning=0
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 24, ".\\000373\\pipe\\_OctPusaun8", 36, array(180, 390, -1), $pipeinfo);
addRank($list, 25, 5, ".\\000373\\pipe\\_OctPusaun8", 48, array(180, 390, -1), $pipeinfo);
printList($list);
?>
Pipe001PitchTuning=-145
Pipe002PitchTuning=-65
Pipe003PitchTuning=-155
Pipe004PitchTuning=-65
Pipe005PitchTuning=-174
Pipe006PitchTuning=-65
Pipe007PitchTuning=-61
Pipe008PitchTuning=-145
Pipe009PitchTuning=-55
Pipe010PitchTuning=-149
Pipe011PitchTuning=-61
Pipe012PitchTuning=-73
Pipe013PitchTuning=-45
Pipe014PitchTuning=-65
Pipe015PitchTuning=-55
Pipe016PitchTuning=-65
Pipe017PitchTuning=-74
Pipe018PitchTuning=-65
Pipe019PitchTuning=-61
Pipe020PitchTuning=-45
Pipe021PitchTuning=-55
Pipe022PitchTuning=-49
Pipe023PitchTuning=-61
Pipe024PitchTuning=-73
;extended
Pipe025PitchTuning=1155
Pipe026PitchTuning=1135
Pipe027PitchTuning=1145
Pipe028PitchTuning=1135
Pipe029PitchTuning=1126




;------------------------------------------------------------------------------
;     Rückpos.            man. I        Stop section
;------------------------------------------------------------------------------

;----- Rückpos. ----- Copula major 8'
[Stop101]
Name=Copula major 8'
DispLabelText=Copula major 8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=6
DispDrawstopRow=5
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\CopulaMajor8st", 36, array(360, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\CopulaMajor8st", 73, array(360, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Rückpos. ----- Principal 4'
[Stop102]
Name=Principal 4'
DispLabelText=Principal 4'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=6
DispDrawstopRow=3
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=16
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\Principal4st", 36, array(330, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\Principal4st", 73, array(330, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Rückpos. ----- Flauta amabilis 4'
[Stop103]
Name=Flauta amabilis 4'
DispLabelText=Flauta amabilis 4'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=6
DispDrawstopRow=4
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=16
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\Flautaamabilis4st", 36, array(290, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\Flautaamabilis4st", 73, array(290, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Rückpos. ----- Octava 2'
[Stop104]
Name=Octava 2'
DispLabelText=Octava 2'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=6
DispDrawstopRow=2
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=32
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\Octava2st", 36, array(260, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\Octava2st", 73, array(260, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200




;----- Rückpos. ----- Quinta 1 1/3'
[Stop105]
Name=Quinta 1 1/3'
DispLabelText=Quinta 1 1/3'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=1
DispDrawstopRow=5
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=48
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\Quinta113st", 36, array(290, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\Quinta113st", 73, array(290, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Rückpos. ----- Quintadecima 9+ (=1')
[Stop106]
Name=Quintadecima 9+ (=1')
DispLabelText=Quinta- decima 9+
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=1
DispDrawstopRow=4
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=64
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\Quintadecima1st", 36, array(190, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\Quintadecima1st", 73, array(190, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200




;----- Rückpos. ----- Mixtura 3fach
[Stop107]
Name=Mixtura 3fach
DispLabelText=Mixtura 3fach
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=1
DispDrawstopRow=3
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\Mixtur4xst", 36, array(220, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\Mixtur4xst", 73, array(220, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=96
Pipe002PitchTuning=100
Pipe002HarmonicNumber=96
Pipe003HarmonicNumber=96
Pipe004PitchTuning=100
Pipe004HarmonicNumber=96
Pipe005HarmonicNumber=96
Pipe006HarmonicNumber=96
Pipe007PitchTuning=100
Pipe007HarmonicNumber=96
Pipe008HarmonicNumber=96
Pipe009PitchTuning=100
Pipe009HarmonicNumber=96
Pipe010HarmonicNumber=96
Pipe011HarmonicNumber=96
Pipe012HarmonicNumber=96
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
Pipe025HarmonicNumber=24
Pipe026HarmonicNumber=24
Pipe027HarmonicNumber=24
Pipe028HarmonicNumber=24
Pipe029HarmonicNumber=24
Pipe030HarmonicNumber=24
Pipe031HarmonicNumber=24
Pipe032HarmonicNumber=24
Pipe033HarmonicNumber=24
Pipe034HarmonicNumber=24
Pipe035HarmonicNumber=24
Pipe036HarmonicNumber=24
Pipe037HarmonicNumber=12
Pipe038HarmonicNumber=12
Pipe039HarmonicNumber=12
Pipe040HarmonicNumber=12
Pipe041HarmonicNumber=12
Pipe042HarmonicNumber=12
Pipe043HarmonicNumber=12
Pipe044HarmonicNumber=12
Pipe045HarmonicNumber=12
Pipe046HarmonicNumber=12
Pipe047HarmonicNumber=12
Pipe048HarmonicNumber=12
Pipe049HarmonicNumber=12
;extended
Pipe050HarmonicNumber=6
Pipe050PitchTuning=1200
Pipe051HarmonicNumber=6
Pipe051PitchTuning=1200
Pipe052HarmonicNumber=6
Pipe052PitchTuning=1200
Pipe053HarmonicNumber=6
Pipe053PitchTuning=1200
Pipe054HarmonicNumber=6
Pipe054PitchTuning=1200




;----- Rückpos. ----- Rauschquint 2fach
[Stop108]
Name=Rauschquint 2fach
DispLabelText=Rausch- quint 2fach
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=1
DispDrawstopRow=2
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000374\\pipe\\Rauschquinta2xst", 36, array(250, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000374\\pipe\\Rauschquinta2xst", 73, array(250, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=128
Pipe002PitchTuning=100
Pipe002HarmonicNumber=128
Pipe003HarmonicNumber=128
Pipe004PitchTuning=100
Pipe004HarmonicNumber=128
Pipe005HarmonicNumber=128
Pipe006HarmonicNumber=128
Pipe007PitchTuning=100
Pipe007HarmonicNumber=128
Pipe008HarmonicNumber=128
Pipe009PitchTuning=100
Pipe009HarmonicNumber=128
Pipe010HarmonicNumber=128
Pipe011HarmonicNumber=128
Pipe012HarmonicNumber=128
Pipe013HarmonicNumber=96
Pipe014HarmonicNumber=96
Pipe015HarmonicNumber=96
Pipe016HarmonicNumber=96
Pipe017HarmonicNumber=96
Pipe018HarmonicNumber=96
Pipe019HarmonicNumber=96
Pipe020HarmonicNumber=96
Pipe021HarmonicNumber=96
Pipe022HarmonicNumber=96
Pipe023HarmonicNumber=96
Pipe024HarmonicNumber=96
Pipe025HarmonicNumber=64
Pipe026HarmonicNumber=64
Pipe027HarmonicNumber=64
Pipe028HarmonicNumber=64
Pipe029HarmonicNumber=64
Pipe030HarmonicNumber=64
Pipe031HarmonicNumber=64
Pipe032HarmonicNumber=64
Pipe033HarmonicNumber=64
Pipe034HarmonicNumber=64
Pipe035HarmonicNumber=64
Pipe036HarmonicNumber=64
Pipe037HarmonicNumber=64
Pipe038HarmonicNumber=64
Pipe039HarmonicNumber=64
Pipe040HarmonicNumber=64
Pipe041HarmonicNumber=64
Pipe042HarmonicNumber=64
Pipe043HarmonicNumber=64
Pipe044HarmonicNumber=64
Pipe045HarmonicNumber=64
Pipe046HarmonicNumber=64
Pipe047HarmonicNumber=64
Pipe048HarmonicNumber=64
Pipe049HarmonicNumber=64
;extended
Pipe050HarmonicNumber=32
Pipe050PitchTuning=1200
Pipe051HarmonicNumber=32
Pipe051PitchTuning=1200
Pipe052HarmonicNumber=32
Pipe052PitchTuning=1200
Pipe053HarmonicNumber=32
Pipe053PitchTuning=1200
Pipe054HarmonicNumber=32
Pipe054PitchTuning=1200



;----- Rückpos. ----- Crumbhorn 8'
[Stop109]
Name=Crumbhorn 8'
DispLabelText=Crumb- horn    8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=1
DispDrawstopRow=6
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
PitchTuning=0
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 50, ".\\000373\\pipe\\_crumbhornpos", 36, array(66, 180, 400, -1), $pipeinfo);
addRank($list, 51, 4, ".\\000373\\pipe\\_crumbhornpos", 74, array(66, 180, 400, -1), $pipeinfo);
printList($list);
?>
Pipe001PitchTuning=-145
Pipe002PitchTuning=-65
Pipe003PitchTuning=45
Pipe004PitchTuning=-65
Pipe005PitchTuning=26
Pipe006PitchTuning=-65
Pipe007PitchTuning=-61
Pipe008PitchTuning=55
Pipe009PitchTuning=-55
Pipe010PitchTuning=51
Pipe011PitchTuning=-61
Pipe012PitchTuning=-73
Pipe013PitchTuning=-45
Pipe014PitchTuning=-65
Pipe015PitchTuning=-55
Pipe016PitchTuning=-65
Pipe017PitchTuning=-74
Pipe018PitchTuning=-65
Pipe019PitchTuning=-61
Pipe020PitchTuning=-45
Pipe021PitchTuning=-55
Pipe022PitchTuning=-49
Pipe023PitchTuning=-61
Pipe024PitchTuning=-73
Pipe025PitchTuning=-45
Pipe026PitchTuning=-65
Pipe027PitchTuning=-55
Pipe028PitchTuning=-65
Pipe029PitchTuning=-74
Pipe030PitchTuning=-65
Pipe031PitchTuning=-61
Pipe032PitchTuning=-45
Pipe033PitchTuning=-55
Pipe034PitchTuning=-49
Pipe035PitchTuning=-61
Pipe036PitchTuning=-73
Pipe037PitchTuning=-45
Pipe038PitchTuning=-65
Pipe039PitchTuning=-55
Pipe040PitchTuning=-65
Pipe041PitchTuning=-74
Pipe042PitchTuning=-65
Pipe043PitchTuning=-61
Pipe044PitchTuning=-45
Pipe045PitchTuning=-55
Pipe046PitchTuning=-49
Pipe047PitchTuning=-61
Pipe048PitchTuning=-73
Pipe049PitchTuning=-45
Pipe050PitchTuning=-65
;extended
Pipe051PitchTuning=1155
Pipe052PitchTuning=1135
Pipe053PitchTuning=1126
Pipe054PitchTuning=1135




;----- Rückpos. ----- Regal 8'
[Stop110]
Name=Regal 8'
DispLabelText=Regal                  8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=002
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=6
DispDrawstopRow=6
DispLabelColour=DARK BLUE
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
PitchTuning=0
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 50, ".\\000373\\pipe\\_regal", 36, array(180, 360, -1), $pipeinfo);
addRank($list, 51, 4, ".\\000373\\pipe\\_regal", 74, array(180, 360, -1), $pipeinfo);
printList($list);
?>
Pipe001PitchTuning=-145
Pipe002PitchTuning=-65
Pipe003PitchTuning=45
Pipe004PitchTuning=-65
Pipe005PitchTuning=26
Pipe006PitchTuning=-65
Pipe007PitchTuning=-61
Pipe008PitchTuning=-145
Pipe009PitchTuning=-55
Pipe010PitchTuning=-149
Pipe011PitchTuning=-61
Pipe012PitchTuning=-73
Pipe013PitchTuning=-45
Pipe014PitchTuning=-65
Pipe015PitchTuning=-55
Pipe016PitchTuning=-65
Pipe017PitchTuning=-74
Pipe018PitchTuning=-65
Pipe019PitchTuning=-61
Pipe020PitchTuning=-45
Pipe021PitchTuning=-55
Pipe022PitchTuning=-49
Pipe023PitchTuning=-61
Pipe024PitchTuning=-73
Pipe025PitchTuning=-45
Pipe026PitchTuning=-65
Pipe027PitchTuning=-55
Pipe028PitchTuning=-65
Pipe029PitchTuning=-74
Pipe030PitchTuning=-65
Pipe031PitchTuning=-61
Pipe032PitchTuning=-45
Pipe033PitchTuning=-55
Pipe034PitchTuning=-49
Pipe035PitchTuning=-61
Pipe036PitchTuning=-73
Pipe037PitchTuning=-45
Pipe038PitchTuning=-65
Pipe039PitchTuning=-55
Pipe040PitchTuning=-65
Pipe041PitchTuning=-74
Pipe042PitchTuning=-65
Pipe043PitchTuning=-61
Pipe044PitchTuning=-45
Pipe045PitchTuning=-55
Pipe046PitchTuning=-49
Pipe047PitchTuning=-61
Pipe048PitchTuning=-73
Pipe049PitchTuning=-45
Pipe050PitchTuning=-65
;extended
Pipe051PitchTuning=1155
Pipe052PitchTuning=1135
Pipe053PitchTuning=1126
Pipe054PitchTuning=1135





;------------------------------------------------------------------------------
;     Hauptwerk          man. II        Stop section
;------------------------------------------------------------------------------

;----- Hauptwerk ----- Bourdunflauta 16'
[Stop201]
Name=Bourdunflauta 16'
DispLabelText=Bordun Flauta 16'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=4
DispDrawstopRow=1
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=4
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\bordun16st", 36, array(370, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\bordun16st", 73, array(370, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200




;----- Hauptwerk ----- Principal 8'
[Stop202]
Name=Principal 8'
DispLabelText=Principal 8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=5
DispDrawstopRow=5
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\principal8st", 36, array(85, 150, 370, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\principal8st", 73, array(85, 150, 370, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=-100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200




;----- Hauptwerk ----- Flauta dulcis 8'
[Stop203]
Name=Flauta dulcis 8'
DispLabelText=Flauta dulcis 8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=2
DispDrawstopRow=2
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\flauta8st", 36, array(310, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\flauta8st", 73, array(310, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Hauptwerk ----- Quintatöne 8'
[Stop204]
Name=Quintatöne 8'
DispLabelText=Quinta= tone 8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=3
DispDrawstopRow=3
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\quintadena8st", 36, array(300, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\quintadena8st", 73, array(300, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Hauptwerk ----- Salicional 8'
[Stop205]
Name=Salicional 8'
DispLabelText=Salicional    8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=2
DispDrawstopRow=5
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\salicional8st", 36, array(360, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\salicional8st", 73, array(360, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Hauptwerk ----- Copula major 8'
[Stop206]
Name=Copula major 8'
DispLabelText=Copula major       8'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=4
DispDrawstopRow=3
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\copula8st", 36, array(310, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\copula8st", 73, array(310, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200




;----- Hauptwerk ----- Copula minor 4'
[Stop207]
Name=Copula minor 4'
DispLabelText=Copula minor      4'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=5
DispDrawstopRow=3
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=16
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\copula4st", 36, array(270, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\copula4st", 73, array(270, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200




;----- Hauptwerk ----- Octava 4'
[Stop208]
Name=Octava 4'
DispLabelText=Octava                 4'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=4
DispDrawstopRow=5
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=16
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\octava4st", 36, array(90, 330, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\octava4st", 73, array(90, 330, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200




;----- Hauptwerk ----- Quinta major 3'
[Stop209]
Name=Quinta major 3'
DispLabelText=Quinta major                  3'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=2
DispDrawstopRow=4
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=24
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\quintamajor3st", 36, array(340, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\quintamajor3st", 73, array(340, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Hauptwerk ----- Superoctava 2'
[Stop210]
Name=Superoctava 2'
DispLabelText=Super= octava       2'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=5
DispDrawstopRow=4
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=32
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\superoctava2st", 36, array(250, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\superoctava2st", 73, array(250, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Hauptwerk ----- Quinta minor 1 1/2'
[Stop211]
Name=Quinta minor 1 1/2'
DispLabelText=Quinta    minor             1 1/2'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=3
DispDrawstopRow=4
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=48
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\quintaminorst", 36, array(290, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\quintaminorst", 73, array(290, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Hauptwerk ----- Sedecima 1'
[Stop212]
Name=Sedecima 1'
DispLabelText=Sedecima               1'
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=4
DispDrawstopRow=4
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
HarmonicNumber=64
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\sedecima1st", 36, array(180, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\sedecima1st", 73, array(180, -1), $pipeinfo);
printList($list);
?>
Pipe002PitchTuning=100
Pipe004PitchTuning=100
Pipe007PitchTuning=100
Pipe009PitchTuning=100
;extended
Pipe050PitchTuning=1200
Pipe051PitchTuning=1200
Pipe052PitchTuning=1200
Pipe053PitchTuning=1200
Pipe054PitchTuning=1200



;----- Hauptwerk ----- Mixtura 1' 6fach
[Stop213]
Name=Mixtura 1' 6fach
DispLabelText=Mixtura     6.fach
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=5
DispDrawstopRow=2
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\mixturst", 36, array(280, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\mixturst", 73, array(280, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=64
Pipe002PitchTuning=100
Pipe002HarmonicNumber=64
Pipe003HarmonicNumber=64
Pipe004PitchTuning=100
Pipe004HarmonicNumber=64
Pipe005HarmonicNumber=64
Pipe006HarmonicNumber=64
Pipe007PitchTuning=100
Pipe007HarmonicNumber=64
Pipe008HarmonicNumber=64
Pipe009PitchTuning=100
Pipe009HarmonicNumber=64
Pipe010HarmonicNumber=64
Pipe011HarmonicNumber=64
Pipe012HarmonicNumber=64
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
Pipe025HarmonicNumber=16
Pipe026HarmonicNumber=16
Pipe027HarmonicNumber=16
Pipe028HarmonicNumber=16
Pipe029HarmonicNumber=16
Pipe030HarmonicNumber=16
Pipe031HarmonicNumber=16
Pipe032HarmonicNumber=16
Pipe033HarmonicNumber=16
Pipe034HarmonicNumber=16
Pipe035HarmonicNumber=16
Pipe036HarmonicNumber=16
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
;extended
Pipe050PitchTuning=0
Pipe051PitchTuning=0
Pipe052PitchTuning=0
Pipe053PitchTuning=0
Pipe054PitchTuning=0




;----- Hauptwerk ----- Cembalo 4fach
[Stop214]
Name=Cembalo 4fach
DispLabelText=Cembalo      4fach
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=2
DispDrawstopRow=3
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 49, ".\\000372\\pipe\\cembalost", 36, array(250, -1), $pipeinfo);
addRank($list, 50, 5, ".\\000372\\pipe\\cembalost", 73, array(250, -1), $pipeinfo);
printList($list);
?>
Pipe001HarmonicNumber=128
Pipe002PitchTuning=100
Pipe002HarmonicNumber=128
Pipe003HarmonicNumber=128
Pipe004PitchTuning=100
Pipe004HarmonicNumber=128
Pipe005HarmonicNumber=128
Pipe006HarmonicNumber=128
Pipe007PitchTuning=100
Pipe007HarmonicNumber=128
Pipe008HarmonicNumber=128
Pipe009PitchTuning=100
Pipe009HarmonicNumber=128
Pipe010HarmonicNumber=128
Pipe011HarmonicNumber=128
Pipe012HarmonicNumber=128
Pipe013HarmonicNumber=96
Pipe014HarmonicNumber=96
Pipe015HarmonicNumber=96
Pipe016HarmonicNumber=96
Pipe017HarmonicNumber=96
Pipe018HarmonicNumber=64
Pipe019HarmonicNumber=64
Pipe020HarmonicNumber=64
Pipe021HarmonicNumber=64
Pipe022HarmonicNumber=64
Pipe023HarmonicNumber=64
Pipe024HarmonicNumber=64
Pipe025HarmonicNumber=48
Pipe026HarmonicNumber=48
Pipe027HarmonicNumber=48
Pipe028HarmonicNumber=48
Pipe029HarmonicNumber=48
Pipe030HarmonicNumber=32
Pipe031HarmonicNumber=32
Pipe032HarmonicNumber=32
Pipe033HarmonicNumber=32
Pipe034HarmonicNumber=32
Pipe035HarmonicNumber=32
Pipe036HarmonicNumber=32
Pipe037HarmonicNumber=24
Pipe038HarmonicNumber=24
Pipe039HarmonicNumber=24
Pipe040HarmonicNumber=24
Pipe041HarmonicNumber=24
Pipe042HarmonicNumber=16
Pipe043HarmonicNumber=16
Pipe044HarmonicNumber=16
Pipe045HarmonicNumber=16
Pipe046HarmonicNumber=16
Pipe047HarmonicNumber=16
Pipe048HarmonicNumber=16
Pipe049HarmonicNumber=16
;extended
Pipe050PitchTuning=0
Pipe051PitchTuning=0
Pipe052PitchTuning=0
Pipe053PitchTuning=0
Pipe054PitchTuning=0




;----- Hauptwerk ----- Dulzian 16'
[Stop215]
Name=Dulzian 16'
DispLabelText=Dulzian       16.
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=3
DispDrawstopRow=1
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
PitchTuning=0
HarmonicNumber=4
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 50, ".\\000373\\pipe\\_dulcian16", 36, array(180, 366, -1), $pipeinfo);
addRank($list, 51, 4, ".\\000373\\pipe\\_dulcian16", 74, array(180, 366, -1), $pipeinfo);
printList($list);
?>
Pipe001PitchTuning=-145
Pipe002PitchTuning=-65
Pipe003PitchTuning=45
Pipe004PitchTuning=-65
Pipe005PitchTuning=26
Pipe006PitchTuning=-65
Pipe007PitchTuning=-61
Pipe008PitchTuning=55
Pipe009PitchTuning=-55
Pipe010PitchTuning=51
Pipe011PitchTuning=-61
Pipe012PitchTuning=-73
Pipe013PitchTuning=-45
Pipe014PitchTuning=-65
Pipe015PitchTuning=-55
Pipe016PitchTuning=-65
Pipe017PitchTuning=-74
Pipe018PitchTuning=-65
Pipe019PitchTuning=-61
Pipe020PitchTuning=-45
Pipe021PitchTuning=-55
Pipe022PitchTuning=-49
Pipe023PitchTuning=-61
Pipe024PitchTuning=-73
Pipe025PitchTuning=-45
Pipe026PitchTuning=-65
Pipe027PitchTuning=-55
Pipe028PitchTuning=-65
Pipe029PitchTuning=-74
Pipe030PitchTuning=-65
Pipe031PitchTuning=-61
Pipe032PitchTuning=-45
Pipe033PitchTuning=-55
Pipe034PitchTuning=-49
Pipe035PitchTuning=-61
Pipe036PitchTuning=-73
Pipe037PitchTuning=-45
Pipe038PitchTuning=-65
Pipe039PitchTuning=-55
Pipe040PitchTuning=-65
Pipe041PitchTuning=-74
Pipe042PitchTuning=-65
Pipe043PitchTuning=-61
Pipe044PitchTuning=-45
Pipe045PitchTuning=-55
Pipe046PitchTuning=-49
Pipe047PitchTuning=-61
Pipe048PitchTuning=-73
Pipe049PitchTuning=-45
Pipe050PitchTuning=-65
;extended
Pipe051PitchTuning=1155
Pipe052PitchTuning=1135
Pipe053PitchTuning=1126
Pipe054PitchTuning=1135




;----- Hauptwerk ----- Pusaun 8'
[Stop216]
Name=Pusaun 8'
DispLabelText=Pusaun           8.
NumberOfLogicalPipes=54
NumberOfAccessiblePipes=54
FirstAccessiblePipeLogicalPipeNumber=001
FirstAccessiblePipeLogicalKeyNumber=001
WindchestGroup=003
Percussive=N
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=2
DispDrawstopRow=1
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
AmplitudeLevel=100
DispKeyLabelOnLeft=Y
PitchTuning=0
HarmonicNumber=8
<?php
$pipeinfo = array("mainnorelease"=> true, "releasecuepoint" => true);
initList($list);
addRank($list, 1, 50, ".\\000373\\pipe\\_pusaun8hw", 36, array(75, 180, 380, -1), $pipeinfo);
addRank($list, 51, 4, ".\\000373\\pipe\\_pusaun8hw", 74, array(75, 180, 380, -1), $pipeinfo);
printList($list);
?>
Pipe001PitchTuning=-145
Pipe002PitchTuning=-65
Pipe003PitchTuning=45
Pipe004PitchTuning=-65
Pipe005PitchTuning=26
Pipe006PitchTuning=-65
Pipe007PitchTuning=-61
Pipe008PitchTuning=55
Pipe009PitchTuning=-55
Pipe010PitchTuning=51
Pipe011PitchTuning=-61
Pipe012PitchTuning=-73
Pipe013PitchTuning=-45
Pipe014PitchTuning=-65
Pipe015PitchTuning=-55
Pipe016PitchTuning=-65
Pipe017PitchTuning=-74
Pipe018PitchTuning=-65
Pipe019PitchTuning=-61
Pipe020PitchTuning=-45
Pipe021PitchTuning=-55
Pipe022PitchTuning=-49
Pipe023PitchTuning=-61
Pipe024PitchTuning=-73
Pipe025PitchTuning=-45
Pipe026PitchTuning=-65
Pipe027PitchTuning=-55
Pipe028PitchTuning=-65
Pipe029PitchTuning=-74
Pipe030PitchTuning=-65
Pipe031PitchTuning=-61
Pipe032PitchTuning=-45
Pipe033PitchTuning=-55
Pipe034PitchTuning=-49
Pipe035PitchTuning=-61
Pipe036PitchTuning=-73
Pipe037PitchTuning=-45
Pipe038PitchTuning=-65
Pipe039PitchTuning=-55
Pipe040PitchTuning=-65
Pipe041PitchTuning=-74
Pipe042PitchTuning=-65
Pipe043PitchTuning=-61
Pipe044PitchTuning=-45
Pipe045PitchTuning=-55
Pipe046PitchTuning=-49
Pipe047PitchTuning=-61
Pipe048PitchTuning=-73
Pipe049PitchTuning=-45
Pipe050PitchTuning=-65
;extended
Pipe051PitchTuning=1155
Pipe052PitchTuning=1135
Pipe053PitchTuning=1126
Pipe054PitchTuning=1135


;----- Zibelstern links
[Stop217]
Name=Zimbelstern links
DispLabelText=Zimbel- stern
NumberOfRanks=1
NumberOfAccessiblePipes=1
FirstAccessiblePipeLogicalKeyNumber=001
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=3
DispDrawstopRow=2
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
DispKeyLabelOnLeft=Y
Rank001=001

[Rank001]
Name=Zibelstern links
FirstMidiNoteNumber=36
NumberOfLogicalPipes=1
AmplitudeLevel=100
WindchestGroup=003
Percussive=N
HarmonicNumber=32
Pipe001=.\000371\ruchy\cimbel\cimbell01.wav
Pipe001LoadRelease=Y



;----- Zibelstern rechts
[Stop218]
Name=Zimbelstern rechts
DispLabelText=Zimbel- stern
NumberOfRanks=1
NumberOfAccessiblePipes=1
FirstAccessiblePipeLogicalKeyNumber=001
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=4
DispDrawstopRow=2
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
DispKeyLabelOnLeft=Y
Rank001=002

[Rank002]
Name=Zibel- stern rechts
FirstMidiNoteNumber=36
NumberOfLogicalPipes=1
AmplitudeLevel=100
WindchestGroup=003
Percussive=N
HarmonicNumber=32
Pipe001=.\000371\ruchy\cimbel\cimbelr01.wav
Pipe001LoadRelease=Y



;----- Kalkantenruf
[Stop219]
Name=Calcant
DispLabelText=Calcant
NumberOfRanks=1
NumberOfAccessiblePipes=1
FirstAccessiblePipeLogicalKeyNumber=001
DefaultToEngaged=N
DisplayInInvertedState=N
DispDrawstopCol=3
DispDrawstopRow=5
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
DispKeyLabelOnLeft=Y
Rank001=003

[Rank003]
Name=Calcant
FirstMidiNoteNumber=36
NumberOfLogicalPipes=1
AmplitudeLevel=100
WindchestGroup=003
Percussive=N
HarmonicNumber=32
Pipe001=.\000371\ruchy\calcant\atk\01.wav
Pipe001LoadRelease=N
Pipe001ReleaseCount=1
Pipe001Release001=.\000371\ruchy\calcant\rel\01.wav
Pipe001Release001CuePoint=0
Pipe001Release001MaxKeyPressTime=-1



;----- Motor
[Stop220]
Name=Motor
DispLabelText=Motor
NumberOfRanks=1
NumberOfAccessiblePipes=1
FirstAccessiblePipeLogicalKeyNumber=001
DefaultToEngaged=Y
DisplayInInvertedState=N
DispDrawstopCol=1
DispDrawstopRow=1
DispLabelColour=BLACK
DispLabelFontSize=Large
Displayed=Y
DispImageNum=1
DispKeyLabelOnLeft=Y
Rank001=004

[Rank004]
Name=Motor
FirstMidiNoteNumber=36
NumberOfLogicalPipes=1
AmplitudeLevel=1000
WindchestGroup=003
Percussive=N
HarmonicNumber=8
Pipe001=.\000371\pipe\mech\mech.wav
Pipe001LoadRelease=Y




;------------------------------------------------------------------------------
;     Label section
;------------------------------------------------------------------------------

[Label001]
Name=Prague
FreeXPlacement=Y
FreeYPlacement=Y
DispXpos=400
DispYpos=30
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=1

[Label002]
Name=Baroque
FreeXPlacement=Y
FreeYPlacement=Y
DispXpos=500
DispYpos=30
DispLabelColour=BLACK
DispLabelFontSize=Large
DispImageNum=1






