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
		System.out.println("jOdfCleaner version 2014-04-05");
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
				
				while (true) {
					String line = inFile.readLine();
					boolean copyLine = true;
					if (line == null)
						break;
					
					// stop if we come to lines with old style settings
					if (line.startsWith("[_"))
						break;
					
					// remove comments occuring after a config line
					if (line.indexOf(';', 1) != -1) {
						line = line.substring(0, line.indexOf(';'));
						line = line.trim();
					}
					
					// remove all excess whitespace
					line = line.trim();
					
					// decide if we're in the [Organ] section or not
					if (line.startsWith("[")) {
						if (line.equals("[Organ]"))
							inOrganSection = true;
						else
							inOrganSection = false;
					}
					
					if (!line.startsWith(";") && !line.startsWith("[")) {
						// make sure there's an equal sign on the line
						if (!line.contains("="))
							copyLine = false;
						
						// except for an empty line
						if (line.equals(""))
							copyLine = true;
					}
					
					// look for lines that should not be present
					if (inOrganSection) {
						if (line.startsWith("HauptwerkOrganFileFormatVersion"))
							copyLine = false;

						if (line.startsWith("NumberOfFrameGenerals"))
							copyLine = false;

						if (line.startsWith("HighestSampleFormat"))
							copyLine = false;
					}
					
					if (!inOrganSection) {
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
						
						if (line.startsWith("MIDIProgramChangeNumber"))
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
