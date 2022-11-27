unit view.cad.aditoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms,
  Controls, Graphics, Dialogs,
  ExtCtrls, ComCtrls, Buttons,
  DBGrids, EditBtn, StdCtrls,
  ZDataset, dtm.conexao;

type

  { TFormCadAudit }

  TFormCadAudit = class(TForm)
    ButtonAlterar: TSpeedButton;
    ButtonAPagar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    ButtonNovo: TSpeedButton;
    ButtonSair: TSpeedButton;
    ButtonSalvar: TSpeedButton;
    DsListagem: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    EditCod: TLabeledEdit;
    EditTitulo: TLabeledEdit;
    EditCliente: TLabeledEdit;
    EditCPFCNPJ: TLabeledEdit;
    EditAssEscopo: TLabeledEdit;
    EditAssForaEscopo: TLabeledEdit;
    MemoRetornoPerito: TMemo;
    PagePrincipal: TPageControl;
    Panel2: TPanel;
    Panel3: TPanel;
    TabListagem: TTabSheet;
    TabAlteracoes: TTabSheet;
    Query: TZQuery;
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     procedure ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
     procedure CriaDataModule;
     procedure PassaDadosAosCampos;

  public

  end;

var
  FormCadAudit: TFormCadAudit;

implementation

{$R *.lfm}

{ TFormCadAudit }

procedure TFormCadAudit.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCadAudit.ButtonSalvarClick(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
end;

procedure TFormCadAudit.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  FreeAndNil(DtmConexao);
end;

procedure TFormCadAudit.FormCreate(Sender: TObject);
begin
  CriaDataModule;
end;

procedure TFormCadAudit.ButtonNovoClick(Sender: TObject);
begin
  ControlaPage(TabAlteracoes, TabListagem);
end;

procedure TFormCadAudit.ButtonAlterarClick(Sender: TObject);
begin
  ControlaPage(TabAlteracoes, TabListagem);
  PassaDadosAosCampos;
end;

procedure TFormCadAudit.ButtonCancelarClick(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
end;

procedure TFormCadAudit.FormShow(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
end;

procedure TFormCadAudit.ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
begin
  TabVisivel.TabVisible := True;
  TabInvisivel.TabVisible := False;
end;

procedure TFormCadAudit.CriaDataModule;
begin
  DtmConexao := TDtmConexao.Create(self);
  Query.Connection := DtmConexao.ConexaoDB;
  Query.Active := True;
end;

procedure TFormCadAudit.PassaDadosAosCampos;
begin
  EditCod.Text := DsListagem.DataSet.FieldByName('codauditoria').AsString;
  EditTitulo.Text  := DsListagem.DataSet.FieldByName('titulo').AsString;
  EditCliente.Text := DsListagem.DataSet.FieldByName('cliente').AsString;
  EditCPFCNPJ.Text := DsListagem.DataSet.FieldByName('cpfcnpj').AsString;
  EditAssEscopo.Text := DsListagem.DataSet.FieldByName('assuntoescopo').AsString;
  EditAssForaEscopo.Text := DsListagem.DataSet.FieldByName('assuntoforadoescopo').AsString;

  MemoRetornoPerito.Lines.Clear;
  MemoRetornoPerito.Lines.Add(DsListagem.DataSet.FieldByName('feedbackperito').AsString);

  if(EditTitulo.Enabled) then
    EditTitulo.SetFocus;
end;

end.

