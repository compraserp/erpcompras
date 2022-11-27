unit view.entidade.analise;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset,
  Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls,
  Buttons, DBGrids, StdCtrls,
  EditBtn, Menus, DividerBevel,
  view.pesquisa.multiselecao,
  types.actions, view.rel.pedido,
  classe.analise,
  classe.funcoesAuxiliares;

type

  { TFormAnaliseCompras }

  TFormAnaliseCompras = class(TForm)
    BufProdutosAnalise: TBufDataset;
    BufProdutosAnalisecodbarras: TStringField;
    BufProdutosAnalisecodproduto: TLongintField;
    BufProdutosAnalisedescricao: TStringField;
    BufProdutosAnaliseentradas: TFloatField;
    BufProdutosAnaliseestoque: TLongintField;
    BufProdutosAnalisegerapedido: TLongintField;
    BufProdutosAnaliseqtdComprar: TFloatField;
    BufProdutosAnalisesaidas: TFloatField;
    BufProdutosAnalisesugestao: TFloatField;
    ButtonGeraSugestao: TSpeedButton;
    ButtonAlterar: TSpeedButton;
    ButtonAPagar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    ButtonNovo: TSpeedButton;
    ButtonSair: TSpeedButton;
    ButtonSalvar: TSpeedButton;
    ComboMesAnalise: TComboBox;
    ComboTipoPedido: TComboBox;
    DsCarregaProd: TDataSource;
    DsAnalise: TDataSource;
    GridAnaliseSugestao: TDBGrid;
    DsListagem: TDataSource;
    BevelDivisao: TDividerBevel;
    GridListagem: TDBGrid;
    EditCodSugestao: TLabeledEdit;
    EditCPFCNPJ: TLabeledEdit;
    EditNomeFornecedor: TLabeledEdit;
    GrupoBaseAnalise: TGroupBox;
    LabelTituloAnalise: TLabel;
    LabelInfoPedidos: TLabel;
    LabelMesAnalise: TLabel;
    LabelTipoPedido: TLabel;
    MenuMarcarTodos: TMenuItem;
    MenuDesmarcarTodos: TMenuItem;
    MenuItem3: TMenuItem;
    MenuPassaSugestaoQtd: TMenuItem;
    ButtonImprimirPed: TSpeedButton;
    ZeraQtdComprada: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PagePrincipal: TPageControl;
    PanelAcoes: TPanel;
    PanelRodape: TPanel;
    PanelAnalise: TPanel;
    PanelRodapeBotoes: TPanel;
    ButtonAddProdutos: TSpeedButton;
    PopupMenuAnalise: TPopupMenu;
    TabAlteracoes: TTabSheet;
    TabListagem: TTabSheet;
    procedure ButtonAddProdutosClick(Sender: TObject);
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonAPagarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonGeraSugestaoClick(Sender: TObject);
    procedure ButtonImprimirPedClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure DsAnaliseDataChange(Sender: TObject; Field: TField);
    procedure DsListagemDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuMarcarTodosClick(Sender: TObject);
    procedure MenuDesmarcarTodosClick(Sender: TObject);
    procedure MenuPassaSugestaoQtdClick(Sender: TObject);
    procedure ZeraQtdCompradaClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    TypeAcao: TAcaoCrud;
    Auxiliar: TAnalise;
    FuncAuxiliares: TFuncAuxiliar;
    ListaProdutos: String;

    procedure ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
    procedure DefineAcao;
    procedure LimpaBuf;
    procedure ApagarRegistro;
    procedure AbreTelaPesquisa;
    procedure AcaoSalvar;

    procedure ValidaStatusPedidoExclusao;
    procedure BloqueiaAltPedidoEntregue;

    // Ações com BUF
    procedure AddProdutosNoBuf;
    procedure AcaoMarcarDesmarcarTodos(ValCheck: Integer);
    procedure ZerarValorQtdComprar;
    procedure PassaSugestaoParaQtdComprada;
    procedure ValidaItensComQtdZero;

    procedure PassaValorSugestaoBuf;

    procedure ValidaItensNaoGerados;

    // Ações CRUD do cabeçalho
    procedure PassaValoresCabClasse;
    procedure PassaDadosAosCampos;

  public

  end;

var
  FormAnaliseCompras: TFormAnaliseCompras;

implementation

uses
  view.principal;

{$R *.lfm}

{ TFormAnaliseCompras }

procedure TFormAnaliseCompras.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAnaliseCompras.ButtonSalvarClick(Sender: TObject);
begin
  AcaoSalvar;
end;

procedure TFormAnaliseCompras.DsAnaliseDataChange(Sender: TObject; Field: TField
  );
