unit view.cad.medias.produto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls, ComCtrls, Spin,
  DateUtils, classe.cad.medias, db;

type

  { TFormCadMedias }

  TFormCadMedias = class(TForm)
    BevelEntradas: TBevel;
    BevelSaidas: TBevel;
    ButtonApagarSaida: TSpeedButton;
    ButtonApagarEntrada: TSpeedButton;
    ButtonGravarEntrada: TSpeedButton;
    ButtonSair: TSpeedButton;
    ComboAnoSaida: TComboBox;
    ComboAnoEntrada: TComboBox;
    ComboTipoPedidoSaida: TComboBox;
    ComboMesSaida: TComboBox;
    ComboMesEntrada: TComboBox;
    ComboTipoPedidoEntrada: TComboBox;
    DsListagemEntradas: TDataSource;
    DsListagemSaidas: TDataSource;
    EditProdutoE: TLabeledEdit;
    EditTotalSaida: TFloatSpinEdit;
    EditProduto: TLabeledEdit;
    EditTotalEntrada: TFloatSpinEdit;
    GridSaidas: TDBGrid;
    GridEntradas: TDBGrid;
    GrupoDadosSaida: TGroupBox;
    GrupoDadosEntrada: TGroupBox;
    LabelTipoPedidoSaida: TLabel;
    LabelInfoSaida: TLabel;
    LabelAnoSaida: TLabel;
    LabelAnoEntrada: TLabel;
    LabelInfoEntradas: TLabel;
    LabelMesSaida: TLabel;
    LabelMesSaida1: TLabel;
    LabelMesEntrada: TLabel;
    LabelTipoPedidoEntrada: TLabel;
    LabelTotalEntrada: TLabel;
    PageCadastros: TPageControl;
    PanelButtunsCrud: TPanel;
    PanelPrincipal: TPanel;
    PaneltTopo: TPanel;
    ButtonGravarSaida: TSpeedButton;
    TabCadSaidas: TTabSheet;
    TabCadEntradas: TTabSheet;
    procedure ButtonApagarEntradaClick(Sender: TObject);
    procedure ButtonApagarSaidaClick(Sender: TObject);
    procedure ButtonGravarEntradaClick(Sender: TObject);
    procedure ButtonGravarSaidaClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
     FCodProduto: Integer;
     FDescricaoCpl: String;
     Auxiliar: TCadMedias;
     procedure InsereAnoCombo;

     // Ações Saída
     procedure AcaoInserirS(DsAux: TDataSource; Natureza: String);
     procedure AcaoExluirS(CodMedia: Integer);
     procedure PassaValoresSaida;

     // Ações Entrada
     procedure AcaoInserirE(DsAux: TDataSource; Natureza: String);
     procedure AcaoExluirE(CodMedia: Integer);
     procedure PassaValoresEntrada;

     procedure ValidaValorZero(Valor: Currency);


  public
     property F_CodProduto: Integer read FCodProduto write FCodProduto;
     property F_DescCPL: String read FDescricaoCpl   write FDescricaoCpl;

  end;

var
  FormCadMedias: TFormCadMedias;

implementation

uses
  view.principal;

{$R *.lfm}

{ TFormCadMedias }

procedure TFormCadMedias.FormShow(Sender: TObject);
begin
  InsereAnoCombo;
  EditProduto.Text  := FDescricaoCpl;
  EditProdutoE.Text := FDescricaoCpl;
  Auxiliar.ListagemMediasSaidas(FCodProduto, DsListagemSaidas);
  Auxiliar.ListagemMediasEntradas(FCodProduto, DsListagemEntradas);
  PageCadastros.ActivePage := TabCadSaidas;
end;

procedure TFormCadMedias.InsereAnoCombo;
var
  i: Integer;
  Ano: String;
