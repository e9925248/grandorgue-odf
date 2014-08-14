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

	void read(Tokenizer tok) {
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

			displayed = Tokenizer.convertToBoolean(stringParts.get(7));
			if (displayed) {
				dispImageNum = Tokenizer.convertToInt(stringParts.get(8));
				dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(9));
				dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(10));
				textBreakWidth = Tokenizer.convertToInt(stringParts.get(11));
			}
			break;
		case "wave":
			tremType = stringParts.get(1);
			defaultToEngaged = Tokenizer.convertToBoolean(stringParts.get(2));

			displayed = Tokenizer.convertToBoolean(stringParts.get(3));
			if (displayed) {
				dispImageNum = Tokenizer.convertToInt(stringParts.get(4));
				dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(5));
				dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(6));
				textBreakWidth = Tokenizer.convertToInt(stringParts.get(7));
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
		outfile.println("Name=" + name);
		if (function != Function.INPUT) {
			outfile.println("Function=" + function.func);
			int sw = m_switches.size();
			outfile.println("SwitchCount=" + sw);
			for (int j = 0; j < sw; j++) {
				outfile.println("Switch" + NumberUtil.format(j + 1) + "="
						+ m_switches.get(j));
			}
		}
		if (tremType.equalsIgnoreCase("Synth")) {
			outfile.println("Period=" + period);
			outfile.println("AmpModDepth=" + ampModDepth);
			outfile.println("StartRate=" + startRate);
			outfile.println("StopRate=" + stopRate);
		} else {
			outfile.println("TremulantType=" + tremType);
		}
		if (displayed) {
			outfile.println("Displayed=Y");
			if (textBreakWidth >= 0)
				outfile.println("TextBreakWidth=" + textBreakWidth);
			outfile.println("DispDrawstopCol=" + dispDrawstopCol);
			outfile.println("DispDrawstopRow=" + dispDrawstopRow);
			outfile.println("DispImageNum=" + dispImageNum);
		} else {
			outfile.println("Displayed=N");
		}
		if (function == Function.INPUT) {
			if (defaultToEngaged)
				outfile.println("DefaultToEngaged=Y");
			else
				outfile.println("DefaultToEngaged=N");
		}
	}
}
