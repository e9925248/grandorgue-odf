program OrganBuilder;

uses
  Windows,
  Classes,
  Graphics,
  Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  Organ in 'Organ.pas',
  ListenFormUnit in 'ListenFormUnit.pas' {ListenForm},
  ObjectMatrixFrameUnit in 'ObjectMatrixFrameUnit.pas' {ObjectMatrixFrame: TFrame},
  ObjectFrameUnit in 'ObjectFrameUnit.pas' {ObjectFrame: TFrame},
  WoodFormUnit in 'WoodFormUnit.pas' {WoodForm},
  ScanFormUnit in 'ScanFormUnit.pas' {ScanForm},
  ExportFormUnit in 'ExportFormUnit.pas' {ExportForm},
  WarningFormUnit in 'WarningFormUnit.pas' {WarningForm},
  ConfigurationFormUnit in 'ConfigurationFormUnit.pas' {ConfigurationForm},
  SplashFormUnit in 'SplashFormUnit.pas' {SplashForm};

{$R *.res}

procedure PatchSystemFont;
var
  LF: TLogFont;
  a: Integer;
begin
  if SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(LF), @LF, 0) then begin
    if LF.lfHeight < - 13 then
      LF.lfHeight := -13;
    if LF.lfHeight > 13 then
      LF.lfHeight := 13;
    for a := 0 to Screen.FormCount - 1 do
      with Screen.Forms[a] do begin
        Font.Height := LF.lfHeight;
        //Font.Orientation := LF.lfOrientation;
        Font.Charset := TFontCharset(LF.lfCharSet);
        Font.Name := PChar(@LF.lfFaceName);
        Font.Style := [];
        if LF.lfWeight >= FW_BOLD then
          Font.Style := Font.Style + [fsBold];
        if Boolean(LF.lfItalic) then
          Font.Style := Font.Style + [fsItalic];
        if Boolean(LF.lfUnderline) then
          Font.Style := Font.Style + [fsUnderline];
        if Boolean(LF.lfStrikeOut) then
          Font.Style := Font.Style + [fsStrikeOut];
        case LF.lfPitchAndFamily and $F of
          VARIABLE_PITCH: Font.Pitch := fpVariable;
          FIXED_PITCH: Font.Pitch := fpFixed;
        else
          Font.Pitch := fpDefault;
        end;
      end;
  end;
  TStringList(Screen.Fonts).CaseSensitive := False;
end;

begin
  Application.Initialize;
  PatchApplicationTitle;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TListenForm, ListenForm);
  Application.CreateForm(TWoodForm, WoodForm);
  Application.CreateForm(TScanForm, ScanForm);
  Application.CreateForm(TExportForm, ExportForm);
  Application.CreateForm(TWarningForm, WarningForm);
  Application.CreateForm(TSplashForm, SplashForm);
  Application.CreateForm(TConfigurationForm, ConfigurationForm);
  if not ConfigurationForm.Terminated then begin
    PatchSystemFont;
    SplashForm.Execute;
    MainForm.Initialize;
    Application.Run;
  end;
end.
