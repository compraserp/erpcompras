unit classe.funcoesAuxiliares;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons,
  ComCtrls, DBGrids, EditBtn, StdCtrls, Spin;

type

  { TFuncAuxiliar }

  TFuncAuxiliar = class

    private

    public

      procedure LimpaCampos(Form: TForm);
      procedure CampoObrigatorio(Form: TForm; FTag: Integer);
      constructor Create;
      destructor Destroy; Override;
  end;

implementation

{ TFuncAuxiliar }

constructor TFuncAuxiliar.Create;
begin
  //
end;

destructor TFuncAuxiliar.Destroy;
begin
  inherited Destroy;
end;

procedure TFuncAuxiliar.LimpaCampos(Form: TForm);
var
  i: Integer;
begin
  for i := 0 to Form.Componentcount-1 do begin
    if(Form.Components[i] is TLabeledEdit) then
      TLabeledEdit(Form.Components[i]).Text := EmptyStr
    else if(Form.Components[i] is TEdit) then
      TEdit(Form.Components[i]).Text := EmptyStr
    else if(Form.Components[i] is TSpinEdit) then
      TSpinEdit(Form.Components[i]).Value := 0
    else if(Form.Components[i] is TFloatSpinEdit) then
        TFloatSpinEdit(Form.Components[i]).Value := 0.00
    else if(Form.Components[i] is TMemo) then
      if (TMemo(Form.Components[i]).Tag <> 1) then
        TMemo(Form.Components[i]).Lines.Clear;
  end;
end;

procedure TFuncAuxiliar.CampoObrigatorio(Form: TForm; FTag: Integer);
var
  i: Integer;
begin
  for i := 0 to Form.ComponentCount -1 do begin
      if(Form.Components[i] is TLabeledEdit) then begin
        if((TLabeledEdit(Form.Components[i]).Text = Trim('')) and
           (TLabeledEdit(Form.Components[i]).Tag = FTag)) then begin
             MessageDlg('O campo ' + TLabeledEdit(Form.Components[i]).EditLabel.Caption +
             ' é obrigatório!', mtWarning, [mbOk], 0);
            TLabeledEdit(Form.Components[i]).SetFocus;
            Abort;
        end;
    end;
    if(Form.Components[i] is TEdit) then begin
      if((TEdit(Form.Components[i]).Text = Trim('')) and
        (TEdit(Form.Components[i]).Tag = FTag)) then begin
          MessageDlg('O campo ' + TLabeledEdit(Form.Components[i]).EditLabel.Caption +
          ' é obrigatório!', mtWarning, [mbOk], 0);
        TEdit(Form.Components[i]).SetFocus;
        Abort;
      end;
    end;
  end;
end;

end.

