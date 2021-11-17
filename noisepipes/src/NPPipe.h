/* 
 * NPPipe.h is a part of NoisePipes software
 * Copyright (C) 2021 Lars Palo 
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

#ifndef NPPIPE_H
#define NPPIPE_H

#include <wx/wx.h>
#include <vector>

typedef struct {
	wxString pipePath;
	unsigned loopStart;
	unsigned loopEnd;
} ATTACK;

class NPPipe {
public:
	NPPipe();
	~NPPipe();

	void AddPipeAttack(wxString path, unsigned start, unsigned end);
	void AddPipeRelease(wxString path);

	unsigned GetNumberOfAttacks();
	unsigned GetNumberOfReleases();
	wxString GetAttackPath(unsigned idx);
	unsigned GetAttackLoopStart(unsigned idx);
	unsigned GetAttackLoopEnd(unsigned idx);
	wxString GetReleasePath(unsigned idx);

private:
	std::vector<ATTACK> m_pipeAttacks;
	std::vector<wxString> m_pipeReleases;
};

#endif
