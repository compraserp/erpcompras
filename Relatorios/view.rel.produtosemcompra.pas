unit view.rel.produtosemcompra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Forms, Controls,
  Graphics, Dialogs,
  RLReport, DB,
  ZConnection, ZDataSet;

type

  { TFormRelProdSemCompra }

  TFormRelProdSemCompra = class(TForm)
    DsRel: TDataSource;
    RelatorioPrincipal: TRLReport;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw4: TRLDraw;
    RLDraw5: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RelatorioPrincipalBeforePrint(Sender: TObject;
      var PrintIt: Boolean);

  private
    FQuery: TZQuery;
    FConexao: TZConnection;
    procedure ListaDados;

  public

  published
    property F_Conexao: TZConnection read FConexao write FConexao;

  end;

var
  FormRelProdSemCompra: TFormRelProdSemCompra;

implementation

{$R *.lfm}

{ TFormRelProdSemCompra }

procedure TFormRelProdSemCompra.FormCreate(Sender: TObject);
begin
  FQuery :=  TZQuery.Create(Nil);
end;

procedure TFormRelProdSemCompra.RelatorioPrincipalBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  ListaDados;
end;

procedure TFormRelProdSemCompra.ListaDados;
begin
  DsRel.DataSet := FQuery;
  FQuery.Connection := Self.FConexao;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_produtos_sem_compra ');
  FQuery.Active := True;
end;

procedure TFormRelProdSemCompra.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(FQuery) then begin
    FreeAndNil(FQuery);
  end;
end;

end.

