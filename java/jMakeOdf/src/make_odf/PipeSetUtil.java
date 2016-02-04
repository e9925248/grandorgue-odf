/* Copyright (c) 2016 Marcin Listkowski, Lars Palo
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

import java.util.List;

public class PipeSetUtil {

	private PipeSetUtil() {
	}

	public static void readPipeSet(IPipeSet pipeSet,
			boolean loadOneSamplePerPipe, List<String> stringParts,
			int pipesThisLine) {
		String loadString = stringParts.get(1);
		switch (loadString.charAt(0)) {
		case 'L':
			readCaseL(stringParts, pipesThisLine, loadOneSamplePerPipe,
					pipeSet, loadString);
			break;
		case 'R':
			readCaseR(stringParts, pipesThisLine, pipeSet, loadString);
			break;
		case 'C':
			readCaseC(stringParts, pipesThisLine, pipeSet, loadString);
			break;
		case 'M':
			readCaseM(stringParts, pipesThisLine, pipeSet);
			break;
		default:
			throw new TextFileParserException("ERROR: Load method "
					+ loadString + " for " + pipeSet.getKindName() + " "
					+ pipeSet.getName() + " is invalid!");
		}
	}

	private static void readCaseL(List<String> stringParts, int nbPipesToLoad,
			boolean loadOneSamplePerPipe, IPipeSet pipeSet, String loadString) {
		String pathToSearch = stringParts.get(2);
		String loadAttRel = stringParts.get(3);
		boolean pipePercussive = Tokenizer.convertToBoolean(stringParts.get(4));
		int startMidiNote = Tokenizer.convertToInt(loadString.substring(1,
				loadString.length()));
		for (int k = 0; k < nbPipesToLoad; k++) {
			Pipe p = Pipe.loadSamples(startMidiNote + k, loadString,
					pathToSearch, loadAttRel, pipePercussive,
					loadOneSamplePerPipe);
			// we don't set isPercussive here as it's set in Pipe.loadSamples
			pipeSet.setBasicAttributes(p);
			pipeSet.addPipe(p);
		}
	}

	private static void readCaseR(List<String> stringParts, int nbPipesToLoad,
			IPipeSet pipeSet, String loadString) {
		int startPipe = Tokenizer.convertToInt(loadString.substring(1,
				loadString.length()));
		String keybCode = stringParts.get(2);
		int stop = Tokenizer.convertToInt(stringParts.get(3));
		for (int k = 0; k < nbPipesToLoad; k++) {
			Pipe p = Pipe.createReference(startPipe + k, keybCode, stop);

			p.isPercussive = pipeSet.isPercussive();
			pipeSet.setBasicAttributes(p);
			pipeSet.addPipe(p);
		}
	}

	private static void readCaseC(List<String> stringParts, int nbPipesToLoad,
			IPipeSet pipeSet, String loadString) {
		int startCopy = Tokenizer.convertToInt(loadString.substring(1,
				loadString.length())) - 1;
		float pitchChange = Tokenizer.convertToFloat(stringParts.get(2));
		for (int k = 0; k < nbPipesToLoad; k++) {
			Pipe source = pipeSet.getPipe(startCopy + k);
			Pipe p = new Pipe(source);
			p.pitchTuning = pitchChange;
			pipeSet.addPipe(p);
		}
	}

	private static void readCaseM(List<String> stringParts, int nbPipesToLoad,
			IPipeSet pipeSet) {
		int nextIndex = 2;
		for (int k = 0; k < nbPipesToLoad; k++) {
			Pipe p = new Pipe();
			Attack a = new Attack();
			a.fileName = stringParts.get(nextIndex);
			nextIndex++;
			if (Tokenizer.convertToBooleanInverted(stringParts.get(nextIndex))) {
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
			p.isPercussive = pipeSet.isPercussive();
			pipeSet.setBasicAttributes(p);
			pipeSet.addPipe(p);
		}
	}

}
