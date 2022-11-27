unit classe.pedido.entrega;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BufDataset,
  DB, ZConnection, ZDataset;

type

  { TPedidoEntrega }

  TPedidoEntrega = class


    private
      FQuery: TZQuery;
      FQueryMedia: TZQuery;

      procedure AtualizaPedidos(CodPedido: Integer);
      procedure InsereMediaProduto(CodPedido: Integer);

    public
      procedure ListaPedidosPendentes(DsAux: TDataSource);
      procedure RealizaEntregaPedidos(BufPedidos: TBufDataset);

      constructor Create(FConexao: TZConnection);
      destructor Destroy; Override;

  end;

implementation

{ TPedidoEntrega }

procedure TPedidoEntrega.AtualizaPedidos(CodPedido: Integer);
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' update pedido set status = 1 where codpedido = :cod');
  FQuery.ParamByName('cod').AsInteger := CodPedido;
  try
    FQuery.ExecSQL;
  finally
     //
  end;
end;

procedure TPedidoEntrega.ListaPedidosPendentes(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_list_pedidos_pendentes ');
  FQuery.Active := True;
end;

procedure TPedidoEntrega.RealizaEntregaPedidos(BufPedidos: TBufDataset);
begin
  BufPedidos.First;
  while not BufPedidos.EOF do begin
    if(BufPedidos.FieldByName('status').AsInteger = 1) then
      AtualizaPedidos(BufPedidos.FieldByName('codpedido').AsInteger);
    BufPedidos.Next;
  end;
end;

procedure TPedidoEntrega.InsereMediaProduto(CodPedido: Integer);
begin
  FQueryMedia.SQL.Clear;
  FQueryMedia.SQL.Add(' select * from vw_insere_media_entrega ' +
                      ' where codpedido = :cod ');
  FQueryMedia.ParamByName('cod').AsInteger := CodPedido;
  FQueryMedia.Active := True;
end;

constructor TPedidoEntrega.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  FQueryMedia := TZQuery.Create(Nil);
  FQuery.Connection := FConexao;
  FQueryMedia.Connection := FConexao;
end;

destructor TPedidoEntrega.Destroy;
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  if Assigned(FQueryMedia) then
      FreeAndNil(FQueryMedia);
  inherited Destroy;
end;

end.

