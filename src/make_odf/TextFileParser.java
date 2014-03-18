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

import java.util.*;
import java.io.*;

public class TextFileParser {
	boolean loadOneSamplePerPipe;
	ArrayList<String> stringParts = new ArrayList<String>();
	
	public TextFileParser(File f, Organ org) {		
		try {
			Scanner sc = new Scanner(f);
			
			org.name = getLine(sc);
			org.amplitudeLevel = convertToFloat(getLine(sc));
			org.pitchTuning = convertToFloat(getLine(sc));
			org.dispScreenSizeHoriz = getLine(sc);
			org.dispScreenSizeVert = getLine(sc);
			org.drawstopCols = convertToInt(getLine(sc));
			org.drawstopRows = convertToInt(getLine(sc));
			org.extraDrawstopRows = convertToInt(getLine(sc));
			org.extraDrawstopCols = convertToInt(getLine(sc));
			
			String textLine = getLine(sc);
			if (textLine.equalsIgnoreCase("yes"))
				loadOneSamplePerPipe = true;
			else
				loadOneSamplePerPipe = false;
			
			textLine = getLine(sc);
			int nbSwitches = convertToInt(textLine);
			for (int i = 0; i < nbSwitches; i++) {
				Switch sw = new Switch();
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				sw.name = stringParts.get(0);
				if (stringParts.get(1).equalsIgnoreCase("yes"))
					sw.defaultToEngaged = true;
				else
					sw.defaultToEngaged = false;
				if (stringParts.get(2).equalsIgnoreCase("yes")) {
					sw.displayed = true;
					sw.dispImageNum = convertToInt(stringParts.get(3));
					sw.dispDrawstopCol = convertToInt(stringParts.get(4));
					sw.dispDrawstopRow = convertToInt(stringParts.get(5));
					sw.textBreakWidth = convertToInt(stringParts.get(6));
				} else {
					sw.displayed = false;
				}
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				sw.function = Enum.valueOf(Function.class, stringParts.get(0).toUpperCase());
				int nbOfSw = convertToInt(stringParts.get(1));
				for (int j = 0; j < nbOfSw; j++) {
					sw.m_switches.add(convertToInt(stringParts.get(2 + j)));
				}
				org.m_Switches.add(sw);
			}
			
			textLine = getLine(sc);
			int nbEnclosures = convertToInt(textLine);
			for (int i = 0; i < nbEnclosures; i++) {
				Enclosure enc = new Enclosure();
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				enc.name = stringParts.get(0);
				enc.ampMinimumLevel = convertToInt(stringParts.get(1));
				if (stringParts.get(2).equalsIgnoreCase("yes")) {
					enc.displayed = true;
				} else {
					enc.displayed = false;
				}
				enc.textBreakWidth = convertToInt(stringParts.get(3));
				
				org.m_Enclosures.add(enc);
			}
			
			textLine = getLine(sc);
			int nbTremulants = convertToInt(textLine);
			for (int i = 0; i < nbTremulants; i++) {
				Tremulant trem = new Tremulant();
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				trem.name = stringParts.get(0);
				if (stringParts.get(1).equalsIgnoreCase("Synth")) {
					trem.tremType = stringParts.get(1);
					trem.period = convertToInt(stringParts.get(2));
					trem.ampModDepth = convertToInt(stringParts.get(3));
					trem.startRate = convertToInt(stringParts.get(4));
					trem.stopRate = convertToInt(stringParts.get(5));
					if (stringParts.get(6).equalsIgnoreCase("yes"))
						trem.defaultToEngaged = true;
					else
						trem.defaultToEngaged = false;

					if (stringParts.get(7).equalsIgnoreCase("yes")) {
						trem.displayed = true;
						trem.dispImageNum = convertToInt(stringParts.get(8));
						trem.dispDrawstopCol = convertToInt(stringParts.get(9));
						trem.dispDrawstopRow = convertToInt(stringParts.get(10));
						trem.textBreakWidth = convertToInt(stringParts.get(11));
					} else {
						trem.displayed = false;
					}
				} else if (stringParts.get(1).equalsIgnoreCase("Wave")) {
					trem.tremType = stringParts.get(1);
					if (stringParts.get(2).equalsIgnoreCase("yes"))
						trem.defaultToEngaged = true;
					else
						trem.defaultToEngaged = false;

					if (stringParts.get(3).equalsIgnoreCase("yes")) {
						trem.displayed = true;
						trem.dispImageNum = convertToInt(stringParts.get(4));
						trem.dispDrawstopCol = convertToInt(stringParts.get(5));
						trem.dispDrawstopRow = convertToInt(stringParts.get(6));
						trem.textBreakWidth = convertToInt(stringParts.get(7));
					} else {
						trem.displayed = false;
					}
				} else {
					System.out.println("ERROR: Tremulant type " + stringParts.get(1) + " is not valid!");
					System.exit(1);
				}
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				trem.function = Enum.valueOf(Function.class, stringParts.get(0).toUpperCase());
				int nbOfSw = convertToInt(stringParts.get(1));
				for (int j = 0; j < nbOfSw; j++) {
					trem.m_switches.add(convertToInt(stringParts.get(2 + j)));
				}
				
				org.m_Tremulants.add(trem);
			}
			
			textLine = getLine(sc);
			int nbWindchests = convertToInt(textLine);
			for (int i = 0; i < nbWindchests; i++) {
				WindchestGroup wc = new WindchestGroup();
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				wc.name = stringParts.get(0);
				int enclosures = convertToInt(stringParts.get(1));
				if (enclosures > 0) {
					int lastIndex = 0;
					for (int j = 0; j < enclosures; j++) {
						int enclosureRef = convertToInt(stringParts.get(j + 2));
						wc.m_Enclosures.add(enclosureRef);
						lastIndex = j + 2;
					}
					int tremulants = convertToInt(stringParts.get(lastIndex));
					for (int j = 0; j < tremulants; j++) {
						int tremulantRef = convertToInt(stringParts.get(lastIndex + 1 + j));
						wc.m_Tremulants.add(tremulantRef);
					}
				} else {
					int tremulants = convertToInt(stringParts.get(2));
					for (int j = 0; j < tremulants; j++) {
						int tremulantRef = convertToInt(stringParts.get(j + 3));
						wc.m_Tremulants.add(tremulantRef);
					}
				}
				org.m_WindchestGroups.add(wc);
			}
			
			textLine = getLine(sc);
			int keybNumber = convertToInt(textLine);
			for (int i = 0; i < keybNumber; i++) {
				Manual m = new Manual();
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				m.keyboardName = stringParts.get(0);
				m.keyboardCode = stringParts.get(1);
				m.keyboardSize = convertToInt(stringParts.get(2));
				m.keyboardFirstMidiCode = convertToInt(stringParts.get(3));
				if (stringParts.get(4).equalsIgnoreCase("yes"))
					m.isDisplayed = true;
				else
					m.isDisplayed = false;
				
				textLine = getLine(sc);
				int nbCouplers = convertToInt(textLine);
				for (int j = 0; j < nbCouplers; j++) {
					textLine = getLine(sc);
					getParts(textLine, stringParts);
					Coupler cp = new Coupler();
					cp.name = stringParts.get(0);
					String couplerString = stringParts.get(1);
					switch(couplerString.charAt(0)) {
					case 'N':
						cp.m_type = CouplerType.NORMAL;
						break;
					case 'M':
						cp.m_type = CouplerType.MELODY;
						break;
					case 'B':
						cp.m_type = CouplerType.BASS;
						break;
					default:
						System.out.println("ERROR: Coupler type for " + cp.name + " is not recognized!");
						System.exit(1);
						break;
					}
					couplerString = stringParts.get(2);
					switch (couplerString.charAt(0)) {
					case '=':
						cp.destinationKeyShift = 0;
						break;
					case '+':
						cp.destinationKeyShift = 12;
						break;
					case '-':
						cp.destinationKeyShift = -12;
						break;
					default:
						System.out.println("ERROR: Destination keyshift " + cp.name + " is not recognized!");
						System.exit(1);
						break;
					}
					cp.destinationManualCode = stringParts.get(3);
					if (stringParts.get(4).equalsIgnoreCase("yes"))
						cp.defaultToEngaged = true;
					else
						cp.defaultToEngaged = false;
					if (stringParts.get(5).equalsIgnoreCase("yes")) {
						cp.displayed = true;
						cp.dispImageNum = convertToInt(stringParts.get(6));
						cp.dispDrawstopCol = convertToInt(stringParts.get(7));
						cp.dispDrawstopRow = convertToInt(stringParts.get(8));
						cp.textBreakWidth = convertToInt(stringParts.get(9));
					} else {
						cp.displayed = false;
					}
					textLine = getLine(sc);
					getParts(textLine, stringParts);
					cp.function = Enum.valueOf(Function.class, stringParts.get(0).toUpperCase());
					int nbOfSw = convertToInt(stringParts.get(1));
					for (int k = 0; k < nbOfSw; k++) {
						cp.m_switches.add(convertToInt(stringParts.get(2 + k)));
					}
					
					m.m_Couplers.add(cp);
				}
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				int nbTrems = convertToInt(stringParts.get(0));
				for (int j = 0; j < nbTrems; j++) {
					m.m_Tremulants.add(convertToInt(stringParts.get(1 + j)));
				}
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				int nbSw = convertToInt(stringParts.get(0));
				for (int j = 0; j < nbSw; j++) {
					m.m_Switches.add(convertToInt(stringParts.get(1 + j)));
				}
				
				textLine = getLine(sc);
				int nbStops = convertToInt(textLine);
				for (int j = 0; j < nbStops; j++) {
					Stop s = new Stop();
					
					textLine = getLine(sc);
					getParts(textLine, stringParts);
					s.name = stringParts.get(0);
					s.numberOfAccessiblePipes = convertToInt(stringParts.get(1));
					s.firstAccessiblePipeLogicalKeyNumber = convertToInt(stringParts.get(2));
					s.amplitudeLevel = convertToFloat(stringParts.get(3));
					s.harmonicNumber = convertToInt(stringParts.get(4));
					s.pitchTuning = convertToFloat(stringParts.get(5));
					s.pitchCorrection = convertToFloat(stringParts.get(6));
					s.m_windchestGroup = convertToInt(stringParts.get(7));
					if (stringParts.get(8).equalsIgnoreCase("yes"))
						s.isPercussive = true;
					else
						s.isPercussive = false;
					if (stringParts.get(9).equalsIgnoreCase("yes"))
						s.defaultToEngaged = true;
					else
						s.defaultToEngaged = false;
					if (stringParts.get(10).equalsIgnoreCase("yes")) {
						s.displayed = true;
						s.dispImageNum = convertToInt(stringParts.get(11));
						s.dispDrawstopCol = convertToInt(stringParts.get(12));
						s.dispDrawstopRow = convertToInt(stringParts.get(13));
						s.textBreakWidth = convertToInt(stringParts.get(14));
					} else {
						s.displayed = false;
					}
					
					int pipesLoaded = 0;
					System.out.println("Trying to read pipes for stop " + s.name);
					while (pipesLoaded < s.numberOfAccessiblePipes) {
						textLine = getLine(sc);
						getParts(textLine, stringParts);
						
						int nbPipesToLoad = convertToInt(stringParts.get(0));
						if (nbPipesToLoad > 0) {
							// The stop have it's own pipes to load
							String loadString = stringParts.get(1);
							switch (loadString.charAt(0)) {
							case 'L':
								String pathToSearch = stringParts.get(2);
								String loadAttRel = stringParts.get(3);
								boolean pipePercussive = stringParts.get(4).equalsIgnoreCase("yes");
								int startMidiNote = convertToInt(loadString.substring(1, loadString.length()));
								for (int k = 0; k < nbPipesToLoad; k++) {
									Pipe p = loadSamples(startMidiNote + k, loadString, pathToSearch, loadAttRel, pipePercussive);
									p.amplitudeLevel = s.amplitudeLevel;
									p.harmonicNumber = s.harmonicNumber;
									p.pitchTuning = s.pitchTuning;
									p.pitchCorrection = s.pitchCorrection;
									p.windchestGroup = s.m_windchestGroup;
									s.m_Pipes.add(p);
								}
								break;
							case 'R':
								int startPipe = convertToInt(loadString.substring(1, loadString.length()));
								String keybCode = stringParts.get(2);
								int stop = convertToInt(stringParts.get(3));
								for (int k = 0; k < nbPipesToLoad; k++) {
									Pipe p = new Pipe();
									p = createReference(startPipe + k, keybCode, stop);
									p.isPercussive = s.isPercussive;
									p.amplitudeLevel = s.amplitudeLevel;
									p.harmonicNumber = s.harmonicNumber;
									p.pitchTuning = s.pitchTuning;
									p.pitchCorrection = s.pitchCorrection;
									p.windchestGroup = s.m_windchestGroup;
									s.m_Pipes.add(p);
								}
								break;
							case 'C':
								int startCopy = convertToInt(loadString.substring(1, loadString.length())) - 1;
								float pitchChange = convertToFloat(stringParts.get(2));
								for (int k = 0; k < nbPipesToLoad; k++) {
									Pipe p = new Pipe();
									p.pitchTuning = pitchChange;
									p.isPercussive = s.m_Pipes.get(startCopy + k).isPercussive;
									p.amplitudeLevel = s.m_Pipes.get(startCopy + k).amplitudeLevel;
									p.harmonicNumber = s.m_Pipes.get(startCopy + k).harmonicNumber;
									p.pitchCorrection = s.m_Pipes.get(startCopy + k).pitchCorrection;
									p.windchestGroup = s.m_Pipes.get(startCopy + k).windchestGroup;
									p.isTremulant = s.m_Pipes.get(startCopy + k).isTremulant;
									for (int l = 0; l < s.m_Pipes.get(startCopy + k).attacks.size(); l++) {
										Attack a = new Attack();
										a.fileName = s.m_Pipes.get(startCopy + k).attacks.get(l).fileName;
										a.loadRelease = s.m_Pipes.get(startCopy + k).attacks.get(l).loadRelease;
										a.attackVelocity = s.m_Pipes.get(startCopy + k).attacks.get(l).attackVelocity;
										a.maxKeyPressTime = s.m_Pipes.get(startCopy + k).attacks.get(l).maxKeyPressTime;
										a.isTremulant = s.m_Pipes.get(startCopy + k).attacks.get(l).isTremulant;
										p.attacks.add(a);
									}
									for (int l = 0; l < s.m_Pipes.get(startCopy + k).releases.size(); l++) {
										Release r = new Release();
										r.fileName = s.m_Pipes.get(startCopy + k).releases.get(l).fileName;
										r.maxKeyPressTime = s.m_Pipes.get(startCopy + k).releases.get(l).maxKeyPressTime;
										r.isTremulant = s.m_Pipes.get(startCopy + k).releases.get(l).isTremulant;
										p.releases.add(r);
									}
									s.m_Pipes.add(p);
								}
								break;
							case 'M':
								int nextIndex = 2;
								for (int k = 0; k < nbPipesToLoad; k++) {
									Pipe p = new Pipe();
									Attack a = new Attack();
									a.fileName = stringParts.get(nextIndex);
									nextIndex++;
									if (stringParts.get(nextIndex).equalsIgnoreCase("no")) {
										a.loadRelease = false;
										a.attackVelocity = 0;
										a.maxKeyPressTime = -1;
										nextIndex++;
										p.attacks.add(a);
										Release r = new Release();
										r.fileName = stringParts.get(nextIndex);
										nextIndex++;
										p.releases.add(r);
									} else {
										a.loadRelease = true;
										a.attackVelocity = 0;
										a.maxKeyPressTime = -1;
										nextIndex++;
										p.attacks.add(a);
									}
									p.isPercussive = s.isPercussive;
									p.amplitudeLevel = s.amplitudeLevel;
									p.harmonicNumber = s.harmonicNumber;
									p.pitchTuning = s.pitchTuning;
									p.pitchCorrection = s.pitchCorrection;
									p.windchestGroup = s.m_windchestGroup;
									s.m_Pipes.add(p);
								}
								break;
							default:
								System.out.println("ERROR: Load method " + loadString + " for stop " + s.name + " is invalid!");
								System.exit(1);
							}
							pipesLoaded += nbPipesToLoad;
						} else {
							// The stops have ranks instead
							int nbOfRanks = convertToInt(stringParts.get(1));
							for (int k = 0; k < nbOfRanks; k++) {
								s.m_Ranks.add(convertToInt(stringParts.get(1 + k)));
							}
							pipesLoaded = s.numberOfAccessiblePipes;
						}
					}
					
					textLine = getLine(sc);
					getParts(textLine, stringParts);
					s.function = Enum.valueOf(Function.class, stringParts.get(0).toUpperCase());
					int nbOfSw = convertToInt(stringParts.get(1));
					for (int k = 0; k < nbOfSw; k++) {
						s.m_switches.add(convertToInt(stringParts.get(2 + k)));
					}
					
					m.m_Stops.add(s);
				}
				
				org.m_Manuals.add(m);
			}
			// Make sure manuals are sorted according to keyboard code
			Collections.sort(org.m_Manuals);
			
			textLine = getLine(sc);
			int nbRanks = convertToInt(textLine);
			for (int i = 0; i < nbRanks; i++) {
				Rank rk = new Rank();
				
				textLine = getLine(sc);
				getParts(textLine, stringParts);
				rk.name = stringParts.get(0);
				int nbPipes = convertToInt(stringParts.get(1));
				rk.numberOfLogicalPipes = nbPipes;
				rk.firstMidiNoteNumber = convertToInt(stringParts.get(2));
				rk.amplitudeLevel = convertToFloat(stringParts.get(3));
				rk.harmonicNumber = convertToInt(stringParts.get(4));
				rk.pitchTuning = convertToFloat(stringParts.get(5));
				rk.pitchCorrection = convertToFloat(stringParts.get(6));
				rk.m_windchestGroup = convertToInt(stringParts.get(7));
				if (stringParts.get(8).equalsIgnoreCase("yes"))
					rk.isPercussive = true;
				else
					rk.isPercussive = false;
				System.out.println("Trying to read pipes for rank " + rk.name);
				int processedPipes = 0;
				while (processedPipes < nbPipes) {
					textLine = getLine(sc);
					getParts(textLine, stringParts);
					int pipesThisLine = convertToInt(stringParts.get(0));
					String loadString = stringParts.get(1);
					switch (loadString.charAt(0)) {
					case 'L':
						String pathToSearch = stringParts.get(2);
						String loadAttRel = stringParts.get(3);
						boolean pipePercussive = stringParts.get(4).equalsIgnoreCase("yes");
						int startMidiNote = convertToInt(loadString.substring(1, loadString.length()));
						for (int j = 0; j < pipesThisLine; j++) {
							Pipe p = loadSamples(startMidiNote + j, loadString, pathToSearch, loadAttRel, pipePercussive);
							p.amplitudeLevel = rk.amplitudeLevel;
							p.harmonicNumber = rk.harmonicNumber;
							p.pitchTuning = rk.pitchTuning;
							p.pitchCorrection = rk.pitchCorrection;
							p.windchestGroup = rk.m_windchestGroup;
							rk.m_Pipes.add(p);
						}
						break;
					case 'R':
						int startPipe = convertToInt(loadString.substring(1, loadString.length()));
						String keybCode = stringParts.get(2);
						int stop = convertToInt(stringParts.get(3));
						for (int j = 0; j < pipesThisLine; j++) {
							Pipe p = new Pipe();
							p = createReference(startPipe + j, keybCode, stop);
							p.isPercussive = rk.isPercussive;
							p.amplitudeLevel = rk.amplitudeLevel;
							p.harmonicNumber = rk.harmonicNumber;
							p.pitchTuning = rk.pitchTuning;
							p.pitchCorrection = rk.pitchCorrection;
							p.windchestGroup = rk.m_windchestGroup;
							rk.m_Pipes.add(p);
						}
						break;
					case 'C':
						int startCopy = convertToInt(loadString.substring(1, loadString.length())) - 1;
						float pitchChange = convertToFloat(stringParts.get(2));
						for (int j = 0; j < pipesThisLine; j++) {
							Pipe p = new Pipe();
							p.pitchTuning = pitchChange;
							p.isPercussive = rk.m_Pipes.get(startCopy + j).isPercussive;
							p.amplitudeLevel = rk.m_Pipes.get(startCopy + j).amplitudeLevel;
							p.harmonicNumber = rk.m_Pipes.get(startCopy + j).harmonicNumber;
							p.pitchCorrection = rk.m_Pipes.get(startCopy + j).pitchCorrection;
							p.windchestGroup = rk.m_Pipes.get(startCopy + j).windchestGroup;
							p.isTremulant = rk.m_Pipes.get(startCopy + j).isTremulant;
							for (int k = 0; k < rk.m_Pipes.get(startCopy + j).attacks.size(); k++) {
								Attack a = new Attack();
								a.fileName = rk.m_Pipes.get(startCopy + j).attacks.get(k).fileName;
								a.loadRelease = rk.m_Pipes.get(startCopy + j).attacks.get(k).loadRelease;
								a.attackVelocity = rk.m_Pipes.get(startCopy + j).attacks.get(k).attackVelocity;
								a.maxKeyPressTime = rk.m_Pipes.get(startCopy + j).attacks.get(k).maxKeyPressTime;
								a.isTremulant = rk.m_Pipes.get(startCopy + j).attacks.get(k).isTremulant;
								p.attacks.add(a);
							}
							for (int k = 0; k < rk.m_Pipes.get(startCopy + j).releases.size(); k++) {
								Release r = new Release();
								r.fileName = rk.m_Pipes.get(startCopy + j).releases.get(k).fileName;
								r.maxKeyPressTime = rk.m_Pipes.get(startCopy + j).releases.get(k).maxKeyPressTime;
								r.isTremulant = rk.m_Pipes.get(startCopy + j).releases.get(k).isTremulant;
								p.releases.add(r);
							}
							rk.m_Pipes.add(p);
						}
						break;
					case 'M':
						int nextIndex = 2;
						for (int k = 0; k < pipesThisLine; k++) {
							Pipe p = new Pipe();
							Attack a = new Attack();
							a.fileName = stringParts.get(nextIndex);
							nextIndex++;
							if (stringParts.get(nextIndex).equalsIgnoreCase("no")) {
								a.loadRelease = false;
								a.attackVelocity = 0;
								a.maxKeyPressTime = -1;
								nextIndex++;
								p.attacks.add(a);
								Release r = new Release();
								r.fileName = stringParts.get(nextIndex);
								nextIndex++;
								p.releases.add(r);
							} else {
								a.loadRelease = true;
								a.attackVelocity = 0;
								a.maxKeyPressTime = -1;
								nextIndex++;
								p.attacks.add(a);
							}
							p.isPercussive = rk.isPercussive;
							p.amplitudeLevel = rk.amplitudeLevel;
							p.harmonicNumber = rk.harmonicNumber;
							p.pitchTuning = rk.pitchTuning;
							p.pitchCorrection = rk.pitchCorrection;
							p.windchestGroup = rk.m_windchestGroup;
							rk.m_Pipes.add(p);
						}
						break;
					default:
						System.out.println("ERROR: Load method " + loadString + " for stop " + rk.name + " is invalid!");
						System.exit(1);
					}
					processedPipes += pipesThisLine;
				}
			}
			
		}
		catch (FileNotFoundException fe) {
			System.out.println("ERROR: Couldn't read anything from file!");
			System.exit(1);
		}
	}
	
