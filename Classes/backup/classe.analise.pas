unit classe.analise;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  ZConnection, ZDataset,
  DB, BufDataset;

type

  { TAnalise }

  TAnalise = class

    private
       FQuery: TZQuery;
       FQueryAnalise: TZQuery;
       FQueryProdAnalise: TZQuery;

       FNomeFornecedor: String;
       FCPFCNPJ: String;
       FMesAnalise: Integer;
       FDtPedido: TDate;
       FTipoPedido: String;


       procedure ApagarProdutos(Buf: TBufDataset; CodPed: Integer);
       procedure AtualizaProdutosAnalise(BufProd: TBufDataset; CodPed: Integer);
       function EsteItemExiste(CodPedido: Integer; CodProd: Integer): Boolean;
       function InsereItensAnalise(BufProd: TBufDataSet; CodPedido: Integer): Boolean;
       function InNot(Buf: TBufDataset): String;
       function RetornaSaidasNoMes(CodProduto, MesRef: Integer): Currency;
       function RetornaEntradasNoMes(CodProduto, MesRef: Integer): Currency;
       procedure SelecionaProdutosPedido(BufProd: TBufDataset; CodPedido: Integer);

    public
        procedure AtualizaCabecalho(BufItens: TBufDataset; DsAux: TDataSource;
             Cod: Integer);
        procedure CarregaProdutosParaAnalise(DsAux: TDataSource; ListaCodProd: String);
        procedure DeletePedido(CodPedido: Integer);
        procedure InserirCabecalho(BufItens: TBufDataset; DsAux: TDataSource);
        procedure ListaCabecalhoPedido(DsAux: TDataSource);
        function RetornaSugestaoCompra(CodProduto, Mesref: Integer;
                 Estoque: Currency): Double;
        procedure SelecionaCabecalho(var BufProd: TBufDataSet; DsAux: TDataSource;
                 CodPedido: Integer);


       constructor Create(FConexao: TZConnection);
       destructor Destroy; Override;

   published
        property F_NomeForn: String    read FNomeFornecedor write FNomeFornecedor;
        property F_CPFCNPJ: String     read FCPFCNPJ        write FCPFCNPJ;
        property F_MesAnalise: Integer read FMesAnalise     write FMesAnalise;
        property F_DtPedido: TDate     read FDtPedido       write FDtPedido;
        property F_TipoPedido: String  read FTipoPedido     write FTipoPedido;


  end;

implementation

{ TAnalise }

function TAnalise.RetornaSaidasNoMes(CodProduto, MesRef: Integer): Currency;
begin
  FQueryAnalise.SQL.Clear;
  FQueryAnalise.SQL.Add(' select * from vw_media_saida_por_mes ' +
                        ' where codproduto = :codprod and mes = :mes ');
  FQueryAnalise.ParamByName('codprod').AsInteger := CodProduto;
  FQueryAnalise.ParamByName('mes').AsInteger := MesRef;
  try
     FQueryAnalise.Active := True;
  finally
    Result := FQueryAnalise.FieldByName('media').AsCurrency;
  end;
end;

function TAnalise.RetornaEntradasNoMes(CodProduto, MesRef: Integer): Currency;
begin
  FQueryAnalise.SQL.Clear;
  FQueryAnalise.SQL.Add(' select * from vw_media_entrada_por_mes ' +
                        ' where codproduto = :codprod and mes = :mes ');
  FQueryAnalise.ParamByName('codprod').AsInteger := CodProduto;
  FQueryAnalise.ParamByName('mes').AsInteger := MesRef;
  try
     FQueryAnalise.Active := True;
  finally
    Result := FQueryAnalise.FieldByName('media').AsCurrency;
  end;
end;

