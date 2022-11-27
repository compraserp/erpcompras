unit view.cad.acoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls,
  Buttons, DBGrids, EditBtn,
  StdCtrls, DividerBevel,
  classe.cad.acoes, db;

type

  { TFormCadComprador }

  TFormCadComprador = class(TForm)
    ButtonAlterar: TSpeedButton;
    ButtonAPagar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    ButtonNovo: TSpeedButton;
    ButtonSair: TSpeedButton;
    ButtonSalvar: TSpeedButton;
    DsAcao: TDataSource;
    DsListagem: TDataSource;
    DividerBevel1: TDividerBevel;
    EditCod: TLabeledEdit;
    EditDataAbertura: TDateEdit;
    EditNomeComprador: TLabeledEdit;
    GridListagem: TDBGrid;
    Label1: TLabel;
    LabelInfoQtdCaracteres: TLabel;
    MemoAuditoria: TMemo;
    PagePrincipal: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelTopo: TPanel;
    PanelRodapeBotoes: TPanel;
    TabAlteracoes: TTabSheet;
    TabListagem: TTabSheet;
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Auxiliar: TCadAcoes;
    FCodAuditoria: Integer;
    FAuditoria: String;
    procedure ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
    procedure PassaDadosAosCampos;
    procedure LimpaCampos;

  public

  published
     property F_CodAuditoria: Integer read FCodAuditoria write FCodAuditoria;
     property F_Auditoria: String     read FAuditoria    write FAuditoria;

  end;

var
  FormCadComprador: TFormCadComprador;

implementation

uses
  view.principal;

{$R *.lfm}

{ TFormCadComprador }

procedure TFormCadComprador.FormShow(Sender: TObject);
begin
  MemoAuditoria.Lines.Clear;
  MemoAuditoria.Lines.Add('Auditoria: ' + IntToStr(Self.FCodAuditoria)
                          + ' - ' + Self.FAuditoria);
  Auxiliar.Listagem(Self.FCodAuditoria, DsListagem);
  ControlaPage(TabListagem, TabAlteracoes);
end;

procedure TFormCadComprador.ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
begin
  TabVisivel.TabVisible := True;
  TabInvisivel.TabVisible := False;
end;

procedure TFormCadComprador.PassaDadosAosCampos;
var
  Codigo: Integer;
begin
  Codigo := DsListagem.DataSet.FieldByName('codacao').AsInteger;
  Auxiliar.Selecionar(Codigo, DsAcao);

  EditCod.Text := DsAcao.DataSet.FieldByName('codacao').AsString;
  EditNomeComprador.Text := DsAcao.DataSet.FieldByName('tituloacao').AsString;
  MemoDescAcao.Lines.Clear;
  MemoDescAcao.Lines.Add(DsAcao.DataSet.FieldByName('descacao').AsString);
  EditNomeComprador.SetFocus;
end;

procedure TFormCadComprador.LimpaCampos;
begin
  EditCod.Clear;
  EditNomeComprador.Clear;
  MemoDescAcao.Lines.Clear;
end;

procedure TFormCadComprador.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCadComprador.ButtonCancelarClick(Sender: TObject);
begin
  LimpaCampos;
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.Listagem(Self.FCodAuditoria, DsListagem);
end;

procedure TFormCadComprador.ButtonAlterarClick(Sender: TObject);
begin
  LimpaCampos;
  ControlaPage(TabAlteracoes, TabListagem);
  PassaDadosAosCampos;
end;

procedure TFormCadComprador.ButtonNovoClick(Sender: TObject);
begin
  LimpaCampos;
  ControlaPage(TabAlteracoes, TabListagem);
  EditCod.Text := '-1';
  EditNomeComprador.SetFocus;
end;

procedure TFormCadComprador.ButtonSalvarClick(Sender: TObject);
begin
  LimpaCampos;
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.Listagem(Self.FCodAuditoria, DsListagem);
end;

procedure TFormCadComprador.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if(Assigned(Auxiliar)) then
    FreeAndNil(Auxiliar);
end;

procedure TFormCadComprador.FormCreate(Sender: TObject);
begin
  Auxiliar := TCadAcoes.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

end.

