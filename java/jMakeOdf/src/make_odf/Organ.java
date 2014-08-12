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
import java.util.Collections;

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

	public void read(Tokenizer tok) {
		name = tok.readLine();
		amplitudeLevel = tok.readFloatLine();
		pitchTuning = tok.readFloatLine();
		dispScreenSizeHoriz = tok.readLine();
		dispScreenSizeVert = tok.readLine();
		drawstopCols = tok.readIntLine();
		drawstopRows = tok.readIntLine();
		extraDrawstopRows = tok.readIntLine();
		extraDrawstopCols = tok.readIntLine();

		boolean loadOneSamplePerPipe;

		loadOneSamplePerPipe = tok.readLine().equalsIgnoreCase("yes");

		int nbSwitches = tok.readIntLine();
		for (int i = 0; i < nbSwitches; i++) {
			Switch sw = new Switch();

			sw.read(tok);

			m_Switches.add(sw);
		}

		int nbEnclosures = tok.readIntLine();
		for (int i = 0; i < nbEnclosures; i++) {
			Enclosure enc = new Enclosure();

			enc.read(tok);

			m_Enclosures.add(enc);
		}

		int nbTremulants = tok.readIntLine();
		for (int i = 0; i < nbTremulants; i++) {
			Tremulant trem = new Tremulant();

			trem.read(tok);

			m_Tremulants.add(trem);
		}

		int nbWindchests = tok.readIntLine();
		for (int i = 0; i < nbWindchests; i++) {
			WindchestGroup wc = new WindchestGroup();

			wc.read(tok);

			m_WindchestGroups.add(wc);
		}

		int keybNumber = tok.readIntLine();
		for (int i = 0; i < keybNumber; i++) {
			Manual m = new Manual();

			m.read(tok, loadOneSamplePerPipe);

			m_Manuals.add(m);
		}
		// Make sure manuals are sorted according to keyboard code
		Collections.sort(m_Manuals);

		hasPedals = false;

		for (Manual manual : m_Manuals) {
			if (manual.keyboardCode.equalsIgnoreCase("PED")) {
				hasPedals = true;
				break;
			}
		}

		int nbRanks = tok.readIntLine();
		for (int i = 0; i < nbRanks; i++) {
			Rank rk = new Rank();

			rk.read(tok, loadOneSamplePerPipe);

			m_Ranks.add(rk);
		}
	}

}
