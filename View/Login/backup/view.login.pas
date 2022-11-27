unit view.login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Forms, Controls,
  Graphics, Dialogs,
  ExtCtrls, StdCtrls,
  Buttons, ZDataset,
  model.conexao, md5,
  classe.usuarios.login, db;

type

  { TFormLogin }

  TFormLogin = class(TForm)
    CheckMostrarSenha: TCheckBox;
    DsUsuario: TDataSource;
    EditUsuario: TEdit;
    EditSenha: TEdit;
    ImageLogin: TImage;
    ImagemPrincipal: TImage;
    LabelCopy: TLabel;
    LabelUsuario: TLabel;
    LabelSenha: TLabel;
    PanelButtonCancelar: TPanel;
    PanelButtonAcessar: TPanel;
    PanelPrincipal: TPanel;
    PanelEditUsuario: TPanel;
    PanelUsuario: TPanel;
    PanelEditSenha: TPanel;
    PanelSenha: TPanel;
    ButtonAcessar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    procedure ButtonAcessarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure CheckMostrarSenhaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    FCodUsuLog: Integer;
    FCodFuncUsuLog: Integer;
    FNomeUsuLog: String;

    obj_userLogin: TUserLogin;

    procedure ColetaDadosUsuario;
    procedure Login;

  published
    property F_CodUsuario: Integer  read FCodUsuLog     write FCodUsuLog;
    property F_NomeUsuario: String  read FNomeUsuLog    write FNomeUsuLog;
    property F_FuncUsuario: Integer read FCodFuncUsuLog write FCodFuncUsuLog;

  end;

var
  FormLogin: TFormLogin;

implementation

uses
  view.principal;

{$R *.lfm}

{ TFormLogin }

procedure TFormLogin.ButtonAcessarClick(Sender: TObject);
begin
  Login;
  Close;
end;

procedure TFormLogin.ButtonCancelarClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormLogin.CheckMostrarSenhaChange(Sender: TObject);
begin
  if(CheckMostrarSenha.Checked) then
    EditSenha.PasswordChar := #0
  else EditSenha.PasswordChar := '#';
end;

procedure TFormLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(obj_userLogin) then
    FreeAndNil(obj_userLogin);
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  obj_userLogin := TUserLogin.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

procedure TFormLogin.ColetaDadosUsuario;
begin
  FCodUsuLog     := DsUsuario.DataSet.FieldByName('codacesso').AsInteger;
  FNomeUsuLog    := DsUsuario.DataSet.FieldByName('nome').AsString;
  FCodFuncUsuLog := DsUsuario.DataSet.FieldByName('funcao').AsInteger;
end;

procedure TFormLogin.Login;
var
  VlrRetorno: Integer;
begin
  VlrRetorno
    := obj_userLogin.ValidaUsuarioLogin(EditUsuario.Text, EditSenha.Text);
  if(VlrRetorno = 1) then begin
    obj_userLogin.PegaDadosUsuario(DsUsuario, EditUsuario.Text, EditSenha.Text);
    ColetaDadosUsuario;
    Exit;
  end
  else if(VlrRetorno = 0) then begin
    MessageDlg('Dados inválidos! Login não permitido!', mtError, [mbOk], 0);
    Abort;
  end;

end;

end.