begin
  ButtonGeraSugestao.Enabled := not(DsAnalise.DataSet.IsEmpty);
end;

procedure TFormAnaliseCompras.DsListagemDataChange(Sender: TObject;
  Field: TField);
begin
  ButtonAlterar.Enabled := not(DsListagem.DataSet.IsEmpty);
  ButtonAPagar.Enabled  := not(DsListagem.DataSet.IsEmpty);
end;

procedure TFormAnaliseCompras.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if(Assigned(Auxiliar)) then
    FreeAndNil(Auxiliar);
  if(Assigned(FuncAuxiliares)) then
    FreeAndNil(FuncAuxiliares);
  BufProdutosAnalise.Close;
end;

procedure TFormAnaliseCompras.LimpaBuf;
var
  i: Integer;
begin
 for i := 0 to BufProdutosAnalise.RecordCount -1 do begin
   BufProdutosAnalise.Delete;
 end;
end;

procedure TFormAnaliseCompras.FormCreate(Sender: TObject);
begin
  Auxiliar := TAnalise.Create(FormPrincipal.F_Conexao.FDriverConexao);
  FuncAuxiliares := TFuncAuxiliar.Create;
  BufProdutosAnalise.CreateDataset;
  BufProdutosAnalise.Open;
end;

procedure TFormAnaliseCompras.FormShow(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
  ButtonGeraSugestao.Enabled := not(DsAnalise.DataSet.IsEmpty);
  Auxiliar.ListaCabecalhoPedido(DsListagem);
end;

procedure TFormAnaliseCompras.MenuMarcarTodosClick(Sender: TObject);
begin
  AcaoMarcarDesmarcarTodos(1);
end;

procedure TFormAnaliseCompras.MenuDesmarcarTodosClick(Sender: TObject);
begin
  AcaoMarcarDesmarcarTodos(0);
end;

procedure TFormAnaliseCompras.MenuPassaSugestaoQtdClick(Sender: TObject);
begin
  PassaSugestaoParaQtdComprada;
end;

procedure TFormAnaliseCompras.ZeraQtdCompradaClick(Sender: TObject);
begin
  ZerarValorQtdComprar;
end;

procedure TFormAnaliseCompras.SpeedButton1Click(Sender: TObject);
begin
 BufProdutosAnalise.First;
 while not BufProdutosAnalise.EOF do begin
   ShowMessage(BufProdutosAnalisedescricao.Value);
   BufProdutosAnalise.Next;
 end;
end;

procedure TFormAnaliseCompras.ButtonNovoClick(Sender: TObject);
begin
  LabelInfoPedidos.Visible := False;
  ControlaPage(TabAlteracoes, TabListagem);
  TypeAcao := tpInsert;
  EditCodSugestao.Text := '-1';
  EditNomeFornecedor.SetFocus;
  LimpaBuf;
  ButtonSalvar.Enabled := True;
  ButtonAddProdutos.Enabled := True;
  ButtonImprimirPed.Enabled := False;
end;

procedure TFormAnaliseCompras.ButtonAlterarClick(Sender: TObject);
begin
  LimpaBuf;
  BloqueiaAltPedidoEntregue;
  ControlaPage(TabAlteracoes, TabListagem);
  TypeAcao := tpUpdate;
  PassaDadosAosCampos;
  EditNomeFornecedor.SetFocus;
  LabelInfoPedidos.Visible := True;
  ButtonImprimirPed.Enabled := True;
end;

procedure TFormAnaliseCompras.ButtonAddProdutosClick(Sender: TObject);
begin
  AbreTelaPesquisa;
end;

procedure TFormAnaliseCompras.ButtonAPagarClick(Sender: TObject);
begin
  ApagarRegistro();
end;

procedure TFormAnaliseCompras.ButtonCancelarClick(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
  Auxiliar.ListaCabecalhoPedido(DsListagem);
  FuncAuxiliares.LimpaCampos(FormAnaliseCompras);
end;

procedure TFormAnaliseCompras.ButtonGeraSugestaoClick(Sender: TObject);
begin
  PassaValorSugestaoBuf;
end;

procedure TFormAnaliseCompras.ButtonImprimirPedClick(Sender: TObject);
begin
  FormRelPedido := TFormRelPedido.Create(Self);
  try
    FormRelPedido
      .CarregaDadosPedido(DsListagem.DataSet.FieldByName('codpedido').AsInteger);
    FormRelPedido.ReportPrincipal.Preview;
  finally
    FormRelPedido.Release;
  end;
end;

procedure TFormAnaliseCompras.ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
begin
  TabVisivel.TabVisible := True;
  TabInvisivel.TabVisible := False;
end;

procedure TFormAnaliseCompras.DefineAcao;
begin
  if(TypeAcao = tpInsert) then begin
    Auxiliar.InserirCabecalho(BufProdutosAnalise, DsListagem);
  end;
  if(TypeAcao = tpUpdate) then begin
    Auxiliar.AtualizaCabecalho(BufProdutosAnalise, DsListagem,
       StrToIntDef(EditCodSugestao.Text, -1));
  end;
end;

procedure TFormAnaliseCompras.PassaDadosAosCampos;
var
  Codigo: Integer;
begin
 Codigo := DsListagem.DataSet.FieldByName('codpedido').AsInteger;
 Auxiliar.SelecionaCabecalho(BufProdutosAnalise, DsListagem, Codigo);
 EditCodSugestao.Text
    := IntToStr(Codigo);
 EditNomeFornecedor.Text
    := DsListagem.DataSet.FieldByName('nomeFornecedor').AsString;
 EditCPFCNPJ.Text
    := DsListagem.DataSet.FieldByName('cpfcnpj').AsString;
 ComboMesAnalise.ItemIndex
    := DsListagem.DataSet.FieldByName('mesanalise').AsInteger;
 ComboTipoPedido.ItemIndex
    := DsListagem.DataSet.FieldByName('tppedido').AsInteger;
end;

procedure TFormAnaliseCompras.ApagarRegistro;
var
  Codigo: Integer;
begin
  ValidaStatusPedidoExclusao;
  if(MessageDlg('Deseja realmente apagar o registro?', mtWarning,
               [mbYes, mbNo],0) = mrYes) then begin
     Codigo := DsListagem.DataSet.FieldByName('codpedido').AsInteger;
     Auxiliar.DeletePedido(Codigo);
     Auxiliar.ListaCabecalhoPedido(DsListagem);
  end;
end;

procedure TFormAnaliseCompras.AbreTelaPesquisa;
begin
  FormPesquisaMultiSelecao := TFormPesquisaMultiSelecao.Create(Self);
  try
    FormPesquisaMultiSelecao.ShowModal;
  finally
    ListaProdutos := FormPesquisaMultiSelecao.RetornaListaAoForm;
    FormPesquisaMultiSelecao.Release;
  end;
  LimpaBuf;
  AddProdutosNoBuf;
end;

procedure TFormAnaliseCompras.AcaoSalvar;
begin
 ValidaItensNaoGerados;
 ValidaItensComQtdZero;
 FuncAuxiliares.CampoObrigatorio(FormAnaliseCompras, 2);
 PassaValoresCabClasse;
 ControlaPage(TabListagem, TabAlteracoes);
 DefineAcao;
 LimpaBuf;
 FuncAuxiliares.LimpaCampos(FormAnaliseCompras);
 Auxiliar.ListaCabecalhoPedido(DsListagem);
end;

procedure TFormAnaliseCompras.ValidaStatusPedidoExclusao;
var
  Status: Integer;
begin
 DsListagem.DataSet.Refresh;
 Status := DsListagem.DataSet.FieldByName('status').AsInteger;
 if(Status = 1) then begin
    MessageDlg('Este pedido já está entregue, portanto não será ' +
         ' possível exclui-lo!', mtError, [mbOK], 0);
    Abort;
 end;
 Exit;
end;

procedure TFormAnaliseCompras.BloqueiaAltPedidoEntregue;
var
  PedEntregue: Boolean;
begin
 PedEntregue := (DsListagem.DataSet.FieldByName('status').AsInteger = 0);
 ButtonSalvar.Enabled := PedEntregue;
end;

procedure TFormAnaliseCompras.AddProdutosNoBuf;
begin
  Auxiliar.CarregaProdutosParaAnalise(DsCarregaProd, ListaProdutos);
  DsCarregaProd.DataSet.First;
  while not DsCarregaProd.DataSet.EOF do begin
    BufProdutosAnalise.Insert;
    BufProdutosAnalisegerapedido.Value  := 0;
     BufProdutosAnalisecodproduto.Value  := DsCarregaProd.DataSet.FieldByName('codproduto').AsInteger;
      BufProdutosAnalisedescricao.Value   := DsCarregaProd.DataSet.FieldByName('descricao').AsString;
       BufProdutosAnalisecodbarras.Value   := DsCarregaProd.DataSet.FieldByName('codbarras').AsString;
       BufProdutosAnaliseestoque.Value     := DsCarregaProd.DataSet.FieldByName('estoque').AsInteger;
      BufProdutosAnalisesaidas.Value      := DsCarregaProd.DataSet.FieldByName('saidas').AsFloat;
     BufProdutosAnaliseentradas.Value    := DsCarregaProd.DataSet.FieldByName('entradas').AsFloat;
     BufProdutosAnaliseqtdComprar.Value := 0;
     BufProdutosAnalisesugestao.Value  := 0;
    BufProdutosAnalise.Append;
    BufProdutosAnalise.Next;
    DsCarregaProd.DataSet.Next;
  end;
end;

procedure TFormAnaliseCompras.AcaoMarcarDesmarcarTodos(ValCheck: Integer);
begin
  BufProdutosAnalise.First;
  while not BufProdutosAnalise.EOF do begin
    BufProdutosAnalise.Edit;
     BufProdutosAnalisegerapedido.Value := ValCheck;
    BufProdutosAnalise.Next;
  end;
  BufProdutosAnalise.First;
end;

procedure TFormAnaliseCompras.ZerarValorQtdComprar;
begin
  BufProdutosAnalise.First;
  while not BufProdutosAnalise.EOF do begin
    BufProdutosAnalise.Edit;
     BufProdutosAnaliseqtdComprar.Value := 0;
    BufProdutosAnalise.Next;
  end;
  BufProdutosAnalise.First;
end;

procedure TFormAnaliseCompras.PassaSugestaoParaQtdComprada;
begin
  BufProdutosAnalise.First;
  while not BufProdutosAnalise.EOF do begin
    BufProdutosAnalise.Edit;
     BufProdutosAnaliseqtdComprar.Value := BufProdutosAnalisesugestao.Value;
    BufProdutosAnalise.Next;
  end;
  BufProdutosAnalise.First;
end;

procedure TFormAnaliseCompras.ValidaItensComQtdZero;
begin
 BufProdutosAnalise.First;
 while not BufProdutosAnalise.EOF do begin
   if(BufProdutosAnalisegerapedido.Value = 1) and
      (BufProdutosAnaliseqtdComprar.Value <= 0) then begin
         MessageDlg('O Produto "' + BufProdutosAnalisedescricao.Value +
         '" está marcado para gerar pedido, mas está com a quantidade zero!' +
         ' Ajuste a quantidade ou desmarque o produto.',
         mtWarning, [mbOk], 0);
     Abort;
   end
   else BufProdutosAnalise.Next;
 end;
end;

procedure TFormAnaliseCompras.PassaValorSugestaoBuf;
begin
 BufProdutosAnalise.First;
 while not BufProdutosAnalise.EOF do begin
   BufProdutosAnalise.Edit;
   BufProdutosAnalisesugestao.Value
       := Auxiliar.RetornaSugestaoCompra(
           BufProdutosAnalisecodproduto.Value,
           ComboMesAnalise.ItemIndex,
           BufProdutosAnaliseestoque.Value);
   BufProdutosAnaliseqtdComprar.Value := BufProdutosAnalisesugestao.Value;
   BufProdutosAnalise.Next;
 end;
 BufProdutosAnalise.First;
end;

procedure TFormAnaliseCompras.ValidaItensNaoGerados;
var
  i, QtdProdSemGerar: Integer;
begin
 QtdProdSemGerar := 0;
  BufProdutosAnalise.First;
  while not BufProdutosAnalise.EOF do begin
    if(BufProdutosAnalise.FieldByName('gerapedido').AsInteger = 0) then
      QtdProdSemGerar := QtdProdSemGerar + 1;
    BufProdutosAnalise.Next;
  end;
  if(QtdProdSemGerar > 0) then begin
    if(MessageDlg('Existem '+IntToStr(QtdProdSemGerar) +
        ' produto(s) não marcados para gerar pedido. Deseja exclui-los?',
        mtWarning, [mbYes, mbNo], 0) = mrYes) then begin
       BufProdutosAnalise.First;
       while not BufProdutosAnalise.EOF do begin
          if(BufProdutosAnalise.FieldByName('gerapedido').AsInteger = 0) then begin
            BufProdutosAnalise.Delete;
            BufProdutosAnalise.First;
          end;
          BufProdutosAnalise.Next;
       end;
    end;
  end;
end;

procedure TFormAnaliseCompras.PassaValoresCabClasse;
begin
  Auxiliar.F_NomeForn   := EditNomeFornecedor.Text;
  Auxiliar.F_CPFCNPJ    := EditCPFCNPJ.Text;
  Auxiliar.F_TipoPedido := Copy(ComboTipoPedido.Text, 1,2);
  Auxiliar.F_MesAnalise := ComboMesAnalise.ItemIndex;
end;

end.

