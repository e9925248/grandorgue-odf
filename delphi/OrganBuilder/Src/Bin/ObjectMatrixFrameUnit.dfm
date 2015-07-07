object ObjectMatrixFrame: TObjectMatrixFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  OnResize = FrameResize
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 265
    Height = 201
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    TabOrder = 0
    object PanelTopLabels: TPanel
      Left = 32
      Top = 88
      Width = 89
      Height = 25
      BevelOuter = bvNone
      Caption = 'Top labels :'
      TabOrder = 0
    end
    object PanelBottomLabels: TPanel
      Left = 136
      Top = 88
      Width = 89
      Height = 25
      BevelOuter = bvNone
      Caption = 'Bottom labels :'
      TabOrder = 1
    end
  end
end
