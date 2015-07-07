unit ListenFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Organ, MMSystem, ComCtrls, Buttons, WaveUtils,
  WaveStorage, WaveIO, WaveOut, WavePlayers;

type
  TPlayerState = (psNone, psIndex, psStop);

  TListenForm = class(TForm)
    LabelStart: TLabel;
    LabelFormat: TLabel;
    LabelEnd: TLabel;
    ButtonPlay: TBitBtn;
    ButtonPause: TBitBtn;
    ProgressBar: TProgressBar;
    LabelPipe: TLabel;
    ComboBoxPipe: TComboBox;
    CheckBoxContinuous: TCheckBox;
    ButtonStop: TBitBtn;
    AudioPlayer: TAudioPlayer;
    procedure AudioPlayerDeactivate(Sender: TObject);
    procedure AudioPlayerLevel(Sender: TObject; Level: Integer);
    procedure ButtonPauseClick(Sender: TObject);
    procedure ComboBoxPipeChange(Sender: TObject);
    procedure AudioPlayerActivate(Sender: TObject);
    procedure ButtonPlayClick(Sender: TObject);
    procedure AudioPlayerPause(Sender: TObject);
    procedure AudioPlayerResume(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
  private
    FRank: TRank;
    FState: TPlayerState;
  public
    procedure Execute(ARank: TRank);
  end;

var
  ListenForm: TListenForm;

  S_ValuedDuration: string = '%s s';
  S_ErrorCannotObtainFormat: string = 'ERROR: cannot obtain format';
  S_ErrorCannotObtainLength: string = 'ERROR: cannot obtain length';

implementation

{$R *.dfm}

{ TListenForm }

procedure TListenForm.Execute(ARank: TRank);
var
  a: Integer;
begin
  FRank := ARank;
  Caption := ExtractFileName(FRank.Path);
  ComboBoxPipe.Items.Clear;
  for a := 0 to FRank.NumberOfPipes - 1 do
    ComboBoxPipe.Items.Add(ExtractFileName(FRank.PipeFilename[a]));
  ComboBoxPipe.ItemIndex := 0;
  ComboBoxPipeChange(nil);
  FState := psNone;
  ShowModal;
  AudioPlayer.Active := False;
  AudioPlayer.Wave.Clear;
  FRank := nil;
end;

procedure TListenForm.AudioPlayerDeactivate(Sender: TObject);
begin
  ButtonPlay.Enabled := True;
  ButtonPause.Enabled := False;
  ButtonStop.Enabled := False;
  if Assigned(FRank) then begin
    case FState of
      psNone: if CheckBoxContinuous.Checked then begin
        ComboBoxPipe.ItemIndex := (ComboBoxPipe.ItemIndex + 1) mod FRank.NumberOfPipes;
        ComboBoxPipeChange(nil);
        AudioPlayer.Active := True;
      end;
      psIndex: if CheckBoxContinuous.Checked then AudioPlayer.Active := True;
      psStop:;
    end;
  end;
  FState := psNone;
end;

procedure TListenForm.AudioPlayerLevel(Sender: TObject;
  Level: Integer);
begin
  if AudioPlayer.Position <> Cardinal(ProgressBar.Position) then
    ProgressBar.Position := AudioPlayer.Position;
end;
                                         
procedure TListenForm.ButtonPauseClick(Sender: TObject);
begin
  AudioPlayer.Paused := True;
end;

procedure TListenForm.ComboBoxPipeChange(Sender: TObject);
var
  t: Boolean;
begin
  if Assigned(FRank) then begin
    t := AudioPlayer.Active;
    FState := psIndex;
    AudioPlayer.Active := False;
    ProgressBar.Position := 0;
    LabelFormat.Caption := S_ErrorCannotObtainFormat;
    LabelEnd.Caption := S_ErrorCannotObtainLength;
    AudioPlayer.Wave.Clear;
    try
      AudioPlayer.Wave.LoadFromFile(FRank.PipeFilename[ComboBoxPipe.ItemIndex]);
      LabelFormat.Caption := AudioPlayer.Wave.AudioFormat;
      ProgressBar.Max := AudioPlayer.Wave.Length;
      LabelEnd.Caption := Format(S_ValuedDuration, [MS2Str(AudioPlayer.Wave.Length, msSh)]);
      ButtonPlay.Enabled := not AudioPlayer.Active;
      if not t and CheckBoxContinuous.Checked then
        AudioPlayer.Active := True;
    except
      on e: Exception do
        MessageBox(Handle, PChar(e.Message), nil, 0);
    end;
  end;
end;

procedure TListenForm.AudioPlayerActivate(Sender: TObject);
begin
  ButtonPlay.Enabled := AudioPlayer.Paused;
  ButtonPause.Enabled := not AudioPlayer.Paused;
  ButtonStop.Enabled := True;
end;

procedure TListenForm.ButtonPlayClick(Sender: TObject);
begin
  AudioPlayer.Active := True;
  AudioPlayer.Paused := False;
end;

procedure TListenForm.AudioPlayerPause(Sender: TObject);
begin
  ButtonPlay.Enabled := True;
  ButtonPause.Enabled := False;
end;

procedure TListenForm.AudioPlayerResume(Sender: TObject);
begin
  ButtonPlay.Enabled := False;
  ButtonPause.Enabled := True;
end;

procedure TListenForm.ButtonStopClick(Sender: TObject);
begin
//  AudioPlayer.Wave.Clear;
  AudioPlayer.Active := False;
  FState := psStop;
end;

end.
