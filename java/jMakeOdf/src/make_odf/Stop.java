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
}
