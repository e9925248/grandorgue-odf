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
import java.util.List;

public class Rank {
	String name;
	int firstMidiNoteNumber;
	int numberOfLogicalPipes;
	boolean isPercussive;
	float amplitudeLevel;
	int harmonicNumber;
	float pitchTuning;
	float pitchCorrection;
	int m_windchestGroup;
	ArrayList<Pipe> m_Pipes = new ArrayList<Pipe>();

	public Rank() {
		this.name = "";
		this.firstMidiNoteNumber = 36;
		this.numberOfLogicalPipes = 1;
		this.isPercussive = false;
		this.amplitudeLevel = 100;
		this.harmonicNumber = 8;
		this.pitchTuning = 0;
		this.pitchCorrection = 0;
		this.m_windchestGroup = 1;
	}

	int readHeader(Tokenizer tok) {
		List<String> stringParts = tok.readAndSplitLine();
		name = stringParts.get(0);
		int nbPipes = Tokenizer.convertToInt(stringParts.get(1));
		numberOfLogicalPipes = nbPipes;
		firstMidiNoteNumber = Tokenizer.convertToInt(stringParts.get(2));
		amplitudeLevel = Tokenizer.convertToFloat(stringParts.get(3));
		harmonicNumber = Tokenizer.convertToInt(stringParts.get(4));
		pitchTuning = Tokenizer.convertToFloat(stringParts.get(5));
		pitchCorrection = Tokenizer.convertToFloat(stringParts.get(6));
		m_windchestGroup = Tokenizer.convertToInt(stringParts.get(7));
		isPercussive = Tokenizer.convertToBoolean(stringParts.get(8));
		return nbPipes;
	}

	int readPipesLine(Tokenizer tok, boolean loadOneSamplePerPipe) {
		List<String> stringParts = tok.readAndSplitLine();
		int pipesThisLine = Tokenizer.convertToInt(stringParts.get(0));
		String loadString = stringParts.get(1);
		switch (loadString.charAt(0)) {
		case 'L':
			String pathToSearch = stringParts.get(2);
			String loadAttRel = stringParts.get(3);
			boolean pipePercussive = Tokenizer.convertToBoolean(stringParts
					.get(4));
			int startMidiNote = Tokenizer.convertToInt(loadString.substring(1,
					loadString.length()));
			for (int j = 0; j < pipesThisLine; j++) {
				Pipe p = Pipe.loadSamples(startMidiNote + j, loadString,
						pathToSearch, loadAttRel, pipePercussive,
						loadOneSamplePerPipe);
				// FIXME isPercussive - is it omitted here on purpose? compare
				// to next calls of setBasicAttributes
				setBasicAttributes(p);
				m_Pipes.add(p);
			}
			break;
		case 'R':
			int startPipe = Tokenizer.convertToInt(loadString.substring(1,
					loadString.length()));
			String keybCode = stringParts.get(2);
			int stop = Tokenizer.convertToInt(stringParts.get(3));
			for (int j = 0; j < pipesThisLine; j++) {
				Pipe p = Pipe.createReference(startPipe + j, keybCode, stop);
				p.isPercussive = isPercussive;
				setBasicAttributes(p);
				m_Pipes.add(p);
			}
			break;
		case 'C':
			int startCopy = Tokenizer.convertToInt(loadString.substring(1,
					loadString.length())) - 1;
			float pitchChange = Tokenizer.convertToFloat(stringParts.get(2));
			for (int j = 0; j < pipesThisLine; j++) {
				Pipe source = m_Pipes.get(startCopy + j);
				Pipe p = new Pipe(source);
				p.pitchTuning = pitchChange;
				m_Pipes.add(p);
			}
			break;
		case 'M':
			int nextIndex = 2;
			for (int k = 0; k < pipesThisLine; k++) {
				Pipe p = new Pipe();
				Attack a = new Attack();
				a.fileName = stringParts.get(nextIndex);
				nextIndex++;
				if (Tokenizer.convertToBooleanInverted(stringParts
						.get(nextIndex))) {
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
				setBasicAttributes(p);
				m_Pipes.add(p);
			}
			break;
		default:
			throw new TextFileParserException("ERROR: Load method "
					+ loadString + " for stop " + name + " is invalid!");
		}
		return pipesThisLine;
	}

	public void setBasicAttributes(Pipe p) {
		p.amplitudeLevel = amplitudeLevel;
		p.harmonicNumber = harmonicNumber;
		p.pitchTuning = pitchTuning;
		p.pitchCorrection = pitchCorrection;
		p.windchestGroup = m_windchestGroup;
	}

	public void read(Tokenizer tok, boolean loadOneSamplePerPipe) {
		int nbPipes = readHeader(tok);
		System.out.println("Trying to read pipes for rank " + name);
		int processedPipes = 0;
		while (processedPipes < nbPipes) {
			int pipesThisLine = readPipesLine(tok, loadOneSamplePerPipe);
			processedPipes += pipesThisLine;
		}
	}

	public void write(PrintWriter outfile) {
		writeHeader(outfile);
		for (int j = 0; j < m_Pipes.size(); j++) {
			// First attack must always exist
			String pipeNr = "Pipe" + NumberUtil.format(j + 1);
			boolean isRankPercussive = isPercussive;
			Pipe pipe = m_Pipes.get(j);
			pipe.writeInsideRank(outfile, pipeNr, isRankPercussive);
		}
	}

	public void writeHeader(PrintWriter outfile) {
		outfile.println("Name=" + name);
		outfile.println("FirstMidiNoteNumber=" + firstMidiNoteNumber);
		outfile.println("NumberOfLogicalPipes=" + numberOfLogicalPipes);
		outfile.println("WindchestGroup=" + m_windchestGroup);
		if (isPercussive)
			outfile.println("Percussive=Y");
		else
			outfile.println("Percussive=N");
		outfile.println("AmplitudeLevel=" + amplitudeLevel);
		outfile.println("PitchTuning=" + pitchTuning);
		outfile.println("PitchCorrection=" + pitchCorrection);
		outfile.println("HarmonicNumber=" + harmonicNumber);
	}
}
