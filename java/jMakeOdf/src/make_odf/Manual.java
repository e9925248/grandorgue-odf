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

package make_odf;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

public class Manual implements Comparable<Manual> {
	String keyboardName;
	String keyboardCode;
	int keyboardSize;
	int keyboardFirstMidiCode;
	boolean isDisplayed;
	ArrayList<Coupler> m_Couplers = new ArrayList<Coupler>();
	ArrayList<Stop> m_Stops = new ArrayList<Stop>();
	ArrayList<Integer> m_Tremulants = new ArrayList<Integer>();
	ArrayList<Integer> m_Switches = new ArrayList<Integer>();

	public Manual() {
		keyboardName = "";
		keyboardCode = "";
		keyboardSize = 0;
		keyboardFirstMidiCode = 0;
		isDisplayed = true;
	}

	@Override
	public int compareTo(Manual m) {
		int thisCode = translateKeyCode(keyboardCode);
		int thatCode = translateKeyCode(m.keyboardCode);
		return Integer.compare(thisCode, thatCode);
	}

	public static int translateKeyCode(String keybCode) {
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

	public static int CalculateRomans(int i, int prevNr, int nr) {
		if (prevNr > i) {
			return nr - i;
		} else {
			return nr + i;
		}
	}

	void readHeader(Tokenizer tok) {
		List<String> stringParts = tok.readAndSplitLine();
		keyboardName = stringParts.get(0);
		keyboardCode = stringParts.get(1);
		keyboardSize = Tokenizer.convertToInt(stringParts.get(2));
		keyboardFirstMidiCode = Tokenizer.convertToInt(stringParts.get(3));
		if (stringParts.get(4).equalsIgnoreCase("yes"))
			isDisplayed = true;
		else
			isDisplayed = false;
	}

	public void read(Tokenizer tok, boolean loadOneSamplePerPipe) {
		readHeader(tok);

		int nbCouplers = tok.readIntLine();
		for (int j = 0; j < nbCouplers; j++) {
			Coupler cp = new Coupler();

			cp.read(tok);

			m_Couplers.add(cp);
		}

		tok.readLineOfReferences(m_Tremulants);

		tok.readLineOfReferences(m_Switches);

		int nbStops = tok.readIntLine();
		for (int j = 0; j < nbStops; j++) {
			Stop s = new Stop();

			s.read(tok, loadOneSamplePerPipe);

			m_Stops.add(s);
		}
	}

	public void writeStopsReferences(PrintWriter outfile, Counters counters) {
		int nbStops = m_Stops.size();
		outfile.println("NumberOfStops=" + nbStops);
		for (int j = 0; j < nbStops; j++) {
			counters.totalNbStops++;
			outfile.println("Stop" + NumberUtil.format(j + 1) + "="
					+ NumberUtil.format(counters.totalNbStops));
		}
	}

	public void writeSwitchesReferences(PrintWriter outfile) {
		int nbSwitches = m_Switches.size();
		outfile.println("NumberOfSwitches=" + nbSwitches);
		for (int j = 0; j < nbSwitches; j++) {
			outfile.println("Switch" + NumberUtil.format(j + 1) + "="
					+ NumberUtil.format(m_Switches.get(j)));
		}
	}

	public void writeTremulantsReferences(PrintWriter outfile) {
		int nbTrems = m_Tremulants.size();
		outfile.println("NumberOfTremulants=" + nbTrems);
		for (int j = 0; j < nbTrems; j++) {
			outfile.println("Tremulant" + NumberUtil.format(j + 1) + "="
					+ NumberUtil.format(m_Tremulants.get(j)));
		}
	}

	public void write(PrintWriter outfile, Counters counters,
			int midiInputNumber) {
		outfile.println("Name=" + keyboardName);
		outfile.println("MIDIInputNumber=" + midiInputNumber);
		outfile.println("NumberOfLogicalKeys=" + keyboardSize);
		outfile.println("NumberOfAccessibleKeys=" + keyboardSize);
		outfile.println("FirstAccessibleKeyLogicalKeyNumber=1");
		outfile.println("FirstAccessibleKeyMIDINoteNumber="
				+ keyboardFirstMidiCode);
		writeStopsReferences(outfile, counters);
		writeSwitchesReferences(outfile);
		writeCouplersRefernces(outfile, counters);
		writeTremulantsReferences(outfile);
		outfile.println("NumberOfDivisionals=0");
		if (isDisplayed) {
			outfile.println("Displayed=Y");
			outfile.println("DispKeyColourInverted=N");
		} else
			outfile.println("Displayed=N");
	}

	public void writeCouplersRefernces(PrintWriter outfile, Counters counters) {
		int nbCouplers = m_Couplers.size();
		outfile.println("NumberOfCouplers=" + nbCouplers);
		for (int j = 0; j < nbCouplers; j++) {
			counters.totalNbCouplers++;
			outfile.println("Coupler" + NumberUtil.format(j + 1) + "="
					+ NumberUtil.format(counters.totalNbCouplers));
		}
	}
}
