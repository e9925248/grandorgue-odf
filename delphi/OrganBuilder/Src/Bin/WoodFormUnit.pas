unit WoodFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons;

type
  TWoodForm = class(TForm)
    DrawGrid: TDrawGrid;
    ButtonOk: TBitBtn;
    ButtonCancel: TBitBtn;
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
  public
    function Execute(var Index: Integer; Name: string): Boolean;
  end;

var
  WoodForm: TWoodForm;

  S_SelectBackgroundFor: string = 'Select background for %s...';

implementation

uses
  MainFormUnit;

{$R *.dfm}

{ TWoodForm }

procedure TWoodForm.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  MainForm.ImageListWoods.Draw(DrawGrid.Canvas, Rect.Left, Rect.Top, ACol + ARow * 8);
  if gdSelected in State then begin
    DrawGrid.Canvas.Brush.Style := bsClear;
    DrawGrid.Canvas.Pen.Color := clRed;
    DrawGrid.Canvas.Pen.Width := 3;
    InflateRect(Rect, -1, -1);
    DrawGrid.Canvas.Rectangle(Rect);
  end;
end;

function TWoodForm.Execute(var Index: Integer; Name: string): Boolean;
var
  r: TGridRect;
begin
  r.Left := Index mod 8;
  r.Top := Index div 8;
  r.BottomRight := r.TopLeft;
  DrawGrid.Selection := r;
  Caption := Format(S_SelectBackgroundFor, [Name]);
  Result := ShowModal = mrOk;
  if Result then
    Index := DrawGrid.Selection.Left + 8 * DrawGrid.Selection.Top;
end;

end.
