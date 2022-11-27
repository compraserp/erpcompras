unit view.entidade.cadComprador;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls,
  Buttons, DBGrids, EditBtn,
  StdCtrls, DividerBevel,
  classe.cad.compradores,
  types.actions, db, MD5,
  classe.funcoesAuxiliares;

type

  { TFormCadComprador }

  TFormCadComprador = class(TForm)
    ButtonAlterar: TSpeedButton;
    ButtonAPagar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    ButtonNovo: TSpeedButton;
    ButtonSair: TSpeedButton;
    ButtonSalvar: TSpeedButton;
    CheckMudaSenha: TCheckBox;
    ComboFuncao: TComboBox;
    DividerBevel2: TDividerBevel;
    DsAcao: TDataSource;
    DsListagem: TDataSource;
    DividerBevel1: TDividerBevel;
    EditCod: TLabeledEdit;
    EditDataAbertura: TDateEdit;
    EditNomeComprador: TLabeledEdit;
    EditSenha: TLabeledEdit;
    EditRepetirSenha: TLabeledEdit;
    GridListagem: TDBGrid;
    Label1: TLabel;
    LabelAvisoLogin: TLabel;
    LabelAvisoLogin1: TLabel;
    LabelFuncao: TLabel;
    PagePrincipal: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelTopo: TPanel;
    PanelRodapeBotoes: TPanel;
    TabAlteracoes: TTabSheet;
    TabListagem: TTabSheet;
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonAPagarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

    FuncAuxiliar: TFuncAuxiliar;
    Auxiliar: TCadCompradores;
    FCodAuditoria: Integer;
    FAuditoria: String;
    FTypeAction: TAcaoCrud;
    Codigo: Integer;

    procedure ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
    procedure ValidaSenhaVazia;
    procedure ValidaSenhaDiferentes;
    procedure BloqueiaAcoes(CodFuncao: Integer);

    // Procedimentos comuns
    procedure PassaDadosAosCampos;
    procedure PassaValoresClasse;

    procedure AcaoSalvar;
    procedure AcaoDeletar;

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
  Auxiliar.Listagem(DsListagem);
  ControlaPage(TabListagem, TabAlteracoes);
  BloqueiaAcoes(FormPrincipal.F_FuncUsuario);
end;

procedure TFormCadComprador.ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
begin
  TabVisivel.TabVisible := True;
  TabInvisivel.TabVisible := False;
end;

procedure TFormCadComprador.PassaDadosAosCampos;
begin
  Codigo := DsListagem.DataSet.FieldByName('codacesso').AsInteger;
  Auxiliar.Selecionar(Codigo, DsAcao);

  EditCod.Text := DsAcao.DataSet.FieldByName('codacesso').AsString;
  EditNomeComprador.Text := DsAcao.DataSet.FieldByName('nome').AsString;
  ComboFuncao.ItemIndex := DsAcao.DataSet.FieldByName('funcao').AsInteger;
  EditNomeComprador.SetFocus;
end;

procedure TFormCadComprador.ValidaSenhaVazia;
begin
  if(CheckMudaSenha.Checked) then begin
    if(Trim(EditSenha.Text) = EmptyStr)
      or (Trim(EditRepetirSenha.Text) = EmptyStr) then begin
      MessageDlg('O campo "Senha" e "Repita a senha" não podem ser vazios!', mtWarning, [mbOk], 0);
      Abort;
    end;
  end;
end;

procedure TFormCadComprador.ValidaSenhaDiferentes;
begin
  if(CheckMudaSenha.Checked) then
    if(Trim(EditSenha.Text) <> Trim(EditRepetirSenha.Text)) then begin
      MessageDlg('As senhas não conferem!', mtError, [mbOk], 0);
      Abort;
    end;
end;

procedure TFormCadComprador.BloqueiaAcoes(CodFuncao: Integer);
var
  Usuario_Adm: Boolean;
begin
  Usuario_Adm := (CodFuncao = 2);
  // 100 é o código da função do Adm.
  ButtonSalvar.Enabled  := Usuario_Adm;
  ButtonNovo.Enabled    := Usuario_Adm;
  ButtonAlterar.Enabled := Usuario_Adm;
  ButtonAPagar.Enabled  := Usuario_Adm;
end;

procedure TFormCadComprador.PassaValoresClasse;
begin
  Auxiliar.F_CodComprador := Codigo;
  Auxiliar.F_Funcao       := ComboFuncao.ItemIndex;
  Auxiliar.F_Nome         := EditNomeComprador.Text;
  Auxiliar.F_Pwd          := MD5Print(MD5String(EditSenha.Text));
end;

procedure TFormCadComprador.AcaoSalvar;
begin
  FuncAuxiliar.CampoObrigatorio(FormCadComprador, 2);
  ValidaSenhaVazia;
  ValidaSenhaDiferentes;
  ControlaPage(TabListagem, TabAlteracoes);
  PassaValoresClasse;

  Case (FTypeAction) of
  tpInsert: Auxiliar.Inserir(DsAcao);
  tpUpdate:
    begin
     if(CheckMudaSenha.Checked) then
       Auxiliar.AtualizarComSenha(Codigo, DsAcao)
     else
       Auxiliar.Atualizar(Codigo, DsAcao);
    end;
  end;

  FuncAuxiliar.LimpaCampos(FormCadComprador);
  Auxiliar.Listagem(DsListagem);
end;

procedure TFormCadComprador.AcaoDeletar;
var
  Cod: Integer;
begin
  if not(DsListagem.DataSet.IsEmpty) then begin
    Cod := DsListagem.DataSet.FieldByName('codacesso').AsInteger;
    if(MessageDlg('Deseja realmente exclui o registro?!',
       mtWarning, [mbYes, mbNo], 0) = mrYes) then begin
       Auxiliar.Deletar(Cod);
       Auxiliar.Listagem(DsListagem);
    end
    else Abort;
  end;
end;

procedure TFormCadComprador.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCadComprador.ButtonCancelarClick(Sender: TObject);
begin
  FuncAuxiliar.LimpaCampos(FormCadComprador);
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.Listagem(DsListagem);
end;

procedure TFormCadComprador.ButtonAlterarClick(Sender: TObject);
begin
  if not(DsListagem.DataSet.IsEmpty) then begin
    FTypeAction := tpUpdate;
    ControlaPage(TabAlteracoes, TabListagem);
    PassaDadosAosCampos;
    CheckMudaSenha.Checked := False;
    CheckMudaSenha.Enabled := True;
  end;
end;

procedure TFormCadComprador.ButtonAPagarClick(Sender: TObject);
begin
  AcaoDeletar;
end;

procedure TFormCadComprador.ButtonNovoClick(Sender: TObject);
begin
  ControlaPage(TabAlteracoes, TabListagem);
  EditCod.Text := '-1';
  EditNomeComprador.SetFocus;
  CheckMudaSenha.Checked := True;
  CheckMudaSenha.Enabled := False;
  FTypeAction := tpInsert;
end;

procedure TFormCadComprador.ButtonSalvarClick(Sender: TObject);
begin
  AcaoSalvar;
  BloqueiaAcoes(FormPrincipal.F_FuncUsuario);
end;

procedure TFormCadComprador.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if(Assigned(FuncAuxiliar)) then
    FreeAndNil(FuncAuxiliar);
  if(Assigned(Auxiliar)) then
    FreeAndNil(Auxiliar);
end;

procedure TFormCadComprador.FormCreate(Sender: TObject);
begin
  FuncAuxiliar := TFuncAuxiliar.Create;
  Auxiliar := TCadCompradores.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

end.

