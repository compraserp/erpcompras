unit view.principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, Menus, StdCtrls,
  TDIClass, view.entidade.cadComprador,
  view.cad.itens,
  view.sobre,
  view.pedido.entregar,
  view.entidade.analise,
  model.conexao, view.login,
  view.rel.produtosemsaida,
  view.rel.produtosemcompra,
  view.resumo.produtos;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    ButtonCadAuditoria: TSpeedButton;
    ButtonCadComprador: TSpeedButton;
    ButtonCadProduto: TSpeedButton;
    ButtonResumoProdutos: TSpeedButton;
    ButtonTrocaUsuario: TSpeedButton;
    ControllRodape: TControlBar;
    ImgPrincipal: TImage;
    LablHoraAtual: TLabel;
    LabelUserLog: TLabel;
    MenuCadastros: TMenuItem;
    MenuAnalise: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    SubMenuSobreSistem: TMenuItem;
    MenuSobre: TMenuItem;
    SubMenuEntregarPedido: TMenuItem;
    MenuPedidos: TMenuItem;
    SubMenuTrocaUsuario: TMenuItem;
    SubMenuResumoProd: TMenuItem;
    SubMenuProdSemCompras: TMenuItem;
    N1: TMenuItem;
    SubMenuProdSemSaidas: TMenuItem;
    SubMenuProdutos: TMenuItem;
    MenuRelatorios: TMenuItem;
    SubMenuSair: TMenuItem;
    SubMenuGerarAnalise: TMenuItem;
    MenuItem3: TMenuItem;
    SubMenuCadProdutos: TMenuItem;
    SubMenuCompradores: TMenuItem;
    PanelImg: TPanel;
    PanelTopo: TPanel;
    ButtonSair: TSpeedButton;
    MenuPrincipal: TMainMenu;
    TDIPrincipal: TTDINoteBook;
    TimerHora: TTimer;
    procedure ButtonCadAuditoriaClick(Sender: TObject);
    procedure ButtonCadCompradorClick(Sender: TObject);
    procedure ButtonCadProdutoClick(Sender: TObject);
    procedure ButtonResumoProdutosClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonTrocaUsuarioClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SubMenuCadProdutosClick(Sender: TObject);
    procedure SubMenuCompradoresClick(Sender: TObject);
    procedure SubMenuEntregarPedidoClick(Sender: TObject);
    procedure SubMenuGerarAnaliseClick(Sender: TObject);
    procedure SubMenuLogOffClick(Sender: TObject);
    procedure SubMenuProdSemComprasClick(Sender: TObject);
    procedure SubMenuProdSemSaidasClick(Sender: TObject);
    procedure SubMenuResumoProdClick(Sender: TObject);
    procedure SubMenuSairClick(Sender: TObject);
    procedure SubMenuSobreSistemClick(Sender: TObject);
    procedure SubMenuTrocaUsuarioClick(Sender: TObject);
    procedure TimerHoraTimer(Sender: TObject);

  private
     FConexao: TModelConexao;
     FFuncUsuario: Integer;
     procedure RecebeDadosUsuario;
     procedure Login;

  public
     property F_Conexao: TModelConexao read FConexao       write FConexao;
     property F_FuncUsuario: Integer   read FFuncUsuario   write FFuncUsuario;

  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.lfm}

{ TFormPrincipal }

procedure TFormPrincipal.ButtonCadAuditoriaClick(Sender: TObject);
begin
  SubMenuGerarAnalise.Click;
end;

procedure TFormPrincipal.ButtonCadCompradorClick(Sender: TObject);
begin
  SubMenuCompradores.Click;
end;

procedure TFormPrincipal.ButtonCadProdutoClick(Sender: TObject);
begin
  SubMenuCadProdutos.Click;
end;

procedure TFormPrincipal.ButtonResumoProdutosClick(Sender: TObject);
begin
  SubMenuResumoProd.Click;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  Login;
  TDIPrincipal.Align := alClient;
end;

procedure TFormPrincipal.SubMenuCadProdutosClick(Sender: TObject);
var
  i: Integer;
begin
  i := TDIPrincipal.FindFormInPages(FormCadProdutos);
  if( i < 0) then
     FormCadProdutos := TFormCadProdutos.Create(Self);
  TDIPrincipal.ShowFormInPage(FormCadProdutos);
