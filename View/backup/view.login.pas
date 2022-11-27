unit view.login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TFormLogin }

  TFormLogin = class(TForm)
    ButtonEntrar: TBitBtn;
    BitBtn2: TBitBtn;
    EditSenha: TEdit;
    ImgLogin: TImage;
    EditUsuario: TLabeledEdit;
    LabelSenha: TLabel;
  private

  public

  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.lfm}

end.

