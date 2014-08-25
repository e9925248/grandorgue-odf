/* Copyright (c) 2014 Marcin Listkowski, Lars Palo
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

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.ArrayList;

public class OdfWriter {
	public OdfWriter() {
	}

	public void write(Organ org, String fileName) {
		System.out.println("Writing ODF file " + fileName);

		try (PrintWriter outfile = new PrintWriter(new BufferedWriter(
				new OutputStreamWriter(new FileOutputStream(fileName), "ISO-8859-1")));) {
			org.write(outfile);

		} catch (IOException ie) {
			throw new OdfWriterException("ERROR: Couldn't write ODF file!", ie);
		}
	}

	public static void writeReferences(PrintWriter outfile, String elementName,
			ArrayList<Integer> list) {
		for (int k = 0; k < list.size(); k++) {
			outfile.println(elementName + NumberUtil.format(k + 1) + "="
					+ list.get(k));
		}
	}
}
