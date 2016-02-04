/* Copyright (c) 2016 Marcin Listkowski, Lars Palo
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

public class Button {
	String name;
	boolean displayed;
	boolean displayInInvertedState;
	int shortCutKey;

	public Button() {
		this.name = "";
		this.displayed = false;
		this.displayInInvertedState = false;
		this.shortCutKey = 0;
	}
	
	public void write(PrintWriter outfile) {
		outfile.println("Name=" + name);
		if (displayed)
			outfile.println("Displayed=Y");
		if (displayInInvertedState)
			outfile.println("DisplayInInvertedState=Y");
		if (shortCutKey != 0)
			outfile.println("ShortCutKey=" + shortCutKey);
	}
	
	public String toString() {
		return name;
	}
}