begin
  Ano := FormatDateTime('yyyy', Date );
  ComboAnoSaida.Items.Clear;
  ComboAnoEntrada.Items.Clear;
  for i := 2000 to StrToIntDef(Ano, -1) do begin
    ComboAnoSaida.Items.Add(IntToStr(i));
    ComboAnoEntrada.Items.Add(IntToStr(i));
  end;
  ComboAnoSaida.ItemIndex := ComboAnoSaida.Items.Count -1;
  ComboAnoEntrada.ItemIndex := ComboAnoSaida.Items.Count -1;
end;

procedure TFormCadMedias.AcaoInserirS(DsAux: TDataSource; Natureza: String);
begin
  Auxiliar.InserirDadosS(FCodProduto, DsAux, Natureza);
end;

procedure TFormCadMedias.AcaoExluirS(CodMedia: Integer);
begin
  Auxiliar.DeletarMediaS(CodMedia);
end;

procedure TFormCadMedias.PassaValoresSaida;
begin
  Auxiliar.F_Mes      := ComboMesSaida.ItemIndex;
  Auxiliar.F_Ano      := StrToIntDef(ComboAnoSaida.Text, -1);
  Auxiliar.F_Total    := EditTotalSaida.Value;
  Auxiliar.F_Operacao := Copy(ComboTipoPedidoSaida.Text, 1, 2);
end;

procedure TFormCadMedias.AcaoInserirE(DsAux: TDataSource; Natureza: String);
begin
  Auxiliar.InserirDadosE(FCodProduto, DsAux, Natureza);
end;

procedure TFormCadMedias.AcaoExluirE(CodMedia: Integer);
begin
  Auxiliar.DeletarMediaE(CodMedia);
end;

procedure TFormCadMedias.PassaValoresEntrada;
begin
  Auxiliar.F_Mes      := ComboMesEntrada.ItemIndex;
  Auxiliar.F_Ano      := StrToIntDef(ComboAnoEntrada.Text, -1);
  Auxiliar.F_Total    := EditTotalEntrada.Value;
  Auxiliar.F_Operacao := Copy(ComboTipoPedidoEntrada.Text, 1, 2);
end;

procedure TFormCadMedias.ValidaValorZero(Valor: Currency);
begin
  if(Valor <= 0.00) then begin
    MessageDlg('Não é possível inserir média menor ou igual a zero!'
         , mtWarning, [mbOk],0);
    Abort;
  end;
end;

procedure TFormCadMedias.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCadMedias.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(Auxiliar) then
    FreeAndNil(Auxiliar);
end;

procedure TFormCadMedias.FormCreate(Sender: TObject);
begin
  Auxiliar := TCadMedias.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

procedure TFormCadMedias.ButtonGravarSaidaClick(Sender: TObject);
begin
  ValidaValorZero(EditTotalSaida.Value);
  if(EditTotalSaida.Value > 0) then begin
    PassaValoresSaida;
    AcaoInserirS(DsListagemSaidas, 'S');
    Auxiliar.ListagemMediasSaidas(FCodProduto, DsListagemSaidas);
  end;
end;

procedure TFormCadMedias.ButtonApagarSaidaClick(Sender: TObject);
begin
  AcaoExluirS(DsListagemSaidas.DataSet.FieldByName('codmedia').AsInteger);
  Auxiliar.ListagemMediasSaidas(FCodProduto, DsListagemSaidas);
end;

procedure TFormCadMedias.ButtonGravarEntradaClick(Sender: TObject);
begin
  ValidaValorZero(EditTotalEntrada.Value);
  if(EditTotalEntrada.Value > 0) then begin
    PassaValoresEntrada;
    AcaoInserirE(DsListagemEntradas, 'E');
    Auxiliar.ListagemMediasEntradas(FCodProduto, DsListagemEntradas);
  end;
end;

procedure TFormCadMedias.ButtonApagarEntradaClick(Sender: TObject);
begin
  AcaoExluirE(DsListagemEntradas.DataSet.FieldByName('codmedia').AsInteger);
  Auxiliar.ListagemMediasEntradas(FCodProduto, DsListagemEntradas);
end;

end.

