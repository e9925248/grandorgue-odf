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
		this.scanner = new Scanner(f);
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
