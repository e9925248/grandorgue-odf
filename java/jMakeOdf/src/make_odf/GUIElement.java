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

public class GUIElement {
	String type;
	ArrayList<Object> m_elements = new ArrayList<Object>();

	public class SetterElement {
		String type;

		public class Swell extends GUIEnclosure {
			String type;
			
			Swell() {
				super();
				this.type = "Swell";
			}
		}
		
		public class CrescendoLabel extends GUILabel {
			String type;
			
			CrescendoLabel() {
				super();
				this.type = "CrescendoLabel";
			}
		}
		
		public class Label extends GUILabel {
			String type;
			
			Label() {
				super();
				this.type = "Label";
			}
		}

		public class Prev extends GUIButton {
			String type;
			
			Prev() {
				super();
				this.type = "Prev";
			}
		}
		public class Next extends GUIButton {
			String type;
			
			Next() {
				super();
				this.type = "Next";
			}
		}
		public class Set extends GUIButton {
			String type;
			
			Set() {
				super();
				this.type = "Set";
			}
		}
		public class M100 extends GUIButton {
			String type;
			
			M100() {
				super();
				this.type = "M100";
			}
		}
		public class M10 extends GUIButton {
			String type;
			
			M10() {
				super();
				this.type = "M10";
			}
		}
		public class M1 extends GUIButton {
			String type;
			
			M1() {
				super();
				this.type = "M1";
			}
		}
		public class P1 extends GUIButton {
			String type;
			
			P1() {
				super();
				this.type = "P1";
			}
		}
		public class P10 extends GUIButton {
			String type;
			
			P10() {
				super();
				this.type = "P10";
			}
		}
		public class P100 extends GUIButton {
			String type;
			
			P100() {
				super();
				this.type = "P100";
			}
		}
		public class Home extends GUIButton {
			String type;
			
			Home() {
				super();
				this.type = "Home";
			}
		}
		public class Current extends GUIButton {
			String type;
			
			Current() {
				super();
				this.type = "Current";
			}
		}
		public class GC extends GUIButton {
			String type;
			
			GC() {
				super();
				this.type = "GC";
			}
		}
		public class L0 extends GUIButton {
			String type;
			
			L0() {
				super();
				this.type = "L0";
			}
		}
		public class L1 extends GUIButton {
			String type;

			L1() {
				super();
				this.type = "L1";
			}
		}
		public class L2 extends GUIButton {
			String type;

			L2() {
				super();
				this.type = "L2";
			}
		}
		public class L3 extends GUIButton {
			String type;

			L3() {
				super();
				this.type = "L3";
			}
		}
		public class L4 extends GUIButton {
			String type;

			L4() {
				super();
				this.type = "L4";
			}
		}
		public class L5 extends GUIButton {
			String type;

			L5() {
				super();
				this.type = "L5";
			}
		}
		public class L6 extends GUIButton {
			String type;

			L6() {
				super();
				this.type = "L6";
			}
		}
		public class L7 extends GUIButton {
			String type;

			L7() {
				super();
				this.type = "L7";
			}
		}
		public class L8 extends GUIButton {
			String type;

			L8() {
				super();
				this.type = "L8";
			}
		}
		public class L9 extends GUIButton {
			String type;

			L9() {
				super();
				this.type = "L9";
			}
		}
		public class Regular extends GUIButton {
			String type;
			
			Regular() {
				super();
				this.type = "Regular";
			}
		}
		public class Scope extends GUIButton {
			String type;
			
			Scope() {
				super();
				this.type = "Scope";
			}
		}
		public class Scoped extends GUIButton {
			String type;
			
			Scoped() {
				super();
				this.type = "Scoped";
			}
		}
		public class Full extends GUIButton {
			String type;
			
			Full() {
				super();
				this.type = "Full";
			}
		}
		public class Insert extends GUIButton {
			String type;
			
			Insert() {
				super();
				this.type = "Insert";
			}
		}
		public class Delete extends GUIButton {
			String type;
			
			Delete() {
				super();
				this.type = "Delete";
			}
		}
		public class General01 extends GUIButton {
			String type;

			General01() {
				super();
				this.type = "General01";
			}
		}
		public class General02 extends GUIButton {
			String type;

			General02() {
				super();
				this.type = "General02";
			}
		}
		public class General03 extends GUIButton {
			String type;

			General03() {
				super();
				this.type = "General03";
			}
		}
		public class General04 extends GUIButton {
			String type;

