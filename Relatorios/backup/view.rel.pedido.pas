unit view.rel.pedido;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms,
  Controls, Graphics, Dialogs,
  RLReport, ZDataSet, ZConnection;

type

  { TFormRelPedido }

  TFormRelPedido = class(TForm)
    DsRel: TDataSource;
    ReportPrincipal: TRLReport;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLBand5: TRLBand;
    RLBand6: TRLBand;
    RLDBResult1: TRLDBResult;
    RLDBText1: TRLDBText;
    RLDBText10: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText8: TRLDBText;
    RLDBText9: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw4: TRLDraw;
    RLDraw5: TRLDraw;
    RLDraw6: TRLDraw;
    RLDraw7: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
      FCodPedido: Integer;
      FQuery: TZQuery;


  published
    property F_CodPedido: Integer read FCodPedido write FCodPedido;

  public
    procedure CarregaDadosPedido(CodPedido: Integer);

  end;

var
  FormRelPedido: TFormRelPedido;

implementation

{$R *.lfm}

uses
  View.Principal;

{ TFormRelPedido }

procedure TFormRelPedido.FormCreate(Sender: TObject);
begin
  FQuery := TZQuery.Create(Nil);
  FQuery.Connection := FormPrincipal.F_Conexao.FDriverConexao;
end;

procedure TFormRelPedido.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(FQuery) then
    FreeAndNil(FQuery);
end;

procedure TFormRelPedido.CarregaDadosPedido(CodPedido: Integer);
begin
  DsRel.DataSet := FQuery;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(' select * from vw_rel_pedido where codpedido =:cod ');
  FQuery.ParamByName('cod').AsInteger := CodPedido;

  FQuery.Active := True;
end;

end.

