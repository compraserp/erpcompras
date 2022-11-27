unit view.cad.auditoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB,
  Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls,
  Buttons, DBGrids, StdCtrls,
  EditBtn, DividerBevel,
  types.actions,
  classe.cad.auditoria,
  view.rel.compCadAuditoria,
  view.cad.acoes;

type

  { TFormCadAuditRapido }

  TFormCadAuditRapido = class(TForm)
    ButtonAlterar: TSpeedButton;
    ButtonAPagar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    ButtonAddAcoes: TSpeedButton;
    ButtonNovo: TSpeedButton;
    ButtonSair: TSpeedButton;
    ButtonSalvar: TSpeedButton;
    ComboMetodo: TComboBox;
    DividerBevel3: TDividerBevel;
    DsAcoes: TDataSource;
    DsListagem: TDataSource;
    DividerBevel1: TDividerBevel;
    DividerBevel2: TDividerBevel;
    EditDataAbertura: TDateEdit;
    GridListagem: TDBGrid;
    EditAssEscopo: TLabeledEdit;
    EditAssForaEscopo: TLabeledEdit;
    EditAuditorResponsavel: TLabeledEdit;
    EditCliente: TLabeledEdit;
    EditCod: TLabeledEdit;
    EditCPFCNPJ: TLabeledEdit;
    EditTitulo: TLabeledEdit;
    Label1: TLabel;
    EditObs: TLabeledEdit;
    LabelMetodo: TLabel;
    PagePrincipal: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelRodapeBotoes: TPanel;
    ButtonImprimirComp: TSpeedButton;
    TabAlteracoes: TTabSheet;
    TabListagem: TTabSheet;
    procedure ButtonAddAcoesClick(Sender: TObject);
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonAPagarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonImprimirCompClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure DsListagemDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Auxiliar: TCadAuditoria;
    TypeAcao: TAcaoCrud;

    procedure AbreTelaAcoes;
    procedure ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
    procedure DefineAcao;
    procedure PassaDadosAosCampos;
    procedure PassDadosAClasse;
    procedure ApagarRegistro;

    procedure LimpaCamposTmp;

  public

  end;

var
  FormCadAuditRapido: TFormCadAuditRapido;

implementation

uses
  view.principal;

{$R *.lfm}

{ TFormCadAuditRapido }

procedure TFormCadAuditRapido.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCadAuditRapido.ButtonSalvarClick(Sender: TObject);
begin
  PassDadosAClasse;
  ControlaPage(TabListagem, TabAlteracoes);
  DefineAcao;
  Auxiliar
   .Listagem(DsListagem);
  LimpaCamposTmp;
  ButtonImprimirComp.Enabled := False;
end;

procedure TFormCadAuditRapido.DsListagemDataChange(Sender: TObject;
  Field: TField);
begin
  ButtonAlterar.Enabled := not(DsListagem.DataSet.IsEmpty);
  ButtonAPagar.Enabled  := not(DsListagem.DataSet.IsEmpty);
end;

procedure TFormCadAuditRapido.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if(Assigned(Auxiliar)) then
    FreeAndNil(Auxiliar);
end;

procedure TFormCadAuditRapido.FormCreate(Sender: TObject);
begin
  Auxiliar := TCadAuditoria.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

