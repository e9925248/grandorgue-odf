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

	public void write(PrintWriter outfile) {
		// Organ section
		System.out.println("Writing organ section.");
		outfile.println("[Organ]");
		writeHeader(outfile);
		outfile.println();

		// Manual section
		System.out.println("Writing manual section.");
		int adjustedIndex;

		Counters counters = new Counters();

		if (hasPedals)
			adjustedIndex = 0;
		else
			adjustedIndex = 1;
		for (int i = 0; i < m_Manuals.size(); i++) {
			outfile.println("[Manual" + NumberUtil.format(i + adjustedIndex)
					+ "]");
			Manual manual = m_Manuals.get(i);
			int midiInputNumber = adjustedIndex + i + 1;
			manual.write(outfile, counters, midiInputNumber);

			outfile.println();
		}

		// Windchests section
		System.out.println("Writing windchest section.");
		for (int i = 0; i < m_WindchestGroups.size(); i++) {
			outfile.println("[WindchestGroup" + NumberUtil.format(i + 1) + "]");
			WindchestGroup windchestGroup = m_WindchestGroups.get(i);
			windchestGroup.write(outfile);
			outfile.println();
		}

		// Enclosures section
		System.out.println("Writing enclosure section.");
		for (int i = 0; i < m_Enclosures.size(); i++) {
			outfile.println("[Enclosure" + NumberUtil.format(i + 1) + "]");
			Enclosure enclosure = m_Enclosures.get(i);
			enclosure.write(outfile, i + 1);
			outfile.println();
		}

		// Tremulants section
		System.out.println("Writing tremulant section.");
		for (int i = 0; i < m_Tremulants.size(); i++) {
			outfile.println("[Tremulant" + NumberUtil.format(i + 1) + "]");
			Tremulant tremulant = m_Tremulants.get(i);

			tremulant.write(outfile);
			outfile.println();
		}

		// Coupler section
		System.out.println("Writing coupler section.");
		counters = new Counters();

		for (int i = 0; i < m_Manuals.size(); i++) {
			Manual manual = m_Manuals.get(i);
			int nbCouplers = manual.m_Couplers.size();
			for (int j = 0; j < nbCouplers; j++) {
				counters.totalNbCouplers += 1;
				outfile.println("[Coupler"
						+ NumberUtil.format(counters.totalNbCouplers) + "]");
				Coupler coupler = manual.m_Couplers.get(j);
				coupler.write(outfile);
				outfile.println();
			}
		}

		// Rank section
		if (!m_Ranks.isEmpty())
			System.out.println("Writing rank section.");
		for (int i = 0; i < m_Ranks.size(); i++) {
			Rank rank = m_Ranks.get(i);
			System.out.println("Writing rank " + rank.name);
			outfile.println("[Rank" + NumberUtil.format(i + 1) + "]");
			rank.write(outfile);
			outfile.println();
		}

		// Stop section
		System.out.println("Writing stop section.");
		for (int i = 0; i < m_Manuals.size(); i++) {
			Manual manual = m_Manuals.get(i);
			for (int j = 0; j < manual.m_Stops.size(); j++) {
				counters.totalNbStops += 1;
				Stop stop = manual.m_Stops.get(j);
				System.out.println("Writing stop " + stop.name);
				outfile.println("[Stop"
						+ NumberUtil.format(counters.totalNbStops) + "]");
				stop.write(outfile);
				outfile.println();
			}
		}

		// Switch section
		if (!m_Switches.isEmpty())
			System.out.println("Writing switch section");
		for (int i = 0; i < m_Switches.size(); i++) {
			outfile.println("[Switch" + NumberUtil.format(i + 1) + "]");
			Switch switch_ = m_Switches.get(i);
			outfile.println("Name=" + switch_.name);
			switch_.write(outfile);

			outfile.println();
		}
		System.out.println("Done writing ODF file!");
	}

	public void writeHeader(PrintWriter outfile) {
		outfile.println("ChurchName=" + name);
		outfile.println("ChurchAddress=?");
		outfile.println("OrganBuilder=?");
		outfile.println("OrganBuildDate=?");
		outfile.println("OrganComments=?");
		outfile.println("RecordingDetails=?");
		outfile.println("InfoFilename=?");
		if (hasPedals) {
			outfile.println("NumberOfManuals=" + (m_Manuals.size() - 1));
			outfile.println("HasPedals=Y");
		} else {
			outfile.println("NumberOfManuals=" + m_Manuals.size());
			outfile.println("HasPedals=N");
		}
		outfile.println("NumberOfGenerals=0");
		outfile.println("NumberOfEnclosures=" + m_Enclosures.size());
		outfile.println("NumberOfTremulants=" + m_Tremulants.size());
		outfile.println("NumberOfWindchestGroups=" + m_WindchestGroups.size());
		outfile.println("NumberOfReversiblePistons=0");
		outfile.println("NumberOfLabels=0");
		outfile.println("NumberOfDivisionalCouplers=0");
		outfile.println("NumberOfImages=0");
		outfile.println("NumberOfSetterElements=0");
		outfile.println("NumberOfPanels=0");
		outfile.println("NumberOfRanks=" + m_Ranks.size());
		outfile.println("NumberOfSwitches=" + m_Switches.size());
		outfile.println("DispDrawstopCols=" + drawstopCols);
		outfile.println("DispDrawstopRows=" + drawstopRows);
		outfile.println("DispDrawstopColsOffset=N");
		outfile.println("DispDrawstopOuterColOffsetUp=N");
		outfile.println("DispPairDrawstopCols=N");
		outfile.println("DispExtraDrawstopCols=" + extraDrawstopCols);
		outfile.println("DispExtraDrawstopRows=" + extraDrawstopRows);
		outfile.println("DispExtraDrawstopRowsAboveExtraButtonRows=N");
		outfile.println("DispScreenSizeHoriz=" + dispScreenSizeHoriz);
		outfile.println("DispScreenSizeVert=" + dispScreenSizeVert);
		outfile.println("DispControlLabelFont=Arial");
		outfile.println("DispShortcutKeyLabelFont=Arial");
		outfile.println("DispShortcutKeyLabelColour=Yellow");
		outfile.println("DispGroupLabelFont=Arial");
		outfile.println("DispDrawstopBackgroundImageNum=7");
		outfile.println("DispConsoleBackgroundImageNum=43");
		outfile.println("DispKeyHorizBackgroundImageNum=8");
		outfile.println("DispKeyVertBackgroundImageNum=37");
		outfile.println("DispDrawstopInsetBackgroundImageNum=5");
		outfile.println("DispExtraButtonRows=1");
		outfile.println("DispButtonCols=10");
		outfile.println("DispExtraPedalButtonRow=N");
		outfile.println("DispExtraPedalButtonRowOffset=Y");
		outfile.println("DispExtraPedalButtonRowOffsetRight=Y");
		outfile.println("DispButtonsAboveManuals=N");
		outfile.println("DispTrimAboveExtraRows=Y");
		outfile.println("DispTrimAboveManuals=Y");
		outfile.println("DispTrimBelowManuals=N");
		outfile.println("DivisionalsStoreTremulants=Y");
		outfile.println("DivisionalsStoreIntermanualCouplers=Y");
		outfile.println("DivisionalsStoreIntramanualCouplers=Y");
		outfile.println("GeneralsStoreDivisionalCouplers=Y");
		outfile.println("CombinationsStoreNonDisplayedDrawstops=Y");
		outfile.println("AmplitudeLevel=" + amplitudeLevel);
	}

}
