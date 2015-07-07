unit ObjectMatrixFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Organ, ObjectFrameUnit, Contnrs, StdCtrls, ExtCtrls;

type
  TObjectMatrixFrame = class(TFrame)
    ScrollBox: TScrollBox;
    PanelTopLabels: TPanel;
    PanelBottomLabels: TPanel;
    procedure FrameResize(Sender: TObject);
  private
    FUpdating: Boolean;
    FOrgan: TOrgan;
    FMatrix, FInternalMatrix: TObjectMatrix;
    FTopLabels, FBottomLabels: TStrings;
    FPanels: TObjectList;
    FEdits: TObjectList;
    FItemWidth, FItemHeight: Integer;

    procedure SetOrgan(const Value: TOrgan);
    procedure SetMatrix(const Value: TObjectMatrix);
    procedure SetTopLabels(const Value: TStrings);
    procedure SetBottomLabels(const Value: TStrings);

    procedure EditChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdateData(Sender: TObjectFrame);
    procedure UpdateGUI;

    property Organ: TOrgan write SetOrgan;
    property Matrix: TObjectMatrix read FMatrix write SetMatrix;
    property TopLabels: TStrings write SetTopLabels;
    property BottomLabels: TStrings write SetBottomLabels;

    property ItemWidth: Integer read FItemWidth write FItemWidth;
    property ItemHeight: Integer read FItemHeight write FItemHeight;
  end;

var
  S_TopLabels: string = 'Top labels :';
  S_BottomLabels: string = 'Bottom labels :';

implementation

uses
  MainFormUnit;

{$R *.dfm}

{ TObjectMatrixFrame }

constructor TObjectMatrixFrame.Create(AOwner: TComponent);
begin
  inherited;
  FInternalMatrix := TObjectMatrix.Create;
  FEdits := TObjectList.Create(True);
  FPanels := TObjectList.Create(True);
  FItemWidth := 100;
  FItemHeight := 50;
end;

destructor TObjectMatrixFrame.Destroy;
begin
  FreeAndNil(FPanels);
  FreeAndNil(FEdits);
  FreeAndNil(FInternalMatrix);
  inherited;
end;

procedure TObjectMatrixFrame.SetMatrix(const Value: TObjectMatrix);
begin
  FMatrix := Value;
  UpdateGUI;
end;

procedure TObjectMatrixFrame.UpdateData(Sender: TObjectFrame);
var
  a, b: Integer;
begin
  if FUpdating then
    Exit;
  if Assigned(FMatrix) then
    for a := 0 to FMatrix.Width - 1 do
      for b := 0 to FMatrix.Height - 1 do
        if (FInternalMatrix[a, b] = Sender) and (FMatrix[a, b] <> (FInternalMatrix[a, b] as TObjectFrame)._Object) then begin
          (Owner as TMainForm).DataSync := (Owner as TMainForm).DataSync - [dsPanelStructure];
          (Owner as TMainForm).Organ.MarkModified;
          FMatrix[a, b] := (FInternalMatrix[a, b] as TObjectFrame)._Object;
        end;
  (Owner as TMainForm).UpdateGUI;
end;

procedure TObjectMatrixFrame.UpdateGUI;
var                                    
  a, b: Integer;
begin
  FUpdating := True;
  try
    if Assigned(FOrgan) then begin
      if FOrgan.HasPedals then
        b := FOrgan.NumberOfManuals + 1
      else
        b := FOrgan.NumberOfManuals;
    end else
      b := 0;
    while FPanels.Count > b do
      FPanels.Delete(FPanels.Count - 1);
    while FPanels.Count < b do begin
      ScrollBox.Visible := False;
      FPanels.Add(TPanel.Create(nil));
      with FPanels[FPanels.Count - 1] as TPanel do begin
        BevelOuter := bvNone;
        Parent := ScrollBox;
      end;
    end;
    for a := 0 to FPanels.Count - 1 do
      with FPanels[a] as TPanel do begin
        Caption := FOrgan.Manual[FOrgan.NumberOfManuals - a].Name;
        Visible := not FOrgan.Manual[FOrgan.NumberOfManuals - a].Invisible;
      end;
    if Assigned(FMatrix) then begin
      a := FMatrix.Width;
      b := FMatrix.Height;
    end else begin
      a := 0;
      b := 0;
    end;
    if (a <> FInternalMatrix.Width) or (b <> FInternalMatrix.Height) then begin
      FInternalMatrix.Clear(True);
      FInternalMatrix.Resize(a, b);
    end;
    for a := 0 to FInternalMatrix.Width - 1 do
      for b := 0 to FInternalMatrix.Height - 1 do begin
        if not Assigned(FInternalMatrix[a, b]) then begin
          ScrollBox.Visible := False;
          FInternalMatrix[a, b] := TObjectFrame.Create(Self);
        end;
        with FInternalMatrix[a, b] as TObjectFrame do begin
          _Object := FMatrix[a, b];
          Visible := not Assigned(FOrgan) or (b < FOrgan.Layout.TopPistonMatrixHeight) or (b >= FMatrix.Height - FOrgan.Layout.BottomPistonMatrixHeight) or not FOrgan.Manual[FMatrix.Height - FOrgan.Layout.BottomPistonMatrixHeight - b].Invisible;
          Parent := ScrollBox;
        end;
      end;
    if Assigned(FTopLabels) then
      a := FTopLabels.Count
    else
      a := 0;
    if Assigned(FBottomLabels) then
      Inc(a, FBottomLabels.Count);
    while FEdits.Count > a do begin
      ScrollBox.Visible := False;
      FEdits.Delete(FEdits.Count - 1);
    end;
    while FEdits.Count < a do begin
      ScrollBox.Visible := False;
      FEdits.Add(TEdit.Create(nil));
      with FEdits[FEdits.Count - 1] as TEdit do begin
        BorderStyle := bsNone;
        BevelKind := bkFlat;
        OnChange := EditChange;
        Parent := ScrollBox;
      end;
    end;
    if Assigned(FTopLabels) then
      b := FTopLabels.Count
    else
      b := 0;
    for a := 0 to FEdits.Count - 1 do
      with TEdit(FEdits[a]) do
        if a < b then begin
          Tag := a;
          Text := FTopLabels[a];
        end else begin
          Tag := (a - b) or $100;
          Text := FBottomLabels[a - b];
        end;
    PanelTopLabels.Visible := FEdits.Count > 0;
    PanelTopLabels.Caption := S_TopLabels;
    PanelBottomLabels.Visible := FEdits.Count > 0;
    PanelBottomLabels.Caption := S_BottomLabels;
    FrameResize(nil);
  finally
    FUpdating := False;
  end;
