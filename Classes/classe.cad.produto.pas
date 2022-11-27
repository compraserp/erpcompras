unit classe.cad.produto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  DB, ZDataset,
  ZConnection;

type

  { TCadProduto }

  TCadProduto = class

    private
      FQuery: TZQuery;

      FCodProduto: Integer;
      FDescricao: String;
      FCodBarras: String;
      FCustoAtual: Currency;
      FVlrVenda: Currency;
      FEstoque: Currency;
      FDataAlt: TDate;

      procedure ApagaMediaDoProduto(CodProd: Integer);
      function ValidaProdutoPedido(CodProd: Integer): Boolean;

   published
     property F_CodProduto: Integer   read FCodProduto write FCodProduto;
     property F_Descricao: String     read FDescricao  write FDescricao;
     property F_CodBarras: String     read FCodBarras  write FCodBarras;
     property F_CustoAtual: Currency  read FCustoAtual write FCustoAtual;
     property F_VlrVenda: Currency    read FVlrVenda   write FVlrVenda;
     property F_Estoque: Currency     read FEstoque    write FEstoque;
     property F_DataAlt: TDate        read FDataAlt    write FDataAlt;


    public
      procedure Listagem(DsAux: TDataSource);
      procedure Selecionar(Cod: Integer; DsAux: TDataSource);

      procedure Atualizar(Cod: Integer; DsAux: TDataSource);

      procedure Inserir(DsAux: TDataSource);

      function Deletar(Cod: Integer): Boolean;

      constructor Create(FConexao: TZConnection);
      destructor Destroy; Override;

  end;

implementation

{ TCadProduto }

procedure TCadProduto.ApagaMediaDoProduto(CodProd: Integer);
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' delete from produto_medias where codproduto = :cod ' +
                 ' and codproduto not in(select codproduto from produto_pedido) ');
  FQuery.ParamByName('cod').AsInteger := CodProd;
  try
    FQuery.ExecSQL;
  finally
    // Implantar erros
  end;
end;

function TCadProduto.ValidaProdutoPedido(CodProd: Integer): Boolean;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select count(codProduto) as qtd from produto_pedido ' +
                 ' where codproduto = :cod ');
  FQuery.ParamByName('cod').AsInteger := CodProd;
  FQuery.Active := True;
  if(FQuery.FieldByName('qtd').AsInteger > 0) then
    Result := True
  else Result := False;
end;

procedure TCadProduto.Listagem(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_list_produto ');
  FQuery.Active := True;
end;

procedure TCadProduto.Selecionar(Cod: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_select_produto ' +
                 ' where codproduto =:cod ');
  FQuery.ParamByName('cod').AsInteger := Cod;
  FQuery.Active := True;
end;

procedure TCadProduto.Atualizar(Cod: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' update produto set descricao  = :desc    ' +
                 '                   ,codbarras  = :codbar  ' +
                 '                   ,custoatual = :ctatual ' +
                 '                   ,vlrvenda   = :vlvenda ' +
                 '                   ,dataalt    = current_date ' +
                 '                   ,estoque    = :estoque ' +
                 ' where codproduto =:codrdz ');
  FQuery.ParamByName('desc').AsString       := Self.FDescricao;
  FQuery.ParamByName('codbar').AsString     := Self.FCodBarras;
  FQuery.ParamByName('ctatual').AsCurrency  := Self.FCustoAtual;
  FQuery.ParamByName('vlvenda').AsCurrency  := Self.FVlrVenda;
  FQuery.ParamByName('estoque').AsCurrency  := Self.FEstoque;
  FQuery.ParamByName('codrdz').AsInteger    := Cod;

  try
    FQuery.ExecSQL;
  except
    // Em caso de erros
  end;
end;

procedure TCadProduto.Inserir(DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' insert into produto(descricao, codbarras, custoatual,  ' +
                 '   vlrvenda, datacad, estoque) values(:desc, :codbar,   ' +
                 '   :ctatual, :vlrvenda, current_date, :estoque) ');
  FQuery.ParamByName('desc').AsString        := Self.FDescricao;
  FQuery.ParamByName('codbar').AsString      := Self.FCodBarras;
  FQuery.ParamByName('ctatual').AsCurrency   := Self.FCustoAtual;
  FQuery.ParamByName('vlrvenda').AsCurrency  := Self.FVlrVenda;
  FQuery.ParamByName('estoque').AsCurrency   := Self.FEstoque;
  try
    FQuery.ExecSQL;
  except
    // Implementar erros
  end;
end;

function TCadProduto.Deletar(Cod: Integer): Boolean;
begin
  if(ValidaProdutoPedido(Cod)) then begin
    Result := False;
    Exit;
  end;

  ApagaMediaDoProduto(Cod);  // Apaga as médias primeiro
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' delete from produto where codproduto = :cod ' +
                 ' and codproduto not in(select codproduto from produto_pedido)');
  FQuery.ParamByName('cod').AsInteger := Cod;

  try
     FQuery.ExecSQL;
  finally
    Result := True;
  end;
end;

constructor TCadProduto.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  FQuery.Connection := FConexao;
end;

destructor TCadProduto.Destroy;
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  inherited Destroy;
end;

end.

