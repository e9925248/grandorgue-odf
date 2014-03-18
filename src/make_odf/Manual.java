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

import java.util.ArrayList;

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
	
	public int compareTo(Manual m) {
		if (translateKeyCode(keyboardCode) < translateKeyCode(m.keyboardCode))
			return -1;
		else if (translateKeyCode(keyboardCode) > translateKeyCode(m.keyboardCode))
			return 1;
		else
			return 0;
	}
	
	private int translateKeyCode(String keybCode) {
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

	private int CalculateRomans(int i, int prevNr, int nr) {
		if (prevNr > i) {
			return nr - i;
		} else {
			return nr + i;
		}
	}
}
