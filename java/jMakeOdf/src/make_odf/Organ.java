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

public class Organ {
	String name;
	float amplitudeLevel;
	float pitchTuning;
	String dispScreenSizeHoriz;
	String dispScreenSizeVert;
	int drawstopCols;
	int drawstopRows;
	int extraDrawstopCols;
	int extraDrawstopRows;
	ArrayList<Manual> m_Manuals = new ArrayList<Manual>();
	boolean hasPedals;
	ArrayList<Enclosure> m_Enclosures = new ArrayList<Enclosure>();
	ArrayList<Tremulant> m_Tremulants = new ArrayList<Tremulant>();
	ArrayList<WindchestGroup> m_WindchestGroups = new ArrayList<WindchestGroup>();
	ArrayList<Switch> m_Switches = new ArrayList<Switch>();
	ArrayList<Rank> m_Ranks = new ArrayList<Rank>();
	public Organ() {
		this.name = "";
		this.amplitudeLevel = 100;
		this.pitchTuning = 0;
		this.dispScreenSizeHoriz = "Medium";
		this.dispScreenSizeVert = "Medium";
		this.drawstopCols = 2;
		this.drawstopRows = 6;
		this.extraDrawstopCols = 0;
		this.extraDrawstopRows = 0;
		this.hasPedals = true;
	}
	
	
}
