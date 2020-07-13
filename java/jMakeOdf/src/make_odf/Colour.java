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

public enum Colour {
	BLACK("Black"),
	BLUE("Blue"),
	DARK_BLUE("Dark blue"),
	GREEN("Green"),
	DARK_GREEN("Dark green"),
	CYAN("Cyan"),
	DARK_CYAN("Dark cyan"),
	RED("Red"),
	DARK_RED("Dark red"),
	MAGENTA("Magenta"),
	DARK_MAGENTA("Dark magenta"),
	YELLOW("Yellow"),
	DARK_YELLOW("Dark yellow"),
	LIGHT_GREY("Light grey"),
	DARK_GREY("Dark grey"),
	WHITE("White"),
	BROWN("Brown"),
	HTML("Html");
	
	public final String colour;
	private String HtmlColour;

	public String getHtmlColour() {
		return HtmlColour;
	}

	public void setHtmlColour(String htmlColour) {
		HtmlColour = htmlColour;
	}

	Colour(String str) {
		colour = str;
	}
}
