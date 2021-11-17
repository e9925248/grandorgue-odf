/* 
 * NoisePipes is a software to help organ definition file creation for
 * the virtual pipe organ application GrandOrgue
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

#include "NoisePipes.h"
#include "NPDef.h"
#include "wx/image.h"
#include <wx/filename.h>
#include <wx/stdpaths.h>

IMPLEMENT_APP(NoisePipesApp)

bool NoisePipesApp::OnInit() {
	// Create the frame window
	wxString fullAppName = wxT("NoisePipes ");
	fullAppName.Append(wxT(NP_VERSION));

	m_frame = new NPFrame(fullAppName);

	wxFileName fn(wxStandardPaths::Get().GetExecutablePath());
	fn = fn.GetPath();
	wxString BaseDir = fn.GetPath();
	wxString ResourceDir = BaseDir + wxFILE_SEP_PATH + wxT("share");

	// load icons
	wxImage::AddHandler(new wxPNGHandler);
	m_icons = wxIconBundle(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/16x16/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/24x24/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/32x32/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/48x48/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/64x64/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/128x128/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/256x256/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/512x512/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));
	m_icons.AddIcon(wxIcon(ResourceDir + wxFILE_SEP_PATH + wxT("icons/hicolor/1024x1024/apps/NoisePipes.png"), wxBITMAP_TYPE_PNG));

	m_frame->SetIcons(m_icons);

	// Show the frame
	m_frame->Show(true);

	// Start the event loop
	return true;
}

int NoisePipesApp::OnExit() {
	return wxApp::OnExit();
}
