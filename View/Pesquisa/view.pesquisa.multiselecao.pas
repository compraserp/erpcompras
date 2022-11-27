unit view.pesquisa.multiselecao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms,
  Controls, Graphics, Dialogs,
  ExtCtrls, Buttons,
  StdCtrls, DBGrids, Menus,
  classe.pesquisa;

type

  { TFormPesquisaMultiSelecao }

  TFormPesquisaMultiSelecao = class(TForm)
    ButtonSair: TSpeedButton;
    DsListagem: TDataSource;
    GridListagem: TDBGrid;
    EditPesquisa: TEdit;
    ImagemPrincipal: TImage;
    LabelInfoRegSelecionados: TLabel;
    MemoEscolhidos: TMemo;
    MenuEscolherSel: TMenuItem;
    MenuAcoesGrid: TMenuItem;
    MenuItem1: TMenuItem;
    SubMenuLimpaLista: TMenuItem;
    MenuItem4: TMenuItem;
    SubMenuSelecionaTodos: TMenuItem;
    MenuItem3: TMenuItem;
    MenuSair: TMenuItem;
    N1: TMenuItem;
    PanelCabecalho: TPanel;
    PopupMenuAcoes: TPopupMenu;
    procedure ButtonSairClick(Sender: TObject);
    procedure EditPesquisaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridListagemDblClick(Sender: TObject);
    procedure GridListagemTitleClick(Column: TColumn);
    procedure MenuAcoesGridClick(Sender: TObject);
    procedure MenuEscolherSelClick(Sender: TObject);
    procedure MenuSairClick(Sender: TObject);
    procedure SubMenuLimpaListaClick(Sender: TObject);
    procedure SubMenuSelecionaTodosClick(Sender: TObject);

  private

     Auxiliar: TPesquisa;
     procedure SelecionaUmRegistro;
     procedure SelecionaTodosOsRegistros;
     procedure LimpaLista;

  public

    TituloPesquisa: String;
    Lista: TStringList;

    function RetornaListaAoForm: String;
  end;

var
  FormPesquisaMultiSelecao: TFormPesquisaMultiSelecao;


implementation

{$R *.lfm}
uses  View.principal;

{ TFormPesquisaMultiSelecao }

procedure TFormPesquisaMultiSelecao.FormCreate(Sender: TObject);
begin
  TituloPesquisa := 'Tela de pesquisa'; // Default
  Position       := poScreenCenter;
  BorderStyle    := bsNone;
  Auxiliar := TPesquisa.Create(FormPrincipal.F_Conexao.FDriverConexao);
end;

procedure TFormPesquisaMultiSelecao.FormShow(Sender: TObject);
begin
  Lista := TStringList.Create;
  Lista.Add('-1');
  //FController
  // .DefineTipoPesquisa(DsListagem, FStatus, EditPesquisa.Text, Lista.Text);
  //PanelCabecalho.Caption := TituloPesquisa;
  Auxiliar.ListaProdutos(DsListagem, Lista.Text, EditPesquisa.Text);
  EditPesquisa.SetFocus;
end;

procedure TFormPesquisaMultiSelecao.GridListagemDblClick(Sender: TObject);
begin
  SelecionaUmRegistro;
end;

procedure TFormPesquisaMultiSelecao.GridListagemTitleClick(Column: TColumn);
begin
  // Ordenação
end;

procedure TFormPesquisaMultiSelecao.MenuAcoesGridClick(Sender: TObject);
begin
  GridListagem.AutoFillColumns := not(GridListagem.AutoFillColumns);
end;

procedure TFormPesquisaMultiSelecao.MenuEscolherSelClick(Sender: TObject);
begin;
  SelecionaUmRegistro;
end;

procedure TFormPesquisaMultiSelecao.MenuSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPesquisaMultiSelecao.SubMenuLimpaListaClick(Sender: TObject);
begin
  LimpaLista;
end;

procedure TFormPesquisaMultiSelecao.SubMenuSelecionaTodosClick(Sender: TObject);
begin
  SelecionaTodosOsRegistros;
end;

procedure TFormPesquisaMultiSelecao.SelecionaUmRegistro;
begin
  if not(DsListagem.DataSet.IsEmpty) then begin
    MemoEscolhidos.Lines.Add(
      DsListagem.DataSet.Fields[0].AsString + ' - '  + DsListagem.DataSet.Fields[1].AsString
    );
    Lista.Add(',' + DsListagem.DataSet.Fields[0].AsString);
  end;
  Auxiliar.ListaProdutos(DsListagem, Lista.Text, EditPesquisa.Text);
end;

procedure TFormPesquisaMultiSelecao.SelecionaTodosOsRegistros;
begin
  if not(DsListagem.DataSet.IsEmpty) then begin
      DsListagem.DataSet.First;
      MemoEscolhidos.Lines.Clear;

      //CriaTelaDeProgresso('Adicionando os itens, aguarde...', 50, 10);
      while not DsListagem.DataSet.EOF do begin
        MemoEscolhidos.Lines.Add(
        DsListagem.DataSet.Fields[0].AsString + ' - ' + DsListagem.DataSet.Fields[1].AsString
        );
        Lista.Add(',' + DsListagem.DataSet.Fields[0].AsString);
        DsListagem.DataSet.Next;
      end;
      Auxiliar.ListaProdutos(DsListagem, Lista.Text, EditPesquisa.Text);
    end;
end;

procedure TFormPesquisaMultiSelecao.LimpaLista;
begin
  MemoEscolhidos.Lines.Clear;
  Lista.Clear;
  Lista.Add('-1');
  Auxiliar.ListaProdutos(DsListagem, Lista.Text, EditPesquisa.Text);
end;

function TFormPesquisaMultiSelecao.RetornaListaAoForm: String;
var
  ListTemp, ListaFim: String;
  i: Integer;
begin
  Result := '';
  ListTemp := EmptyStr;

  for i := 0 to Lista.Count - 1 do begin
    ListTemp := ListTemp + Lista[i];
  end;

  ListTemp := StringReplace(ListTemp, '-1', '', [rfIgnoreCase]);
  ListaFim := StringReplace(ListTemp, ',', '', [rfIgnoreCase]);

  if(Trim(ListaFim) = EmptyStr) then
    Result := '0'
  else Result := ListaFim;
end;

procedure TFormPesquisaMultiSelecao.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPesquisaMultiSelecao.EditPesquisaChange(Sender: TObject);
begin
  Auxiliar.ListaProdutos(DsListagem, Lista.Text, EditPesquisa.Text);
end;

procedure TFormPesquisaMultiSelecao.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(Auxiliar) then
    FreeAndNil(Auxiliar);
end;

end.

