unit classe.pesquisa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  ZConnection, ZDataset,
  DB;

type

  { TPesquisa }

  TPesquisa = class

    private
       FQuery: TZQuery;

    public

       procedure ListaProdutos(DsAux: TDataSource; ListaNotIn, TxtLike: String);
       constructor Create(FConexao: TZConnection);
       destructor Destroy; Override;
  end;

implementation

{ TPesquisa }

procedure TPesquisa.ListaProdutos(DsAux: TDataSource; ListaNotIn, TxtLike: String);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_pesquisa_produto ' +
                 ' where lower(descricao) like :desc ' +
                 ' and codproduto not in('+ListaNotIn+') ');
  FQuery.ParamByName('desc').AsString := ;
  try
     FQuery.Active := True;
  except
    //
  end;
end;

constructor TPesquisa.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  FQuery.Connection := FConexao;
end;

destructor TPesquisa.Destroy;
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
  inherited Destroy;
end;

end.

