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

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Scanner;

public class Tokenizer implements AutoCloseable {
	private Scanner scanner;
	private int currentLineNumber = 0;

	public Tokenizer(File f) throws FileNotFoundException {
		this.scanner = new Scanner(f, "ISO-8859-1");
	}

	public String readLine() {
		String result = "";
		try {
			result = scanner.nextLine();
			int idx;
			idx = result.indexOf('*');
			if (idx > 0) {
				// There's a comment to strip
				result = result.substring(0, idx);
			}
			result = result.trim();
			currentLineNumber++;
			return result;
		} catch (NoSuchElementException ne) {
			throw new TextFileParserException(
					"ERROR: Couldn't find a line to read data from!", ne);
		}
	}

	public float readFloatLine() {
		return Tokenizer.convertToFloat(readLine());
	}

	public int readIntLine() {
		return Tokenizer.convertToInt(readLine());
	}

	public void readLineOfReferences(ArrayList<Integer> references) {
		String textLine;
		List<String> stringParts;
		textLine = readLine();
		stringParts = Tokenizer.getParts(textLine);
		Tokenizer.readNumericReferences(stringParts, references);
	}

	public List<String> readAndSplitLine() {
		return getParts(readLine());
	}

	public int getLineNumber() {
		return currentLineNumber;
	}

	@Override
	public void close() {
		this.scanner.close();
	}

	public static void readNumericReferencesOffset1(List<String> stringParts,
			ArrayList<Integer> arrayList) {
		List<String> subList = stringParts.subList(1, stringParts.size());

		readNumericReferences(subList, arrayList);
	}

	public static void readNumericReferences(List<String> list,
			ArrayList<Integer> references) {
		int n = convertToInt(list.get(0));
		for (int k = 0; k < n; k++) {
			references.add(convertToInt(list.get(1 + k)));
		}
	}

	public static int convertToInt(String s) {
		try {
			return Integer.parseInt(s);
		} catch (NumberFormatException nfe) {
			throw new TextFileParserException("ERROR: Couldn't convert " + s
					+ " to an integer value!");
		}
	}

	public static float convertToFloat(String s) {
		try {
			return Float.parseFloat(s);
		} catch (NumberFormatException nfe) {
			throw new TextFileParserException("ERROR: Couldn't convert " + s
					+ " to a floating point value!", nfe);
		}
	}

	public static boolean convertToBoolean(String string) {
		return string.equalsIgnoreCase("yes");
	}

	public static boolean convertToBooleanInverted(String string) {
		return string.equalsIgnoreCase("no");
	}

	private static List<String> getParts(String str) {
		if (str.isEmpty()) {
			throw new TextFileParserException("ERROR: No string to split!");
		}
		List<String> parts = Arrays.asList(str.split(":"));
		if (parts.isEmpty()) {
			throw new TextFileParserException(
					"ERROR: Nothing in the list of strings!");
		}
		return parts;
	}
}
