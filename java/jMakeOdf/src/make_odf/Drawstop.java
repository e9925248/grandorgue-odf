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

public class Drawstop extends Button {
	Function function;
	ArrayList<Integer> m_switches = new ArrayList<Integer>();
	boolean defaultToEngaged;
	int gcState;
	boolean storeInDivisional;
	boolean storeInGeneral;

	public Drawstop() {
		super();
		this.function = Function.INPUT;
		this.defaultToEngaged = false;
		this.gcState = 0;
		this.storeInDivisional = true;
		this.storeInGeneral = true;
	}
	
	public void write(PrintWriter outfile) {
		super.write(outfile);
		if (function != Function.INPUT) {
			// The object has switches
			outfile.println("Function=" + function.func);
			outfile.println("SwitchCount=" + m_switches.size());
			OdfWriter.writeReferences(outfile, "Switch", m_switches);
		}
		if (function == Function.INPUT) {
			if (defaultToEngaged)
				outfile.println("DefaultToEngaged=Y");
			else
				outfile.println("DefaultToEngaged=N");
		}
		if (gcState != 0)
			outfile.println("GCState=" + gcState);
		if (!storeInDivisional)
			outfile.println("StoreInDivisional=N");
		if (!storeInGeneral)
			outfile.println("StoreInGeneral=N");
	}
}
