object ObjectFrame: TObjectFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  OnResize = FrameResize
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 0
    object PaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 316
      Height = 236
      Align = alClient
      DragMode = dmAutomatic
      OnDragDrop = PaintBoxDragDrop
      OnDragOver = PaintBoxDragOver
      OnMouseMove = PaintBoxMouseMove
      OnPaint = PaintBoxPaint
      OnStartDrag = PaintBoxStartDrag
    end
    object ButtonDelete: TSpeedButton
      Left = 256
      Top = 16
      Width = 17
      Height = 17
      Caption = #251
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clMenuHighlight
      Font.Height = -20
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      Visible = False
      OnClick = ButtonDeleteClick
    end
  end
end
