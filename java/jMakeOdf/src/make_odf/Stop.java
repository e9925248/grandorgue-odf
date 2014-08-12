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
import java.util.List;

public class Stop extends Drawstop {
	ArrayList<Integer> m_Ranks = new ArrayList<Integer>();
	int firstAccessiblePipeLogicalKeyNumber;
	int numberOfAccessiblePipes;
	int firstAccessiblePipeLogicalPipeNumber;
	boolean isPercussive;
	float amplitudeLevel;
	int harmonicNumber;
	float pitchTuning;
	float pitchCorrection;
	int m_windchestGroup;
	ArrayList<Pipe> m_Pipes = new ArrayList<Pipe>();

	public Stop() {
		super();
		this.firstAccessiblePipeLogicalKeyNumber = 1;
		this.numberOfAccessiblePipes = 1;
		this.firstAccessiblePipeLogicalPipeNumber = 1;
		this.isPercussive = false;
		this.amplitudeLevel = 100;
		this.harmonicNumber = 8;
		this.pitchTuning = 0;
		this.pitchCorrection = 0;
		this.m_windchestGroup = 1;
	}

	void readHeader(Tokenizer tok) {
		List<String> stringParts = tok.readAndSplitLine();
		name = stringParts.get(0);
		numberOfAccessiblePipes = Tokenizer.convertToInt(stringParts.get(1));
		firstAccessiblePipeLogicalKeyNumber = Tokenizer
				.convertToInt(stringParts.get(2));
		amplitudeLevel = Tokenizer.convertToFloat(stringParts.get(3));
		harmonicNumber = Tokenizer.convertToInt(stringParts.get(4));
		pitchTuning = Tokenizer.convertToFloat(stringParts.get(5));
		pitchCorrection = Tokenizer.convertToFloat(stringParts.get(6));
		m_windchestGroup = Tokenizer.convertToInt(stringParts.get(7));
		if (stringParts.get(8).equalsIgnoreCase("yes"))
			isPercussive = true;
		else
			isPercussive = false;
		if (stringParts.get(9).equalsIgnoreCase("yes"))
			defaultToEngaged = true;
		else
			defaultToEngaged = false;
		if (stringParts.get(10).equalsIgnoreCase("yes")) {
			displayed = true;
			dispImageNum = Tokenizer.convertToInt(stringParts.get(11));
			dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(12));
			dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(13));
			textBreakWidth = Tokenizer.convertToInt(stringParts.get(14));
		} else {
			displayed = false;
		}
	}

	int readPipesPortion(List<String> stringParts, int pipesLoaded,
			int nbPipesToLoad, boolean loadOneSamplePerPipe) {
		if (nbPipesToLoad > 0) {
			// The stop have it's own pipes to load
			String loadString = stringParts.get(1);
			switch (loadString.charAt(0)) {
			case 'L':
				String pathToSearch = stringParts.get(2);
				String loadAttRel = stringParts.get(3);
				boolean pipePercussive = stringParts.get(4).equalsIgnoreCase(
						"yes");
				int startMidiNote = Tokenizer.convertToInt(loadString
						.substring(1, loadString.length()));
				for (int k = 0; k < nbPipesToLoad; k++) {
					Pipe p = Pipe.loadSamples(startMidiNote + k, loadString,
							pathToSearch, loadAttRel, pipePercussive,
							loadOneSamplePerPipe);
					p.amplitudeLevel = amplitudeLevel;
					p.harmonicNumber = harmonicNumber;
					p.pitchTuning = pitchTuning;
					p.pitchCorrection = pitchCorrection;
					p.windchestGroup = m_windchestGroup;
					m_Pipes.add(p);
				}
				break;
			case 'R':
				int startPipe = Tokenizer.convertToInt(loadString.substring(1,
						loadString.length()));
				String keybCode = stringParts.get(2);
				int stop = Tokenizer.convertToInt(stringParts.get(3));
				for (int k = 0; k < nbPipesToLoad; k++) {
					Pipe p = new Pipe();
					p = Pipe.createReference(startPipe + k, keybCode, stop);
					p.isPercussive = isPercussive;
					p.amplitudeLevel = amplitudeLevel;
					p.harmonicNumber = harmonicNumber;
					p.pitchTuning = pitchTuning;
					p.pitchCorrection = pitchCorrection;
					p.windchestGroup = m_windchestGroup;
					m_Pipes.add(p);
				}
				break;
			case 'C':
				int startCopy = Tokenizer.convertToInt(loadString.substring(1,
						loadString.length())) - 1;
				float pitchChange = Tokenizer
						.convertToFloat(stringParts.get(2));
				for (int k = 0; k < nbPipesToLoad; k++) {
					Pipe p = new Pipe();
					p.pitchTuning = pitchChange;
					p.isPercussive = m_Pipes.get(startCopy + k).isPercussive;
					p.amplitudeLevel = m_Pipes.get(startCopy + k).amplitudeLevel;
					p.harmonicNumber = m_Pipes.get(startCopy + k).harmonicNumber;
					p.pitchCorrection = m_Pipes.get(startCopy + k).pitchCorrection;
					p.windchestGroup = m_Pipes.get(startCopy + k).windchestGroup;
					p.isTremulant = m_Pipes.get(startCopy + k).isTremulant;
					for (int l = 0; l < m_Pipes.get(startCopy + k).attacks
							.size(); l++) {
						Attack a = new Attack();
						a.fileName = m_Pipes.get(startCopy + k).attacks.get(l).fileName;
						a.loadRelease = m_Pipes.get(startCopy + k).attacks
								.get(l).loadRelease;
						a.attackVelocity = m_Pipes.get(startCopy + k).attacks
								.get(l).attackVelocity;
						a.maxKeyPressTime = m_Pipes.get(startCopy + k).attacks
								.get(l).maxKeyPressTime;
						a.isTremulant = m_Pipes.get(startCopy + k).attacks
								.get(l).isTremulant;
						p.attacks.add(a);
					}
					for (int l = 0; l < m_Pipes.get(startCopy + k).releases
							.size(); l++) {
						Release r = new Release();
						r.fileName = m_Pipes.get(startCopy + k).releases.get(l).fileName;
						r.maxKeyPressTime = m_Pipes.get(startCopy + k).releases
								.get(l).maxKeyPressTime;
						r.isTremulant = m_Pipes.get(startCopy + k).releases
								.get(l).isTremulant;
						p.releases.add(r);
					}
					m_Pipes.add(p);
				}
				break;
			case 'M':
				int nextIndex = 2;
				for (int k = 0; k < nbPipesToLoad; k++) {
					Pipe p = new Pipe();
					Attack a = new Attack();
					a.fileName = stringParts.get(nextIndex);
					nextIndex++;
					if (stringParts.get(nextIndex).equalsIgnoreCase("no")) {
						a.loadRelease = false;
						a.attackVelocity = 0;
						a.maxKeyPressTime = -1;
						nextIndex++;
						p.attacks.add(a);
						Release r = new Release();
						r.fileName = stringParts.get(nextIndex);
						nextIndex++;
						p.releases.add(r);
					} else {
						a.loadRelease = true;
						a.attackVelocity = 0;
						a.maxKeyPressTime = -1;
						nextIndex++;
						p.attacks.add(a);
					}
					p.isPercussive = isPercussive;
					p.amplitudeLevel = amplitudeLevel;
					p.harmonicNumber = harmonicNumber;
					p.pitchTuning = pitchTuning;
					p.pitchCorrection = pitchCorrection;
					p.windchestGroup = m_windchestGroup;
					m_Pipes.add(p);
				}
				break;
			default:
				throw new TextFileParserException("ERROR: Load method "
						+ loadString + " for stop " + name + " is invalid!");
			}
			pipesLoaded += nbPipesToLoad;
		} else {
			// The stops have ranks instead
			Tokenizer.readNumericReferencesOffset1(stringParts, m_Ranks);
			pipesLoaded = numberOfAccessiblePipes;
		}
		return pipesLoaded;
	}

	public void read(Tokenizer tok, boolean loadOneSamplePerPipe) {
		List<String> stringParts;
		readHeader(tok);

		int pipesLoaded = 0;
		System.out.println("Trying to read pipes for stop " + name);
		while (pipesLoaded < numberOfAccessiblePipes) {
			stringParts = tok.readAndSplitLine();

			int nbPipesToLoad = Tokenizer.convertToInt(stringParts.get(0));
			pipesLoaded = readPipesPortion(stringParts, pipesLoaded,
					nbPipesToLoad, loadOneSamplePerPipe);
		}

		stringParts = tok.readAndSplitLine();

		function = Enum.valueOf(Function.class, stringParts.get(0)
				.toUpperCase());
		Tokenizer.readNumericReferencesOffset1(stringParts, m_switches);
	}
}
