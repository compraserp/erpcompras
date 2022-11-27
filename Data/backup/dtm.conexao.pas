unit dtm.conexao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDtmConexao }

  TDtmConexao = class(TDataModule)
    ConexaoDB: TZConnection;
  private

  public

  end;

var
  DtmConexao: TDtmConexao;

implementation

{$R *.lfm}

end.