procedure TFormCadAuditRapido.FormShow(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.Listagem(DsListagem);
end;

procedure TFormCadAuditRapido.AbreTelaAcoes;
begin
  FormCadAcoes := TFormCadAcoes.Create(Self);
  try
    FormCadAcoes.F_CodAuditoria := StrToIntDef(EditCod.Text, 0);
    FormCadAcoes.F_Auditoria    := EditTitulo.Text;
    FormCadAcoes.ShowModal;
  finally
    FormCadAcoes.Release;
  end;
end;

procedure TFormCadAuditRapido.ButtonNovoClick(Sender: TObject);
begin
  ControlaPage(TabAlteracoes, TabListagem);
  TypeAcao := tpInsert;
  LimpaCamposTmp;
  EditCod.Text := '-1';
  EditTitulo.SetFocus;
  ButtonImprimirComp.Enabled := False;
end;

procedure TFormCadAuditRapido.ButtonAlterarClick(Sender: TObject);
begin
  LimpaCamposTmp;
  ControlaPage(TabAlteracoes, TabListagem);
  TypeAcao := tpUpdate;
  PassaDadosAosCampos;
  EditTitulo.SetFocus;
  ButtonImprimirComp.Enabled := True;
end;

procedure TFormCadAuditRapido.ButtonAddAcoesClick(Sender: TObject);
begin
  AbreTelaAcoes;
end;

procedure TFormCadAuditRapido.ButtonAPagarClick(Sender: TObject);
begin
  ApagarRegistro();
end;

procedure TFormCadAuditRapido.ButtonCancelarClick(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.Listagem(DsListagem);
  LimpaCamposTmp;
  ButtonImprimirComp.Enabled := False;
end;

procedure TFormCadAuditRapido.ButtonImprimirCompClick(Sender: TObject);
begin
  FormRelCompAudit := TFormRelCompAudit.Create(Self);
  FormRelCompAudit.F_DataSet := DsAcoes.DataSet;
  FormRelCompAudit.F_Obs     := EditObs.Text;
  FormRelCompAudit.ReportPrincipal.Preview;
end;

procedure TFormCadAuditRapido.ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
begin
  TabVisivel.TabVisible := True;
  TabInvisivel.TabVisible := False;
end;

procedure TFormCadAuditRapido.DefineAcao;
begin
  if(TypeAcao = tpUpdate) then begin
    if not(Auxiliar.Atualizar(DsAcoes.DataSet.FieldByName('codauditoria').AsInteger))
      then begin
        MessageDlg('Não foi possível atualizar o registro!!', mtWarning, [mbOk], 0);
        Abort;
      end;
  end
  else begin
    if not(Auxiliar.Inserir)
      then begin
        MessageDlg('Não foi possível Inserir o registro!!', mtWarning, [mbOk], 0);
        Abort;
      end;
  end;
end;

procedure TFormCadAuditRapido.PassaDadosAosCampos;
var
  Codigo: Integer;
begin
  Codigo
     := DsListagem.DataSet.FieldByName('codauditoria').AsInteger;
  Auxiliar.Selecionar(DsAcoes, Codigo);

  EditCod.Text
     := DsAcoes.DataSet.FieldByName('codauditoria').AsString;
  EditTitulo.Text
     := DsAcoes.DataSet.FieldByName('titulo').AsString;
  EditCliente.Text
     := DsAcoes.DataSet.FieldByName('nomeCliente').AsString;
  EditCPFCNPJ.Text
     := DsAcoes.DataSet.FieldByName('cpfcnpj').AsString;
  EditAssEscopo.Text
     := DsAcoes.DataSet.FieldByName('assescopo').AsString;
  EditAssForaEscopo.Text
     := DsAcoes.DataSet.FieldByName('assForaEscopo').AsString;
  EditAuditorResponsavel.Text
     := DsAcoes.DataSet.FieldByName('auditresp').AsString;
  EditDataAbertura.Date
     := DsAcoes.DataSet.FieldByName('dataCad').AsDateTime;
  ComboMetodo.ItemIndex
     := DsAcoes.DataSet.FieldByName('metodo').AsInteger;
end;

procedure TFormCadAuditRapido.PassDadosAClasse;
begin
  Auxiliar.F_CodAudit      := StrToIntDef(EditCod.Text, 0);
  Auxiliar.F_Titulo        := EditTitulo.Text;
  Auxiliar.F_NomeCliente   := EditCliente.Text;
  Auxiliar.F_CPFCNPJ       := EditCPFCNPJ.Text;
  Auxiliar.F_AssEscopo     := EditAssEscopo.Text;
  Auxiliar.F_AssForaEscopo := EditAssForaEscopo.Text;
  Auxiliar.F_AuditResp     := EditAuditorResponsavel.Text;
  Auxiliar.F_Metodo        := ComboMetodo.ItemIndex;
  Auxiliar.F_DataCad       := EditDataAbertura.Date;
end;

procedure TFormCadAuditRapido.ApagarRegistro;
var
  Codigo: Integer;
begin
  Codigo := DsListagem.DataSet.FieldByName('codauditoria').AsInteger;
  if(MessageDlg('Deseja realmente apagar o registro?', mtWarning,
               [mbYes, mbNo],0) = mrYes) then begin
    if not(Auxiliar.Deletar(Codigo)) then begin
       MessageDlg('Não foi possível apagar o registro!', mtError, [mbOk], 0);
       Auxiliar.Listagem(DsListagem);
       Abort;
    end;
    Auxiliar.Listagem(DsListagem);
  end;
end;

procedure TFormCadAuditRapido.LimpaCamposTmp;
begin
  EditCod.Clear;
  EditDataAbertura.Date := Now;
  EditTitulo.Clear;
  EditCliente.Clear;
  EditCPFCNPJ.Clear;
  EditAssForaEscopo.Clear;
  EditAssEscopo.Clear;
  EditAuditorResponsavel.Clear;
  ComboMetodo.ItemIndex := 0;
  EditObs.Clear;
end;

end.

