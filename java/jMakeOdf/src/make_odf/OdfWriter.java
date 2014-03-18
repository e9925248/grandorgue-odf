/* Copyright (c) 2014 Lars Palo
 * Based on (partly ported from) make_odf Copyright (c) 2013 Jean-Luc Derouineau
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package make_odf;

import java.io.*;

public class OdfWriter {
	public OdfWriter(Organ org) {
		String fileName = org.name + ".organ";
		System.out.println("Writing ODF file " + fileName);
		
		try {
			PrintWriter outfile = new PrintWriter(new BufferedWriter(new FileWriter(fileName)));

			// Organ section
			System.out.println("Writing organ section.");
			outfile.println("[Organ]");
			outfile.println("ChurchName=" + org.name);
			outfile.println("ChurchAddress=?");
			outfile.println("OrganBuilder=?");
			outfile.println("OrganBuildDate=?");
			outfile.println("OrganComments=?");
			outfile.println("RecordingDetails=?");
			outfile.println("InfoFilename=?");
			if (org.hasPedals) {
				outfile.println("NumberOfManuals=" + (org.m_Manuals.size() - 1));
				outfile.println("HasPedals=Y");
			} else {
				outfile.println("NumberOfManuals=" + org.m_Manuals.size());
				outfile.println("HasPedals=N");
			}
			outfile.println("NumberOfGenerals=0");
			outfile.println("NumberOfEnclosures=" + org.m_Enclosures.size());
			outfile.println("NumberOfTremulants=" + org.m_Tremulants.size());
			outfile.println("NumberOfWindchestGroups=" + org.m_WindchestGroups.size());
			outfile.println("NumberOfReversiblePistons=0");
			outfile.println("NumberOfLabels=0");
			outfile.println("NumberOfDivisionalCouplers=0");
			outfile.println("NumberOfImages=0");
			outfile.println("NumberOfSetterElements=0");
			outfile.println("NumberOfPanels=0");
			outfile.println("NumberOfRanks=" + org.m_Ranks.size());
			outfile.println("NumberOfSwitches=" + org.m_Switches.size());
			outfile.println("DispDrawstopCols=" + org.drawstopCols);
			outfile.println("DispDrawstopRows=" + org.drawstopRows);
			outfile.println("DispDrawstopColsOffset=N");
			outfile.println("DispDrawstopOuterColOffsetUp=N");
			outfile.println("DispPairDrawstopCols=N");
			outfile.println("DispExtraDrawstopCols=" + org.extraDrawstopCols);
			outfile.println("DispExtraDrawstopRows=" + org.extraDrawstopRows);
			outfile.println("DispExtraDrawstopRowsAboveExtraButtonRows=N");
			outfile.println("DispScreenSizeHoriz=" + org.dispScreenSizeHoriz);
			outfile.println("DispScreenSizeVert=" + org.dispScreenSizeVert);
			outfile.println("DispControlLabelFont=Arial");
			outfile.println("DispShortcutKeyLabelFont=Arial");
			outfile.println("DispShortcutKeyLabelColour=Yellow");
			outfile.println("DispGroupLabelFont=Arial");
			outfile.println("DispDrawstopBackgroundImageNum=7");
			outfile.println("DispConsoleBackgroundImageNum=43");
			outfile.println("DispKeyHorizBackgroundImageNum=8");
			outfile.println("DispKeyVertBackgroundImageNum=37");
			outfile.println("DispDrawstopInsetBackgroundImageNum=5");
			outfile.println("DispExtraButtonRows=1");
			outfile.println("DispButtonCols=10");
			outfile.println("DispExtraPedalButtonRow=N");
			outfile.println("DispExtraPedalButtonRowOffset=Y");
			outfile.println("DispExtraPedalButtonRowOffsetRight=Y");
			outfile.println("DispButtonsAboveManuals=N");
			outfile.println("DispTrimAboveExtraRows=Y");
			outfile.println("DispTrimAboveManuals=Y");
			outfile.println("DispTrimBelowManuals=N");
			outfile.println("DivisionalsStoreTremulants=Y");
			outfile.println("DivisionalsStoreIntermanualCouplers=Y");
			outfile.println("DivisionalsStoreIntramanualCouplers=Y");
			outfile.println("GeneralsStoreDivisionalCouplers=Y");
			outfile.println("CombinationsStoreNonDisplayedDrawstops=Y");
			outfile.println("AmplitudeLevel=" + org.amplitudeLevel);
			outfile.println();

			// Manual section
			System.out.println("Writing manual section.");
			int adjustedIndex;
			int totalNbStops = 0;
			int totalNbCouplers = 0;
			if (org.hasPedals)
				adjustedIndex = 0;
			else
				adjustedIndex = 1;
			for (int i = 0; i < org.m_Manuals.size(); i++) {
				outfile.println("[Manual" + String.format("%03d", (i + adjustedIndex)) + "]");
				outfile.println("Name=" + org.m_Manuals.get(i).keyboardName);
				outfile.println("MIDIInputNumber=" + (adjustedIndex + i + 1));
				outfile.println("NumberOfLogicalKeys=" + org.m_Manuals.get(i).keyboardSize);
				outfile.println("NumberOfAccessibleKeys=" + org.m_Manuals.get(i).keyboardSize);
				outfile.println("FirstAccessibleKeyLogicalKeyNumber=1");
				outfile.println("FirstAccessibleKeyMIDINoteNumber=" + org.m_Manuals.get(i).keyboardFirstMidiCode);
				int nbStops = org.m_Manuals.get(i).m_Stops.size();
				outfile.println("NumberOfStops=" + nbStops);
				for (int j = 0; j < nbStops; j++) {
					totalNbStops += 1;
					outfile.println("Stop" + String.format("%03d", (j + 1)) + "=" + String.format("%03d", totalNbStops));
				}
				int nbSwitches = org.m_Manuals.get(i).m_Switches.size();
				outfile.println("NumberOfSwitches=" + nbSwitches);
				for (int j = 0; j < nbSwitches; j++) {
					outfile.println("Switch" + String.format("%03d", (j + 1)) + "=" + String.format("%03d", org.m_Manuals.get(i).m_Switches.get(j)));
				}
				int nbCouplers = org.m_Manuals.get(i).m_Couplers.size();
				outfile.println("NumberOfCouplers=" + nbCouplers);
				for (int j = 0; j < nbCouplers; j++) {
					totalNbCouplers += 1;
					outfile.println("Coupler" + String.format("%03d", (j + 1)) + "=" + String.format("%03d", totalNbCouplers));
				}
				int nbTrems = org.m_Manuals.get(i).m_Tremulants.size();
				outfile.println("NumberOfTremulants=" + nbTrems);
				for (int j = 0; j < nbTrems; j++) {
					outfile.println("Tremulant" + String.format("%03d", (j + 1)) + "=" + String.format("%03d", org.m_Manuals.get(i).m_Tremulants.get(j)));
				}
				outfile.println("NumberOfDivisionals=0");
				if (org.m_Manuals.get(i).isDisplayed) {
					outfile.println("Displayed=Y");
					outfile.println("DispKeyColourInverted=N");
				} else
					outfile.println("Displayed=N");

				outfile.println();
			}

			// Windchests section
			System.out.println("Writing windchest section.");
			for (int i = 0; i < org.m_WindchestGroups.size(); i++) {
				outfile.println("[WindchestGroup" + String.format("%03d", i + 1) + "]");
				outfile.println("Name=" + org.m_WindchestGroups.get(i).name);
				int enclosures = org.m_WindchestGroups.get(i).m_Enclosures.size();
				outfile.println("NumberOfEnclosures=" + enclosures);
				for (int j = 0; j < enclosures; j++) {
					outfile.println("Enclosure" + String.format("%03d", j + 1) + "=" + String.format("%03d", org.m_WindchestGroups.get(i).m_Enclosures.get(j)));
				}
				int tremulants = org.m_WindchestGroups.get(i).m_Tremulants.size();
				outfile.println("NumberOfTremulants=" + tremulants);
				for (int j = 0; j < tremulants; j++) {
					outfile.println("Tremulant" + String.format("%03d", j + 1) + "=" + String.format("%03d", org.m_WindchestGroups.get(i).m_Tremulants.get(j)));
				}
				outfile.println();
			}

			// Enclosures section
			System.out.println("Writing enclosure section.");
			for (int i = 0; i < org.m_Enclosures.size(); i++) {
				outfile.println("[Enclosure" + String.format("%03d", i + 1) + "]");
				outfile.println("Name=" + org.m_Enclosures.get(i).name);
				outfile.println("AmpMinimumLevel=" + org.m_Enclosures.get(i).ampMinimumLevel);
				outfile.println("MIDIInputNumber=" + (i + 1));
				if (org.m_Enclosures.get(i).displayed) {
					outfile.println("Displayed=Y");
					if (org.m_Enclosures.get(i).textBreakWidth >= 0)
						outfile.println("TextBreakWidth=" + org.m_Enclosures.get(i).textBreakWidth);
				} else {
					outfile.println("Displayed=N");
				}
				outfile.println();
			}

			// Tremulants section
			System.out.println("Writing tremulant section.");
			for (int i = 0; i < org.m_Tremulants.size(); i++) {
				outfile.println("[Tremulant" + String.format("%03d", i + 1) + "]");
				outfile.println("Name=" + org.m_Tremulants.get(i).name);
				if (org.m_Tremulants.get(i).function != Function.INPUT) {
					outfile.println("Function=" + org.m_Tremulants.get(i).function.func);
					int sw = org.m_Tremulants.get(i).m_switches.size();
					outfile.println("SwitchCount=" + sw);
					for (int j = 0; j < sw; j++) {
						outfile.println("Switch" + String.format("%03d", j + 1) + "=" + org.m_Tremulants.get(i).m_switches.get(j));
					}
				}
				if (org.m_Tremulants.get(i).tremType.equalsIgnoreCase("Synth")) {
					outfile.println("Period=" + org.m_Tremulants.get(i).period);
					outfile.println("AmpModDepth=" + org.m_Tremulants.get(i).ampModDepth);
					outfile.println("StartRate=" + org.m_Tremulants.get(i).startRate);
					outfile.println("StopRate=" + org.m_Tremulants.get(i).stopRate);
				} else {
					outfile.println("TremulantType=" + org.m_Tremulants.get(i).tremType);
				}
				if (org.m_Tremulants.get(i).displayed) {
					outfile.println("Displayed=Y");
					if (org.m_Tremulants.get(i).textBreakWidth >= 0)
						outfile.println("TextBreakWidth=" + org.m_Tremulants.get(i).textBreakWidth);
					outfile.println("DispDrawstopCol=" + org.m_Tremulants.get(i).dispDrawstopCol);
					outfile.println("DispDrawstopRow=" + org.m_Tremulants.get(i).dispDrawstopRow);
					outfile.println("DispImageNum=" + org.m_Tremulants.get(i).dispImageNum);
				} else {
					outfile.println("Displayed=N");
				}
				if (org.m_Tremulants.get(i).function == Function.INPUT) {
					if (org.m_Tremulants.get(i).defaultToEngaged)
						outfile.println("DefaultToEngaged=Y");
					else
						outfile.println("DefaultToEngaged=N");
				}
				outfile.println();
			}

			// Coupler section
			System.out.println("Writing coupler section.");
			totalNbCouplers = 0;
			for (int i = 0; i < org.m_Manuals.size(); i++) {
				int nbCouplers = org.m_Manuals.get(i).m_Couplers.size();
				for (int j = 0; j < nbCouplers; j++) {
					totalNbCouplers += 1;
					outfile.println("[Coupler" + String.format("%03d", totalNbCouplers) + "]");
					outfile.println("Name=" + org.m_Manuals.get(i).m_Couplers.get(j).name);
					if (org.m_Manuals.get(i).m_Couplers.get(j).function != Function.INPUT) {
						// The coupler has switches
						outfile.println("Function=" + org.m_Manuals.get(i).m_Couplers.get(j).function.func);
						outfile.println("SwitchCount=" + org.m_Manuals.get(i).m_Couplers.get(j).m_switches.size());
						for (int k = 0; k < org.m_Manuals.get(i).m_Couplers.get(j).m_switches.size(); k++)
							outfile.println("Switch" + String.format("%03d", (k + 1)) + "=" + org.m_Manuals.get(i).m_Couplers.get(j).m_switches.get(k));
					}
					if (org.m_Manuals.get(i).m_Couplers.get(j).m_type != CouplerType.NORMAL)
						outfile.println("CouplerType=" + org.m_Manuals.get(i).m_Couplers.get(j).m_type.type);
					outfile.println("UnisonOff=N");
					outfile.println("DestinationManual=" + String.format("%03d", translateKeyCode(org.m_Manuals.get(i).m_Couplers.get(j).destinationManualCode)));
					outfile.println("DestinationKeyshift=" + org.m_Manuals.get(i).m_Couplers.get(j).destinationKeyShift);
					outfile.println("CoupleToSubsequentUnisonIntermanualCouplers=N");
					outfile.println("CoupleToSubsequentUpwardIntermanualCouplers=N");
					outfile.println("CoupleToSubsequentDownwardIntermanualCouplers=N");
					outfile.println("CoupleToSubsequentUpwardIntramanualCouplers=N");
					outfile.println("CoupleToSubsequentDownwardIntramanualCouplers=N");
					if (org.m_Manuals.get(i).m_Couplers.get(j).displayed) {
						outfile.println("Displayed=Y");
						outfile.println("DispImageNum=" + org.m_Manuals.get(i).m_Couplers.get(j).dispImageNum);
						outfile.println("DispDrawstopCol=" + org.m_Manuals.get(i).m_Couplers.get(j).dispDrawstopCol);
						outfile.println("DispDrawstopRow=" + org.m_Manuals.get(i).m_Couplers.get(j).dispDrawstopRow);
						outfile.println("DispLabelColour=Black");
						outfile.println("DispLabelFontSize=Normal");
						if (org.m_Manuals.get(i).m_Couplers.get(j).textBreakWidth >= 0)
							outfile.println("TextBreakWidth=" + org.m_Manuals.get(i).m_Couplers.get(j).textBreakWidth);
					} else
						outfile.println("Displayed=N");
					if (org.m_Manuals.get(i).m_Couplers.get(j).function == Function.INPUT) {
						if (org.m_Manuals.get(i).m_Couplers.get(j).defaultToEngaged)
							outfile.println("DefaultToEngaged=Y");
						else
							outfile.println("DefaultToEngaged=N");
					}
					outfile.println();
				}
			}

			// Rank section
			if (!org.m_Ranks.isEmpty())
				System.out.println("Writing rank section.");
			for (int i = 0; i < org.m_Ranks.size(); i++) {
				System.out.println("Writing rank " + org.m_Ranks.get(i).name);
				outfile.println("[Rank" + String.format("%03d", (i + 1)));
				outfile.println("Name=" + org.m_Ranks.get(i).name);
				outfile.println("FirstMidiNoteNumber=" + org.m_Ranks.get(i).firstMidiNoteNumber);
				outfile.println("NumberOfLogicalPipes=" + org.m_Ranks.get(i).numberOfLogicalPipes);
				outfile.println("WindchestGroup=" + org.m_Ranks.get(i).m_windchestGroup);
				if (org.m_Ranks.get(i).isPercussive)
					outfile.println("Percussive=Y");
				else
					outfile.println("Percussive=N");
				outfile.println("AmplitudeLevel=" + org.m_Ranks.get(i).amplitudeLevel);
				outfile.println("PitchTuning=" + org.m_Ranks.get(i).pitchTuning);
				outfile.println("PitchCorrection=" + org.m_Ranks.get(i).pitchCorrection);
				outfile.println("HarmonicNumber=" + org.m_Ranks.get(i).harmonicNumber);
				for (int j = 0; j < org.m_Ranks.get(i).m_Pipes.size(); j++) {
					// First attack must always exist
					String pipeNr = "Pipe" + String.format("%03d", (j + 1));
					if (!org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(0).fileName.startsWith("REF")) {
						outfile.println(pipeNr + "=." + File.separator + org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(0).fileName);
						if (org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(0).isTremulant != -1)
							outfile.println(pipeNr + "IsTremulant=" + org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(0).isTremulant);
						if (org.m_Ranks.get(i).m_Pipes.get(j).isPercussive != org.m_Ranks.get(i).isPercussive) {
							if (org.m_Ranks.get(i).m_Pipes.get(j).isPercussive)
								outfile.println("Percussive=Y");
							else
								outfile.println("Percussive=N");
						}
						if (!org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(0).loadRelease)
							outfile.println(pipeNr + "LoadRelease=N");
						// Deal with possible additional attacks
						if (org.m_Ranks.get(i).m_Pipes.get(j).attacks.size() > 1) {
							outfile.println(pipeNr + "AttackCount=" + (org.m_Ranks.get(i).m_Pipes.get(j).attacks.size() - 1));
							for (int k = 1; k < org.m_Ranks.get(i).m_Pipes.get(j).attacks.size(); k++) {
								outfile.println(pipeNr + "Attack" + String.format("%03d", k) +"=." + File.separator + org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(k).fileName);
								if (org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(k).isTremulant != -1)
									outfile.println(pipeNr + "Attack" + String.format("%03d", k) +"IsTremulant=" + org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(k).isTremulant);
								if (!org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(k).loadRelease)
									outfile.println(pipeNr + "Attack" + String.format("%03d", k) + "LoadRelease=N");
							}
						}
						// Deal with possible additional releases
						if (!org.m_Ranks.get(i).m_Pipes.get(j).releases.isEmpty()) {
							outfile.println(pipeNr + "ReleaseCount=" + org.m_Ranks.get(i).m_Pipes.get(j).releases.size());
							for (int k = 0; k < org.m_Ranks.get(i).m_Pipes.get(j).releases.size(); k++) {
								outfile.println(pipeNr + "Release" + String.format("%03d", (k + 1)) +"=." + File.separator + org.m_Ranks.get(i).m_Pipes.get(j).releases.get(k).fileName);
								outfile.println(pipeNr + "Release" + String.format("%03d", (k + 1)) +"MaxKeyPressTime=" + org.m_Ranks.get(i).m_Pipes.get(j).releases.get(k).maxKeyPressTime);
								if (org.m_Ranks.get(i).m_Pipes.get(j).releases.get(k).isTremulant != -1)
									outfile.println(pipeNr + "Release" + String.format("%03d", (k + 1)) +"IsTremulant=" + org.m_Ranks.get(i).m_Pipes.get(j).releases.get(k).isTremulant);
							}
						}
					} else {
						outfile.println(pipeNr + "=" + org.m_Ranks.get(i).m_Pipes.get(j).attacks.get(0).fileName);
					}
				}
				outfile.println();
			}

			// Stop section
			totalNbStops = 0;
			System.out.println("Writing stop section.");
			for (int i = 0; i < org.m_Manuals.size(); i++) {
				for (int j = 0; j < org.m_Manuals.get(i).m_Stops.size(); j++) {
					totalNbStops += 1;
					System.out.println("Writing stop " + org.m_Manuals.get(i).m_Stops.get(j).name);
					outfile.println("[Stop" + String.format("%03d", totalNbStops) + "]");
					outfile.println("Name=" + org.m_Manuals.get(i).m_Stops.get(j).name);
					if (org.m_Manuals.get(i).m_Stops.get(j).function != Function.INPUT) {
						// This stop has switches
						outfile.println("Function=" + org.m_Manuals.get(i).m_Stops.get(j).function.func);
						outfile.println("SwitchCount=" + org.m_Manuals.get(i).m_Stops.get(j).m_switches.size());
						for (int k = 0; k < org.m_Manuals.get(i).m_Stops.get(j).m_switches.size(); k++)
							outfile.println("Switch" + String.format("%03d", (k + 1)) + "=" + org.m_Manuals.get(i).m_Stops.get(j).m_switches.get(k));
					}
					if (!org.m_Manuals.get(i).m_Stops.get(j).m_Ranks.isEmpty()) {
						// This stop has ranks
						outfile.println("NumberOfRanks=" + org.m_Manuals.get(i).m_Stops.get(j).m_Ranks.size());
						for (int k = 0; k < org.m_Manuals.get(i).m_Stops.get(j).m_Ranks.size(); k++)
							outfile.println("Rank" + String.format("%03d", (k + 1)) + "=" + org.m_Manuals.get(i).m_Stops.get(j).m_Ranks.get(k));

						outfile.println("NumberOfAccessiblePipes=" + org.m_Manuals.get(i).m_Stops.get(j).numberOfAccessiblePipes);
						outfile.println("FirstAccessiblePipeLogicalKeyNumber=" + org.m_Manuals.get(i).m_Stops.get(j).firstAccessiblePipeLogicalKeyNumber);
					} else {
						outfile.println("NumberOfLogicalPipes=" + org.m_Manuals.get(i).m_Stops.get(j).numberOfAccessiblePipes);
						outfile.println("NumberOfAccessiblePipes=" + org.m_Manuals.get(i).m_Stops.get(j).numberOfAccessiblePipes);
						outfile.println("FirstAccessiblePipeLogicalPipeNumber=" + org.m_Manuals.get(i).m_Stops.get(j).firstAccessiblePipeLogicalPipeNumber);
						outfile.println("FirstAccessiblePipeLogicalKeyNumber=" + org.m_Manuals.get(i).m_Stops.get(j).firstAccessiblePipeLogicalKeyNumber);
						outfile.println("WindchestGroup=" + org.m_Manuals.get(i).m_Stops.get(j).m_windchestGroup);
						if (org.m_Manuals.get(i).m_Stops.get(j).isPercussive)
							outfile.println("Percussive=Y");
						else
							outfile.println("Percussive=N");
						outfile.println("AmplitudeLevel=" + org.m_Manuals.get(i).m_Stops.get(j).amplitudeLevel);
						outfile.println("PitchTuning=" + org.m_Manuals.get(i).m_Stops.get(j).pitchTuning);
						outfile.println("PitchCorrection=" + org.m_Manuals.get(i).m_Stops.get(j).pitchCorrection);
						outfile.println("HarmonicNumber=" + org.m_Manuals.get(i).m_Stops.get(j).harmonicNumber);
					}
					if (org.m_Manuals.get(i).m_Stops.get(j).function == Function.INPUT) {
						if (org.m_Manuals.get(i).m_Stops.get(j).defaultToEngaged)
							outfile.println("DefaultToEngaged=Y");
						else
							outfile.println("DefaultToEngaged=N");
					}
					if (org.m_Manuals.get(i).m_Stops.get(j).displayed) {
						outfile.println("Displayed=Y");
						outfile.println("DispImageNum=" + org.m_Manuals.get(i).m_Stops.get(j).dispImageNum);
						outfile.println("DispDrawstopCol=" + org.m_Manuals.get(i).m_Stops.get(j).dispDrawstopCol);
						outfile.println("DispDrawstopRow=" + org.m_Manuals.get(i).m_Stops.get(j).dispDrawstopRow);
						outfile.println("DispLabelColour=Black");
						outfile.println("DispLabelFontSize=Normal");
						outfile.println("DisplayInInvertedState=N");
						if (org.m_Manuals.get(i).m_Stops.get(j).textBreakWidth >= 0)
							outfile.println("TextBreakWidth=" + org.m_Manuals.get(i).m_Stops.get(j).textBreakWidth);
					} else {
						outfile.println("Displayed=N");
					}
					if (org.m_Manuals.get(i).m_Stops.get(j).m_Ranks.isEmpty()) {
						// This stop has pipes
						for (int k = 0; k < org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.size(); k++) {
							// First attack must always exist
							String pipeNr = "Pipe" + String.format("%03d", (k + 1));
							if (!org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(0).fileName.startsWith("REF")) {
								outfile.println(pipeNr + "=." + File.separator + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(0).fileName);
								if (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(0).isTremulant != -1)
									outfile.println(pipeNr + "IsTremulant=" + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(0).isTremulant);
								if (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).pitchTuning != 0)
									outfile.println(pipeNr + "PitchTuning=" + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).pitchTuning);
								if (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).isPercussive != org.m_Manuals.get(i).m_Stops.get(j).isPercussive) {
									if (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).isPercussive)
										outfile.println("Percussive=Y");
									else
										outfile.println("Percussive=N");
								}
								if (!org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(0).loadRelease)
									outfile.println(pipeNr + "LoadRelease=N");
								// Deal with possible additional attacks
								if (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.size() > 1) {
									outfile.println(pipeNr + "AttackCount=" + (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.size() - 1));
									for (int l = 1; l < org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.size(); l++) {
										outfile.println(pipeNr + "Attack" + String.format("%03d", l) +"=." + File.separator + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(l).fileName);
										if (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(l).isTremulant != -1)
											outfile.println(pipeNr + "Attack" + String.format("%03d", l)  + "IsTremulant=" + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(l).isTremulant);
										if (!org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(l).loadRelease)
											outfile.println(pipeNr + "Attack" + String.format("%03d", l)  + "LoadRelease=N");
									}
								}
								// Deal with possible additional releases
								if (!org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).releases.isEmpty()) {
									outfile.println(pipeNr + "ReleaseCount=" + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).releases.size());
									for (int l = 0; l < org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).releases.size(); l++) {
										outfile.println(pipeNr + "Release" + String.format("%03d", (l + 1)) +"=." + File.separator + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).releases.get(l).fileName);
										outfile.println(pipeNr + "Release" + String.format("%03d", (l + 1)) +"MaxKeyPressTime=" + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).releases.get(l).maxKeyPressTime);
										if (org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).releases.get(l).isTremulant != -1)
											outfile.println(pipeNr + "Release" + String.format("%03d", (l + 1)) +"IsTremulant=" + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).releases.get(l).isTremulant);
									}
								}
							} else {
								outfile.println(pipeNr + "=" + org.m_Manuals.get(i).m_Stops.get(j).m_Pipes.get(k).attacks.get(0).fileName);
							}
						}
					}
					outfile.println();
				}
			}

			// Switch section
			if (!org.m_Switches.isEmpty())
				System.out.println("Writing switch section");
			for (int i = 0; i < org.m_Switches.size(); i++) {
				outfile.println("[Switch" + String.format("%03d", (i + 1)) + "]");
				outfile.println("Name=" + org.m_Switches.get(i).name);
				if (org.m_Switches.get(i).function != Function.INPUT) {
					// The switch has switches
					outfile.println("Function=" + org.m_Switches.get(i).function.func);
					for (int j = 0; j < org.m_Switches.get(i).m_switches.size(); j++)
						outfile.println("Switch" + String.format("%03d", (j + 1)) + "=" + org.m_Switches.get(i).m_switches.get(j));
				}
				if (org.m_Switches.get(i).defaultToEngaged)
					outfile.println("DefaultToEngaged=Y");
				else
					outfile.println("DefaultToEngaged=N");
				if (org.m_Switches.get(i).displayed) {
					outfile.println("Displayed=Y");
					outfile.println("DispImageNum=" + org.m_Switches.get(i).dispImageNum);
					outfile.println("DispDrawstopCol=" + org.m_Switches.get(i).dispDrawstopCol);
					outfile.println("DispDrawstopRow=" + org.m_Switches.get(i).dispDrawstopRow);
					outfile.println("DispLabelColour=Black");
					outfile.println("DispLabelFontSize=Normal");
					outfile.println("DisplayInInvertedState=N");
					if (org.m_Switches.get(i).textBreakWidth >= 0)
						outfile.println("TextBreakWidth=" + org.m_Switches.get(i).textBreakWidth);
				} else {
					outfile.println("Displayed=N");
				}

				outfile.println();
			}
			System.out.println("Done writing ODF file!");
			outfile.close();
		}
		catch (IOException ie) {
			System.out.println("ERROR: Couldn't write ODF file!");
			System.exit(1);
		}
	}
	
	private int translateKeyCode(String keybCode) {
		if (keybCode.equalsIgnoreCase("PED"))
			return 0;
		else {
			int nr = 0;
			int prevNr = 0;
			String str = keybCode.toUpperCase();
			for (int i = str.length() - 1; i >= 0; i--) {
				switch (str.charAt(i)) {
				case 'X':
					nr = CalculateRomans(10, prevNr, nr);
					prevNr = 10;
					break;
				case 'V':
					nr = CalculateRomans(5, prevNr, nr);
					prevNr = 5;
					break;
				case 'I':
					nr = CalculateRomans(1, prevNr, nr);
					prevNr = 1;
					break;
				}
			}
			return nr;
		}
	}

	private int CalculateRomans(int i, int prevNr, int nr) {
		if (prevNr > i) {
			return nr - i;
		} else {
			return nr + i;
		}
	}
}
