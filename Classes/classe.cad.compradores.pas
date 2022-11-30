unit classe.cad.compradores;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  DB, ZDataset,
  ZConnection;

type

  { TCadCompradores }

  TCadCompradores = class

    private
       FQuery: TZQuery;
       ConexaoDB: TZConnection;

       FCodComprador: Integer;
       FNome: String;
       FPwd: String;
       FFuncao: Integer;

    public

       procedure Atualizar(Cod: Integer; DsAux: TDataSource);
       procedure AtualizarComSenha(Cod: Integer; DsAux: TDataSource);
       procedure Deletar(Cod: Integer);
       procedure Inserir(DsAux: TDataSource);

       procedure Listagem(DsAux: TDataSource);
       procedure Selecionar(Cod: Integer; DsAux: TDataSource);


       constructor Create(FConexao: TZConnection);
       destructor Destroy; Override;

  published
     property F_CodComprador: Integer read FCodComprador write FCodComprador;
     property F_Nome: String          read FNome         write FNome;
     property F_Pwd: String           read FPwd          write FPwd;
     property F_Funcao: Integer       read FFuncao       write FFuncao;



  end;

implementation

{ TCadCompradores }

procedure TCadCompradores.Listagem(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_list_comprador ');
  FQuery.Active := True;
end;

procedure TCadCompradores.Selecionar(Cod: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_select_comprador ' +
                 ' where codacesso = :cod ');
  FQuery.ParamByName('cod').AsInteger := Cod;
  FQuery.Active := True;
end;

procedure TCadCompradores.Atualizar(Cod: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' update usuario_comprador set nome = :nome ' +
                 '                            ,funcao = :func ' +
                 ' where codacesso = :cod ');
  FQuery.ParamByName('nome').AsString  := Self.FNome;
  FQuery.ParamByName('func').AsInteger := Self.FFuncao;
  FQuery.ParamByName('cod').AsInteger  := Cod;

  try
   FQuery.ExecSQL;
  except
    // Ações de erro
  end;
end;


procedure TCadCompradores.AtualizarComSenha(Cod: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' update usuario_comprador set nome  = :nome ' +
                 '                            ,funcao = :func ' +
                 '                            ,pwd    = :pwd  ' +
                 ' where codacesso = :cod ');
  FQuery.ParamByName('nome').AsString  := Self.FNome;
  FQuery.ParamByName('func').AsInteger := Self.FFuncao;
  FQuery.ParamByName('pwd').AsString   := Self.FPwd;
  FQuery.ParamByName('cod').AsInteger  := Cod;

  try
   FQuery.ExecSQL;
  except
    // Ações de erro
  end;
end;

procedure TCadCompradores.Inserir(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' insert into usuario_comprador(nome, funcao, pwd) ' +
                 '    values(:nome, :func, :pwd) ');
  FQuery.ParamByName('nome').AsString  := Self.FNome;
  FQuery.ParamByName('func').AsInteger := Self.FFuncao;
  FQuery.ParamByName('pwd').AsString   := Self.FPwd;
  try
    FQuery.ExecSQL;
  except
    // Ações de erro
  end;
end;

procedure TCadCompradores.Deletar(Cod: Integer);
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' delete from usuario_comprador where codacesso = :cod ');
  FQuery.ParamByName('cod').AsInteger := Cod;
  try
    FQuery.ExecSQL;
  except
    // Ação de erro
  end;

end;

constructor TCadCompradores.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  ConexaoDB := FConexao;
  FQuery.Connection := ConexaoDB;
end;

destructor TCadCompradores.Destroy;
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  inherited Destroy;
end;

end.

