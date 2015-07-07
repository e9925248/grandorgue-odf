unit ConfigurationFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList, ToolWin, ExtCtrls, Contnrs,
  IniFiles, StrUtils, Menus, VirtualTrees, ShellAPI, shlobj, ActiveX;

type
  TLocalization = class
  private
    FFilename, FName, FDisplayName: string;
    FSmallFlag, FLargeFlag: TBitmap;
    FDefault: Boolean;
  public
    constructor Create(AFilename: string);
    destructor Destroy; override;
  end;

  TLocalizableStringArray = class
  private
    FName: string;
    FAddresses: TList;
    FOffset: Integer;
  public
    constructor Create(AName: string; var AStringArray: array of string; AOffset: Integer);
    destructor Destroy; override;
  end;

  TConfigurationForm = class(TForm)
    ButtonOk: TBitBtn;
    ButtonCancel: TBitBtn;
    LabelLanguage: TLabel;
    ImageListFlags: TImageList;
    LabelPathStorage: TLabel;
    ComboBoxPathStorage: TComboBox;
    PanelLanguageButtons: TPanel;
    ComboBoxLanguage: TComboBox;
    ButtonReset: TBitBtn;
    procedure ComboBoxLanguageDrawItem(Control: TWinControl;
      Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ComboBoxLanguageChange(Sender: TObject);
    procedure ButtonResetClick(Sender: TObject);
  private
    FLangFolder: string;
    FConfigurationFolder: string;      
    FHelpFolder: string;
    FFirstRun: Boolean;

    FLocalizations: TObjectList;
    FDefaultLocalizationIndex: Integer;
    FLocalizableStrings: TStringList;
    FLocalizableStringArrays: TObjectList;

    FRecents: TStrings;

    FTerminated: Boolean;
  protected
    procedure ButtonLanguageClick(Sender: TObject);

    procedure ExportLocalization(Filename: string);
    procedure ImportLocalization(Index: Integer);

    procedure RegisterLocalizableStrings;
    procedure RegisterLocalizableString(AName: string; AAddress: PString);
    procedure RegisterLocalizableStringArray(AName: string; var AStringArray: array of string; AOffset: Integer = 0);

    procedure LoadConfiguration;
    procedure SaveConfiguration;

    function GetStoreRelativePaths: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Execute;

    procedure ShowHelp;

    procedure AddToRecents(AFilename: string);
    procedure RemoveFromRecents(AFilename: string);
    property Recents: TStrings read FRecents;

    property StoreRelativePaths: Boolean read GetStoreRelativePaths;

    property Terminated: Boolean read FTerminated;
  end;

var
  ConfigurationForm: TConfigurationForm;

  S_CouldNotLocateAppDataFolder: string = 'Could not locate appdata folder, your settings might not load nor save.';
  S_CouldNotCreateConfigurationDirectory: string = 'Could not create configuration directory [%s].';
  S_CouldNotSaveConfiguration: string = 'Could not save configuration [%s].';

procedure GetVersionInfo(var V1, V2, V3, V4: word);
function GetShortVersionInfo: string;
function GetLongVersionInfo: string;

procedure PatchApplicationTitle;

implementation

uses
  MainFormUnit, ListenFormUnit, WoodFormUnit, ScanFormUnit,
  SplashFormUnit, ObjectMatrixFrameUnit, Organ;

{$R *.dfm}

type
  TControlAccess=class(TControl);

procedure GetVersionInfo(var V1, V2, V3, V4: word);
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize > 0 then
  begin
      GetMem(VerInfo, VerInfoSize);
      try
        if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
        begin
          VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
          with VerValue^ do
          begin
            V1 := dwFileVersionMS shr 16;
            V2 := dwFileVersionMS and $FFFF;
            V3 := dwFileVersionLS shr 16;
            V4 := dwFileVersionLS and $FFFF;
          end;
        end;
      finally
        FreeMem(VerInfo, VerInfoSize);
      end;
  end;
end;

function GetShortVersionInfo: string;
var
  V1, V2, V3, V4: word;
begin
  GetVersionInfo(V1, V2, V3, V4);
  Result := IntToStr(V1) + '.' + IntToStr(V2);
end;

function GetLongVersionInfo: string;
var
  V1, V2, V3, V4: word;
begin
  GetVersionInfo(V1, V2, V3, V4);
  Result := IntToStr(V1) + '.' + IntToStr(V2) + '.' + IntToStr(V3) + '.' + IntToStr(V4);
end;

procedure PatchApplicationTitle;
begin
  Application.Title := 'Organ Builder ' + GetShortVersionInfo;
  S_Version := GetLongVersionInfo;
end;

function GetSpecialFolderPath(const Index: Integer; var Path: string): Boolean;
var
  p: PItemIDList;
  s: array[0 .. MAX_PATH] of Char;
begin
  Result := SHGetSpecialFolderLocation(Application.Handle, Index, p) = S_OK;
  if Result then
    try
      Result := SHGetPathFromIDList(p, s);
      if Result then
        Path := s;
    finally
      CoTaskMemFree(p);
    end;
end;

{ TLocalization }

constructor TLocalization.Create(AFilename: string);
var
  f: TMemIniFile;
  p: TBitmap;
  s: string;
begin
  inherited Create;
  FFilename := AFilename;
  SetLength(s, 1024);
  SetLength(s, VerLanguageName(GetSystemDefaultLangID, PChar(s), Length(s)));
  FName := ChangeFileExt(ExtractFileName(AFilename), '');
  f := TMemIniFile.Create(AFilename);
  try
    FName := f.ReadString('Language', 'Name', FName);
    FDisplayName := f.ReadString('Language', 'DisplayName', FName);
    FDefault := UpperCase(Copy(s, 1, Length(FDisplayName))) = UpperCase(FDisplayName);
  finally
    f.Destroy;
  end;
  if FileExists(ChangeFileExt(AFilename, '.bmp')) then
    try
      p := TBitmap.Create;
      try
        p.LoadFromFile(ChangeFileExt(AFilename, '.bmp'));
        FLargeFlag := TBitmap.Create;
        FSmallFlag := TBitmap.Create;
        FLargeFlag.Width := 48;
        FLargeFlag.Height := 32;
        FSmallFlag.Width := 24;
        FSmallFlag.Height := 16;
        FLargeFlag.Canvas.StretchDraw(Rect(0, 0, FLargeFlag.Width, FLargeFlag.Height), p);
        FSmallFlag.Canvas.StretchDraw(Rect(0, 0, FSmallFlag.Width, FSmallFlag.Height), FLargeFlag);
      finally
        p.Destroy;
      end;
    except
    end;
end;

destructor TLocalization.Destroy;
begin
  FreeAndNil(FSmallFlag);
  FreeAndNil(FLargeFlag);
  inherited;
end;

{ TLocalizableStringArray }

constructor TLocalizableStringArray.Create(AName: string;
  var AStringArray: array of string; AOffset: Integer);
var
  a: Integer;
begin
  inherited Create;
  FName := AName;
  FAddresses := TList.Create;
  FOffset := AOffset;
  for a := Low(AStringArray) to High(AStringArray) do
    FAddresses.Add(@AStringArray[a]);
end;

destructor TLocalizableStringArray.Destroy;
begin
  FreeAndNil(FAddresses);
  inherited;
end;

{ TConfigurationForm }

procedure TConfigurationForm.ButtonLanguageClick(Sender: TObject);
begin
  ComboBoxLanguage.ItemIndex := (Sender as TSpeedButton).Tag;
  ComboBoxLanguageChange(nil);
end;

constructor TConfigurationForm.Create(AOwner: TComponent);
var
  a, b, c: Integer;
  r: TSearchRec;
{$IFNDEF PORTABLE}
  s: string;
const
  CSIDL_COMMON_APPDATA = $0023;
{$ENDIF}
begin
  inherited;
{$IFDEF PORTABLE}
  FLangFolder := 'Lang/';
  FConfigurationFolder := '';
{$ELSE}
  FLangFolder := ExtractFilePath(Application.ExeName) + 'Lang\';
  if not GetSpecialFolderPath(CSIDL_COMMON_APPDATA, s) then begin
    MessageBox(0, PChar(S_CouldNotLocateAppDataFolder), nil, MB_ICONERROR or MB_SETFOREGROUND);
    FConfigurationFolder := '';
  end else
    FConfigurationFolder := s + '\OrganBuilder\';
{$ENDIF}
  FHelpFolder := ExtractFilePath(Application.ExeName) + 'Help\';
  FLocalizableStrings := TStringList.Create;
  FLocalizableStringArrays := TObjectList.Create(True);
  RegisterLocalizableStrings;
  FLocalizations := TObjectList.Create(True);
  if FindFirst(FLangFolder + '*.dat', faAnyFile, r) = 0 then
    try
      repeat
        FLocalizations.Add(TLocalization.Create(FLangFolder + r.Name));
      until FindNext(r) <> 0;
    finally
      FindClose(r);
    end;
  b := 0;
  FDefaultLocalizationIndex := -1;
  for a := 0 to FLocalizations.Count - 1 do
    with FLocalizations[a] as TLocalization do begin
      with TSpeedButton.Create(PanelLanguageButtons) do begin
        Tag := a;
        Hint := FDisplayName;
        if Assigned(FLargeFlag) then begin
          Glyph := FLargeFlag;
          Glyph.TransparentColor := clNone;
          Width := FLargeFlag.Width + 8;
          Height := FLargeFlag.Height + 6;
        end else begin
          Caption := FDisplayName;
          Width := Canvas.TextWidth(FDisplayName) + 20;
          Height := 38;
        end;
        Left := b;
        Inc(b, Width + 4);
        OnClick := ButtonLanguageClick;
        Parent := PanelLanguageButtons;
      end;
      if Assigned(FSmallFlag) then
        c := ComboBoxLanguage.Items.AddObject(FDisplayName, TObject(ImageListFlags.Add(FSmallFlag, nil)))
      else
        c := ComboBoxLanguage.Items.AddObject(FDisplayName, TObject(-2));
      if FDefault then
        FDefaultLocalizationIndex := c;
      if (FDefaultLocalizationIndex = -1) and (UpperCase(FName) = 'ENGLISH') then
        FDefaultLocalizationIndex := c;
    end;
  FRecents := TStringList.Create;
  if FDefaultLocalizationIndex = -1 then
    FDefaultLocalizationIndex := FLocalizations.Count - 1;
//  ExportLocalization(FLangFolder + '\default');
  LoadConfiguration;
  if FFirstRun then
    Execute;
end;

destructor TConfigurationForm.Destroy;
begin
  if not FFirstRun then
    SaveConfiguration;
  FreeAndNil(FRecents);
  FreeAndNil(FLocalizations);
  FreeAndNil(FLocalizableStringArrays);
  FreeAndNil(FLocalizableStrings);
  inherited;
end;

procedure TConfigurationForm.ExportLocalization(Filename: string);
var
  f: TMemIniFile;
  a, b: Integer;
  c: TComponent;
  s: string;

  function Purge(s: string): string;
  begin
    Result := AnsiReplaceStr(s, #13, '|');
    Result := AnsiReplaceStr(Result, #10, '');
  end;

  procedure WriteComponent;
  var
    a: Integer;
    t: string;
  begin
    t := '';
    if (c is TControl)
       and not (c is TEdit)
       and not (c is TToolBar)
       and not (c is TComboBox) then
      t := TControlAccess(c).Caption;
    if (c is TMenuItem) and (TMenuItem(c).Caption <> '-') then
      t := TMenuItem(c).Caption;
    if c is TOpenDialog then
      t := TOpenDialog(c).Title;
    if t <> '' then
      f.WriteString(s + '.Captions', c.Name, Purge(t));
    t := '';
    if c is TControl then
      t := TControl(c).Hint;
    if t <> '' then
      f.WriteString(s + '.Hints', c.Name, t);
    if c is TComboBox then
      with TComboBox(c) do
        for a := 0 to Items.Count - 1 do
          f.WriteString(s + '.Captions', c.Name + '.Items[' + IntToStr(a) + ']', Items[a]);
    if c is TVirtualStringTree then
      with TVirtualStringTree(c) do
        for a := 0 to Header.Columns.Count - 1 do
          f.WriteString(s + '.Captions', c.Name + '.Columns[' + IntToStr(a) + ']', Header.Columns[a].Text);
  end;

begin
  f:=TMemIniFile.Create(Filename);
  try
    f.Clear;
    f.WriteString('Language', 'Name', '');
    for a := 0 to Screen.FormCount - 1 do
      with Screen.Forms[a] do begin
        s := Name;
        f.WriteString(s + '.Captions', 'Title', Caption);
        for b := 0 to ComponentCount - 1 do begin
          c := Components[b];
          if c.Name <> '' then
            WriteComponent;
        end;
      end;
    for a := 0 to FLocalizableStrings.Count - 1 do
      f.WriteString('Strings', FLocalizableStrings[a], Purge(PString(FLocalizableStrings.Objects[a])^));
    for a:=0 to FLocalizableStringArrays.Count - 1 do
      with TLocalizableStringArray(FLocalizableStringArrays[a]) do
        for b := 0 to FAddresses.Count - 1 do
          f.WriteString(FName, 'Item[' + IntToStr(b + FOffset) + ']', PString(FAddresses[b])^);
    f.UpdateFile;
  finally
    f.Destroy;
  end;
end;

procedure TConfigurationForm.ImportLocalization(Index: Integer);
var
  f:TMemIniFile;
  a, b: Integer;
  c: TComponent;
  s: string;

  function Unpurge(s: string): string;
  begin
    Result := AnsiReplaceStr(s, '|', #13#10);
  end;

  procedure UpdateHint(c:TComponent);
  begin
    if c is TLabel then
      with TLabel(c) do
        if Assigned(FocusControl) then
          Hint := FocusControl.Hint;
    if c is TUpDown then
      with TUpDown(c) do
        if Assigned(Associate) then
          Hint := Associate.Hint;
  end;

  procedure ReadComponent;
  var
    a, b: Integer;
  begin
    if (c is TControl)
       and not (c is TEdit)
       and not (c is TToolBar)
       and not (c is TComboBox) then
      TControlAccess(c).Caption := Unpurge(f.ReadString(s + '.Captions', c.Name, TControlAccess(c).Caption));
    if (c is TMenuItem) and (TMenuItem(c).Caption <> '-') then
      TMenuItem(c).Caption := Unpurge(f.ReadString(s + '.Captions', c.Name, TMenuItem(c).Caption));
    if c is TOpenDialog then
      TOpenDialog(c).Title := Unpurge(f.ReadString(s + '.Captions', c.Name, TOpenDialog(c).Title));
    if c is TControl then
      TControl(c).Hint:=Unpurge(f.ReadString(s + '.Hints', c.Name, TControl(c).Hint));
    if c is TComboBox then
      with TComboBox(c) do begin
        b := ItemIndex;
        Items.BeginUpdate;
        try
          for a := 0 to Items.Count - 1 do
            if f.ValueExists(s + '.Captions', c.Name + '.Items[' + IntToStr(a) + ']') then
              Items[a] := f.ReadString(s + '.Captions', c.Name + '.Items[' + IntToStr(a) + ']', Items[a]);
        finally
          Items.EndUpdate;
        end;
        if ItemIndex <> b then
          ItemIndex := b;
      end;
    if c is TVirtualStringTree then
      with TVirtualStringTree(c) do
        for a := 0 to Header.Columns.Count - 1 do
          Header.Columns[a].Text := f.ReadString(s + '.Captions', c.Name + '.Columns[' + IntToStr(a) + ']', Header.Columns[a].Text);
  end;

begin
  if (Index < 0) or (Index >= FLocalizations.Count) then
    Exit;
  with FLocalizations[Index] as TLocalization do begin
    f := TMemIniFile.Create(FFilename);
    try
      for a := 0 to FLocalizableStrings.Count - 1 do
        PString(FLocalizableStrings.Objects[a])^ := Unpurge(f.ReadString('Strings', FLocalizableStrings[a], PString(FLocalizableStrings.Objects[a])^));
      for a:=0 to FLocalizableStringArrays.Count - 1 do
        with TLocalizableStringArray(FLocalizableStringArrays[a]) do
          for b := 0 to FAddresses.Count - 1 do
            PString(FAddresses[b])^ := Unpurge(f.ReadString(FName, 'Item[' + IntToStr(b + FOffset) + ']', PString(FAddresses[b])^));
      for a := 0 to Screen.FormCount - 1 do
        with Screen.Forms[a] do begin
          s := Name;
          Caption := f.ReadString(s + '.Captions', 'Title', Caption);
          for b := 0 to ComponentCount - 1 do begin
            c := Components[b];
            ReadComponent;
          end;
        end;
      for a := 0 to Screen.FormCount - 1 do
        with Screen.Forms[a] do
          for b := 0 to ComponentCount - 1 do
            UpdateHint(Components[b]);
    finally
      f.Destroy;
    end;
  end;
end;

procedure TConfigurationForm.RegisterLocalizableStrings;
begin
  RegisterLocalizableString('Organ', @S_Organ);
  RegisterLocalizableString('ManualsAndDivisions', @S_ManualsAndDivisions);
  RegisterLocalizableString('StopAndPedalFamilies', @S_StopAndPedalFamilies);
  RegisterLocalizableString('Couplers', @S_Couplers);
  RegisterLocalizableString('Tremulants', @S_Tremulants);
  RegisterLocalizableString('Enclosures', @S_Enclosures);
  RegisterLocalizableString('NamedManual', @S_NamedManual);
  RegisterLocalizableString('CouplersStopFamily', @S_CouplersStopFamily);
  RegisterLocalizableString('TremulantsStopFamily', @S_TremulantsStopFamily);
  RegisterLocalizableString('NamedStopFamily', @S_NamedStopFamily);
  RegisterLocalizableString('MainPanel', @S_MainPanel);
  RegisterLocalizableString('LeftStopjamb', @S_LeftStopjamb);
  RegisterLocalizableString('RightStopjamb', @S_RightStopjamb);
  RegisterLocalizableString('CenterStopjamb', @S_CenterStopjamb);
  RegisterLocalizableString('Pistons', @S_Pistons);
  RegisterLocalizableString('Untitled', @S_Untitled);
  RegisterLocalizableString('Modified', @S_Modified);
  RegisterLocalizableString('CustomColor', @S_CustomColor);
  RegisterLocalizableString('Division', @S_Division);
  RegisterLocalizableString('Stop', @S_Stop);
  RegisterLocalizableString('NewStopName', @S_NewStopName);
  RegisterLocalizableString('NewStop', @S_NewStop);
  RegisterLocalizableString('InputName', @S_InputName);
  RegisterLocalizableString('StopFamily', @S_StopFamily);
  RegisterLocalizableString('Coupler', @S_Coupler);
  RegisterLocalizableString('Tremulant', @S_Tremulant);
  RegisterLocalizableString('Piston', @S_Piston);
  RegisterLocalizableString('ProjectModifiedQuerySaveChanges', @S_ProjectModifiedQuerySaveChanges);
  RegisterLocalizableString('Confirmation', @S_Confirmation);
  RegisterLocalizableString('SelectPathToExplore', @S_SelectPathToExplore);
  RegisterLocalizableString('DrawstopOn', @S_DrawstopOn);
  RegisterLocalizableString('DrawstopOff', @S_DrawstopOff);
  RegisterLocalizableString('PistonOn', @S_PistonOn);
  RegisterLocalizableString('PistonOff', @S_PistonOff);
  RegisterLocalizableString('Example', @S_Example);
  RegisterLocalizableStringArray('BackgroundNames', S_BackgroundNames);
  RegisterLocalizableString('BackgroundImages', @S_BackgroundImages);
  RegisterLocalizableString('NamedBackgroundImageToEdit', @S_NamedBackgroundImageToEdit);
  RegisterLocalizableString('NoProblemDetected', @S_NoProblemDetected);
  RegisterLocalizableString('Information', @S_Information);
  RegisterLocalizableString('LoadReleaseFromAttackSample', @S_LoadReleaseFromAttackSample);

  RegisterLocalizableString('ValuedDuration', @S_ValuedDuration);
  RegisterLocalizableString('ErrorCannotObtainFormat', @S_ErrorCannotObtainFormat);
  RegisterLocalizableString('ErrorCannotObtainLength', @S_ErrorCannotObtainLength);

  RegisterLocalizableString('SelectBackgroundFor', @S_SelectBackgroundFor);

  RegisterLocalizableString('RanksFoundSoFar', @S_RanksFoundSoFar);

  RegisterLocalizableString('TopLabels', @S_TopLabels);
  RegisterLocalizableString('BottomLabels', @S_BottomLabels);

  RegisterLocalizableString('GeneratedUsingOrganBuilderVersion', @S_GeneratedUsingOrganBuilderVersion);
//  RegisterLocalizableString('Version', @S_Version);
  RegisterLocalizableString('SomeFontsWereUnavailable', @S_SomeFontsWereUnavailable);
  RegisterLocalizableString('Warning', @S_Warning);
  RegisterLocalizableStringArray('Warnings', S_Warnings, 1);
  RegisterLocalizableStringArray('ManualNames', S_ManualNames);
  RegisterLocalizableStringArray('StopFamilyNames', S_StopFamilyNames);

  RegisterLocalizableString('CouldNotLocateAppDataFolder', @S_CouldNotLocateAppDataFolder);
  RegisterLocalizableString('CouldNotCreateConfigurationDirectory', @S_CouldNotCreateConfigurationDirectory);
  RegisterLocalizableString('CouldNotSaveConfiguration', @S_CouldNotSaveConfiguration);
end;

procedure TConfigurationForm.RegisterLocalizableString(AName: string;
  AAddress: PString);
begin
  FLocalizableStrings.AddObject(AName, TObject(AAddress))
end;

procedure TConfigurationForm.RegisterLocalizableStringArray(AName: string;
  var AStringArray: array of string; AOffset: Integer);
begin
  FLocalizableStringArrays.Add(TLocalizableStringArray.Create(AName, AStringArray, AOffset));
end;

procedure TConfigurationForm.Execute;
begin
  if FFirstRun then
    MainForm.Hide;
  case ShowModal of
    mrOk: begin
      FFirstRun := False;
      SaveConfiguration;
    end;
  else
    if FFirstRun then
      FTerminated := True
    else
      LoadConfiguration;
  end;
end;

procedure TConfigurationForm.ComboBoxLanguageDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TComboBox do begin
    Canvas.FillRect(Rect);
    Canvas.TextRect(Rect, Rect.Left + ImageListFlags.Width + 4, Rect.Top + 1, Items[Index]);
    if Enabled then begin
      Inc(Rect.Left, 2);
      Rect.Top := Rect.Top + (Rect.Bottom - Rect.Top - ImageListFlags.Height) div 2;
      Rect.Right := Rect.Left + ImageListFlags.Width;
      Rect.Bottom := Rect.Top + ImageListFlags.Height;
      ImageListFlags.Draw(Canvas, Rect.Left, Rect.Top, Integer(Items.Objects[Index]));
    end;
  end;
end;

procedure TConfigurationForm.ComboBoxLanguageChange(Sender: TObject);
begin
  ImportLocalization(ComboBoxLanguage.ItemIndex);
  if Assigned(MainForm.Organ) then
    MainForm.ResetGUI(False);
end;

procedure TConfigurationForm.LoadConfiguration;
var
  a, b, c: Integer;
  f: TMemIniFile;
  m: TMonitor;
  s: string;
begin
  f := TMemIniFile.Create(FConfigurationFolder + 'OrganBuilder.ini');
  try
    b := FDefaultLocalizationIndex;
    s := f.ReadString('System', 'Language', '');
    for a := 0 to FLocalizations.Count - 1 do
      if TLocalization(FLocalizations[a]).FName = s then
        b := a;
    FFirstRun := f.ReadBool('System', 'FirstRun', True);
    if f.ReadBool('System', 'StoreRelativePaths', False) then
      ComboBoxPathStorage.ItemIndex := 1
    else
      ComboBoxPathStorage.ItemIndex := 0;
    if not Assigned(MainForm.Organ) then begin
      MainForm.Left := f.ReadInteger('System', 'Window.Left', (MainForm.Monitor.Width - MainForm.Width) div 2);
      MainForm.Top := f.ReadInteger('System', 'Window.Top', (MainForm.Monitor.Height - MainForm.Height) div 2);
      MainForm.ClientWidth := f.ReadInteger('System', 'Window.Width', MainForm.NormalSize.cx);
      MainForm.ClientHeight := f.ReadInteger('System', 'Window.Height', MainForm.NormalSize.cy);
      m := MainForm.Monitor;
      if MainForm.Width > m.Width then
        MainForm.Width := m.Width;
      if MainForm.Height > m.Height then
        MainForm.Height := m.Height;
      MainForm.MakeFullyVisible(m);
      if f.ReadBool('System', 'Window.Zoomed', False) then
        MainForm.Perform(WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    end;
    c := f.ReadInteger('Recents', 'Count', 0);
    if c > 8 then
      c := 8;
    FRecents.Clear;
    for a := 0 to c - 1 do begin
      s := f.ReadString('Recents', 'File[' + IntToStr(a) + ']', '');
      if s <> '' then
        FRecents.Add(s);
    end;
  finally
    f.Destroy;
  end;
  ComboBoxLanguage.ItemIndex := b;
  ComboBoxLanguageChange(nil);
end;

function TConfigurationForm.GetStoreRelativePaths: Boolean;
begin
  Result := ComboBoxPathStorage.ItemIndex = 1;
end;

procedure TConfigurationForm.ButtonResetClick(Sender: TObject);
var
  t: Boolean;
begin
  t := FFirstRun;
  DeleteFile(FConfigurationFolder + 'OrganBuilder.ini');
  LoadConfiguration;
  FFirstRun := t;
end;

procedure TConfigurationForm.AddToRecents(AFilename: string);
begin
  RemoveFromRecents(AFilename);
  if AFilename <> '' then
    FRecents.Insert(0, AFilename);
  while FRecents.Count > 8 do
    FRecents.Delete(FRecents.Count - 1);
end;

procedure TConfigurationForm.RemoveFromRecents(AFilename: string);
var
  a: Integer;
begin
  repeat
    a := FRecents.IndexOf(AFilename);
    if a > -1 then
      FRecents.Delete(a);
  until a = -1;
end;

procedure TConfigurationForm.SaveConfiguration;
var
  f: TMemIniFile;
  a: Integer;
begin
  if (FConfigurationFolder <> '') and not DirectoryExists(FConfigurationFolder) and not CreateDirectory(PChar(FConfigurationFolder), nil) then
    MessageBox(Application.Handle, PChar(Format(S_CouldNotCreateConfigurationDirectory, [FConfigurationFolder])), nil, 0)
  else begin
    f := TMemIniFile.Create(FConfigurationFolder + 'OrganBuilder.ini');
    try
      f.Clear;
      if (ComboBoxLanguage.ItemIndex > -1) and (ComboBoxLanguage.ItemIndex < FLocalizations.Count) then
        f.WriteString('System', 'Language', TLocalization(FLocalizations[ComboBoxLanguage.ItemIndex]).FName);
      f.WriteBool('System', 'StoreRelativePaths', ComboBoxPathStorage.ItemIndex = 1);
      f.WriteBool('System', 'FirstRun', False);
      f.WriteInteger('Recents', 'Count', FRecents.Count);
      if Assigned(MainForm.Organ) then begin
        f.WriteInteger('System', 'Window.Left', MainForm.NormalPosition.X);
        f.WriteInteger('System', 'Window.Top', MainForm.NormalPosition.Y);
        f.WriteInteger('System', 'Window.Width', MainForm.NormalSize.cx);
        f.WriteInteger('System', 'Window.Height', MainForm.NormalSize.cy);
        f.WriteBool('System', 'Window.Zoomed', MainForm.Windowstate = wsMaximized);
      end;
      for a := 0 to FRecents.Count - 1 do
        f.WriteString('Recents', 'File[' + IntToStr(a) + ']', FRecents[a]);
      try
        f.UpdateFile;
      except
        MessageBox(Application.Handle, PChar(Format(S_CouldNotSaveConfiguration, [FConfigurationFolder + 'OrganBuilder.ini'])), nil, 0)
      end;
    finally
      f.Destroy;
    end;
  end;
end;

procedure TConfigurationForm.ShowHelp;
var
  s, t: string;
begin
  s := '';
  if ComboBoxLanguage.ItemIndex > -1 then
    with FLocalizations[ComboBoxLanguage.ItemIndex] as TLocalization do begin
      t := FHelpFolder + 'Manual-' + FName + '.pdf';
      if FileExists(t) then
        s := t;
    end;
  if (s = '') and (FDefaultLocalizationIndex > -1) then
    with FLocalizations[FDefaultLocalizationIndex] as TLocalization do begin
      t := FHelpFolder + 'Manual-' + FName + '.pdf';
      if FileExists(t) then
        s := t;
    end;
  if s = '' then
    s := FHelpFolder + 'Manual-English.pdf';
  ShellExecute(Handle, 'open', PChar(s), nil, nil, SW_SHOWNORMAL)
end;

end.
