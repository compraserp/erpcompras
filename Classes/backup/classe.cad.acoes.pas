unit classe.cad.acoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  DB, ZDataset,
  ZConnection;

type

  { TCadAcoes }

  TCadAcoes = class

    private
       FQuery: TZQuery;
       ConexaoDB: TZConnection;

    public
       procedure Listagem(CodAudit: Integer; DsAux: TDataSource);
       procedure Selecionar(CodAcao: Integer; DsAux: TDataSource);

       constructor Create(FConexao: TZConnection);
       destructor Destroy; Override;
  end;

implementation

{ TCadAcoes }

procedure TCadAcoes.Listagem(CodAudit: Integer; DsAux: TDataSource);
begin
  DsAux.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from acaoauditoria ' +
                 ' where codauditoria = :codaudit ');
  FQuery.ParamByName('codaudit').AsInteger := CodAudit;
  FQuery.Active := True;
end;

procedure TCadAcoes.Selecionar(CodAcao: Integer; DsAux: TDataSource);
begin

end;

constructor TCadAcoes.Create(FConexao: TZConnection);
begin
  FQuery := TZQuery.Create(Nil);
  ConexaoDB := FConexao;
  FQuery.Connection := ConexaoDB;
end;

destructor TCadAcoes.Destroy;
begin
  inherited Destroy;
end;

end.

