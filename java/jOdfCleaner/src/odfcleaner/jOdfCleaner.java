/* Copyright (c) 2014 Lars Palo
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

package odfcleaner;

import java.io.*;

public class jOdfCleaner {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("jOdfCleaner version 2014-07-17");
		System.out.println("(C) 2014 Lars Palo");
		System.out.println("Published under a MIT-license");
		System.out.println();
		if (args.length != 2) {
			System.out.println("Wrong number of parameters!");
			System.out.println("The program expects an infile (.organ) as first parameter");
			System.out.println("and an outfile for the cleaned version as the second.");
			System.exit(1);
		}
		
		try {
			BufferedReader inFile = new BufferedReader(new InputStreamReader(new FileInputStream(args[0]), "ISO-8859-1"));
			
			try {
				PrintWriter outFile = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(args[1]), "ISO-8859-1")));
				
				boolean inOrganSection = false;
				boolean inOldStyleSettings = false;
				boolean inCombinationSection = false;
				boolean inManualSection = false;
				boolean inPanelSection = false;
				boolean foundNbrStops = true;
				boolean foundNbrTremulants = true;
				boolean foundNbrCouplers = true;
				boolean foundNbrDivisionals = true;
				int nbStops = 0;
				int nbTremulants = 0;
				int nbCouplers = 0;
				int nbDivisionals = 0;
				int lineNumber = 0;
				
				while (true) {
					String line = inFile.readLine();
					boolean copyLine = true;
					if (line == null)
						break;
					
					lineNumber++;
					
					// decide if we're in a certain section or not
					if (line.startsWith("[")) {
						if (!foundNbrCouplers)
							outFile.println("NumberOfCouplers=0");
						if (!foundNbrTremulants)
							outFile.println("NumberOfTremulants=0");
						if (!foundNbrStops)
							outFile.println("NumberOfStops=0");
						
						if (line.equals("[Organ]")) {
							inOrganSection = true;
							inOldStyleSettings = false;
							inCombinationSection = false;
							inManualSection = false;
							inPanelSection = false;
							foundNbrTremulants = true;
							foundNbrCouplers = true;
							foundNbrStops = true;
							foundNbrDivisionals = true;
						} else if (line.startsWith("[Manual")) {
							inManualSection = true;
							inOrganSection = false;
							inOldStyleSettings = false;
							inCombinationSection = false;
							inPanelSection = false;
							foundNbrTremulants = false;
							foundNbrCouplers = false;
							foundNbrStops = false;
							foundNbrDivisionals = false;
							nbStops = 0;
							nbTremulants = 0;
							nbCouplers = 0;
							nbDivisionals = 0;
						} else if (line.startsWith("[_")) {
							inOldStyleSettings = true;
							inOrganSection = false;
							inCombinationSection = false;
							inManualSection = false;
							inPanelSection = false;
							foundNbrTremulants = true;
							foundNbrCouplers = true;
							foundNbrStops = true;
							foundNbrDivisionals = true;
						} else if (line.startsWith("[General") || line.startsWith("[Divisional")) {
							inCombinationSection = true;
							inOrganSection = false;
							inOldStyleSettings = false;
							inManualSection = false;
							inPanelSection = false;
							foundNbrTremulants = false;
							foundNbrCouplers = false;
							foundNbrStops = false;
							foundNbrDivisionals = true;
							nbStops = 0;
							nbTremulants = 0;
							nbCouplers = 0;
						} else if (line.startsWith("[Panel") || line.startsWith("[SetterElement") || line.startsWith("[Label")) {
							inPanelSection = true;
							inOrganSection = false;
							inOldStyleSettings = false;
							inCombinationSection = false;
							inManualSection = false;
							foundNbrTremulants = true;
							foundNbrCouplers = true;
							foundNbrStops = true;
							foundNbrDivisionals = true;
						} else {
							inOrganSection = false;
							inOldStyleSettings = false;
							inCombinationSection = false;
							inManualSection = false;
							inPanelSection = false;
							foundNbrTremulants = true;
							foundNbrCouplers = true;
							foundNbrStops = true;
							foundNbrDivisionals = true;
						}
					}
					
					if (inOldStyleSettings)
						copyLine = false;
					else {
						// remove comments occuring after a config line
						if (line.indexOf(';', 1) != -1 && !line.startsWith(";")) {
							line = line.substring(0, line.indexOf(';'));
							line = line.trim();
						}

						// remove all excess whitespace
						line = line.trim();

						if (!line.startsWith(";") && !line.startsWith("[")) {
							// make sure there's an equal sign on the line
							if (!line.contains("="))
								copyLine = false;

							// except for an empty line
							if (line.equals(""))
								copyLine = true;
						}
					}
					
					// fix paths that use / as separator instead of \
					if (line.startsWith("Pipe") ||
							line.startsWith("Bitmap") ||
							line.startsWith("Image") ||
							line.startsWith("Info") ||
							line.startsWith("Key")) {
						if (line.contains("/")) {
							line = line.replace("/", "\\");
						}
					}
					
					// look for lines that should not be present
					if (inOrganSection) {
						if (line.startsWith("HauptwerkOrganFileFormatVersion"))
							copyLine = false;

						if (line.startsWith("NumberOfFrameGenerals"))
							copyLine = false;

						if (line.startsWith("HighestSampleFormat"))
							copyLine = false;
					} else if (inPanelSection) {
						if (line.startsWith("Displayed"))
							copyLine = false;
					} else if (inManualSection) {
						if (line.startsWith("Comments"))
							copyLine = false;
						
						if (foundNbrCouplers) {
							if (line.startsWith("NumberOfCouplers"))
								copyLine = false;
							
							if (line.startsWith("Coupler")) {
								try {
									int couplerNbr = Integer.parseInt(line.substring(7, line.indexOf('=')));
									
									if (couplerNbr > nbCouplers)
										copyLine = false;
								} catch (NumberFormatException ne) {
									System.out.println("Error: Couldn't convert coupler number to integer at line " + lineNumber + ".");
									System.exit(1);
								}
							}
						}
						
						if (foundNbrTremulants) {
							if (line.startsWith("NumberOfTremulants"))
								copyLine = false;
							
							if (line.startsWith("Tremulant")) {
								try {
									int tremulantNbr = Integer.parseInt(line.substring(9, line.indexOf('=')));
									
									if (tremulantNbr > nbTremulants)
										copyLine = false;
								} catch (NumberFormatException ne) {
									System.out.println("Error: Couldn't convert tremulant number to integer at line " + lineNumber + ".");
									System.exit(1);
								}
							}
						}
						
						if (foundNbrStops) {
							if (line.startsWith("NumberOfStops"))
								copyLine = false;
							
							if (line.startsWith("Stop")) {
								try {
									int stopNbr = Integer.parseInt(line.substring(4, line.indexOf('=')));
									
									if (stopNbr > nbStops)
										copyLine = false;
								} catch (NumberFormatException ne) {
									System.out.println("Error: Couldn't convert stop number to integer at line " + lineNumber + ".");
									System.exit(1);
								}
							}
						}
						
						if (foundNbrDivisionals) {
							if (line.startsWith("NumberOfDivisionals"))
								copyLine = false;
							
							if (line.startsWith("Divisional")) {
								try {
									int divisionalNbr = Integer.parseInt(line.substring(10, line.indexOf('=')));
									
									if (divisionalNbr > nbDivisionals)
										copyLine = false;
								} catch (NumberFormatException ne) {
									System.out.println("Error: Couldn't convert divisional number to integer at line " + lineNumber + ".");
									System.exit(1);
								}
							}
						}
						
						if (line.startsWith("NumberOfCouplers")) {
							foundNbrCouplers = true;
							try {
								nbCouplers = Integer.parseInt(line.substring(line.indexOf('=') + 1, line.length()));
							} catch (NumberFormatException ne) {
								System.out.println("Error: Couldn't convert number of couplers to integer at line " + lineNumber + ".");
								System.exit(1);
							}
						}
						
						if (line.startsWith("NumberOfTremulants")) {
							foundNbrTremulants = true;
							try {
								nbTremulants = Integer.parseInt(line.substring(line.indexOf('=') + 1, line.length()));
							} catch (NumberFormatException ne) {
								System.out.println("Error: Couldn't convert number of tremulants to integer at line " + lineNumber + ".");
								System.exit(1);
							}
						}
						
						if (line.startsWith("NumberOfStops")) {
							foundNbrStops = true;
							try {
								nbStops = Integer.parseInt(line.substring(line.indexOf('=') + 1, line.length()));
							} catch (NumberFormatException ne) {
								System.out.println("Error: Couldn't convert number of stops to integer at line " + lineNumber + ".");
								System.exit(1);
							}
						}
						
						if (line.startsWith("NumberOfDivisionals")) {
							foundNbrDivisionals = true;
							try {
								nbDivisionals = Integer.parseInt(line.substring(line.indexOf('=') + 1, line.length()));
							} catch (NumberFormatException ne) {
								System.out.println("Error: Couldn't convert number of divisionals to integer at line " + lineNumber + ".");
								System.exit(1);
							}
						}
					} else if (inCombinationSection) {
						if (line.startsWith("TremulantManual"))
							copyLine = false;
						
						if (line.startsWith("Comments"))
							copyLine = false;
						
						if (line.startsWith("MIDIProgramChangeNumber"))
							copyLine = false;
						
						if (line.equalsIgnoreCase("ShortcutKey="))
							copyLine = false;
						
						if (foundNbrCouplers) {
							if (line.startsWith("NumberOfCouplers"))
								copyLine = false;
							
							if (line.startsWith("CouplerManual") || line.startsWith("CouplerNumber")) {
								try {
									int couplerNbr = Integer.parseInt(line.substring(13, line.indexOf('=')));
									
									if (couplerNbr > nbCouplers)
										copyLine = false;
								} catch (NumberFormatException ne) {
									System.out.println("Error: Couldn't convert CouplerManual/Number number to integer at line " + lineNumber + ".");
									System.exit(1);
								}
							}
						}
						
						if (foundNbrTremulants) {
							if (line.startsWith("NumberOfTremulants"))
								copyLine = false;
							
							if (line.startsWith("TremulantNumber")) {
								try {
									int tremulantNbr = Integer.parseInt(line.substring(15, line.indexOf('=')));
									
									if (tremulantNbr > nbTremulants)
										copyLine = false;
								} catch (NumberFormatException ne) {
									System.out.println("Error: Couldn't convert TremulantNumber number to integer at line " + lineNumber + ".");
									System.exit(1);
								}
							}
						}
						
						if (foundNbrStops) {
							if (line.startsWith("NumberOfStops"))
								copyLine = false;
							
							if (line.startsWith("StopManual") || line.startsWith("StopNumber")) {
								try {
									int stopNbr = Integer.parseInt(line.substring(10, line.indexOf('=')));
									
									if (stopNbr > nbStops)
										copyLine = false;
								} catch (NumberFormatException ne) {
									System.out.println("Error: Couldn't convert StopManual/Number number to integer at line " + lineNumber + ".");
									System.exit(1);
								}
							}
						}
						
						if (line.startsWith("NumberOfCouplers")) {
							foundNbrCouplers = true;
							try {
								nbCouplers = Integer.parseInt(line.substring(line.indexOf('=') + 1, line.length()));
							} catch (NumberFormatException ne) {
								System.out.println("Error: Couldn't convert coupler number to integer at line " + lineNumber + ".");
								System.exit(1);
							}
						}
						
						if (line.startsWith("NumberOfTremulants")) {
							foundNbrTremulants = true;
							try {
								nbTremulants = Integer.parseInt(line.substring(line.indexOf('=') + 1, line.length()));
							} catch (NumberFormatException ne) {
								System.out.println("Error: Couldn't convert tremulant number to integer at line " + lineNumber + ".");
								System.exit(1);
							}
						}
						
						if (line.startsWith("NumberOfStops")) {
							foundNbrStops = true;
							try {
								nbStops = Integer.parseInt(line.substring(line.indexOf('=') + 1, line.length()));
							} catch (NumberFormatException ne) {
								System.out.println("Error: Couldn't convert stops number to integer at line " + lineNumber + ".");
								System.exit(1);
							}
						}
					} else {
						if (line.startsWith("ChurchName"))
							copyLine = false;
						
						if (line.startsWith("ChurchAddress"))
							copyLine = false;
						
						if (line.startsWith("OrganBuilder"))
							copyLine = false;
						
						if (line.startsWith("OrganBuildDate"))
							copyLine = false;
						
						if (line.startsWith("OrganComments"))
							copyLine = false;
						
						if (line.startsWith("RecordingDetails"))
							copyLine = false;
						
						if (line.startsWith("Comments"))
							copyLine = false;
						
						if (line.startsWith("Comment"))
							copyLine = false;
						
						if (line.startsWith("StopControlMIDIKeyNumber"))
							copyLine = false;
						
						if (line.equalsIgnoreCase("ShortcutKey="))
							copyLine = false;
					}
					
					if (copyLine)
						outFile.println(line);
				}
				outFile.close();
				System.out.println("Cleaning complete!");
				System.exit(0);
			} catch (IOException ie) {
				System.out.println("Error: Couldn't create outfile with name " + args[1]);
				System.exit(1);
			}
		} catch (FileNotFoundException f) {
			System.out.println("Error: Couldn't open file with name " + args[0]);
			System.exit(1);
		} catch (UnsupportedEncodingException enc) {
			System.out.println("Error: Couldn't use iso-8859-1 encoding to read file");
			System.exit(1);
		}

	}

}
