unit ScanFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Organ, ExtCtrls, StdCtrls, Buttons, ComCtrls, {$WARNINGS OFF} FileCtrl {$WARNINGS ON};

type
  TScanThread = class(TThread)
  private
    FOrgan: TOrgan;
    FPaths: TStringList;
    FTerminated: Boolean;
  public
    constructor Create(AOrgan: TOrgan; APaths: TStrings);
    destructor Destroy; override;

    procedure Execute; override;

    procedure Terminate;
  end;

  TScanForm = class(TForm)
    Timer: TTimer;
    ButtonAbort: TBitBtn;
    LabelLocation: TLabel;
    LabelPath: TLabel;
    LabelFoundCount: TLabel;
    procedure TimerTimer(Sender: TObject);
  private
    FThread: TScanThread;
  public
    procedure Execute(AOrgan: TOrgan; APaths: TStrings); overload;
    procedure Execute(AOrgan: TOrgan; APath: string); overload;
  end;

var
  ScanForm: TScanForm;

  S_RanksFoundSoFar: string = 'Ranks found so far: %d';

implementation

{$R *.dfm}

{ TScanThread }

constructor TScanThread.Create(AOrgan: TOrgan; APaths: TStrings);
begin
  inherited Create(True);
  FOrgan := AOrgan;
  FPaths := TStringList.Create;
  FPaths.AddStrings(APaths);
  Resume;
end;

destructor TScanThread.Destroy;
begin
  FreeAndNil(FPaths);
  inherited;
end;

procedure TScanThread.Execute;
var
  a: Integer;
begin
  try
    for a := 0 to FPaths.Count - 1 do begin
      FOrgan.ScanFileSystem(FPaths[a], @FTerminated);
      if Terminated then
        Break;
    end;
  finally
    Terminate;
    ScanForm.ModalResult := mrOk;
  end;
end;

procedure TScanThread.Terminate;
begin
  inherited;
  FTerminated := True;
end;

{ TScanForm }

procedure TScanForm.Execute(AOrgan: TOrgan; APath: string);
var
  l: TStringList;
begin
  l := TStringList.Create;
  try
    l.Add(APath);
    Execute(AOrgan, l);
  finally
    l.Destroy;
  end;
end;

procedure TScanForm.Execute(AOrgan: TOrgan; APaths: TStrings);
begin
  Timer.Enabled := True;
  try
    LabelFoundCount.Caption := '';
    FThread := TScanThread.Create(AOrgan, APaths);
    case ShowModal of
      mrAbort: FThread.Terminate;
    end;
    FThread.WaitFor;
    FreeAndNil(FThread);
  finally
    Timer.Enabled := False;
  end;
end;

procedure TScanForm.TimerTimer(Sender: TObject);
begin
  if Assigned(FThread) then begin
    LabelPath.Caption := MinimizeName(FThread.FOrgan.ScanPath, Canvas, ClientWidth - 8 - LabelPath.Left);
    LabelFoundCount.Caption := Format(S_RanksFoundSoFar, [FThread.FOrgan.FoundRanks]);
    if FThread.FTerminated then
      ModalResult := mrOk;
  end;
end;

end.
