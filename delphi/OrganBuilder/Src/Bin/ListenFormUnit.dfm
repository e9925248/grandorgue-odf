object ListenForm: TListenForm
  Left = 482
  Top = 346
  ActiveControl = ComboBoxPipe
  BorderStyle = bsDialog
  Caption = 'ListenForm'
  ClientHeight = 146
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelStart: TLabel
    Left = 14
    Top = 83
    Width = 29
    Height = 13
    Caption = '0.00 s'
    ShowAccelChar = False
    Transparent = False
  end
  object LabelFormat: TLabel
    Left = 14
    Top = 46
    Width = 3
    Height = 13
    ShowAccelChar = False
  end
  object LabelEnd: TLabel
    Left = 294
    Top = 83
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = '0.00 s'
    ShowAccelChar = False
    Transparent = False
  end
  object LabelPipe: TLabel
    Left = 8
    Top = 18
    Width = 41
    Height = 13
    AutoSize = False
    Caption = 'Pipe :'
  end
  object ButtonPlay: TBitBtn
    Left = 14
    Top = 108
    Width = 100
    Height = 25
    Caption = 'Play'
    Enabled = False
    TabOrder = 2
    OnClick = ButtonPlayClick
  end
  object ButtonPause: TBitBtn
    Left = 118
    Top = 108
    Width = 100
    Height = 25
    Caption = 'Pause'
    Enabled = False
    TabOrder = 3
    OnClick = ButtonPauseClick
  end
  object ProgressBar: TProgressBar
    Left = 14
    Top = 63
    Width = 309
    Height = 17
    Smooth = True
    TabOrder = 4
  end
  object ComboBoxPipe: TComboBox
    Left = 56
    Top = 14
    Width = 153
    Height = 21
    BevelKind = bkFlat
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBoxPipeChange
  end
  object CheckBoxContinuous: TCheckBox
    Left = 224
    Top = 16
    Width = 89
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Auto play'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object ButtonStop: TBitBtn
    Left = 223
    Top = 108
    Width = 100
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 5
    OnClick = ButtonStopClick
  end
  object AudioPlayer: TAudioPlayer
    BufferLength = 100
    OnActivate = AudioPlayerActivate
    OnDeactivate = AudioPlayerDeactivate
    OnPause = AudioPlayerPause
    OnResume = AudioPlayerResume
    OnLevel = AudioPlayerLevel
    Left = 8
    Top = 8
  end
end
