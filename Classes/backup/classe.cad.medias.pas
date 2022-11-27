unit classe.cad.medias;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  db, ZConnection, ZDataset;

type

  { TCadMedias }

  TCadMedias = class

    private
      FQueryS: TZQuery;
      FQueryE: TZQuery;

      FAno: Integer;
      FMes: Integer;
      FTotal: Currency;
      FOperacao: String;

    published

      property F_Ano: Integer     read FAno       write FAno;
      property F_Mes: Integer     read FMes       write FMes;
      property F_Total: Currency  read FTotal     write FTotal;
      property F_Operacao: String read FOperacao  write FOperacao;

    public

      procedure ListagemMediasSaidas(CodProd: Integer; DsAux: TDataSource);
      procedure ListagemMediasEntradas(CodProd: Integer; DsAux: TDataSource);

      procedure InserirDadosS(CodProduto: Integer; DsAux: TDataSource; Natureza: String);
      procedure DeletarMediaS(CodMedia: Integer);

      procedure InserirDadosE(CodProduto: Integer; DsAux: TDataSource; Natureza: String);
      procedure DeletarMediaE(CodMedia: Integer);

      constructor Create(FConexao: TZConnection);
      destructor Destroy; Override;
  end;

implementation

{ TCadMedias }

procedure TCadMedias.ListagemMediasSaidas(CodProd: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQueryS;
  FQueryS.SQL.Clear;
  FQueryS.SQL.Add(' select * from vw_list_media_saida ' +
                 ' where codproduto = :cod ');
  FQueryS.ParamByName('cod').AsInteger := CodProd;
  FQueryS.Active := True;
end;

procedure TCadMedias.ListagemMediasEntradas(CodProd: Integer; DsAux: TDataSource
  );
begin
  DsAux.DataSet := FQueryE;
  FQueryE.SQL.Clear;
  FQueryE.SQL.Add(' select * from vw_list_media_entrada ' +
                 ' where codproduto = :cod ');
  FQueryE.ParamByName('cod').AsInteger := CodProd;
  FQueryE.Active := True;
end;

procedure TCadMedias.InserirDadosS(CodProduto: Integer; DsAux: TDataSource;
  Natureza: String);
begin
  DsAux.DataSet := FQueryS;
  FQueryS.SQL.Clear;
  FQueryS.SQL.Add(' insert into produto_medias(codproduto, ano, mes, total, ' +
                  ' natureza, operacao) values(:codprod, :ano, :mes, :tot, :nat, :op) ');
  FQueryS.ParamByName('codprod').AsInteger := CodProduto;
  FQueryS.ParamByName('ano').AsInteger     := Self.FAno;
  FQueryS.ParamByName('mes').AsInteger     := Self.FMes;
  FQueryS.ParamByName('tot').AsCurrency    := Self.FTotal;
  FQueryS.ParamByName('nat').AsString      := UpperCase(Natureza);
  FQueryS.ParamByName('op').AsString       := UpperCase(Self.FOperacao);

  try
    FQueryS.ExecSQL;
  except
    // Implantar erro
  end;
end;

procedure TCadMedias.DeletarMediaS(CodMedia: Integer);
begin
  FQueryS.SQL.Clear;
  FQueryS.SQL.Add(' delete from produto_medias where codmedia = :cod ');
  FQueryS.ParamByName('cod').AsInteger := CodMedia;
  try
    FQueryS.ExecSQL;
  except
    // Implantar erro
  end;
end;

procedure TCadMedias.InserirDadosE(CodProduto: Integer; DsAux: TDataSource;
  Natureza: String);
begin
  DsAux.DataSet := FQueryE;
  FQueryE.SQL.Clear;
  FQueryE.SQL.Add(' insert into produto_medias(codproduto, ano, mes, total, ' +
                  '       natureza, operacao)                               ' +
                  ' values(:codprod, :ano, :mes, :tot, :nat, :op) ');
  FQueryE.ParamByName('codprod').AsInteger := CodProduto;
  FQueryE.ParamByName('ano').AsInteger     := Self.FAno;
  FQueryE.ParamByName('mes').AsInteger     := Self.FMes;
  FQueryE.ParamByName('tot').AsCurrency    := Self.FTotal;
  FQueryE.ParamByName('nat').AsString      := UpperCase(Natureza);
  FQueryE.ParamByName('op').AsString       := UpperCase(Self.FOperacao);

  try
    FQueryE.ExecSQL;
  except
    // Implantar erro
  end;
end;

procedure TCadMedias.DeletarMediaE(CodMedia: Integer);
begin
  FQueryE.SQL.Clear;
  FQueryE.SQL.Add(' delete from produto_medias where codmedia = :cod ');
  FQueryE.ParamByName('cod').AsInteger := CodMedia;
  try
    FQueryE.ExecSQL;
  except
    // Implantar erro
  end;
end;

constructor TCadMedias.Create(FConexao: TZConnection);
begin
  FQueryS := TZQuery.Create(Nil);
  FQueryE := TZQuery.Create(Nil);
  FQueryS.Connection := FConexao;
  FQueryE.Connection := FConexao;
end;

destructor TCadMedias.Destroy;
begin
  if Assigned(FQueryS) then
    FreeAndNil(FQueryS);
  if Assigned(FQueryE) then
      FreeAndNil(FQueryE);
  inherited Destroy;
end;

end.

