/* Copyright (c) 2015 Marcin Listkowski, Lars Palo
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

import java.io.File;

public class jMakeOdf {

	public static void main(String[] args) {
		try {
			new jMakeOdf().run(args);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void run(String[] args) {
		System.out.println("\njMakeOdf 2015-11-30");
		System.out.println("Released under a MIT license");
		System.out.println("Copyright (C) 2015 Marcin Listkowski, Lars Palo");
		System.out
				.println("Based on (partly ported from) make_odf by Jean-Luc Derouineau under MIT License\n");

		if (args.length != 1 || args[0].compareTo("--help") == 0
				|| args[0].compareTo("-h") == 0) {
			printUsageHelp();
		} else {
			String pathname = args[0];
			runForFile(pathname);
		}
	}

	public void runForFile(String pathname) {
		File f = new File(pathname);
		if (!f.exists()) {
			System.out.println("No description file with name " + pathname
					+ " exists!");
		} else {
			System.out.println("Parsing file " + pathname);
			TextFileParser m_Parser = new TextFileParser();
			Organ m_Organ = m_Parser.parse(f);
			OdfWriter ow = new OdfWriter();
			ow.write(m_Organ, getOutputFileName(m_Organ));
		}
	}

	public String getOutputFileName(Organ organ) {
		return organ.churchName + ".organ";
	}

	public static void printUsageHelp() {
		System.out.println("Usage:\njMakeOdf <description file>");
		System.out
				.println("\tTry parsing existing description file in current folder and create an .organ file");
		System.out.println("jMakeOdf --help");
		System.out.println("jMakeOdf -h");
		System.out.println("\tPrints this message and exit");
	}
}
