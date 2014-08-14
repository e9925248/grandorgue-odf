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
import java.util.List;

public class Enclosure {
	String name;
	int ampMinimumLevel;
	int MIDIInputNumber;
	boolean displayed;
	int textBreakWidth;

	public Enclosure() {
		this.name = "";
		this.ampMinimumLevel = 1;
		MIDIInputNumber = 0;
		this.displayed = true;
		this.textBreakWidth = -1;
	}

	void read(Tokenizer tok) {
		List<String> stringParts = tok.readAndSplitLine();
		name = stringParts.get(0);
		ampMinimumLevel = Tokenizer.convertToInt(stringParts.get(1));
		displayed = Tokenizer.convertToBoolean(stringParts.get(2));
		textBreakWidth = Tokenizer.convertToInt(stringParts.get(3));
	}

	public void write(PrintWriter outfile, int midiInputNumber) {
		outfile.println("Name=" + name);
		outfile.println("AmpMinimumLevel=" + ampMinimumLevel);
		outfile.println("MIDIInputNumber=" + midiInputNumber);
		if (displayed) {
			outfile.println("Displayed=Y");
			if (textBreakWidth >= 0)
				outfile.println("TextBreakWidth=" + textBreakWidth);
		} else {
			outfile.println("Displayed=N");
		}
	}
}
