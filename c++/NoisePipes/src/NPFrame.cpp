/*
 * NPFrame.cpp is a part of NoisePipes software
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

#include "NPFrame.h"
#include <wx/aboutdlg.h>
#include <wx/dirdlg.h>
#include <wx/button.h>
#include <wx/dir.h>
#include <sndfile.hh>

// Event table
BEGIN_EVENT_TABLE(NPFrame, wxFrame)
	EVT_MENU(wxID_ABOUT, NPFrame::OnAbout)
	EVT_MENU(wxID_EXIT, NPFrame::OnQuit)
	EVT_BUTTON(ID_BROWSE_FOR_ODF_PATH, NPFrame::OnBrowseForOrganPath)
	EVT_BUTTON(ID_BROWSE_FOR_ATTACK_PATH, NPFrame::OnBrowseForAttackPath)
	EVT_BUTTON(ID_BROWSE_FOR_RELEASE_PATH, NPFrame::OnBrowseForReleasePath)
	EVT_BUTTON(ID_GENERATE_PIPES, NPFrame::OnGeneratePipes)
END_EVENT_TABLE()

NPFrame::NPFrame(const wxString& title) : wxFrame(NULL, wxID_ANY, title) {
	m_odfPath = wxEmptyString;
	m_attackFolderPath = wxEmptyString;
	m_releaseFolderPath = wxEmptyString;

	// Create a file menu
	m_fileMenu = new wxMenu();

	// Add file menu items
	m_fileMenu->Append(wxID_EXIT, wxT("&Exit\tAlt-X"), wxT("Quit this program"));

	// Create a help menu
	m_helpMenu = new wxMenu();

	// Add help menu items
	m_helpMenu->Append(wxID_ABOUT, wxT("&About...\tF1"), wxT("Show about dialog"));

	// Create a menu bar and append the menus to it
	m_menuBar = new wxMenuBar();
	m_menuBar->Append(m_fileMenu, wxT("&File"));
	m_menuBar->Append(m_helpMenu, wxT("&Help"));

	// Attach menu bar to frame
	SetMenuBar(m_menuBar);

	// Create Status bar
	CreateStatusBar(3);
	SetStatusText(wxT("Ready"), 0);

	SetBackgroundColour(wxT("#f4f2ef"));

	m_notebook = new wxNotebook(
		this,
		wxID_ANY,
		wxDefaultPosition,
		wxDefaultSize,
		0,
		wxT("Workspace")
	);
	m_organpanel = new wxPanel(m_notebook, wxID_ANY);
	m_pipepanel = new wxPanel(m_notebook, wxID_ANY);
	m_notebook->AddPage(m_organpanel, wxT("Organ"), true);
	m_notebook->AddPage(m_pipepanel, wxT("Pipes"), false);

	// Create a top level sizer for the organpanel
	wxBoxSizer *topSizer = new wxBoxSizer(wxVERTICAL);
	m_organpanel->SetSizer(topSizer);

	// Create a top level sizer for the pipepanel
	wxBoxSizer *outSizer = new wxBoxSizer(wxVERTICAL);
	m_pipepanel->SetSizer(outSizer);

	// Second box sizer to get nice margins
	wxBoxSizer *boxSizer = new wxBoxSizer(wxVERTICAL);
	topSizer->Add(boxSizer, 1, wxEXPAND|wxALL, 5);

	// Horizontal sizer for first row
	wxBoxSizer *firstRow = new wxBoxSizer(wxHORIZONTAL);
	boxSizer->Add(firstRow, 0, wxGROW|wxALL, 5);

	// Label for the organ file path
	wxStaticText *organPathText = new wxStaticText ( 
		m_organpanel, 
		wxID_STATIC,
		wxT("The .organ file path")
	);
	firstRow->Add(organPathText, 0, wxALL, 5);

	// The odf path textctrl
	m_odfPathField = new wxTextCtrl(
		m_organpanel,
		wxID_ANY,
		wxEmptyString,
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_READONLY
	);
	firstRow->Add(m_odfPathField, 1, wxEXPAND|wxALL, 5);

	// The browse for path button
	wxButton *selectPath = new wxButton(
		m_organpanel,
		ID_BROWSE_FOR_ODF_PATH,
		wxT("Browse..."),
		wxDefaultPosition,
		wxDefaultSize,
		0
	);
	firstRow->Add(selectPath, 0, wxALL, 5);

	// Horizontal sizer for second row
	wxBoxSizer *secondRow = new wxBoxSizer(wxHORIZONTAL);
	boxSizer->Add(secondRow, 0, wxGROW|wxALL, 5);

	// Label for the organ file path
	wxStaticText *attackPathText = new wxStaticText ( 
		m_organpanel, 
		wxID_STATIC,
		wxT("Attack samples folder: ")
	);
	secondRow->Add(attackPathText, 0, wxALL, 5);

	// The odf path textctrl
	m_attackPathField = new wxTextCtrl(
		m_organpanel,
		wxID_ANY,
		wxEmptyString,
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_READONLY
	);
	secondRow->Add(m_attackPathField, 1, wxEXPAND|wxALL, 5);

	// The browse for path button
	wxButton *atkPath = new wxButton(
		m_organpanel,
		ID_BROWSE_FOR_ATTACK_PATH,
		wxT("Browse..."),
		wxDefaultPosition,
		wxDefaultSize,
		0
	);
	secondRow->Add(atkPath, 0, wxALL, 5);

	// Horizontal sizer for third row
	wxBoxSizer *thirdRow = new wxBoxSizer(wxHORIZONTAL);
	boxSizer->Add(thirdRow, 0, wxGROW|wxALL, 5);

	// Label for the organ file path
	wxStaticText *releasePathText = new wxStaticText ( 
		m_organpanel, 
		wxID_STATIC,
		wxT("Release samples folder: ")
	);
	thirdRow->Add(releasePathText, 0, wxALL, 5);

	// The odf path textctrl
	m_releasePathField = new wxTextCtrl(
		m_organpanel,
		wxID_ANY,
		wxEmptyString,
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_READONLY
	);
	thirdRow->Add(m_releasePathField, 1, wxEXPAND|wxALL, 5);

	// The browse for path button
	wxButton *relPath = new wxButton(
		m_organpanel,
		ID_BROWSE_FOR_RELEASE_PATH,
		wxT("Browse..."),
		wxDefaultPosition,
		wxDefaultSize,
		0
	);
	thirdRow->Add(relPath, 0, wxALL, 5);

	// Horizontal sizer for fourth row
	wxBoxSizer *fourthRow = new wxBoxSizer(wxHORIZONTAL);
	boxSizer->Add(fourthRow, 0, wxGROW|wxALL, 5);

	// The generate pipes button
	m_genPipesButton = new wxButton(
		m_organpanel,
		ID_GENERATE_PIPES,
		wxT("Generate Pipes"),
		wxDefaultPosition,
		wxDefaultSize,
		0
	);
	m_genPipesButton->Enable(false);
	fourthRow->Add(m_genPipesButton, 0, wxALL, 5);

	// Label for the process done text
	m_doneText = new wxStaticText ( 
		m_organpanel, 
		wxID_STATIC,
		wxEmptyString
	);
	fourthRow->Add(m_doneText, 0, wxALL, 5);

	// The pipes field textctrl
	m_pipesField = new wxTextCtrl(
		m_pipepanel,
		wxID_ANY,
		wxEmptyString,
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_READONLY|wxTE_MULTILINE
	);
	outSizer->Add(m_pipesField, 1, wxEXPAND|wxALL, 2);
}

NPFrame::~NPFrame() {
}

void NPFrame::OnAbout(wxCommandEvent& event) {
	wxAboutDialogInfo info;
	info.SetName(wxT("NoisePipes"));
	info.SetVersion(wxT("0.1"));
	info.SetDescription(wxT("This program creates the necessary lines for an .organ file of GrandOrgue to use noise effects with separate attacks and releases and no markers."));
	info.SetCopyright(wxT("Copyright (C) 2013 Lars Palo <larspalo AT yahoo DOT se>\nReleased under GNU GPLv3 licence"));
	info.SetWebSite(wxT("https://github.com/larspalo/noisepipes.git"));

	wxAboutBox(info);
}

void NPFrame::OnQuit(wxCommandEvent& event) {
	// Destroy the frame
	Close();
}

wxString NPFrame::GetOdfDirectoryPath() {
	wxString pathToReturn;
	wxString defaultPath;
	if (m_odfPath != wxEmptyString)
		defaultPath = m_odfPath;
	else
		defaultPath = wxT("/");

	wxDirDialog dirDialog(
		this,
		wxT("Pick a directory"),
		defaultPath,
		wxDD_DIR_MUST_EXIST
	);

	if (dirDialog.ShowModal() == wxID_OK) {
		pathToReturn = dirDialog.GetPath();
		return pathToReturn;
	} else {
		return wxEmptyString;
	}
}

void NPFrame::OnBrowseForOrganPath(wxCommandEvent& event) {
	m_odfPath = GetOdfDirectoryPath();
	m_odfPathField->SetValue(m_odfPath);
	ReadyToGeneratePipes();
}

void NPFrame::OnBrowseForAttackPath(wxCommandEvent& event) {
	m_attackFolderPath = GetOdfDirectoryPath();
	m_attackPathField->SetValue(m_attackFolderPath);
	ReadyToGeneratePipes();
}

void NPFrame::OnBrowseForReleasePath(wxCommandEvent& event) {
	m_releaseFolderPath = GetOdfDirectoryPath();
	m_releasePathField->SetValue(m_releaseFolderPath);
	ReadyToGeneratePipes();
}

void NPFrame::ReadyToGeneratePipes() {
	if ((m_odfPathField->GetValue() != wxEmptyString) &&
		(m_attackPathField->GetValue() != wxEmptyString) &&
		(m_releasePathField->GetValue() != wxEmptyString))
		m_genPipesButton->Enable(true);
}

void NPFrame::OnGeneratePipes(wxCommandEvent& event) {
	m_pipesField->Clear();
	if (!m_pipes.empty())
		m_pipes.clear();

	// List all .wav files in the attack folder
	wxArrayString *atkFiles = new wxArrayString;
	wxDir atkDir(m_attackFolderPath);
	if (atkDir.IsOpened()) {
		atkDir.GetAllFiles(
			m_attackFolderPath,
			atkFiles,
			wxT("*.wav"),
			wxDIR_FILES
		);
	}

	// List all .wav files in the release folder
	wxArrayString *relFiles = new wxArrayString;
	wxDir relDir(m_releaseFolderPath);
	if (relDir.IsOpened()) {
		relDir.GetAllFiles(
			m_releaseFolderPath,
			relFiles,
			wxT("*.wav"),
			wxDIR_FILES
		);
	}

	// Remove unnecessary part of file names
	if (!atkFiles->IsEmpty()) {
		atkFiles->Sort();
		for (int i = 0; i < atkFiles->GetCount(); i++) {
			atkFiles->Item(i).Replace(m_attackFolderPath, wxT(""));
			atkFiles->Item(i).erase(0, 1);
		}
	}
	if (!relFiles->IsEmpty()) {
		relFiles->Sort();
		for (int i = 0; i < relFiles->GetCount(); i++) {
			relFiles->Item(i).Replace(m_releaseFolderPath, wxT(""));
			relFiles->Item(i).erase(0, 1);
		}
	}

	// Sort attacks and releases into pipes and
	// get numbers of frames in the attacks to calculate loop start and end
	if (!atkFiles->IsEmpty()) {
		wxString fileName;
		for (unsigned i = 0; i < atkFiles->GetCount(); i++) {
			if (atkFiles->Item(i) != wxEmptyString) {
				NPPipe currentPipe;
				fileName = m_attackFolderPath;
				fileName.append(wxT("/"));
				fileName.append(atkFiles->Item(i));
				SndfileHandle sfh;
				unsigned fileLength = 0;
				sfh = SndfileHandle(((const char*)fileName.mb_str()));

				if (sfh)
					fileLength = sfh.frames();

				currentPipe.AddPipeAttack(atkFiles->Item(i), fileLength - 2, fileLength - 1);

				wxString numberPart;
				numberPart = atkFiles->Item(i).Mid(0, 3);
				atkFiles->Item(i) = wxEmptyString;

				for (unsigned j = i; j < atkFiles->GetCount(); j++) {
					wxString compareWith;
					compareWith = atkFiles->Item(j).Mid(0, 3);
					if (compareWith.IsSameAs(numberPart)) {
						fileName = m_attackFolderPath;
						fileName.append(wxT("/"));
						fileName.append(atkFiles->Item(j));
						SndfileHandle sfHandle;
						sfHandle = SndfileHandle(((const char*)fileName.mb_str()));

						if (sfHandle)
							fileLength = sfHandle.frames();

						currentPipe.AddPipeAttack(atkFiles->Item(j), fileLength - 2, fileLength - 1);

						atkFiles->Item(j) = wxEmptyString;
					}
				}
				if (!relFiles->IsEmpty()) {
					for (unsigned j = 0; j < relFiles->GetCount(); j++) {
						wxString compareWith;
						compareWith = relFiles->Item(j).Mid(0,3);
						if ((relFiles->Item(j) != wxEmptyString) && (compareWith.IsSameAs(numberPart))) {
							currentPipe.AddPipeRelease(relFiles->Item(j));
							relFiles->Item(j) = wxEmptyString;
						}
					}
				}
				m_pipes.push_back(currentPipe);
			}
		}
	}
	if (!m_pipes.empty()) {
		for (unsigned i = 0; i < m_pipes.size(); i++) {
			wxString atkFolder;
			atkFolder = m_attackFolderPath;
			atkFolder.Replace(m_odfPath, wxT(""));
			atkFolder.append(wxT("/"));
			wxString relFolder;
			relFolder = m_releaseFolderPath;
			relFolder.Replace(m_odfPath, wxT(""));
			relFolder.append(wxT("/"));
			for (unsigned j = 0; j < m_pipes[i].GetNumberOfAttacks(); j++) {
				if (j == 0) {
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3u=."), i + 1));
					m_pipesField->AppendText(atkFolder);
					m_pipesField->AppendText(m_pipes[i].GetAttackPath(j));
					m_pipesField->AppendText(wxT("\n"));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uLoopCount=1\n"), i + 1));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uLoop001Start=%u\n"), i + 1, m_pipes[i].GetAttackLoopStart(j)));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uLoop001End=%u\n"), i + 1, m_pipes[i].GetAttackLoopEnd(j)));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uLoadRelease=N\n"), i + 1));
					if (m_pipes[i].GetNumberOfAttacks() > 1)
						m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3iAttackCount=%u\n"), i + 1, (m_pipes[i].GetNumberOfAttacks() - 1)));
				} else {
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uAttack%0.3u=."), i + 1, j));
					m_pipesField->AppendText(atkFolder);
					m_pipesField->AppendText(m_pipes[i].GetAttackPath(j));
					m_pipesField->AppendText(wxT("\n"));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uAttack%0.3uLoopCount=1\n"), i + 1, j));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uAttack%0.3uLoop001Start=%u\n"), i + 1, j, m_pipes[i].GetAttackLoopStart(j)));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uAttack%0.3uLoop001End=%u\n"), i + 1, j, m_pipes[i].GetAttackLoopEnd(j)));
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uAttack%0.3uLoadRelease=N\n"), i + 1, j));
				}
			}
			for (unsigned j = 0; j < m_pipes[i].GetNumberOfReleases(); j++) {
				if (j == 0)
					m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uReleaseCount=%u\n"), i + 1, m_pipes[i].GetNumberOfReleases()));
				m_pipesField->AppendText(wxString::Format(wxT("Pipe%0.3uRelease%0.3u=."), i + 1, j + 1));
				m_pipesField->AppendText(relFolder);
				m_pipesField->AppendText(m_pipes[i].GetReleasePath(j));
				m_pipesField->AppendText(wxT("\n"));
			}
		}
		m_doneText->SetLabel(wxT("Pipes generated, see the 'Pipes' tab!"));
	}
	delete atkFiles;
	delete relFiles;
}