			General04() {
				super();
				this.type = "General04";
			}
		}
		public class General05 extends GUIButton {
			String type;

			General05() {
				super();
				this.type = "General05";
			}
		}
		public class General06 extends GUIButton {
			String type;

			General06() {
				super();
				this.type = "General06";
			}
		}
		public class General07 extends GUIButton {
			String type;

			General07() {
				super();
				this.type = "General07";
			}
		}
		public class General08 extends GUIButton {
			String type;

			General08() {
				super();
				this.type = "General08";
			}
		}
		public class General09 extends GUIButton {
			String type;

			General09() {
				super();
				this.type = "General09";
			}
		}
		public class General10 extends GUIButton {
			String type;

			General10() {
				super();
				this.type = "General10";
			}
		}
		public class General11 extends GUIButton {
			String type;

			General11() {
				super();
				this.type = "General11";
			}
		}
		public class General12 extends GUIButton {
			String type;

			General12() {
				super();
				this.type = "General12";
			}
		}
		public class General13 extends GUIButton {
			String type;

			General13() {
				super();
				this.type = "General13";
			}
		}
		public class General14 extends GUIButton {
			String type;

			General14() {
				super();
				this.type = "General14";
			}
		}
		public class General15 extends GUIButton {
			String type;

			General15() {
				super();
				this.type = "General15";
			}
		}
		public class General16 extends GUIButton {
			String type;

			General16() {
				super();
				this.type = "General16";
			}
		}
		public class General17 extends GUIButton {
			String type;

			General17() {
				super();
				this.type = "General17";
			}
		}
		public class General18 extends GUIButton {
			String type;

			General18() {
				super();
				this.type = "General18";
			}
		}
		public class General19 extends GUIButton {
			String type;

			General19() {
				super();
				this.type = "General19";
			}
		}
		public class General20 extends GUIButton {
			String type;

			General20() {
				super();
				this.type = "General20";
			}
		}
		public class General21 extends GUIButton {
			String type;

			General21() {
				super();
				this.type = "General21";
			}
		}
		public class General22 extends GUIButton {
			String type;

			General22() {
				super();
				this.type = "General22";
			}
		}
		public class General23 extends GUIButton {
			String type;

			General23() {
				super();
				this.type = "General23";
			}
		}
		public class General24 extends GUIButton {
			String type;

			General24() {
				super();
				this.type = "General24";
			}
		}
		public class General25 extends GUIButton {
			String type;

			General25() {
				super();
				this.type = "General25";
			}
		}
		public class General26 extends GUIButton {
			String type;

			General26() {
				super();
				this.type = "General26";
			}
		}
		public class General27 extends GUIButton {
			String type;

			General27() {
				super();
				this.type = "General27";
			}
		}
		public class General28 extends GUIButton {
			String type;

			General28() {
				super();
				this.type = "General28";
			}
		}
		public class General29 extends GUIButton {
			String type;

			General29() {
				super();
				this.type = "General29";
			}
		}
		public class General30 extends GUIButton {
			String type;

			General30() {
				super();
				this.type = "General30";
			}
		}
		public class General31 extends GUIButton {
			String type;

			General31() {
				super();
				this.type = "General31";
			}
		}
		public class General32 extends GUIButton {
			String type;

			General32() {
				super();
				this.type = "General32";
			}
		}
		public class General33 extends GUIButton {
			String type;

			General33() {
				super();
				this.type = "General33";
			}
		}
		public class General34 extends GUIButton {
			String type;

			General34() {
				super();
				this.type = "General34";
			}
		}
		public class General35 extends GUIButton {
			String type;

			General35() {
				super();
				this.type = "General35";
			}
		}
		public class General36 extends GUIButton {
			String type;

			General36() {
				super();
				this.type = "General36";
			}
		}
		public class General37 extends GUIButton {
			String type;

			General37() {
				super();
				this.type = "General37";
			}
		}
		public class General38 extends GUIButton {
			String type;

			General38() {
				super();
				this.type = "General38";
			}
		}
		public class General39 extends GUIButton {
			String type;

			General39() {
				super();
				this.type = "General39";
			}
		}
		public class General40 extends GUIButton {
			String type;

			General40() {
				super();
				this.type = "General40";
			}
		}
		public class General41 extends GUIButton {
			String type;

			General41() {
				super();
				this.type = "General41";
			}
		}
		public class General42 extends GUIButton {
			String type;

			General42() {
				super();
				this.type = "General42";
			}
		}
		public class General43 extends GUIButton {
			String type;

