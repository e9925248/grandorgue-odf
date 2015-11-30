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

public class DisplayMetrics {
	String dispScreenSizeHoriz; 
	String dispScreenSizeVert;
	int dispDrawstopBackgroundImageNum;
	int dispConsoleBackgroundImageNum;
	int dispKeyHorizBackgroundImageNum;
	int dispKeyVertBackgroundImageNum;
	int dispDrawstopInsetBackgroundImageNum;
	String dispControlLabelFont;
	String dispShortcutKeyLabelFont;
	Colour dispShortcutKeyLabelColour;
	String dispGroupLabelFont;
	int dispDrawstopCols;
	int dispDrawstopRows;
	boolean dispDrawstopColsOffset;
	boolean dispDrawstopOuterColOffsetUp;
	boolean dispPairDrawstopCols;
	int dispExtraDrawstopRows;
	int dispExtraDrawstopCols;
	int dispButtonCols;
	int dispExtraButtonRows;
	boolean dispExtraPedalButtonRow;
	boolean dispExtraPedalButtonRowOffset;
	boolean dispExtraPedalButtonRowOffsetRight;
	boolean dispButtonsAboveManuals;
	boolean dispTrimAboveManuals;
	boolean dispTrimBelowManuals;
	boolean dispTrimAboveExtraRows;
	boolean dispExtraDrawstopRowsAboveExtraButtonRows;
	int dispDrawstopWidth;
	int dispDrawstopHeight;
	int dispPistonWidth;
	int dispPistonHeight;
	int dispEnclosureWidth;
	int dispEnclosureHeight;
	int dispPedalHeight;
	int dispPedalKeyWidth;
	int dispManualHeight;
	int dispManualKeyWidth;
	
	public DisplayMetrics() {
		this.dispScreenSizeHoriz = "Medium";
		this.dispScreenSizeVert = "Medium";
		this.dispDrawstopBackgroundImageNum = 7;
		this.dispConsoleBackgroundImageNum = 43;
		this.dispKeyHorizBackgroundImageNum = 8;
		this.dispKeyVertBackgroundImageNum = 37;
		this.dispDrawstopInsetBackgroundImageNum = 5;
		this.dispControlLabelFont = "Arial";
		this.dispShortcutKeyLabelFont = "Arial";
		this.dispShortcutKeyLabelColour = Colour.YELLOW;
		this.dispGroupLabelFont = "Arial";
		this.dispDrawstopCols = 2;
		this.dispDrawstopRows = 6;
		this.dispDrawstopColsOffset = false;
		this.dispDrawstopOuterColOffsetUp = false;
		this.dispPairDrawstopCols = false;
		this.dispExtraDrawstopCols = 0;
		this.dispExtraDrawstopRows = 0;
		this.dispButtonCols = 10;
		this.dispExtraButtonRows = 1;
		this.dispExtraPedalButtonRow = false;
		this.dispExtraPedalButtonRowOffset = true;
		this.dispExtraPedalButtonRowOffsetRight = true;
		this.dispButtonsAboveManuals = false;
		this.dispTrimAboveManuals = true;
		this.dispTrimBelowManuals = false;
		this.dispTrimAboveExtraRows = true;
		this.dispExtraDrawstopRowsAboveExtraButtonRows = false;
		this.dispDrawstopWidth = 78;
		this.dispDrawstopHeight = 69;
		this.dispPistonWidth = 44;
		this.dispPistonHeight = 40;
		this.dispEnclosureWidth = 52;
		this.dispEnclosureHeight = 63;
		this.dispPedalHeight = 40;
		this.dispPedalKeyWidth = 7;
		this.dispManualHeight = 32;
		this.dispManualKeyWidth = 12;
	}
	
