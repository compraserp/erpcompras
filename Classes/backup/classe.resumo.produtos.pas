unit classe.resumo.produtos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB,
  ZConnection, ZDataset;

type

  { TResumoProdutos }

  TResumoProdutos = class

    private
      FQuery: TZQuery;
      FQuerySaidas: TZQuery;
      FQueryEntradas: TZQuery;

    public

      procedure ListaProdutos(DsAux: TDataSource);

      procedure ListaSaidas(CodProduto: Integer; DsAux: TDataSource);
      procedure ListaEntradas(CodProduto: Integer; DsAux: TDataSource);

      constructor Create(FConexao: TZConnection);
      destructor Destroy; Override;

  end;

implementation

{ TResumoProdutos }

procedure TResumoProdutos.ListaProdutos(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_resumo_produto ');
  FQuery.Active := True;
end;

procedure TResumoProdutos.ListaSaidas(CodProduto: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQuerySaidas;
  FQuerySaidas.SQL.Clear;
  FQuerySaidas.SQL.Add(' select * from vw_resumo_saidas ' +
                       ' where codproduto = :cod ');
  FQuerySaidas.ParamByName('cod').AsInteger := CodProduto;
  FQuerySaidas.Active := True;
end;

procedure TResumoProdutos.ListaEntradas(CodProduto: Integer; DsAux: TDataSource
  );
begin
  DsAux.DataSet := FQueryEntradas;
  FQueryEntradas.SQL.Clear;
  FQueryEntradas.SQL.Add(' select * from vw_resumo_entradas ' +
                       ' where codproduto = :cod ');
  FQueryEntradas.ParamByName('cod').AsInteger := CodProduto;
  FQueryEntradas.Active := True;
end;

constructor TResumoProdutos.Create(FConexao: TZConnection);
begin
  FQuery     := TZQuery.Create(Nil);
  FQuerySaidas := TZQuery.Create(Nil);
  FQueryEntradas := TZQuery.Create(Nil);

  FQuery.Connection     := FConexao;
  FQuerySaidas.Connection := FConexao;
  FQueryEntradas.Connection := FConexao;
end;

destructor TResumoProdutos.Destroy;
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  if Assigned(FQuerySaidas) then
    FreeAndNil(FQuerySaidas);
  if Assigned(FQueryEntradas) then
    FreeAndNil(FQueryEntradas);
  inherited Destroy;
end;

end.

