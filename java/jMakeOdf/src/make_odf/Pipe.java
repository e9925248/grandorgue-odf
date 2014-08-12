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

import java.io.File;
import java.io.FilenameFilter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;

public class Pipe {
	boolean isPercussive;
	float amplitudeLevel;
	int harmonicNumber;
	float pitchTuning;
	float pitchCorrection;
	int windchestGroup;
	int isTremulant;
	ArrayList<Attack> attacks = new ArrayList<Attack>();
	ArrayList<Release> releases = new ArrayList<Release>();

	public Pipe() {
		this.isPercussive = false;
		this.amplitudeLevel = 100;
		this.harmonicNumber = 8;
		this.pitchTuning = 0;
		this.pitchCorrection = 0;
		this.windchestGroup = 1;
		this.isTremulant = -1;
	}

	static Pipe loadSamples(int midiNr, String loadtype, String path,
			String loadAttRel, boolean percussive, boolean loadOneSamplePerPipe) {
		Pipe p = new Pipe();
		File f1 = new File(path);

		String[] tremFolders = listFolder(f1, new TremulantFolderFilter());

		boolean hasTremSamples;
		if (tremFolders.length > 0) {
			hasTremSamples = true;
			p.isTremulant = 0;
		} else {
			hasTremSamples = false;
		}

		MIDINrSampleFilter nrFilter = new MIDINrSampleFilter(midiNr);
		String[] fileList = listFolder(f1, nrFilter);
		for (String str : fileList) {
			Attack a = new Attack();
			a.fileName = path + File.separator + str;
			a.loadRelease = loadAttRel.equalsIgnoreCase("yes");
			a.attackVelocity = 0;
			a.maxKeyPressTime = -1;
			if (hasTremSamples && (!loadOneSamplePerPipe)) {
				a.isTremulant = 0;
			}
			p.attacks.add(a);
			if (loadOneSamplePerPipe)
				break;
		}
		p.isPercussive = percussive;

		// add trem attack samples
		if (hasTremSamples && (!loadOneSamplePerPipe)) {
			for (int i = 0; i < tremFolders.length; i++) {
				File f3 = new File(f1, tremFolders[i]);
				String[] tremSamples = listFolder(f3, nrFilter);
				for (String trems : tremSamples) {
					Attack a = new Attack();
					a.fileName = path + File.separator + tremFolders[i]
							+ File.separator + trems;
					a.loadRelease = loadAttRel.equalsIgnoreCase("yes");
					a.attackVelocity = 0;
					a.maxKeyPressTime = -1;
					a.isTremulant = 1;
					p.attacks.add(a);
				}

				// also take care of possible additional trem releases
				String[] tremRelFolders = listFolder(f3,
						new ReleaseFolderFilter());
				for (String str : tremRelFolders) {
					// extract keypresstime from folder name
					int firstNum = -1;
					int relTime = -1;
					for (int j = 0; j < str.length(); j++) {
						if (Character.isDigit(str.charAt(j))) {
							firstNum = j;
							break;
						}
					}
					if (firstNum > -1) {
						relTime = Tokenizer.convertToInt(str.substring(
								firstNum, str.length()));
					}

					File f4 = new File(f1, str);
					String[] releaseList = listFolder(f4, nrFilter);
					for (String rel : releaseList) {
						Release r = new Release();
						r.fileName = path + File.separator + tremFolders[i]
								+ File.separator + str + File.separator + rel;
						r.maxKeyPressTime = relTime;
						r.isTremulant = 1;
						p.releases.add(r);
					}
				}
			}
		}

		// deal with possible additional releases
		String[] folders = listFolder(f1, new ReleaseFolderFilter());
		for (String str : folders) {
			// extract keypresstime from folder name
			int firstNum = -1;
			int relTime = -1;
			for (int i = 0; i < str.length(); i++) {
				if (Character.isDigit(str.charAt(i))) {
					firstNum = i;
					break;
				}
			}
			if (firstNum > -1) {
				relTime = Tokenizer.convertToInt(str.substring(firstNum,
						str.length()));
			}

			File f2 = new File(f1, str);
			String[] releaseList = listFolder(f2, nrFilter);
			for (String rel : releaseList) {
				Release r = new Release();
				r.fileName = path + File.separator + str + File.separator + rel;
				r.maxKeyPressTime = relTime;
				if (hasTremSamples && (!loadOneSamplePerPipe)) {
					r.isTremulant = 0;
				}
				if (loadOneSamplePerPipe && loadAttRel.equalsIgnoreCase("no")) {
					p.releases.add(r);
					break;
				} else {
					p.releases.add(r);
				}
			}
		}
		return p;
	}

	public static String[] listFolder(File f1, FilenameFilter tremFilter) {
		String[] list = f1.list(tremFilter);
		if (list == null) {
			throw new TextFileParserException("The path " + f1
					+ " does not point to a directory");
		}
		Arrays.sort(list);
		return list;
	}

