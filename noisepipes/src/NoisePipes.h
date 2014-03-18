/* 
 * NoisePipes is a software to help organ definition file creation for
 * the virtual pipe organ application GrandOrgue
 * Copyright (C) 2013 Lars Palo 
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * You can contact the author on larspalo(at)yahoo.se
 */

#ifndef NOISEPIPES_H
#define NOISEPIPES_H

#include <wx/wx.h>
#include "NPFrame.h"

class NoisePipesApp : public wxApp {
public:
	virtual bool OnInit();
	int OnExit();
	NPFrame *m_frame;
};

DECLARE_APP(NoisePipesApp)

#endif
