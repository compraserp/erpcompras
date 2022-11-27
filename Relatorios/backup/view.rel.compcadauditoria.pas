unit view.rel.compCadAuditoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms,
  Controls, Graphics, Dialogs,
  RLReport;

type

  { TFormRelCompAudit }

  TFormRelCompAudit = class(TForm)
    DsRel: TDataSource;
    ReportPrincipal: TRLReport;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLBand5: TRLBand;
    RLBand6: TRLBand;
    RLDBMemo1: TRLDBMemo;
    RLDBMemo2: TRLDBMemo;
    RLDBText2: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw4: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabelObs: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    procedure ReportPrincipalBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    FDataSet: TDataSet;
    FObservacao: String;

  public
    property F_DataSet: TDataSet read FDataSet    write FDataSet;
    property F_Obs: String       read FObservacao write FObservacao;

  end;

var
  FormRelCompAudit: TFormRelCompAudit;

implementation

{$R *.lfm}

{ TFormRelCompAudit }

procedure TFormRelCompAudit.ReportPrincipalBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  DsRel.DataSet := Self.FDataSet;
  if(Self.FObservacao = EmptyStr) then
     RLLabelObs.Caption := 'Sem observações'
  else
    RLLabelObs.Caption := Self.FObservacao;
end;

end.

