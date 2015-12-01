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

public class Coupler extends Drawstop {
	boolean unisonOff;
	String destinationManualCode;
	int destinationKeyShift;
	boolean coupleToSubsequentUnisonIntermanualCouplers;
	boolean coupleToSubsequentUpwardIntermanualCouplers;
	boolean coupleToSubsequentDownwardIntermanualCouplers;
	boolean coupleToSubsequentUpwardIntramanualCouplers;
	boolean coupleToSubsequentDownwardIntramanualCouplers;
	CouplerType m_type;
	int firstMIDINoteNumber;
	int numberOfKeys;

	public Coupler() {
		super();
		this.unisonOff = false;
		this.destinationManualCode = "";
		this.destinationKeyShift = 0;
		this.coupleToSubsequentDownwardIntermanualCouplers = false;
		this.coupleToSubsequentDownwardIntramanualCouplers = false;
		this.coupleToSubsequentUnisonIntermanualCouplers = false;
		this.coupleToSubsequentUpwardIntermanualCouplers = false;
		this.coupleToSubsequentUpwardIntramanualCouplers = false;
		this.m_type = CouplerType.NORMAL;
		this.firstMIDINoteNumber = 0;
		this.numberOfKeys = 0;
	}

	void read(Tokenizer tok, Panel p, int orderNr, String keyboardCode) {
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
		boolean isDisplayed = Tokenizer.convertToBoolean(stringParts.get(5));
		if (isDisplayed) {
			GUIElement element = new GUIElement();
			element.type = "Coupler";
			GUIElement.GUICoupler cplr = element.new GUICoupler();
			cplr.dispImageNum = Tokenizer.convertToInt(stringParts.get(6));
			cplr.dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(7));
			cplr.dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(8));
			cplr.textBreakWidth = Tokenizer.convertToInt(stringParts.get(9));
			cplr.keyboardCode = keyboardCode;
			cplr.coupler = orderNr + 1;
			element.m_elements.add(cplr);
			p.m_GUIElements.add(element);
		}
		stringParts = tok.readAndSplitLine();
		function = Enum.valueOf(Function.class, stringParts.get(0)
				.toUpperCase());
		Tokenizer.readNumericReferencesOffset1(stringParts, m_switches);
	}

	public void write(PrintWriter outfile) {
		super.write(outfile);
		if (m_type != CouplerType.NORMAL)
			outfile.println("CouplerType=" + m_type.type);
		if (unisonOff)
			outfile.println("UnisonOff=Y");
		else
			outfile.println("UnisonOff=N");
		outfile.println("DestinationManual="
				+ NumberUtil.format(Manual
						.translateKeyCode(destinationManualCode)));
		outfile.println("DestinationKeyshift=" + destinationKeyShift);
		if (m_type == CouplerType.NORMAL && (!unisonOff)) {
			if (coupleToSubsequentUnisonIntermanualCouplers)
				outfile.println("CoupleToSubsequentUnisonIntermanualCouplers=Y");
			else
				outfile.println("CoupleToSubsequentUnisonIntermanualCouplers=N");
			if (coupleToSubsequentUpwardIntermanualCouplers)
				outfile.println("CoupleToSubsequentUpwardIntermanualCouplers=Y");
			else
				outfile.println("CoupleToSubsequentUpwardIntermanualCouplers=N");
			if (coupleToSubsequentDownwardIntermanualCouplers)
				outfile.println("CoupleToSubsequentDownwardIntermanualCouplers=Y");
			else
				outfile.println("CoupleToSubsequentDownwardIntermanualCouplers=N");
			if (coupleToSubsequentUpwardIntramanualCouplers)
				outfile.println("CoupleToSubsequentUpwardIntramanualCouplers=Y");
			else
				outfile.println("CoupleToSubsequentUpwardIntramanualCouplers=N");
			if (coupleToSubsequentDownwardIntramanualCouplers)
				outfile.println("CoupleToSubsequentDownwardIntramanualCouplers=Y");
			else
				outfile.println("CoupleToSubsequentDownwardIntramanualCouplers=N");
		}
	}

}
