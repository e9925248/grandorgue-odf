/* 
 * NPFrame.h is a part of NoisePipes software
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

#ifndef NPFRAME_H
#define NPFRAME_H

#include <wx/wx.h>
#include <wx/notebook.h>
#include <wx/textctrl.h>
#include <vector>
#include "NPPipe.h"

// Identifiers
enum {
	ID_BROWSE_FOR_ODF_PATH = wxID_HIGHEST + 1,
	ID_BROWSE_FOR_ATTACK_PATH = wxID_HIGHEST + 2,
	ID_BROWSE_FOR_RELEASE_PATH = wxID_HIGHEST + 3,
	ID_GENERATE_PIPES = wxID_HIGHEST + 4
};

class NPFrame : public wxFrame {
public:
	NPFrame(const wxString& title);
	~NPFrame();

	void OnQuit(wxCommandEvent& event);
	void OnAbout(wxCommandEvent& event);

private:
	DECLARE_EVENT_TABLE()

	wxMenu *m_fileMenu;
	wxMenu *m_helpMenu;
	wxMenuBar *m_menuBar;
	wxNotebook *m_notebook;
	wxPanel *m_organpanel;
	wxPanel *m_pipepanel;
	wxString m_odfPath;
	wxString m_attackFolderPath;
	wxString m_releaseFolderPath;
	wxTextCtrl *m_odfPathField;
	wxTextCtrl *m_attackPathField;
	wxTextCtrl *m_releasePathField;
	wxTextCtrl *m_pipesField;
	wxButton *m_genPipesButton;
	wxStaticText *m_doneText;
	std::vector<NPPipe> m_pipes;

	wxString GetOdfDirectoryPath();
	void OnBrowseForOrganPath(wxCommandEvent& event);
	void OnBrowseForAttackPath(wxCommandEvent& event);
	void OnBrowseForReleasePath(wxCommandEvent& event);
	void OnGeneratePipes(wxCommandEvent& event);
	void ReadyToGeneratePipes();
};

#endif