function TAnalise.InsereItensAnalise(BufProd: TBufDataSet; CodPedido: Integer): Boolean;
begin
  Result := False;
  FQuery.Connection.StartTransaction;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' insert into produto_pedido(codproduto,      ' +
                            '        codpedido, sugestao, qtdComprar,     ' +
                            '        gerapedido, estoqueitem, totEnt,     ' +
                            '        totSai) values(:codProd, :codPed,    ' +
                            '        :sug, :qtdComp, :gerPed, :estoque,   ' +
                            '        :totEnt, :totSai) ');
  FQuery.ParamByName('codPed').AsInteger  := CodPedido;
  FQuery.ParamByName('codProd').AsInteger := BufProd.FieldByName('codproduto').AsInteger;
  FQuery.ParamByName('sug').AsFloat       := BufProd.FieldByName('sugestao').AsFloat;
  FQuery.ParamByName('qtdComp').AsFloat   := BufProd.FieldByName('qtdComprar').AsFloat;
  FQuery.ParamByName('gerPed').AsInteger  := BufProd.FieldByName('gerapedido').AsInteger;
  FQuery.ParamByName('estoque').AsFloat   := BufProd.FieldByName('estoque').AsFloat;
  FQuery.ParamByName('totEnt').AsFloat    := BufProd.FieldByName('entradas').AsFloat;
  FQuery.ParamByName('totSai').AsFloat    := BufProd.FieldByName('saidas').AsFloat;
  try
     FQuery.ExecSQL;
  except
    Result := False;
    FQuery.Connection.Rollback;
  end;
  FQuery.Connection.Commit;
end;

function TAnalise.InNot(Buf: TBufDataset): String;
var
  sInNot: String;
begin
  sInNot := EmptyStr;
  Buf.First;
  while not(Buf.Eof) do begin
    if(sInNot = EmptyStr) then
      sInNot := Buf.FieldByName('codproduto').AsString
    else
      sInNot := sInNot +','+Buf.FieldByName('codproduto').AsString;

    Buf.Next;
  end;
  Result := sInNot;
end;

procedure TAnalise.SelecionaProdutosPedido(BufProd: TBufDataset;
  CodPedido: Integer);
begin
  BufProd.First;
  while not BufProd.EOF do begin
   BufProd.Delete;
  end;

  FQueryProdAnalise.SQL.Clear;
  FQueryProdAnalise.SQL.Add(' select * from vw_select_produtos_pedido ' +
                 ' where codpedido = :cod ');
  FQueryProdAnalise.ParamByName('cod').AsInteger := CodPedido;
  FQueryProdAnalise.Active := True;

  while not FQueryProdAnalise.EOF do begin
    BufProd.Append;
    BufProd.FieldByName('codproduto').AsInteger := FQueryProdAnalise.FieldByName('codproduto').AsInteger;
     BufProd.FieldByName('descricao').AsString   := FQueryProdAnalise.FieldByName('descricao').AsString;
      BufProd.FieldByName('gerapedido').AsInteger := FQueryProdAnalise.FieldByName('gerapedido').AsInteger;
       BufProd.FieldByName('codbarras').AsString   := FQueryProdAnalise.FieldByName('codbarras').AsString;
        BufProd.FieldByName('estoque').AsFloat      := FQueryProdAnalise.FieldByName('estoqueitem').AsFloat;
       BufProd.FieldByName('saidas').AsFloat       := FQueryProdAnalise.FieldByName('totSai').AsFloat;
      BufProd.FieldByName('entradas').AsFloat     := FQueryProdAnalise.FieldByName('totEnt').AsFloat;
     BufProd.FieldByName('sugestao').AsFloat     := FQueryProdAnalise.FieldByName('sugestao').AsFloat;
    BufProd.FieldByName('qtdComprar').AsFloat   := FQueryProdAnalise.FieldByName('qtdComprar').AsFloat;
    BufProd.Post;
    FQueryProdAnalise.Next;
  end;
end;

procedure TAnalise.CarregaProdutosParaAnalise(DsAux: TDataSource;
  ListaCodProd: String);
