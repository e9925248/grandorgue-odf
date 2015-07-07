unit WarningFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Organ;

type
  TWarningForm = class(TForm)
    Memo: TMemo;
    ButtonClose: TBitBtn;
    procedure ButtonCloseClick(Sender: TObject);
  private
  public
    procedure Execute(AOrgan: TOrgan);
  end;

var
  WarningForm: TWarningForm;

implementation

{$R *.dfm}

procedure TWarningForm.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TWarningForm.Execute(AOrgan: TOrgan);
begin
  Memo.Clear;
  if AOrgan.Warnings.Count > 0 then begin
    Memo.Lines.AddStrings(AOrgan.Warnings);
    Show;
  end else
    Hide;
end;

end.
