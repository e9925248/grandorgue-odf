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
import java.util.List;

public class Rank implements IPipeSet {
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
		PipeSetUtil.readPipeSet(this, loadOneSamplePerPipe, stringParts,
				pipesThisLine);
		return pipesThisLine;
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
			Pipe pipe = m_Pipes.get(j);
			pipe.writePipes(outfile, pipeNr, isPercussive);
		}
	}

	public void writeHeader(PrintWriter outfile) {
		outfile.println("Name=" + name);
		outfile.println("FirstMidiNoteNumber=" + firstMidiNoteNumber);
		outfile.println("NumberOfLogicalPipes=" + numberOfLogicalPipes);
		outfile.println("WindchestGroup=" + NumberUtil.format(m_windchestGroup));
		if (isPercussive)
			outfile.println("Percussive=Y");
		else
			outfile.println("Percussive=N");
		if (amplitudeLevel != 100)
			outfile.println("AmplitudeLevel=" + amplitudeLevel);
		if (pitchTuning != 0)
			outfile.println("PitchTuning=" + pitchTuning);
		if (pitchCorrection != 0)
			outfile.println("PitchCorrection=" + pitchCorrection);
		outfile.println("HarmonicNumber=" + harmonicNumber);
	}

	@Override
	public void addPipe(Pipe p) {
		m_Pipes.add(p);
	}

	@Override
	public String getKindName() {
		return "rank";
	}

	@Override
	public String getName() {
		return name;
	}

	@Override
	public Pipe getPipe(int index) {
		return m_Pipes.get(index);
	}

	@Override
	public boolean isPercussive() {
		return isPercussive;
	}

	@Override
	public void setBasicAttributes(Pipe p) {
		p.amplitudeLevel = amplitudeLevel;
		p.harmonicNumber = harmonicNumber;
		p.pitchTuning = pitchTuning;
		p.pitchCorrection = pitchCorrection;
		p.windchestGroup = m_windchestGroup;
	}
}
