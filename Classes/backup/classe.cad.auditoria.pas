unit classe.cad.auditoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  DB, ZDataset,
  ZConnection,
  types.actions;

type

  { TCadAuditoria }

  TCadAuditoria = class

     private
       FQuery: TZQuery;

       ConexaoDB: TZConnection;
       FCodAudit: Integer;
       FMetodo: Integer;
       FTitulo: String;
       FNomeCliente: String;
       FCPFCNPJ: String;
       FAssEscopo: String;
       FAssForaEscopo: String;
       FAuditResp: String;
       FDataCad: TDate;



     public
       constructor Create(FConexao: TZConnection);
       destructor Destroy; Override;

       procedure Listagem(DsAux: TDataSource);
       procedure Selecionar(DsAux: TDataSource; Cod: Integer);
       function Atualizar(Cod: Integer): Boolean;
       function Inserir: Boolean;
       function Deletar(Cod: Integer): Boolean;

     published

       property F_CodAudit: Integer     read FCodAudit      write FCodAudit;
       property F_Metodo: Integer       read FMetodo        write FMetodo;
       property F_Titulo: String        read FTitulo        write FTitulo;
       property F_NomeCliente: String   read FNomeCliente   write FNomeCliente;
       property F_CPFCNPJ: String       read FCPFCNPJ       write FCPFCNPJ;
       property F_AssEscopo: String     read FAssEscopo     write FAssEscopo;
       property F_AssForaEscopo: String read FAssForaEscopo write FAssForaEscopo;
       property F_AuditResp: String     read FAuditResp     write FAuditResp;
       property F_DataCad: TDate        read FDataCad       write FDataCad;




  end;

implementation

{ TCadAuditoria }

constructor TCadAuditoria.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  ConexaoDB := FConexao;
  FQuery.Connection := ConexaoDB;
end;

destructor TCadAuditoria.Destroy;
begin
  FreeAndNil(FQuery);
  inherited Destroy;
end;

procedure TCadAuditoria.Listagem(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from auditoriacab  ' +
                 ' order by titulo, nomeCliente, dataCad ');
  FQuery.Active := True;
end;

procedure TCadAuditoria.Selecionar(DsAux: TDataSource; Cod: Integer);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from auditoriacab  ' +
                 ' where codauditoria = :cod ');
  FQuery.ParamByName('cod').AsInteger := Cod;
  FQuery.Active := True;
end;

function TCadAuditoria.Atualizar(Cod: Integer): Boolean;
begin
  Result := True;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' update auditoriacab set titulo       = :titulo    ' +
                 '                       ,nomeCliente   = :cliente   ' +
                 '                       ,cpfcnpj       = :cpfcnpj   ' +
                 '                       ,assescopo     = :assescopo ' +
                 '                       ,assforaescopo = :assforescopo ' +
                 '                       ,metodo        = :metodo       ' +
                 ' where codauditoria = :cod ');
  FQuery.ParamByName('cod').AsInteger         := Cod;
  FQuery.ParamByName('titulo').AsString       := Self.FTitulo;
  FQuery.ParamByName('cliente').AsString      := Self.FNomeCliente;
  FQuery.ParamByName('cpfcnpj').AsString      := Self.FCPFCNPJ;
  FQuery.ParamByName('assescopo').AsString    := Self.FAssEscopo;
  FQuery.ParamByName('assforescopo').AsString := Self.FAssForaEscopo;
  FQuery.ParamByName('metodo').AsInteger      := Self.FMetodo;

  try
    FQuery.ExecSQL;
  except
    Result := False;
  end;
end;

function TCadAuditoria.Inserir: Boolean;
begin
  Result := True;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' insert into auditoriacab(titulo, nomeCliente, cpfcnpj    ' +
                 '             ,assEscopo, assForaEscopo, auditResp         ' +
                 '             ,metodo, datacad) values (:tit, :nmCliente   ' +
                 '             ,:cpfcnpj, :assescopo, :assfescopo, :audResp ' +
                 '             ,:metodo, :dtCad) ');

  FQuery.ParamByName('tit').AsString          := Self.FTitulo;
  FQuery.ParamByName('nmCliente').AsString    := Self.FNomeCliente;
  FQuery.ParamByName('cpfcnpj').AsString      := Self.FCPFCNPJ;
  FQuery.ParamByName('assescopo').AsString    := Self.FAssEscopo;
  FQuery.ParamByName('assfescopo').AsString   := Self.FAssForaEscopo;
  FQuery.ParamByName('audResp').AsString      := Self.FAuditResp;
  FQuery.ParamByName('metodo').AsInteger      := Self.FMetodo;
  FQuery.ParamByName('dtCad').AsDate          := Self.FDataCad;

  try
    FQuery.ExecSQL;
  except
    Result := False;
  end;
end;

function TCadAuditoria.Deletar(Cod: Integer): Boolean;
begin
  Result := True;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('delete from auditoriacab where codauditoria = :cod ');
  FQuery.ParamByName('cod').AsInteger := Cod;
  try
    FQuery.ExecSQL;
  except
    Result := False;
  end;
end;

end.

