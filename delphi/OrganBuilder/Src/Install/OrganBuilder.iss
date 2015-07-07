#define Version GetFileVersion("..\..\Release\OrganBuilder.exe")
#define AppName 'Organ Builder'

[Setup]
;MinVersion=0,5.1
PrivilegesRequired=admin
DisableDirPage=auto
DisableProgramGroupPage=auto
ChangesAssociations=yes

AppId={{90851B49-B295-4F1B-8D52-1CF9B19C56A2}
AppName={#AppName}
AppVerName={#AppName} {#Version}
AppVersion={#Version}

DefaultDirName={pf}\OrganBuilder
DefaultGroupName=Organ Builder
AllowNoIcons=yes
LicenseFile=License.txt
OutputDir=..\..
OutputBaseFilename=OrganBuilderSetup_{#Version}
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french";  MessagesFile: "compiler:Languages\French.isl"
Name: "german";  MessagesFile: "compiler:Languages\German.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[CustomMessages]
english.ViewUserManual=View user manual
french.ViewUserManual =Afficher le manuel utilisateur
german.ViewUserManual =View user manual
spanish.ViewUserManual=View user manual

english.UserManual=User manual
french.UserManual =Manuel utilisateur
german.UserManual =User manual
spanish.UserManual=User manual

[Tasks]
Name: "desktopicon";     Description: "{cm:CreateDesktopIcon}";     GroupDescription: "{cm:AdditionalIcons}";  Flags: unchecked

[Dirs]
Name: "{app}\Lang"
Name: "{app}\Help"
Name: "{commonappdata}\OrganBuilder";     Permissions: everyone-modify


[Files]
Source: "..\..\Release\OrganBuilder.exe"; DestDir: "{app}";       Flags: ignoreversion
Source: "..\..\Release\Lang\*";           DestDir: "{app}\Lang";  Flags: ignoreversion
Source: "..\..\Release\Help\*";           DestDir: "{app}\Help";  Flags: ignoreversion

[Icons]
Name: "{group}\Organ Builder";                                         Filename: "{app}\OrganBuilder.exe";         WorkingDir: "{app}"
Name: "{group}\{cm:UserManual}";                                       Filename: "{app}\Help\Manual-English.pdf";
Name: "{group}\{cm:UninstallProgram,OrganBuilder}";                    Filename: "{uninstallexe}"
Name: "{commondesktop}\WinGED";                                        Filename: "{app}\OrganBuilder.exe";         WorkingDir: "{app}\Bin"; Tasks: desktopicon

[Run]
Filename: "{app}\Help\Manual-English.pdf";  WorkingDir: "{app}"; Description: "{cm:ViewUserManual}";               Flags: nowait postinstall shellexec skipifsilent;
Filename: "{app}\OrganBuilder.exe";         WorkingDir: "{app}"; Description: "{cm:LaunchProgram,Organ Builder}";  Flags: nowait postinstall skipifsilent runasoriginaluser

[Registry]
Root: HKCR; Subkey: ".odp";                             ValueType: string; ValueName: ""; ValueData: "OrganBuilder";              Flags: uninsdeletevalue
Root: HKCR; Subkey: "OrganBuilder";                     ValueType: string; ValueName: ""; ValueData: "Organ definition project";  Flags: uninsdeletekey
Root: HKCR; Subkey: "OrganBuilder\DefaultIcon";         ValueType: string; ValueName: ""; ValueData: "{app}\OrganBuilder.exe,0"
Root: HKCR; Subkey: "OrganBuilder\shell\open\command";  ValueType: string; ValueName: ""; ValueData: """{app}\OrganBuilder.exe"" ""%1"""

[Code]
procedure CurUninstallStepChanged(CurUninstallStep:TUninstallStep);
begin
  case CurUninstallStep of
    usPostUninstall: begin
      case MsgBox('Delete configuration files?', mbConfirmation, MB_YESNO) of
        IDYES: DelTree(ExpandConstant('{commonappdata}') + '\OrganBuilder', True, True, True);
      end;
    end;
  end;
end;











