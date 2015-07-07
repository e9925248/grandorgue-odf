unit SplashFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI;

type
  TSplashForm = class(TForm)
    Image: TImage;
    LabelApplicationName: TLabel;
    LabelLicence: TLabel;
    LabelOriginalAuthor: TLabel;
    LabelAuthorName: TLabel;
    LabelSeparator: TLabel;
    Timer: TTimer;
    procedure FormDeactivate(Sender: TObject);
    procedure LabelAuthorNameMouseEnter(Sender: TObject);
    procedure LabelAuthorNameMouseLeave(Sender: TObject);
    procedure LabelAuthorNameClick(Sender: TObject);
    procedure GenericClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FReady: Boolean;
  public
    procedure Execute;

    property Ready: Boolean read FReady;
  end;

var
  SplashForm: TSplashForm;

implementation

uses
  MainFormUnit, ConfigurationFormUnit;

{$R *.dfm}

{ TForm1 }

procedure TSplashForm.Execute;
begin
  Font.Color := clWhite;
  LabelApplicationName.Caption := 'Organ Builder ' + GetLongVersionInfo;
  LabelApplicationName.Font.Size := Font.Size + 5;
  LabelApplicationName.Font.Style := [fsBold];
  LabelAuthorName.Font.Color := $FF7777;
  Timer.Enabled := not FReady;
  Show;
  Activate;
  Update;
end;

procedure TSplashForm.FormDeactivate(Sender: TObject);
begin
  if FReady then
    Hide
  else
    SetActiveWindow(Handle);
  FReady := True;
end;

procedure TSplashForm.LabelAuthorNameMouseEnter(Sender: TObject);
begin
  LabelAuthorName.Font.Style := LabelAuthorName.Font.Style + [fsUnderline];
end;

procedure TSplashForm.LabelAuthorNameMouseLeave(Sender: TObject);
begin
  LabelAuthorName.Font.Style := LabelAuthorName.Font.Style - [fsUnderline];
end;

procedure TSplashForm.LabelAuthorNameClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(LabelAuthorName.Hint), nil, nil, SW_SHOWNORMAL)
end;

procedure TSplashForm.GenericClick(Sender: TObject);
begin
  Hide;
end;

procedure TSplashForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  FReady := True;
  FormDeactivate(nil);
end;

end.