	public void write(PrintWriter outfile) {
		outfile.println("DispDrawstopCols=" + dispDrawstopCols);
		outfile.println("DispDrawstopRows=" + dispDrawstopRows);
		if (dispDrawstopColsOffset) {
			outfile.println("DispDrawstopColsOffset=Y");
		} else {
			outfile.println("DispDrawstopColsOffset=N");
		}
		if (dispDrawstopOuterColOffsetUp) {
			outfile.println("DispDrawstopOuterColOffsetUp=Y");
		} else {
			outfile.println("DispDrawstopOuterColOffsetUp=N");
		}
		if (dispPairDrawstopCols) {
			outfile.println("DispPairDrawstopCols=Y");
		} else {
			outfile.println("DispPairDrawstopCols=N");
		}
		outfile.println("DispExtraDrawstopCols=" + dispExtraDrawstopCols);
		outfile.println("DispExtraDrawstopRows=" + dispExtraDrawstopRows);
		if (dispExtraDrawstopRowsAboveExtraButtonRows) {
			outfile.println("DispExtraDrawstopRowsAboveExtraButtonRows=Y");
		} else {
			outfile.println("DispExtraDrawstopRowsAboveExtraButtonRows=N");
		}
		outfile.println("DispScreenSizeHoriz=" + dispScreenSizeHoriz);
		outfile.println("DispScreenSizeVert=" + dispScreenSizeVert);
		outfile.println("DispControlLabelFont=" + dispControlLabelFont);
		outfile.println("DispShortcutKeyLabelFont=" + dispShortcutKeyLabelFont);
		if (dispShortcutKeyLabelColour != Colour.HTML) {
			outfile.println("DispShortcutKeyLabelColour=" + dispShortcutKeyLabelColour.colour);
		} else {
			outfile.println("DispShortcutKeyLabelColour=" + dispShortcutKeyLabelColour.getHtmlColour());
		}
		outfile.println("DispGroupLabelFont=" + dispGroupLabelFont);
		outfile.println("DispDrawstopBackgroundImageNum=" + dispDrawstopBackgroundImageNum);
		outfile.println("DispConsoleBackgroundImageNum=" + dispConsoleBackgroundImageNum);
		outfile.println("DispKeyHorizBackgroundImageNum=" + dispKeyHorizBackgroundImageNum);
		outfile.println("DispKeyVertBackgroundImageNum=" + dispKeyVertBackgroundImageNum);
		outfile.println("DispDrawstopInsetBackgroundImageNum=" + dispDrawstopInsetBackgroundImageNum);
		outfile.println("DispExtraButtonRows=" + dispExtraButtonRows);
		outfile.println("DispButtonCols=" + dispButtonCols);
		if (dispExtraPedalButtonRow) {
			outfile.println("DispExtraPedalButtonRow=Y");
		} else {
			outfile.println("DispExtraPedalButtonRow=N");
		}
		if (dispExtraPedalButtonRowOffset) {
			outfile.println("DispExtraPedalButtonRowOffset=Y");
		} else {
			outfile.println("DispExtraPedalButtonRowOffset=N");
		}
		if (dispExtraPedalButtonRowOffsetRight) {
			outfile.println("DispExtraPedalButtonRowOffsetRight=Y");
		} else {
			outfile.println("DispExtraPedalButtonRowOffsetRight=N");
		}
		if (dispButtonsAboveManuals) {
			outfile.println("DispButtonsAboveManuals=Y");
		} else {
			outfile.println("DispButtonsAboveManuals=N");
		}
		if (dispTrimAboveExtraRows) {
			outfile.println("DispTrimAboveExtraRows=Y");
		} else {
			outfile.println("DispTrimAboveExtraRows=N");
		}
		if (dispTrimAboveManuals) {
			outfile.println("DispTrimAboveManuals=Y");
		} else {
			outfile.println("DispTrimAboveManuals=N");
		}
		if (dispTrimBelowManuals) {
			outfile.println("DispTrimBelowManuals=Y");
		} else {
			outfile.println("DispTrimBelowManuals=N");
		}
		if (dispDrawstopWidth != 78)
			outfile.println("DispDrawstopWidth=" + dispDrawstopWidth);
		if (dispDrawstopHeight != 69)
			outfile.println("DispDrawstopHeight=" + dispDrawstopHeight);
		if (dispPistonWidth != 44)
			outfile.println("DispPistonWidth=" + dispPistonWidth);
		if (dispPistonHeight != 40)
			outfile.println("DispPistonHeight=" + dispPistonHeight);
		if (dispEnclosureWidth != 52)
			outfile.println("DispEnclosureWidtht=" + dispEnclosureWidth);
		if (dispEnclosureHeight != 63)
			outfile.println("DispEnclosureHeight=" + dispEnclosureHeight);
		if (dispPedalHeight != 40)
			outfile.println("DispPedalHeight=" + dispPedalHeight);
		if (dispPedalKeyWidth != 7)
			outfile.println("DispPedalKeyWidth=" + dispPedalKeyWidth);
		if (dispManualHeight != 32)
			outfile.println("DispManualHeight=" + dispManualHeight);
		if (dispManualKeyWidth != 12)
			outfile.println("DispManualKeyWidth=" + dispManualKeyWidth);
	}
}
