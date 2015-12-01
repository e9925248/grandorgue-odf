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
import java.util.List;

public class Stop extends Drawstop implements IPipeSet {
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

	void readHeader(Tokenizer tok, Panel p, int orderNr, String keyboardCode) {
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
		isPercussive = Tokenizer.convertToBoolean(stringParts.get(8));
		defaultToEngaged = Tokenizer.convertToBoolean(stringParts.get(9));
		boolean isDisplayed = Tokenizer.convertToBoolean(stringParts.get(10));
		if (isDisplayed) {
			GUIElement element = new GUIElement();
			element.type = "Stop";
			GUIElement.GUIStop stop = element.new GUIStop();
			stop.keyboardCode = keyboardCode;
			stop.stop = orderNr + 1;
			stop.dispImageNum = Tokenizer.convertToInt(stringParts.get(11));
			stop.dispDrawstopCol = Tokenizer.convertToInt(stringParts.get(12));
			stop.dispDrawstopRow = Tokenizer.convertToInt(stringParts.get(13));
			stop.textBreakWidth = Tokenizer.convertToInt(stringParts.get(14));
			element.m_elements.add(stop);
			p.m_GUIElements.add(element);
		}
	}

	int readPipesPortion(List<String> stringParts, int pipesLoaded,
			int nbPipesToLoad, boolean loadOneSamplePerPipe) {
		if (nbPipesToLoad > 0) {
			// The stop have it's own pipes to load
			PipeSetUtil.readPipeSet(this, loadOneSamplePerPipe, stringParts,
					nbPipesToLoad);
			pipesLoaded += nbPipesToLoad;
		} else {
			// The stops have ranks instead
			Tokenizer.readNumericReferencesOffset1(stringParts, m_Ranks);
			pipesLoaded = numberOfAccessiblePipes;
		}
		return pipesLoaded;
	}

	public void read(Tokenizer tok, boolean loadOneSamplePerPipe, Panel p, int orderNr, String keyboardCode) {
		List<String> stringParts;
		readHeader(tok, p, orderNr, keyboardCode);

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

	public void write(PrintWriter outfile) {
		super.write(outfile);
		if (!m_Ranks.isEmpty()) {
			// This stop has ranks
			outfile.println("NumberOfRanks=" + m_Ranks.size());
			OdfWriter.writeReferences(outfile, "Rank", m_Ranks);
			outfile.println("NumberOfAccessiblePipes="
					+ numberOfAccessiblePipes);
			outfile.println("FirstAccessiblePipeLogicalKeyNumber="
					+ firstAccessiblePipeLogicalKeyNumber);
		} else {
			outfile.println("NumberOfLogicalPipes=" + numberOfAccessiblePipes);
			outfile.println("NumberOfAccessiblePipes="
					+ numberOfAccessiblePipes);
			outfile.println("FirstAccessiblePipeLogicalPipeNumber="
					+ firstAccessiblePipeLogicalPipeNumber);
			outfile.println("FirstAccessiblePipeLogicalKeyNumber="
					+ firstAccessiblePipeLogicalKeyNumber);
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
		if (m_Ranks.isEmpty()) {
			// This stop has pipes
			for (int k = 0; k < m_Pipes.size(); k++) {
				// First attack must always exist
				String pipeNr = "Pipe" + NumberUtil.format(k + 1);
				Pipe pipe = m_Pipes.get(k);
				pipe.writePipes(outfile, pipeNr, isPercussive);
			}
		}
	}

	@Override
	public void addPipe(Pipe p) {
		m_Pipes.add(p);
	}

	@Override
	public String getKindName() {
		return "stop";
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
