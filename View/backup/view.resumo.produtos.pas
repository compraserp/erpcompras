unit view.resumo.produtos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DBGrids, StdCtrls,
  classe.resumo.produtos, db;

type

  { TFormResumoProdutos }

  TFormResumoProdutos = class(TForm)
    ButtonCarregaDados: TSpeedButton;
    ButtonSair: TSpeedButton;
    DsSaidas: TDataSource;
    DsEntradas: TDataSource;
    GridSaidas: TDBGrid;
    DsProdutos: TDataSource;
    GridProdutos: TDBGrid;
    GridEntradas: TDBGrid;
    ImgResumo: TImage;
    Label1: TLabel;
    LabelEntradas: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelEntradasSaidas: TPanel;
    PanelFiltros: TPanel;
    PanelProdutos: TPanel;
    procedure ButtonCarregaDadosClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure DsProdutosDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    Auxiliar: TResumoProdutos;

    procedure ListaSaidas;
    procedure ListaEntradas;

  public

  end;

var
  FormResumoProdutos: TFormResumoProdutos;

implementation

uses
  View.principal;

{$R *.lfm}

{ TFormResumoProdutos }

procedure TFormResumoProdutos.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormResumoProdutos.DsProdutosDataChange(Sender: TObject;
  Field: TField);
begin
  ListaSaidas;
  ListaEntradas;
end;

procedure TFormResumoProdutos.ButtonCarregaDadosClick(Sender: TObject);
begin
  Auxiliar.ListaProdutos(DsProdutos);
  ListaSaidas;
  ListaEntradas;
end;

procedure TFormResumoProdutos.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(Auxiliar) then
    FreeAndNil(Auxiliar);
end;

procedure TFormResumoProdutos.FormCreate(Sender: TObject);
begin
  Auxiliar := TResumoProdutos.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

procedure TFormResumoProdutos.ListaSaidas;
var
  CodProduto: Integer;
begin
  CodProduto := DsProdutos.DataSet.FieldByName('codproduto').AsInteger;
  Auxiliar
    .ListaSaidas(CodProduto, DsSaidas);
end;

procedure TFormResumoProdutos.ListaEntradas;
var
  CodProduto: Integer;
begin
  CodProduto := DsProdutos.DataSet.FieldByName('codproduto').AsInteger;
  Auxiliar
    .ListaEntradas(CodProduto, DsEntradas);
end;

end.