begin
  DsAux.DataSet := FQueryAnalise;
  F.SQL.Clear;
  F.SQL.Add(' select * from vw_seleciona_produtos_analise ' +
                 ' where codproduto in('+ListaCodProd+') ');
  F.Active := True;
end;

procedure TAnalise.ListaCabecalhoPedido(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_list_pedidocab ');
  FQuery.Active := True;
end;

procedure TAnalise.SelecionaCabecalho(var BufProd: TBufDataSet;
  DsAux: TDataSource; CodPedido: Integer);
begin
  try
    DsAux.DataSet := FQuery;
    FQuery.SQL.Clear;
    FQuery.SQL.Add(' select * from vw_select_pedido where codpedido =:cod ');
    FQuery.ParamByName('cod').AsInteger := CodPedido;
    FQuery.Active := True;
  finally
     SelecionaProdutosPedido(BufProd, CodPedido);
  end;
end;

procedure TAnalise.InserirCabecalho(BufItens: TBufDataset; DsAux: TDataSource);
var
  CodPedido: Integer;
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' insert into pedido(nomeFornecedor, cpfcnpj, mesAnalise,  ' +
                 ' datapedido, tppedido, status) values (:nmForn, :cpfcnpj, ' +
                 ' :msAnalise, current_date, :tpPedido, 0) returning codpedido ');
  FQuery.ParamByName('nmForn').AsString     := Self.FNomeFornecedor;
  FQuery.ParamByName('cpfcnpj').AsString    := Self.FCPFCNPJ;
  FQuery.ParamByName('msAnalise').AsInteger := Self.FMesAnalise;
  FQuery.ParamByName('tpPedido').AsString   := Self.FTipoPedido;
  try
     FQuery.Active := True;
     CodPedido := FQuery.FieldByName('codpedido').AsInteger;
  finally
    BufItens.First;
    while not BufItens.EOF do begin
     InsereItensAnalise(BufItens, CodPedido);
     BufItens.Next;
    end;
  end;
end;

procedure TAnalise.AtualizaCabecalho(BufItens: TBufDataset; DsAux: TDataSource;
  Cod: Integer);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' update pedido set  nomeFornecedor = :nmForn   ' +
                 '                   ,cpfcnpj        = :cpfcnpj  ' +
                 '                   ,mesanalise     = :mes      ' +
                 '                   ,tpPedido       = :tpPed    ' +
                 ' where codpedido = :cod ');
  FQuery.ParamByName('nmForn').AsString     := Self.FNomeFornecedor;
  FQuery.ParamByName('cpfcnpj').AsString    := Self.FCPFCNPJ;
  FQuery.ParamByName('mes').AsInteger       := Self.FMesAnalise;
  FQuery.ParamByName('tpPed').AsString      := Self.FTipoPedido;
  FQuery.ParamByName('cod').AsInteger       := Cod;

  ApagarProdutos(BufItens, Cod);

  try
    FQuery.ExecSQL;
    BufItens.First;
    while not BufItens.EOF do begin
     if(EsteItemExiste(Cod, BufItens.FieldByName('codproduto').AsInteger)) then begin
          AtualizaProdutosAnalise(BufItens, Cod);
        end
        else begin
          InsereItensAnalise(BufItens, Cod);
        end;
        BufItens.Next;
      end;
  finally

  end;
end;

