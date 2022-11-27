unit view.sobre;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls;

type

  { TFormSobre }

  TFormSobre = class(TForm)
    MemoInfo: TMemo;
    PanelRodape: TPanel;
    PanelTopo: TPanel;
    ButtonOkSair: TSpeedButton;
    procedure ButtonOkSairClick(Sender: TObject);
  private

  public

  end;

var
  FormSobre: TFormSobre;

implementation

{$R *.lfm}

{ TFormSobre }

procedure TFormSobre.ButtonOkSairClick(Sender: TObject);
begin
  Close;
end;

end.