end;

procedure TFormPrincipal.SubMenuCompradoresClick(Sender: TObject);
begin
  FormCadComprador := TFormCadComprador.Create(Self);
  try
    FormCadComprador.ShowModal;
  finally
    FormCadComprador.Release;
  end;
end;

procedure TFormPrincipal.SubMenuEntregarPedidoClick(Sender: TObject);
begin
  FormEntregarPedidos := TFormEntregarPedidos.Create(Self);
  try
    FormEntregarPedidos.ShowModal;
  finally
    FormEntregarPedidos.Release;
  end;
end;

procedure TFormPrincipal.SubMenuGerarAnaliseClick(Sender: TObject);
var
  i: Integer;
begin
  i := TDIPrincipal.FindFormInPages(FormAnaliseCompras);
  if( i < 0) then
     FormAnaliseCompras := TFormAnaliseCompras.Create(Self);
  TDIPrincipal.ShowFormInPage(FormAnaliseCompras);
end;

procedure TFormPrincipal.SubMenuLogOffClick(Sender: TObject);
begin

end;

procedure TFormPrincipal.SubMenuProdSemComprasClick(Sender: TObject);
begin
  FormRelProdSemCompra := TFormRelProdSemCompra.Create(Self);
  try
    FormRelProdSemCompra.F_Conexao := FConexao.FDriverConexao;
    FormRelProdSemCompra.RelatorioPrincipal.Preview;
  finally
    FormRelProdSemCompra.Release;
  end;
end;

procedure TFormPrincipal.SubMenuProdSemSaidasClick(Sender: TObject);
begin
  FormRelProdSemSaidas := TFormRelProdSemSaidas.Create(Self);
  try
    FormRelProdSemSaidas.F_Conexao := FConexao.FDriverConexao;
    FormRelProdSemSaidas.RelatorioPrincipal.Preview;
  finally
    FormRelProdSemSaidas.Release;
  end;
end;

procedure TFormPrincipal.SubMenuResumoProdClick(Sender: TObject);
var
  i: Integer;
begin
  i := TDIPrincipal.FindFormInPages(FormResumoProdutos);
  if( i < 0) then
     FormResumoProdutos := TFormResumoProdutos.Create(Self);
  TDIPrincipal.ShowFormInPage(FormResumoProdutos);
end;

procedure TFormPrincipal.SubMenuSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPrincipal.SubMenuSobreSistemClick(Sender: TObject);
begin
  FormSobre := TFormSobre.Create(Self);
  try
    FormSobre.ShowModal;
  finally
    FormSobre.Release;
  end;
end;

procedure TFormPrincipal.SubMenuTrocaUsuarioClick(Sender: TObject);
begin
  Login;
end;

procedure TFormPrincipal.TimerHoraTimer(Sender: TObject);
begin
  LablHoraAtual.Caption := FormatDateTime('dd/mm/yy - hh:nn:ss', Now);
end;

procedure TFormPrincipal.RecebeDadosUsuario;
begin
  FFuncUsuario := FormLogin.F_FuncUsuario;
  LabelUserLog.Caption := 'Usuário logado: ' +
   IntToStr(FormLogin.F_CodUsuario) + ' -  ' + FormLogin.F_NomeUsuario;
end;

procedure TFormPrincipal.Login;
begin
  FormLogin := TFormLogin.Create(Self);
  try
    FormLogin.ShowModal;
  finally
    RecebeDadosUsuario;
    FormLogin.Release;
  end;
end;

procedure TFormPrincipal.BloqueiaAcaoUsuarioMenu;
var
  UsuarioAdm: Boolean;
begin
  UsuarioAdm := (FFuncUsuario <> 2);
  MenuPrincipal.Items.Enabled := False;
end;

procedure TFormPrincipal.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPrincipal.ButtonTrocaUsuarioClick(Sender: TObject);
begin
  SubMenuTrocaUsuario.Click;
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if(MessageDlg('Deseja realmente sair?', mtInformation, [mbYes, mbNo], 0)=MrYes) then begin
    if(Assigned(FConexao)) then begin
       FreeAndNil(FConexao);
       Application.Terminate;
    end;
  end
  else Abort;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FConexao := TModelConexao.Create;
end;

end.

