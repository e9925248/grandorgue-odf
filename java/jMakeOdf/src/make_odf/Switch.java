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
import java.util.List;

public class Switch extends Drawstop {
	Switch() {
		super();
	}

	void read(Tokenizer tok, Panel p, int orderNr) {
		List<String> stringParts = tok.readAndSplitLine();
		name = stringParts.get(0);
		defaultToEngaged = Tokenizer.convertToBoolean(stringParts.get(1));
		displayed = Tokenizer.convertToBoolean(stringParts.get(2));
		if (displayed) {
			GUIElement element = new GUIElement();
			element.type = "Switch";
			GUIElement.GUISwitch guiSw = element.new GUISwitch();
			guiSw.switchNumber = orderNr;
			guiSw.dispImageNum = Tokenizer.convertToInt(stringParts.get(3));
			guiSw.dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(4));
			guiSw.dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(5));
			guiSw.textBreakWidth = Tokenizer.convertToInt(stringParts.get(6));
			element.m_elements.add(guiSw);
			p.m_GUIElements.add(element);
		}
		stringParts = tok.readAndSplitLine();
		function = Enum.valueOf(Function.class, stringParts.get(0)
				.toUpperCase());
		Tokenizer.readNumericReferencesOffset1(stringParts, m_switches);
	}

	public void write(PrintWriter outfile) {
		if (function != Function.INPUT) {
			// The switch has switches
			outfile.println("Function=" + function.func);

			OdfWriter.writeReferences(outfile, "Switch", m_switches);
		}
		if (defaultToEngaged)
			outfile.println("DefaultToEngaged=Y");
		else
			outfile.println("DefaultToEngaged=N");
	}
}