	private Pipe createReference(int targetPipe, String keybCode, int stop) {
		Pipe p = new Pipe();
		Attack a = new Attack();
		int manual = translateKeyCode(keybCode);
		String refStr = String.format("REF:%03d:%03d:%03d", manual, stop, targetPipe);
		a.fileName = refStr;
		a.loadRelease = true;
		a.attackVelocity = 0;
		a.maxKeyPressTime = -1;
		p.attacks.add(a);
		return p;
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

	private Pipe loadSamples(int midiNr, String loadtype, String path, String loadAttRel, boolean percussive) {
		Pipe p = new Pipe();
		File f1 = new File(path);
		
		TremulantFolderFilter tremFilter = new TremulantFolderFilter();
		String[] tremFolders = f1.list(tremFilter);
		Arrays.sort(tremFolders);
		boolean hasTremSamples;
		if (tremFolders.length > 0) {
			hasTremSamples = true;
			p.isTremulant = 0;
		} else {
			hasTremSamples = false;
		}
		
		MIDINrSampleFilter nrFilter = new MIDINrSampleFilter(midiNr);
		String[] fileList = f1.list(nrFilter);
		Arrays.sort(fileList);
		for (String str: fileList) {
			Attack a = new Attack();
			a.fileName = path + File.separator + str;
			a.loadRelease = loadAttRel.equalsIgnoreCase("yes");
			a.attackVelocity = 0;
			a.maxKeyPressTime = -1;
			if (hasTremSamples && (!loadOneSamplePerPipe)) {
				a.isTremulant=0;
			}
			p.attacks.add(a);
			if (loadOneSamplePerPipe)
				break;
		}
		p.isPercussive = percussive;
		
		// add trem attack samples
		if (hasTremSamples && (!loadOneSamplePerPipe)) {
			for (int i = 0; i < tremFolders.length; i++) {
				File f3 = new File(f1, tremFolders[i]);
				String[] tremSamples = f3.list(nrFilter);
				Arrays.sort(tremSamples);
				for (String trems: tremSamples) {
					Attack a = new Attack();
					a.fileName = path + File.separator + tremFolders[i] + File.separator + trems;
					a.loadRelease = loadAttRel.equalsIgnoreCase("yes");
					a.attackVelocity = 0;
					a.maxKeyPressTime = -1;
					a.isTremulant = 1;
					p.attacks.add(a);
				}
				
				// also take care of possible additional trem releases
				ReleaseFolderFilter rff = new ReleaseFolderFilter();
				String[] tremRelFolders = f3.list(rff);
				Arrays.sort(tremRelFolders);
				for (String str: tremRelFolders) {
					// extract keypresstime from folder name
					int firstNum = -1;
					int relTime = -1;
					for (int j = 0; j < str.length(); j++) {
						if (Character.isDigit(str.charAt(j))) {
							firstNum = j;
							break;
						}
					}
					if (firstNum > -1) {
						relTime = convertToInt(str.substring(firstNum, str.length()));
					}
					
					File f4 = new File(f1, str);
					String[] releaseList = f4.list(nrFilter);
					Arrays.sort(releaseList);
					for (String rel: releaseList) {
						Release r = new Release();
						r.fileName = path + File.separator + tremFolders[i] + File.separator + str + File.separator + rel;
						r.maxKeyPressTime = relTime;
						r.isTremulant=1;
						p.releases.add(r);
					}
				}
			}
		}
		
		// deal with possible additional releases
		ReleaseFolderFilter rff = new ReleaseFolderFilter();
		String[] folders = f1.list(rff);
		Arrays.sort(folders);
		for (String str: folders) {
			// extract keypresstime from folder name
			int firstNum = -1;
			int relTime = -1;
			for (int i = 0; i < str.length(); i++) {
				if (Character.isDigit(str.charAt(i))) {
					firstNum = i;
					break;
				}
			}
			if (firstNum > -1) {
				relTime = convertToInt(str.substring(firstNum, str.length()));
			}
			
			File f2 = new File(f1, str);
			String[] releaseList = f2.list(nrFilter);
			Arrays.sort(releaseList);
			for (String rel: releaseList) {
				Release r = new Release();
				r.fileName = path + File.separator + str + File.separator + rel;
				r.maxKeyPressTime = relTime;
				if (hasTremSamples && (!loadOneSamplePerPipe)) {
					r.isTremulant=0;
				}
				if (loadOneSamplePerPipe && loadAttRel.equalsIgnoreCase("no")) {
					p.releases.add(r);
					break;
				} else {
					p.releases.add(r);
				}
			}
		}
		return p;
	}

	public String getLine (Scanner s) {
		String result = "";
		try {
			result = s.nextLine();
			int idx;
			idx = result.indexOf('*');
			if (idx > 0) {
				// There's a comment to strip
				result = result.substring(0, idx);
			}
			result = result.trim();
		
			return result;
		}
		catch (NoSuchElementException ne) {
			System.out.println("ERROR: Couldn't find a line to read data from!");
			System.exit(1);
		}
		return result;
	}
	
	public void getParts (String str, ArrayList<String> strList) {
		strList.clear();
		if (str != "") {
			for (String part : str.split(":")) {
				strList.add(part);
			}
			if (strList.isEmpty()) {
				System.out.println("ERROR: Nothing in the list of strings!");
				System.exit(1);
			}
		} else {
			System.out.println("ERROR: No string to split!");
			System.exit(1);
		}
	}
	
	public float convertToFloat (String s) {
		float result = 0;
		try {
			result = Float.parseFloat(s);
			return result;
		}
		catch (NumberFormatException nfe) {
			System.out.println("ERROR: Couldn't convert " + s + " to a floating point value!");
			System.exit(1);
		}
		return result;
	}
	
	public int convertToInt (String s) {
		int result = 0;
		try {
			result = Integer.parseInt(s);
			return result;
		}
		catch (NumberFormatException nfe) {
			System.out.println("ERROR: Couldn't convert " + s + " to an integer value!");
			System.exit(1);
		}
		return result;
	}
}