	static Pipe createReference(int targetPipe, String keybCode, int stop) {
		Pipe p = new Pipe();
		Attack a = new Attack();
		int manual = Manual.translateKeyCode(keybCode);
		String refStr = String.format("REF:%03d:%03d:%03d", manual, stop,
				targetPipe);
		a.fileName = refStr;
		a.loadRelease = true;
		a.attackVelocity = 0;
		a.maxKeyPressTime = -1;
		p.attacks.add(a);
		return p;
	}

	public void writeInsideRank(PrintWriter outfile, String pipeNr,
			boolean isRankPercussive) {
		if (!attacks.get(0).fileName.startsWith("REF")) {
			outfile.println(pipeNr + "=." + File.separator
					+ attacks.get(0).fileName);
			if (attacks.get(0).isTremulant != -1)
				outfile.println(pipeNr + "IsTremulant="
						+ attacks.get(0).isTremulant);
			if (isPercussive != isRankPercussive) {
				if (isPercussive)
					outfile.println("Percussive=Y");
				else
					outfile.println("Percussive=N");
			}
			if (!attacks.get(0).loadRelease)
				outfile.println(pipeNr + "LoadRelease=N");
			// Deal with possible additional attacks
			if (attacks.size() > 1) {
				outfile.println(pipeNr + "AttackCount=" + (attacks.size() - 1));
				for (int k = 1; k < attacks.size(); k++) {
					outfile.println(pipeNr + "Attack"
							+ String.format("%03d", k) + "=." + File.separator
							+ attacks.get(k).fileName);
					if (attacks.get(k).isTremulant != -1)
						outfile.println(pipeNr + "Attack"
								+ String.format("%03d", k) + "IsTremulant="
								+ attacks.get(k).isTremulant);
					if (!attacks.get(k).loadRelease)
						outfile.println(pipeNr + "Attack"
								+ String.format("%03d", k) + "LoadRelease=N");
				}
			}
			// Deal with possible additional releases
			if (!releases.isEmpty()) {
				outfile.println(pipeNr + "ReleaseCount=" + releases.size());
				for (int k = 0; k < releases.size(); k++) {
					outfile.println(pipeNr + "Release"
							+ String.format("%03d", (k + 1)) + "=."
							+ File.separator + releases.get(k).fileName);
					outfile.println(pipeNr + "Release"
							+ String.format("%03d", (k + 1))
							+ "MaxKeyPressTime="
							+ releases.get(k).maxKeyPressTime);
					if (releases.get(k).isTremulant != -1)
						outfile.println(pipeNr + "Release"
								+ String.format("%03d", (k + 1))
								+ "IsTremulant=" + releases.get(k).isTremulant);
				}
			}
		} else {
			outfile.println(pipeNr + "=" + attacks.get(0).fileName);
		}
	}

	public void writeInsideStop(PrintWriter outfile, Stop stop, String pipeNr) {
		if (!attacks.get(0).fileName.startsWith("REF")) {
			outfile.println(pipeNr + "=." + File.separator
					+ attacks.get(0).fileName);
			if (attacks.get(0).isTremulant != -1)
				outfile.println(pipeNr + "IsTremulant="
						+ attacks.get(0).isTremulant);
			if (pitchTuning != 0)
				outfile.println(pipeNr + "PitchTuning=" + pitchTuning);
			if (isPercussive != stop.isPercussive) {
				if (isPercussive)
					outfile.println("Percussive=Y");
				else
					outfile.println("Percussive=N");
			}
			if (!attacks.get(0).loadRelease)
				outfile.println(pipeNr + "LoadRelease=N");
			// Deal with possible additional attacks
			if (attacks.size() > 1) {
				outfile.println(pipeNr + "AttackCount=" + (attacks.size() - 1));
				for (int l = 1; l < attacks.size(); l++) {
					outfile.println(pipeNr + "Attack"
							+ String.format("%03d", l) + "=." + File.separator
							+ attacks.get(l).fileName);
					if (attacks.get(l).isTremulant != -1)
						outfile.println(pipeNr + "Attack"
								+ String.format("%03d", l) + "IsTremulant="
								+ attacks.get(l).isTremulant);
					if (!attacks.get(l).loadRelease)
						outfile.println(pipeNr + "Attack"
								+ String.format("%03d", l) + "LoadRelease=N");
				}
			}
			// Deal with possible additional releases
			if (!releases.isEmpty()) {
				outfile.println(pipeNr + "ReleaseCount=" + releases.size());
				for (int l = 0; l < releases.size(); l++) {
					outfile.println(pipeNr + "Release"
							+ String.format("%03d", (l + 1)) + "=."
							+ File.separator + releases.get(l).fileName);
					outfile.println(pipeNr + "Release"
							+ String.format("%03d", (l + 1))
							+ "MaxKeyPressTime="
							+ releases.get(l).maxKeyPressTime);
					if (releases.get(l).isTremulant != -1)
						outfile.println(pipeNr + "Release"
								+ String.format("%03d", (l + 1))
								+ "IsTremulant=" + releases.get(l).isTremulant);
				}
			}
		} else {
			outfile.println(pipeNr + "=" + attacks.get(0).fileName);
		}
	}
}
