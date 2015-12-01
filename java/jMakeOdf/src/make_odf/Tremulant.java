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

public class Tremulant extends Drawstop {
	String tremType;
	int period;
	int startRate;
	int stopRate;
	int ampModDepth;

	public Tremulant() {
		super();
		this.tremType = "Synth";
		this.period = 160;
		this.startRate = 8;
		this.stopRate = 8;
		this.ampModDepth = 18;
	}

	void read(Tokenizer tok, Panel p, int i) {
		List<String> stringParts = tok.readAndSplitLine();
		name = stringParts.get(0);
		String type = stringParts.get(1);
		switch (type.toLowerCase()) {
		case "synth":
			tremType = stringParts.get(1);
			period = Tokenizer.convertToInt(stringParts.get(2));
			ampModDepth = Tokenizer.convertToInt(stringParts.get(3));
			startRate = Tokenizer.convertToInt(stringParts.get(4));
			stopRate = Tokenizer.convertToInt(stringParts.get(5));
			defaultToEngaged = Tokenizer.convertToBoolean(stringParts.get(6));

			boolean isDisplayed = Tokenizer.convertToBoolean(stringParts.get(7));
			if (isDisplayed) {
				GUIElement element = new GUIElement();
				element.type = "Tremulant";
				GUIElement.GUITremulant trem = element.new GUITremulant();
				trem.tremulant = i + 1;
				trem.dispImageNum = Tokenizer.convertToInt(stringParts.get(8));
				trem.dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(9));
				trem.dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(10));
				trem.textBreakWidth = Tokenizer.convertToInt(stringParts.get(11));
				element.m_elements.add(trem);
				p.m_GUIElements.add(element);
			}
			break;
		case "wave":
			tremType = stringParts.get(1);
			defaultToEngaged = Tokenizer.convertToBoolean(stringParts.get(2));

			boolean isdisplayed = Tokenizer.convertToBoolean(stringParts.get(3));
			if (isdisplayed) {
				GUIElement element = new GUIElement();
				element.type = "Tremulant";
				GUIElement.GUITremulant trem = element.new GUITremulant();
				trem.tremulant = i + 1;
				trem.dispImageNum = Tokenizer.convertToInt(stringParts.get(4));
				trem.dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(5));
				trem.dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(6));
				trem.textBreakWidth = Tokenizer.convertToInt(stringParts.get(7));
				element.m_elements.add(trem);
				p.m_GUIElements.add(element);
			}
			break;
		default:
			throw new TextFileParserException("ERROR: Tremulant type " + type
					+ " is not valid!");
		}
		stringParts = tok.readAndSplitLine();
		function = Enum.valueOf(Function.class, stringParts.get(0)
				.toUpperCase());
		ArrayList<Integer> references = m_switches;
		Tokenizer.readNumericReferencesOffset1(stringParts, references);
	}

	public void write(PrintWriter outfile) {
		super.write(outfile);
		if (tremType.equalsIgnoreCase("Synth")) {
			outfile.println("Period=" + period);
			outfile.println("AmpModDepth=" + ampModDepth);
			outfile.println("StartRate=" + startRate);
			outfile.println("StopRate=" + stopRate);
		} else {
			outfile.println("TremulantType=" + tremType);
		}
	}
}