end;

procedure TObjectMatrixFrame.FrameResize(Sender: TObject);
var
  a, b, c, d: Integer;
  r: TRect;
  t, u: Boolean;
begin
//  ScrollBox.Visible := False;
  ScrollBox.HorzScrollBar.Position := 0;
  ScrollBox.VertScrollBar.Position := 0;
  c := 0;
  if PanelTopLabels.Visible then begin
    PanelTopLabels.SetBounds(0, c, FInternalMatrix.Width * FItemWidth - 1, 20);
    Inc(c, 23);
  end;
  b := 0;
  d := 0;
  for a := 0 to FEdits. Count - 1 do
    with FEdits[a] as TEdit do
      if Tag and $100 = 0 then begin
        SetBounds((d div 2) * FItemWidth + b * FItemWidth div 2, c + b * Height, FItemWidth - 1, Height);
        Inc(d);
        b := 1 - b;
      end;
  if FEdits.Count > 0 then begin
    case c of
      0:;
      1: Inc(c, TEdit(FEdits[0]).Height + 15);
    else
      Inc(c, 2 * TEdit(FEdits[0]).Height + 15);
    end;         
  end;
  for b := 0 to FInternalMatrix.Height - 1 do begin
    if Assigned(FOrgan) and (b >= FOrgan.Layout.TopPistonMatrixHeight) and (b - FOrgan.Layout.TopPistonMatrixHeight < FPanels.Count) then begin
      with FPanels[b - FOrgan.Layout.TopPistonMatrixHeight] as TPanel do begin
        SetBounds(0, c + 8, FInternalMatrix.Width * FItemWidth - 1, 15);
        if Visible then
          Inc(c, 26);
      end;
    end;
    if not Assigned(FOrgan) or (b < FOrgan.Layout.TopPistonMatrixHeight) or (b >= FMatrix.Height - FOrgan.Layout.BottomPistonMatrixHeight) or not FOrgan.Manual[FMatrix.Height - FOrgan.Layout.BottomPistonMatrixHeight - b].Invisible then begin
      for a := 0 to FInternalMatrix.Width - 1 do
        with FInternalMatrix[a, b] as TObjectFrame do
          SetBounds(a * FItemWidth, c, FItemWidth - 1, FItemHeight - 1);
      Inc(c, FItemHeight);
    end;
  end;
  if PanelBottomLabels.Visible then begin
    PanelBottomLabels.SetBounds(0, c + 8, FInternalMatrix.Width * FItemWidth - 1, 20);
    Inc(c, 31);
  end;
  b := 0;
  d := 0;
  for a := 0 to FEdits. Count - 1 do
    with FEdits[a] as TEdit do
      if Tag and $100 = $100 then begin
        SetBounds((d div 2) * FItemWidth + b * FItemWidth div 2, c + b * Height, FItemWidth - 1, Height);
        Inc(d);
        b := 1 - b;
      end;
  b := 0;
  c := 0;
  for a := 0 to ScrollBox.ControlCount - 1 do
    with ScrollBox.Controls[a] do
      if Visible then begin
        if Left + Width > b then
          b := Left + Width;
        if Top + Height > c then
          c := Top + Height;
      end;
  Inc(b, 5);
  Inc(c, 5);
  t := b > ClientWidth;
  u := c > ClientHeight;
  if t then
    Inc(c, 20);
  if u then
    Inc(b, 20);
  t := b > ClientWidth;
  u := c > ClientHeight;
  if t then begin
    r.Left := 0;
    r.Right := ClientWidth;
  end else begin
    r.Left := (ClientWidth - b) div 2;
    r.Right := b;
  end;
  if u then begin
    r.Top := 0;
    r.Bottom := ClientHeight;
  end else begin
    r.Top := (ClientHeight - c) div 2;
    r.Bottom := c;
  end;
  with r do
    ScrollBox.SetBounds(Left, Top, Right, Bottom);
  ScrollBox.Visible := True;
end;

procedure TObjectMatrixFrame.SetBottomLabels(const Value: TStrings);
begin
  FBottomLabels := Value;
  UpdateGUI;
end;

procedure TObjectMatrixFrame.SetTopLabels(const Value: TStrings);
begin
  FTopLabels := Value;
  UpdateGUI;
end;

procedure TObjectMatrixFrame.EditChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  with Sender as TEdit do
    if Tag and $100 = 0 then
      FTopLabels[Tag] := Text
    else
      FBottomLabels[Tag and $FF] := Text;
  (Owner as TMainForm).Organ.MarkModified;
  (Owner as TMainForm).UpdateGUI;
end;

procedure TObjectMatrixFrame.SetOrgan(const Value: TOrgan);
begin
  FOrgan := Value;
  UpdateGUI;
end;

end.
