unit view.cad.itens;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons,
  ComCtrls, DBGrids, EditBtn, StdCtrls, Spin,
  DividerBevel, classe.cad.produto, db,
  types.actions, classe.funcoesAuxiliares,
  view.cad.medias.produto;

type

  { TFormCadProdutos }

  TFormCadProdutos = class(TForm)
    ButtonAlterar: TSpeedButton;
    ButtonAPagar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    ButtonNovo: TSpeedButton;
    ButtonSair: TSpeedButton;
    ButtonSalvar: TSpeedButton;
    DsListagem: TDataSource;
    DsAction: TDataSource;
    DividerBevel1: TDividerBevel;
    EditCodProduto: TLabeledEdit;
    EditVlrVenda: TFloatSpinEdit;
    EditDataAlteracao: TDateEdit;
    EditDescricao: TLabeledEdit;
    EditCodBarras: TLabeledEdit;
    EditCustoAtual: TFloatSpinEdit;
    EditEstoqueAtual: TFloatSpinEdit;
    GridListagem: TDBGrid;
    LabelDataAlt: TLabel;
    LabelEstoque: TLabel;
    LabelCustoAtual: TLabel;
    LabelVlrVenda: TLabel;
    PagePrincipal: TPageControl;
    PanelButtonsActions: TPanel;
    PanelButtunsCrud: TPanel;
    PanelRodapeBotoes: TPanel;
    PanelTopo: TPanel;
    ButtonCadMedias: TSpeedButton;
    TabAlteracoes: TTabSheet;
    TabListagem: TTabSheet;
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonAPagarClick(Sender: TObject);
    procedure ButtonCadMediasClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FTypeAction: TAcaoCrud;
    CodProduto: Integer;
    FuncAuxiliar: TFuncAuxiliar;
    Auxiliar: TCadProduto;

    // Procedimentos comuns
    procedure PassaDadosAosCampos;
    procedure PassaValoresClasse;

    procedure ControlaPage(TabVisivel, TabInvisivel: TTabSheet);

    procedure LimpaCampos;
    procedure AcaoSalvar;
    procedure AcaoDeletar;

  public

  end;

var
  FormCadProdutos: TFormCadProdutos;

implementation

uses
  view.principal;

{$R *.lfm}

{ TFormCadProdutos }

procedure TFormCadProdutos.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCadProdutos.ButtonCancelarClick(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.Listagem(DsListagem);
  FuncAuxiliar.LimpaCampos(FormCadProdutos);
end;

procedure TFormCadProdutos.ButtonAlterarClick(Sender: TObject);
begin
  if not(DsListagem.DataSet.IsEmpty) then begin
    ControlaPage(TabAlteracoes, TabListagem);
    PassaDadosAosCampos;
    FTypeAction := tpUpdate;
    EditDescricao.SetFocus;
    ButtonCadMedias.Enabled := True;
  end;
end;

procedure TFormCadProdutos.ButtonAPagarClick(Sender: TObject);
begin
  AcaoDeletar;
end;

procedure TFormCadProdutos.ButtonCadMediasClick(Sender: TObject);
begin
  FormCadMedias := TFormCadMedias.Create(Self);
  try
    FormCadMedias.F_CodProduto
       := StrToIntDef(EditCodProduto.Text, -1);
    FormCadMedias.F_DescCPL
       := EditCodProduto.Text + ' - ' + EditDescricao.Text;
    FormCadMedias.ShowModal;
  finally
    FormCadMedias.Release;
  end;
end;

procedure TFormCadProdutos.ButtonNovoClick(Sender: TObject);
begin
  ControlaPage(TabAlteracoes, TabListagem);
  FTypeAction := tpInsert;
  EditDescricao.SetFocus;
  ButtonCadMedias.Enabled := False;
end;

procedure TFormCadProdutos.ButtonSalvarClick(Sender: TObject);
begin
  AcaoSalvar;
end;

procedure TFormCadProdutos.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(FuncAuxiliar) then
    FreeAndNil(FuncAuxiliar);
  if Assigned(Auxiliar) then
    FreeAndNil(Auxiliar);
end;

procedure TFormCadProdutos.FormCreate(Sender: TObject);
begin
  FuncAuxiliar := TFuncAuxiliar.Create;
  Auxiliar := TCadProduto.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

procedure TFormCadProdutos.FormShow(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.Listagem(DsListagem);
end;

procedure TFormCadProdutos.PassaDadosAosCampos;
begin
  CodProduto := DsListagem.DataSet.FieldByName('codproduto').AsInteger;
  Auxiliar.Selecionar(CodProduto, DsAction);
  EditCodProduto.Text
   := DsAction.DataSet.FieldByName('codproduto').AsString;
  EditDescricao.Text
   := DsAction.DataSet.FieldByName('descricao').AsString;
  EditCodBarras.Text
   := DsAction.DataSet.FieldByName('codbarras').AsString;
  EditEstoqueAtual.Value
   := DsAction.DataSet.FieldByName('estoque').AsCurrency;
  EditCustoAtual.Value
   := DsAction.DataSet.FieldByName('custoatual').AsCurrency;
  EditVlrVenda.Value
   := DsAction.DataSet.FieldByName('vlrvenda').AsCurrency;
  EditDataAlteracao.Date
   := DsAction.DataSet.FieldByName('dataalt').AsDateTime;

  EditDescricao.SetFocus;
end;

procedure TFormCadProdutos.PassaValoresClasse;
begin
  Auxiliar.F_Descricao  := EditDescricao.Text;
  Auxiliar.F_CodBarras  := EditCodBarras.Text;
  Auxiliar.F_Estoque    := EditEstoqueAtual.Value;
  Auxiliar.F_CustoAtual := EditCustoAtual.Value;
  Auxiliar.F_VlrVenda   := EditVlrVenda.Value;
end;

procedure TFormCadProdutos.ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
begin
  TabVisivel.TabVisible := True;
  TabInvisivel.TabVisible := False;
end;

procedure TFormCadProdutos.LimpaCampos;
begin
  EditCodProduto.Clear;
  EditDescricao.Clear;
  EditCodBarras.Clear;
  EditEstoqueAtual.Value := 0.00;
  EditCustoAtual.Value   := 0.00;
  EditVlrVenda.Value     := 0.00;
end;

procedure TFormCadProdutos.AcaoSalvar;
begin
  FuncAuxiliar.CampoObrigatorio(FormCadProdutos, 2);
  PassaValoresClasse;
  Case (FTypeAction) of
    tpInsert: Auxiliar.Inserir(DsAction);
    tpUpdate: Auxiliar.Atualizar(CodProduto, DsAction);
  end;

  ControlaPage(TabListagem, TabAlteracoes);
  FuncAuxiliar.LimpaCampos(FormCadProdutos);
  Auxiliar.Listagem(DsListagem);
end;

procedure TFormCadProdutos.AcaoDeletar;
var
  Cod: Integer;
begin
  if not(DsListagem.DataSet.IsEmpty) then begin
    Cod := DsListagem.DataSet.FieldByName('codproduto').AsInteger;
    if(MessageDlg('Atenção! As médias de entradas e saídas do produto serão excluidas. ' +
                  ' Deseja realmente exclui o registro?!',
       mtWarning, [mbYes, mbNo], 0) = mrYes) then begin
       if(Auxiliar.Deletar(Cod)) then
         Auxiliar.Listagem(DsListagem)
       else begin
         MessageDlg('Ops! Este produto está em um pedido, não será possível ' +
                    'excluí-lo! ', mtError, [mbYes, mbNo], 0);
       end;
    end
    else Abort;
  end;
end;

end.

