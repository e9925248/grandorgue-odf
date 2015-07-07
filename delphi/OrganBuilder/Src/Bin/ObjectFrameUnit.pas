unit ObjectFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Organ, StdCtrls, ExtCtrls, Buttons;

type
  TPanel = class(ExtCtrls.TPanel)
  private
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
  end;

  TSpeedButton = class(Buttons.TSpeedButton)

  end;

  TObjectFrame = class(TFrame)
    Panel: TPanel;
    PaintBox: TPaintBox;
    ButtonDelete: TSpeedButton;
    procedure PaintBoxPaint(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FrameResize(Sender: TObject);
    procedure PaintBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure PaintBoxStartDrag(Sender: TObject;
      var DragObject: TDragObject);
  private
    FObject: TObject;
    FTracking: Boolean;
    FOwner: TFrame;

    procedure SetObject(const Value: TObject);

    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
  public
    constructor Create(AOwner: TFrame); reintroduce;

    property _Object: TObject read FObject write SetObject;
  end;

implementation

uses
  MainFormUnit, ObjectMatrixFrameUnit;

{$R *.dfm}

{ TPanel }

procedure TPanel.WMMouseLeave(var Message: TMessage);
begin
  Owner.Dispatch(Message);
end;

{ TObjectFrame }

procedure TObjectFrame.SetObject(const Value: TObject);
begin
  FObject := Value;
  PaintBox.Invalidate;
  ButtonDelete.Visible := FTracking and Assigned(FObject);
end;

procedure TObjectFrame.PaintBoxPaint(Sender: TObject);
var
  s: string;
  r: TRect;
begin
//  Assert(False);
  s := '';
  PaintBox.Canvas.Font.Style := [fsBold];
  PaintBox.Canvas.Brush.Color := clBtnFace;
  if FObject is TStop then
    with FObject as TStop do begin
      s := Name;
      if Assigned(Manual) then
        s := s + ' (' + Manual.Name +')';
      PaintBox.Canvas.Brush.Color := clWindow;
      PaintBox.Canvas.Font.Color := StopFamily.RGBFontColor;
    end;
  if FObject is TCoupler then
    with FObject as TCoupler do begin
      s := Name;
      PaintBox.Canvas.Brush.Color := clWindow;
      PaintBox.Canvas.Font.Color := Owner.Couplers.RGBFontColor;
    end;
  if FObject is TPiston then
    with FObject as TPiston do begin
      s := Name;
      PaintBox.Canvas.Brush.Color := clWindow;
      PaintBox.Canvas.Font.Color := StopFamily.RGBFontColor;
    end;
  if FObject is TTremulant then
    with FObject as TTremulant do begin
      s := Name;
      PaintBox.Canvas.Brush.Color := clWindow;
      PaintBox.Canvas.Font.Color := Owner.Tremulants.RGBFontColor;
    end;
  PaintBox.Canvas.FillRect(PaintBox.ClientRect);
  r := PaintBox.ClientRect;
  Windows.DrawText(PaintBox.Canvas.Handle, PChar(s), -1, r, DT_CENTER or DT_WORDBREAK or DT_WORD_ELLIPSIS or DT_END_ELLIPSIS or DT_EDITCONTROL or DT_VCENTER);
end;

procedure TObjectFrame.PaintBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  TME: TTrackMouseEvent;
begin
  if not FTracking then begin
    TME.cbSize := SizeOf(TME);
    TME.dwFlags := TME_LEAVE;
    TME.hwndTrack := Panel.Handle;
    TME.dwHoverTime := 0;
    if not TrackMouseEvent(TME) then
      RaiseLastOSError;
  end;
  ButtonDelete.Visible := Assigned(FObject);
end;

procedure TObjectFrame.WMMouseLeave(var Message: TMessage);
var
  p: TPoint;
begin
  GetCursorPos(p);
  Windows.ScreenToClient(Panel.Handle, p);
  if PtInRect(Panel.ClientRect, p) then
    PaintBoxMouseMove(nil, [], 0, 0)
  else begin
    FTracking := False;
    ButtonDelete.Hide;
  end;
end;

procedure TObjectFrame.FrameResize(Sender: TObject);
begin
  with ButtonDelete do
    SetBounds(Panel.ClientWidth - Width, 0, Width, Height);
end;

procedure TObjectFrame.PaintBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TOrganDragObject) and (
    ((Source as TOrganDragObject).Data is TStop) or
    ((Source as TOrganDragObject).Data is TCoupler) or
    ((Source as TOrganDragObject).Data is TPiston) or
    ((Source as TOrganDragObject).Data is TTremulant)
  );
end;

procedure TObjectFrame.PaintBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if Source is TOrganDragObject then
    with Source as TOrganDragObject do
      if (Data is TStop) or (Data is TCoupler) or (Data is TPiston) or (Data is TTremulant) then
        SetObject(Data);
  (FOwner as TObjectMatrixFrame).UpdateData(Self);
end;

procedure TObjectFrame.ButtonDeleteClick(Sender: TObject);
begin
  SetObject(nil);
  (FOwner as TObjectMatrixFrame).UpdateData(Self);
end;

constructor TObjectFrame.Create(AOwner: TFrame);
begin
  inherited Create(nil);
  FOwner := AOwner;
end;

procedure TObjectFrame.PaintBoxStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if Assigned(FObject) then
    DragObject := TOrganDragObject.Create(FObject);
end;

end.
