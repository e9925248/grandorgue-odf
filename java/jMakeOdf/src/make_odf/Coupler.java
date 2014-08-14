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

public class Coupler extends Drawstop {
	String destinationManualCode;
	int destinationKeyShift;
	CouplerType m_type;

	public Coupler() {
		super();
		this.destinationManualCode = "";
		this.destinationKeyShift = 0;
		this.m_type = CouplerType.NORMAL;
	}

	void read(Tokenizer tok) {
		List<String> stringParts = tok.readAndSplitLine();
		name = stringParts.get(0);
		String couplerString = stringParts.get(1);
		switch (couplerString.charAt(0)) {
		case 'N':
			m_type = CouplerType.NORMAL;
			break;
		case 'M':
			m_type = CouplerType.MELODY;
			break;
		case 'B':
			m_type = CouplerType.BASS;
			break;
		default:
			throw new TextFileParserException("ERROR: Coupler type for " + name
					+ " is not recognized!");
		}
		couplerString = stringParts.get(2);
		switch (couplerString.charAt(0)) {
		case '=':
			destinationKeyShift = 0;
			break;
		case '+':
			destinationKeyShift = 12;
			break;
		case '-':
			destinationKeyShift = -12;
			break;
		default:
			throw new TextFileParserException("ERROR: Destination keyshift "
					+ name + " is not recognized!");
		}
		destinationManualCode = stringParts.get(3);
		defaultToEngaged = Tokenizer.convertToBoolean(stringParts.get(4));
		displayed = Tokenizer.convertToBoolean(stringParts.get(5));
		if (displayed) {
			dispImageNum = Tokenizer.convertToInt(stringParts.get(6));
			dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(7));
			dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(8));
			textBreakWidth = Tokenizer.convertToInt(stringParts.get(9));
		}
		stringParts = tok.readAndSplitLine();
		function = Enum.valueOf(Function.class, stringParts.get(0)
				.toUpperCase());
		Tokenizer.readNumericReferencesOffset1(stringParts, m_switches);
	}

	public void write(PrintWriter outfile) {
		outfile.println("Name=" + name);
		if (function != Function.INPUT) {
			// The coupler has switches
			outfile.println("Function=" + function.func);
			outfile.println("SwitchCount=" + m_switches.size());
			for (int k = 0; k < m_switches.size(); k++)
				outfile.println("Switch" + NumberUtil.format(k + 1) + "="
						+ m_switches.get(k));
		}
		if (m_type != CouplerType.NORMAL)
			outfile.println("CouplerType=" + m_type.type);
		outfile.println("UnisonOff=N");
		outfile.println("DestinationManual="
				+ NumberUtil.format(Manual
						.translateKeyCode(destinationManualCode)));
		outfile.println("DestinationKeyshift=" + destinationKeyShift);
		outfile.println("CoupleToSubsequentUnisonIntermanualCouplers=N");
		outfile.println("CoupleToSubsequentUpwardIntermanualCouplers=N");
		outfile.println("CoupleToSubsequentDownwardIntermanualCouplers=N");
		outfile.println("CoupleToSubsequentUpwardIntramanualCouplers=N");
		outfile.println("CoupleToSubsequentDownwardIntramanualCouplers=N");
		if (displayed) {
			outfile.println("Displayed=Y");
			outfile.println("DispImageNum=" + dispImageNum);
			outfile.println("DispDrawstopCol=" + dispDrawstopCol);
			outfile.println("DispDrawstopRow=" + dispDrawstopRow);
			outfile.println("DispLabelColour=Black");
			outfile.println("DispLabelFontSize=Normal");
			if (textBreakWidth >= 0)
				outfile.println("TextBreakWidth=" + textBreakWidth);
		} else
			outfile.println("Displayed=N");
		if (function == Function.INPUT) {
			if (defaultToEngaged)
				outfile.println("DefaultToEngaged=Y");
			else
				outfile.println("DefaultToEngaged=N");
		}
	}

}