			General43() {
				super();
				this.type = "General43";
			}
		}
		public class General44 extends GUIButton {
			String type;

			General44() {
				super();
				this.type = "General44";
			}
		}
		public class General45 extends GUIButton {
			String type;

			General45() {
				super();
				this.type = "General45";
			}
		}
		public class General46 extends GUIButton {
			String type;

			General46() {
				super();
				this.type = "General46";
			}
		}
		public class General47 extends GUIButton {
			String type;

			General47() {
				super();
				this.type = "General47";
			}
		}
		public class General48 extends GUIButton {
			String type;

			General48() {
				super();
				this.type = "General48";
			}
		}
		public class General49 extends GUIButton {
			String type;

			General49() {
				super();
				this.type = "General49";
			}
		}
		public class General50 extends GUIButton {
			String type;

			General50() {
				super();
				this.type = "General50";
			}
		}
		public class GeneralPrev extends GUIButton {
			String type;
			
			GeneralPrev() {
				super();
				this.type = "GeneralPrev";
			}
		}
		public class GeneralNext extends GUIButton {
			String type;
			
			GeneralNext() {
				super();
				this.type = "GeneralNext";
			}
		}
		public class GeneralLabel extends GUILabel {
			String type;
			
			GeneralLabel() {
				super();
				this.type = "GeneralLabel";
			}
		}
		public class CrescendoA extends GUIButton {
			String type;
			
			CrescendoA() {
				super();
				this.type = "CrescendoA";
			}
		}
		public class CrescendoB extends GUIButton {
			String type;
			
			CrescendoB() {
				super();
				this.type = "CrescendoB";
			}
		}
		public class CrescendoC extends GUIButton {
			String type;
			
			CrescendoC() {
				super();
				this.type = "CrescendoC";
			}
		}
		public class CrescendoD extends GUIButton {
			String type;
			
			CrescendoD() {
				super();
				this.type = "CrescendoD";
			}
		}
		public class CrescendoPrev extends GUIButton {
			String type;
			
			CrescendoPrev() {
				super();
				this.type = "CrescendoPrev";
			}
		}
		public class CrescendoNext extends GUIButton {
			String type;
			
			CrescendoNext() {
				super();
				this.type = "CrescendoNext";
			}
		}
		public class CrescendoCurrent extends GUIButton {
			String type;
			
			CrescendoCurrent() {
				super();
				this.type = "CrescendoCurrent";
			}
		}
		public class PitchP1 extends GUIButton {
			String type;
			
			PitchP1() {
				super();
				this.type = "PitchP1";
			}
		}
		public class PitchP10 extends GUIButton {
			String type;
			
			PitchP10() {
				super();
				this.type = "PitchP10";
			}
		}
		public class PitchP100 extends GUIButton {
			String type;
			
			PitchP100() {
				super();
				this.type = "PitchP100";
			}
		}
		public class PitchM1 extends GUIButton {
			String type;
			
			PitchM1() {
				super();
				this.type = "PitchM1";
			}
		}
		public class PitchM10 extends GUIButton {
			String type;
			
			PitchM10() {
				super();
				this.type = "PitchM10";
			}
		}
		public class PitchM100 extends GUIButton {
			String type;
			
			PitchM100() {
				super();
				this.type = "PitchM100";
			}
		}
		public class PitchLabel extends GUILabel {
			String type;
			
			PitchLabel() {
				super();
				this.type = "PitchLabel";
			}
		}
		public class TemperamentPrev extends GUIButton {
			String type;
			
			TemperamentPrev() {
				super();
				this.type = "TemperamentPrev";
			}
		}
		public class TemperamentNext extends GUIButton {
			String type;
			
			TemperamentNext() {
				super();
				this.type = "TemperamentNext";
			}
		}
		public class TemperamentLabel extends GUILabel {
			String type;
			
			TemperamentLabel() {
				super();
				this.type = "TemperamentLabel";
			}
		}
		public class TransposeDown extends GUIButton {
			String type;
			
			TransposeDown() {
				super();
				this.type = "TransposeDown";
			}
		}
		public class TransposeUp extends GUIButton {
			String type;
			
			TransposeUp() {
				super();
				this.type = "TransposeUp";
			}
		}
		public class TransposeLabel extends GUILabel {
			String type;
			
			TransposeLabel() {
				super();
				this.type = "TransposeLabel";
			}
		}
		public class Save  extends GUIButton {
			String type;
			
