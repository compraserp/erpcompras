unit classe.usuarios.login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MD5,
  DB, ZDataset, zconnection,
  model.conexao;

type

  { TUserLogin }

  TUserLogin = class


    private
       FQuery: TZQuery;
       function FormataMD5(TXT: String): String;
    public
      function ValidaUsuarioLogin(vlrUser, vlrPassword: String): Integer;
      procedure PegaDadosUsuario(DsAux: TDataSource; vlrUser, vlrPassword: String);


      constructor Create(FConexao: TZConnection);
      destructor Destroy; Override;
  end;

implementation

{ TUserLogin }

function TUserLogin.FormataMD5(TXT: String): String;
var
  TxtFormMD5: String;
begin
  TxtFormMD5 := MD5Print(MD5String(TXT));

  Result := TxtFormMD5;
end;

function TUserLogin.ValidaUsuarioLogin(vlrUser, vlrPassword: String): Integer;
begin
  Result := -1;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select count(*) as existe        ' +
                 '   from usuario_comprador         ' +
                 ' where lower(nome) = lower(:nome) ' +
                 '   and lower(pwd) = lower(:pwd) ');
  FQuery.ParamByName('nome').AsString := LowerCase(vlrUser);
  FQuery.ParamByName('pwd').AsString  := FormataMD5(vlrPassword);
  try
     FQuery.Active := True;
  finally
    Result := FQuery.FieldByName('existe').AsInteger;
  end;
end;

procedure TUserLogin.PegaDadosUsuario(DsAux: TDataSource; vlrUser, vlrPassword: String);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select codacesso, nome, funcao   ' +
                 '   from usuario_comprador         ' +
                 ' where lower(nome) = lower(:nome) ' +
                 '   and lower(pwd) = lower(:pwd) ');
  FQuery.ParamByName('nome').AsString := LowerCase(vlrUser);
  FQuery.ParamByName('pwd').AsString  := LowerCase(vlrPassword);
  try
     FQuery.Active := True;
  except
    // Inserir, caso erro
  end;
end;

constructor TUserLogin.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  FQuery.Connection := FConexao;
end;

destructor TUserLogin.Destroy;
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  inherited Destroy;
end;

end.

