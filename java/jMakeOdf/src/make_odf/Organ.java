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
import java.util.Collections;

public class Organ {
	String churchName;
	String churchAddress;
	String organBuilder;
	String organBuildDate;
	String organComments;
	String recordingDetails;
	String infoFilename;
	boolean divisionalsStoreIntermanualCouplers;
	boolean divisionalsStoreIntramanualCouplers;
	boolean divisionalsStoreTremulants;
	boolean generalsStoreDivisionalCouplers;
	boolean combinationsStoreNonDisplayedDrawstops;
	boolean hasPedals;
	float amplitudeLevel;
	float gain;
	float pitchTuning;
	int trackerDelay;
	ArrayList<Manual> m_Manuals = new ArrayList<Manual>();
	ArrayList<Enclosure> m_Enclosures = new ArrayList<Enclosure>();
	ArrayList<Tremulant> m_Tremulants = new ArrayList<Tremulant>();
	ArrayList<WindchestGroup> m_WindchestGroups = new ArrayList<WindchestGroup>();
	ArrayList<Panel> m_Panels = new ArrayList<Panel>();
	ArrayList<Switch> m_Switches = new ArrayList<Switch>();
	ArrayList<Rank> m_Ranks = new ArrayList<Rank>();

	public Organ() {
		this.churchName = "";
		this.churchAddress = "?";
		this.organBuilder = "?";
		this.organBuildDate = "?";
		this.organComments = "?";
		this.recordingDetails = "?";
		this.infoFilename = "?";
		this.divisionalsStoreIntermanualCouplers = true;
		this.divisionalsStoreIntramanualCouplers = true;
		this.divisionalsStoreTremulants = true;
		this.generalsStoreDivisionalCouplers = true;
		this.combinationsStoreNonDisplayedDrawstops = true;
		this.amplitudeLevel = 100;
		this.gain = 0;
		this.pitchTuning = 0;
		this.trackerDelay = 0;
		this.hasPedals = false;
		Panel mainPanel = new Panel();
		m_Panels.add(mainPanel);
	}

	public void read(Tokenizer tok) {
		churchName = tok.readLine();
		amplitudeLevel = tok.readFloatLine();
		pitchTuning = tok.readFloatLine();
		
		Panel mainPanel = m_Panels.get(0);
		mainPanel.m_displayMetrics.dispScreenSizeHoriz = tok.readLine();
		mainPanel.m_displayMetrics.dispScreenSizeVert = tok.readLine();
		mainPanel.m_displayMetrics.dispDrawstopCols = tok.readIntLine();
		mainPanel.m_displayMetrics.dispDrawstopRows = tok.readIntLine();
		mainPanel.m_displayMetrics.dispExtraDrawstopRows = tok.readIntLine();
		mainPanel.m_displayMetrics.dispExtraDrawstopCols = tok.readIntLine();

		boolean loadOneSamplePerPipe = Tokenizer.convertToBoolean(tok
				.readLine());

		int nbSwitches = tok.readIntLine();
		for (int i = 0; i < nbSwitches; i++) {
			Switch sw = new Switch();

			sw.read(tok, mainPanel, i);

			m_Switches.add(sw);
		}

		int nbEnclosures = tok.readIntLine();
		for (int i = 0; i < nbEnclosures; i++) {
			Enclosure enc = new Enclosure();

			enc.read(tok, mainPanel, i);

			m_Enclosures.add(enc);
		}

		int nbTremulants = tok.readIntLine();
		for (int i = 0; i < nbTremulants; i++) {
			Tremulant trem = new Tremulant();

			trem.read(tok, mainPanel, i);

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

			m.read(tok, loadOneSamplePerPipe, mainPanel);

			m_Manuals.add(m);
		}
		// Make sure manuals are sorted according to keyboard code
		Collections.sort(m_Manuals);

		hasPedals = false;

		for (Manual manual : m_Manuals) {
			if (Manual.isPedalCode(manual.keyboardCode)) {
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
			switch_.write(outfile);

			outfile.println();
		}
		
		// Panel section
		if (!m_Panels.isEmpty())
			System.out.println("Writing panel section");
		for (int i = 0; i < m_Panels.size(); i++) {
			outfile.println("[Panel" + NumberUtil.format(i) + "]");
			Panel panel_ = m_Panels.get(i);
			if (i > 0) {
				outfile.println("Name=" + panel_.name);
				outfile.println("Group=" + panel_.group);
			}
			panel_.write(outfile, i);

			outfile.println();
		}
		System.out.println("Done writing ODF file!");
	}

	public void writeHeader(PrintWriter outfile) {
		outfile.println("ChurchName=" + churchName);
		outfile.println("ChurchAddress=" + churchAddress);
		outfile.println("OrganBuilder=" + organBuilder);
		outfile.println("OrganBuildDate=" + organBuildDate);
		outfile.println("OrganComments=" + organComments);
		outfile.println("RecordingDetails=" + recordingDetails);
		outfile.println("InfoFilename=" + infoFilename);
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
		outfile.println("NumberOfDivisionalCouplers=0");
		outfile.println("NumberOfPanels=" + (m_Panels.size() - 1));
		outfile.println("NumberOfRanks=" + m_Ranks.size());
		outfile.println("NumberOfSwitches=" + m_Switches.size());
		if (divisionalsStoreTremulants)
			outfile.println("DivisionalsStoreTremulants=Y");
		else
			outfile.println("DivisionalsStoreTremulants=N");
		if (divisionalsStoreIntermanualCouplers)
			outfile.println("DivisionalsStoreIntermanualCouplers=Y");
		else
			outfile.println("DivisionalsStoreIntermanualCouplers=N");
		if (divisionalsStoreIntramanualCouplers)
			outfile.println("DivisionalsStoreIntramanualCouplers=Y");
		else
			outfile.println("DivisionalsStoreIntramanualCouplers=N");
		if (generalsStoreDivisionalCouplers)
			outfile.println("GeneralsStoreDivisionalCouplers=Y");
		else
			outfile.println("GeneralsStoreDivisionalCouplers=N");
		if (combinationsStoreNonDisplayedDrawstops)
			outfile.println("CombinationsStoreNonDisplayedDrawstops=Y");
		else
			outfile.println("CombinationsStoreNonDisplayedDrawstops=N");
		if (amplitudeLevel != 100)
			outfile.println("AmplitudeLevel=" + amplitudeLevel);
		if (gain != 0)
			outfile.println("Gain=" + gain);
		if (pitchTuning != 0)
			outfile.println("PitchTuning=" + pitchTuning);
		if (trackerDelay != 0)
			outfile.println("TrackerDelay=" + trackerDelay);
	}

}