			Save() {
				super();
				this.type = "Save";
			}
		}
	}

	public class GUIManual {
		String type;
		String keyboardCode;
		boolean dispKeyColourInverted;
		boolean dispKeyColourWooden;
		
		GUIManual() {
			type = "Manual";
			this.dispKeyColourInverted = false;
			this.dispKeyColourWooden = false;
		}
		
		public void write(PrintWriter outfile) {
			outfile.println("Type=" + this.type);
			outfile.println("Manual=" + NumberUtil.format(Manual.translateKeyCode(keyboardCode)));
			if (dispKeyColourInverted)
				outfile.println("DispKeyColourInverted=Y");
			else
				outfile.println("DispKeyColourInverted=N");
			if (dispKeyColourWooden)
				outfile.println("DispKeyColourWooden=Y");
		}
	}

	public class GUILabel {
		String type;
		boolean freeXPlacement;
		boolean freeYPlacement;
		int dispXpos;
		int dispYpos;
		boolean dispAtTopOfDrawstopCol;
		int dispDrawstopCol;
		boolean dispSpanDrawstopColToRight;
		Colour dispLabelColour;
		String dispLabelFontSize;
		String displLabelFontName;
		String name;
		int dispImageNum;
		int textBreakWidth;
		
		GUILabel() {
			type = "Label";
			this.freeXPlacement = true;
			this.freeYPlacement = true;
			this.dispXpos = 0;
			this.dispYpos = 0;
			this.dispLabelColour = Colour.BLACK;
			this.dispLabelFontSize = "Normal";
			this.dispImageNum = 1;
			this.textBreakWidth = -1;
		}
	}

	public class GUISwitch extends GUIButton {
		String type;
		int switchNumber;
		
		GUISwitch() {
			super();
			this.type = "Switch";
			this.displayAsPiston = false;
		}
		
		public void write(PrintWriter outfile) {
			outfile.println("Type=" + this.type);
			outfile.println("Switch=" + switchNumber);
			super.write(outfile);	
		}
	}

	public class GUIReversiblePiston extends GUIButton {
		String type;
		int reversiblePiston;
		
		GUIReversiblePiston() {
			super();
			this.type = "ReversiblePiston";
		}
	}

	public class GUIGeneral extends GUIButton {
		String type;
		int general;

		GUIGeneral() {
			super();
			this.type = "General";
		}
	}

	public class GUIDivisionalCoupler extends GUIButton {
		String type;
		int divisionalCoupler;
		
		GUIDivisionalCoupler() {
			super();
			this.type = "DivisionalCoupler";
		}
	}

	public class GUITremulant extends GUIButton {
		String type;
		int tremulant;		
		
		GUITremulant() {
			super();
			this.type = "Tremulant";
		}
		
		public void write(PrintWriter outfile) {
			outfile.println("Type=" + type);
			outfile.println("Tremulant=" + NumberUtil.format(tremulant));
			super.write(outfile);
		}
	}

	public class GUIEnclosure {
		String type;
		int enclosure;
		Colour dispLabelColour;
		String dispLabelFontSize;
		String dispLabelFontName;
		String dispLabelText;
		int enclosureStyle;
		int textBreakWidth;
		
		GUIEnclosure() {
			type = "Enclosure";
			this.dispLabelColour = Colour.WHITE;
			this.dispLabelFontSize = "7";
			this.dispLabelFontName = "";
			this.dispLabelText = "";
			this.enclosureStyle = 1;
			this.textBreakWidth = -1;
		}
		
		public void write(PrintWriter outfile) {
			outfile.println("Type=" + type);
			outfile.println("Enclosure=" + NumberUtil.format(enclosure));
			if (textBreakWidth >= 0)
				outfile.println("TextBreakWidth=" + textBreakWidth);
			if (dispLabelColour != Colour.WHITE)
				outfile.println("DispLabelColour=" + dispLabelColour.colour);
			if (!dispLabelFontName.isEmpty())
				outfile.println("DispLabelFontName=" + dispLabelFontName);
			if (!dispLabelFontSize.equals("7"))
				outfile.println("DispLabelFontSize=" + dispLabelFontSize);
			if (!dispLabelText.isEmpty())
				outfile.println("DispLabelText=" + dispLabelText);
			if (enclosureStyle != 1)
				outfile.println("EnclosureStyle=" + enclosureStyle);
		}
	}

	public class GUIStop extends GUIButton {
		String type;
		String keyboardCode;
		int stop;
		