procedure TAnalise.AtualizaProdutosAnalise(BufProd: TBufDataset; CodPed: Integer);
begin
  FQuery.Connection.StartTransaction;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' update produto_pedido set sugestao     = :sug     ' +
                 '                          ,qtdComprar   = :qtdComp ' +
                 '                          ,geraPedido   = :geraPed ' +
                 '                          ,estoqueItem  = :estItem ' +
                 '                          ,totent       = :totEnt  ' +
                 '                          ,totSai       = :totSai  ' +
                 ' where codproduto =:codProd and codpedido =:codPed ');
  FQuery
   .ParamByName('codPed').AsInteger := CodPed;
  FQuery
   .ParamByName('codProd').AsInteger := BufProd.FieldByName('codproduto').AsInteger;
  FQuery
   .ParamByName('sug').AsFloat := BufProd.FieldByName('sugestao').AsFloat;
  FQuery
   .ParamByName('qtdComp').AsFloat := BufProd.FieldByName('qtdComprar').AsFloat;
  FQuery
   .ParamByName('geraPed').AsInteger := BufProd.FieldByName('gerapedido').AsInteger;
  FQuery
   .ParamByName('estItem').AsFloat := BufProd.FieldByName('estoque').AsFloat;
  FQuery
   .ParamByName('totSai').AsFloat := BufProd.FieldByName('saidas').AsFloat;
  FQuery
   .ParamByName('totEnt').AsFloat := BufProd.FieldByName('entradas').AsFloat;
  try
    FQuery.ExecSQL;
  except
    FQuery.Connection.Rollback;
  end;
  FQuery.Connection.Commit;
end;

procedure TAnalise.DeletePedido(CodPedido: Integer);
begin
  FQuery.Connection.StartTransaction;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' delete from produto_pedido where codpedido =:cod ');
  FQuery.ParamByName('cod').AsInteger := CodPedido;
  try
    FQuery.ExecSQL;
  except
    FQuery.Connection.Rollback;
    Abort;
  end;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' delete from pedido where codpedido = :cod ');
  FQuery.ParamByName('cod').AsInteger := CodPedido;
  try
     FQuery.ExecSQL;
  finally
    FQuery.Connection.Commit;
  end;
end;

procedure TAnalise.ApagarProdutos(Buf: TBufDataset; CodPed: Integer);
var
  sCodNoBuf: String;
begin
  try
    sCodNoBuf := InNot(Buf);
    FQuery.SQL.Clear;
    FQuery.SQL.Add('DELETE FROM produto_pedido WHERE codpedido=:codPed ' +
                ' AND codproduto NOT IN (' + sCodNoBuf+ ')');
    FQuery.ParamByName('codPed').AsInteger := CodPed;
    try
      FQuery.ExecSQL;
    except

    end;
  finally

  end;
end;

function TAnalise.EsteItemExiste(CodPedido: Integer; CodProd: Integer): Boolean;
begin
  try
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT count(codpedido) as qtde ' +
                ' FROM produto_pedido WHERE codpedido =:codPed ' +
                ' AND codproduto =:codProd');
    FQuery.ParamByName('codPed').AsInteger   := CodPedido;
    FQuery.ParamByName('codProd').AsInteger := CodProd;
    try
      FQuery.Active := True;

      if(FQuery.FieldByName('qtde').AsInteger > 0) then
        Result := True
      else
        Result := False;

    except
      Result := False;
    end;
  finally

    end;
end;

constructor TAnalise.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  FQueryAnalise := TZQuery.Create(Nil);
  FQueryProdAnalise := TZQuery.Create(Nil);

  FQuery.Connection := FConexao;
  FQueryAnalise.Connection := FConexao;
  FQueryProdAnalise.Connection := FConexao;
end;

destructor TAnalise.Destroy;
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  if Assigned(FQueryAnalise) then
    FreeAndNil(FQueryAnalise);
  if Assigned(FQueryProdAnalise) then
    FreeAndNil(FQueryProdAnalise);
  inherited Destroy;
end;

function TAnalise.RetornaSugestaoCompra(CodProduto, Mesref: Integer;
  Estoque: Currency): Double;
var
  MediaSaida, MediaEntrada, Resultado: Currency;
begin
  MediaSaida   := RetornaSaidasNoMes(CodProduto, Mesref);
  MediaEntrada := RetornaEntradasNoMes(CodProduto, Mesref);
  Resultado := MediaSaida - Estoque;

  if(Resultado < 0) then
    Result := 0.00
  else Result := Resultado;
end;

end.

