/* Copyright (c) 2020 Marcin Listkowski, Lars Palo
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

public class Panel {
	String name;
	String group;
	boolean hasPedals;
	DisplayMetrics m_displayMetrics;
	ArrayList<Image> m_Images = new ArrayList<Image>();
	ArrayList<GUIElement> m_GUIElements = new ArrayList<GUIElement>();
	
	Panel() {
		this.name = "";
		this.group = "";
		this.hasPedals = false;
		m_displayMetrics = new DisplayMetrics();
	}
	
	public void write(PrintWriter outfile, int orderNr) {
		if (this.hasPedals) {
			outfile.println("HasPedals=Y");
		} else {
			outfile.println("HasPedals=N");
		}
		m_displayMetrics.write(outfile);
		outfile.println("NumberOfImages=" + m_Images.size());
		outfile.println("NumberOfGUIElements=" + m_GUIElements.size());
		outfile.println();
		for (int i = 0; i < m_GUIElements.size(); i++) {
			outfile.println("[Panel" + NumberUtil.format(orderNr) + "Element" + NumberUtil.format(i + 1) + "]");
			GUIElement element_ = m_GUIElements.get(i);
			element_.write(outfile);
			outfile.println();
		}
	}
}