		GUIStop() {
			super();
			this.type = "Stop";
			dispLabelColour = Colour.BLACK;
		}
		
		public void write(PrintWriter outfile) {
			outfile.println("Type=" + this.type);
			outfile.println("Manual=" + NumberUtil.format(Manual.translateKeyCode(keyboardCode)));
			outfile.println("Stop=" + NumberUtil.format(stop));
			super.write(outfile);
		}
	}

	public class GUICoupler extends GUIButton {
		String type;
		String keyboardCode;
		int coupler;
		
		GUICoupler() {
			super();
			this.type = "Coupler";
			dispLabelColour = Colour.BLACK;
		}
		
		public void write(PrintWriter outfile) {
			outfile.println("Type=" + this.type);
			outfile.println("Manual=" + NumberUtil.format(Manual.translateKeyCode(keyboardCode)));
			outfile.println("Coupler=" + NumberUtil.format(coupler));
			super.write(outfile);
		}
	}

	public class GUIDivisional extends GUIButton {
		String type;
		Manual manual;
		int divisional;
		
		GUIDivisional(Manual m) {
			super();
			this.type = "Divisional";
			manual = m;
		}
	}
	
	public class GUIButton {
		boolean displayInInvertedState;
		boolean displayAsPiston;
		Colour dispLabelColour;
		String dispLabelFontSize;
		String dispLabelFontName;
		String dispLabelText;
		boolean dispKeyLabelOnLeft;
		int dispImageNum;
		int dispButtonRow;
		int dispButtonCol;
		int dispDrawstopRow;
		int dispDrawstopCol;
		String imageOn;
		String imageOff;
		String maskOn;
		String maskOff;
		int positionX;
		int positionY;
		int width;
		int height;
		int tileOffsetX;
		int tileOffsetY;
		int mouseRectLeft;
		int mouseRectTop;
		int mouseRectWidth;
		int mouseRectHeight;
		int mouseRadius;
		int textRectLeft;
		int textRectTop;
		int textRectWidth;
		int textRectHeight;
		int textBreakWidth;
		
		GUIButton() {
			this.displayInInvertedState = false;
			this.displayAsPiston = false;
			this.dispLabelColour = Colour.DARK_RED;
			this.dispLabelFontSize = "Normal";
			this.dispLabelFontName = "";
			this.dispLabelText = "";
			this.dispKeyLabelOnLeft = true;
			this.dispImageNum = 1;
			this.dispButtonRow = 1;
			this.dispButtonCol = 1;
			this.dispDrawstopRow = 1;
			this.dispDrawstopCol = 1;
			this.textBreakWidth = -1;
		}
		
		public void write(PrintWriter outfile) {
			if (textBreakWidth >= 0)
				outfile.println("TextBreakWidth=" + textBreakWidth);
			outfile.println("DispLabelColour=" + dispLabelColour.colour);
			outfile.println("DispLabelFontSize=" + dispLabelFontSize);
			outfile.println("DispImageNum=" + dispImageNum);
			if (displayAsPiston) {
				outfile.println("DispButtonRow=" + dispButtonRow);
				outfile.println("DispButtonCol=" + dispButtonCol);
			} else {
				outfile.println("DispDrawstopRow=" + dispDrawstopRow);
				outfile.println("DispDrawstopCol=" + dispDrawstopCol);
			}
			if (displayInInvertedState)
				outfile.println("DisplayInInvertedState=Y");
		}
	}
	
	public void write(PrintWriter outfile) {
		if (this.type.equals("Manual")) {
			GUIElement.GUIManual man = (GUIManual) m_elements.get(0);
			man.write(outfile);
		}
		if (this.type.equals("Switch")) {
			GUIElement.GUISwitch sw = (GUISwitch) m_elements.get(0);
			sw.write(outfile);
		}
		if (this.type.equals("Enclosure")) {
			GUIElement.GUIEnclosure enc = (GUIEnclosure) m_elements.get(0);
			enc.write(outfile);
		}
		if (this.type.equals("Tremulant")) {
			GUIElement.GUITremulant trem = (GUITremulant) m_elements.get(0);
			trem.write(outfile);
		}
		if (this.type.equals("Coupler")) {
			GUIElement.GUICoupler cplr = (GUICoupler) m_elements.get(0);
			cplr.write(outfile);
		}
		if (this.type.equals("Stop")) {
			GUIElement.GUIStop stop = (GUIStop) m_elements.get(0);
			stop.write(outfile);
		}
	}
}
