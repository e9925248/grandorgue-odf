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

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

public class WindchestGroup {
	String name;
	ArrayList<Integer> m_Enclosures = new ArrayList<Integer>();
	ArrayList<Integer> m_Tremulants = new ArrayList<Integer>();

	public WindchestGroup() {
		name = "";
	}

	void read(Tokenizer tok) {
		List<String> stringParts = tok.readAndSplitLine();
		name = stringParts.get(0);
		int enclosures = Tokenizer.convertToInt(stringParts.get(1));
		if (enclosures > 0) {
			int lastIndex = 2;
			for (int j = 0; j < enclosures; j++) {
				int enclosureRef = Tokenizer.convertToInt(stringParts
						.get(j + 2));
				m_Enclosures.add(enclosureRef);
				lastIndex++;
			}
			int tremulants = Tokenizer.convertToInt(stringParts.get(lastIndex));
			for (int j = 0; j < tremulants; j++) {
				int tremulantRef = Tokenizer.convertToInt(stringParts
						.get(lastIndex + 1 + j));
				m_Tremulants.add(tremulantRef);
			}
		} else {
			int tremulants = Tokenizer.convertToInt(stringParts.get(2));
			for (int j = 0; j < tremulants; j++) {
				int tremulantRef = Tokenizer.convertToInt(stringParts
						.get(j + 3));
				m_Tremulants.add(tremulantRef);
			}
		}
	}

	public void write(PrintWriter outfile) {
		outfile.println("Name=" + name);
		outfile.println("NumberOfEnclosures=" + m_Enclosures.size());
		OdfWriter.writeReferences(outfile, "Enclosure", m_Enclosures);
		outfile.println("NumberOfTremulants=" + m_Tremulants.size());
		OdfWriter.writeReferences(outfile, "Tremulant", m_Tremulants);
	}
}
