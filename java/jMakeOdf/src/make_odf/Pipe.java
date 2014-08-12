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

		TremulantFolderFilter tremFilter = new TremulantFolderFilter();
		String[] tremFolders = f1.list(tremFilter);
		Arrays.sort(tremFolders);
		boolean hasTremSamples;
		if (tremFolders.length > 0) {
			hasTremSamples = true;
			p.isTremulant = 0;
		} else {
			hasTremSamples = false;
		}

		MIDINrSampleFilter nrFilter = new MIDINrSampleFilter(midiNr);
		String[] fileList = f1.list(nrFilter);
		Arrays.sort(fileList);
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
				String[] tremSamples = f3.list(nrFilter);
				Arrays.sort(tremSamples);
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
				ReleaseFolderFilter rff = new ReleaseFolderFilter();
				String[] tremRelFolders = f3.list(rff);
				Arrays.sort(tremRelFolders);
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
					String[] releaseList = f4.list(nrFilter);
					Arrays.sort(releaseList);
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
		ReleaseFolderFilter rff = new ReleaseFolderFilter();
		String[] folders = f1.list(rff);
		Arrays.sort(folders);
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
			String[] releaseList = f2.list(nrFilter);
			Arrays.sort(releaseList);
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
}
