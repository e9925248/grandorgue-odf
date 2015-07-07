unit ExportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Organ;

type
  TExportThread = class(TThread)
  private
    FOrgan: TOrgan;
    FFilename: string;
    FTerminated: Boolean;
  public
    constructor Create(AOrgan: TOrgan; AFilename: string);

    procedure Execute; override;

    procedure Terminate;
  end;

  TExportForm = class(TForm)
    ButtonAbort: TBitBtn;
    Timer: TTimer;
    ProgressBar: TProgressBar;
    procedure TimerTimer(Sender: TObject);
  private
    FThread: TExportThread;
  public
    procedure Execute(AOrgan: TOrgan; APath: string);
  end;

var
  ExportForm: TExportForm;

implementation

{$R *.dfm}

{ TExportThread }

constructor TExportThread.Create(AOrgan: TOrgan; AFilename: string);
begin
  inherited Create(True);
  FOrgan := AOrgan;
  FFilename := AFilename;
  Resume;
end;

procedure TExportThread.Execute;
begin
  try
    FOrgan.Export(FFilename, @FTerminated);
  finally
    Terminate;
    ExportForm.ModalResult := mrOk;
  end;
end;

procedure TExportThread.Terminate;
begin
  inherited;
  FTerminated := True;
end;

{ TExportForm }

procedure TExportForm.Execute(AOrgan: TOrgan; APath: string);
begin
  Timer.Enabled := True;
  try
    ProgressBar.Position := 0;
    FThread := TExportThread.Create(AOrgan, APath);
    case ShowModal of
      mrAbort: FThread.Terminate;
    end;
    FThread.WaitFor;
    FreeAndNil(FThread);
  finally
    Timer.Enabled := False;
  end;
end;

procedure TExportForm.TimerTimer(Sender: TObject);
begin
  if Assigned(FThread) then begin
    ProgressBar.Position := Round(1000 * FThread.FOrgan.ExportProgress);
    if FThread.FTerminated then
      ModalResult := mrOk;
  end;
end;

end.
