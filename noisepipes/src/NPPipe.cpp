/* 
 * NPPipe.cpp is a part of NoisePipes software
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

#include "NPPipe.h"

NPPipe::NPPipe() {
}

NPPipe::~NPPipe() {
}

void NPPipe::AddPipeAttack(wxString path, unsigned start, unsigned end) {
	ATTACK atk;
	atk.pipePath = path;
	atk.loopStart = start;
	atk.loopEnd = end;
	m_pipeAttacks.push_back(atk);
}

void NPPipe::AddPipeRelease(wxString path) {
	m_pipeReleases.push_back(path);
}

unsigned NPPipe::GetNumberOfAttacks() {
	return m_pipeAttacks.size();
}

unsigned NPPipe::GetNumberOfReleases() {
	return m_pipeReleases.size();
}

wxString NPPipe::GetAttackPath(unsigned idx) {
	if ((!m_pipeAttacks.empty()) && (idx < m_pipeAttacks.size()))
		return m_pipeAttacks[idx].pipePath;
	else
		return wxEmptyString;
}

unsigned NPPipe::GetAttackLoopStart(unsigned idx) {
	if ((!m_pipeAttacks.empty()) && (idx < m_pipeAttacks.size()))
		return m_pipeAttacks[idx].loopStart;
	else
		return 0;
}

unsigned NPPipe::GetAttackLoopEnd(unsigned idx) {
	if ((!m_pipeAttacks.empty()) && (idx < m_pipeAttacks.size()))
		return m_pipeAttacks[idx].loopEnd;
	else
		return 0;
}

wxString NPPipe::GetReleasePath(unsigned idx) {
	if ((!m_pipeReleases.empty()) && (idx < m_pipeReleases.size()))
		return m_pipeReleases[idx];
	else
		return wxEmptyString;
}
