unit view.pedido.entregar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, BufDataset, Forms,
  Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, DBGrids, DBCtrls, Menus,
  classe.pedido.entrega;

type

  { TFormEntregarPedidos }

  TFormEntregarPedidos = class(TForm)
    BufEntregaPedidos: TBufDataset;
    BufEntregaPedidoscodpedido: TLongintField;
    BufEntregaPedidosdataPedido: TDateField;
    BufEntregaPedidosnomeFornecedor: TStringField;
    BufEntregaPedidosstatus: TLongintField;
    BufEntregaPedidostipoPedido: TStringField;
    ButtonEntregarMarcados: TSpeedButton;
    ButtonSair: TSpeedButton;
    DsBufEntPedidos: TDataSource;
    DsEntregaPedidos: TDataSource;
    GridEntregaPedidos: TDBGrid;
    MenuDesmarcarTodos: TMenuItem;
    MenuItem4: TMenuItem;
    MenuMarcarTodos: TMenuItem;
    PanelRodape: TPanel;
    Paneltopo: TPanel;
    PopupMenuPedidos: TPopupMenu;
    procedure ButtonEntregarMarcadosClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuDesmarcarTodosClick(Sender: TObject);
    procedure MenuMarcarTodosClick(Sender: TObject);

  private
    Auxiliar: TPedidoEntrega;
    procedure AcaoMarcarDesmarcarTodos(ValCheck: Integer);
    procedure PassaPedidosBuf;
    procedure DeletaBuf;
    procedure RealizaEntregaPedidos;

  public

  end;

var
  FormEntregarPedidos: TFormEntregarPedidos;

implementation

{$R *.lfm}

uses
  view.principal;

{ TFormEntregarPedidos }

procedure TFormEntregarPedidos.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormEntregarPedidos.ButtonEntregarMarcadosClick(Sender: TObject);
begin
  if(BufEntregaPedidos.IsEmpty) then Abort;
  if(MessageDlg('Confirma a entrega dos pedidos?! Esta operação não pode ser desfeita.',
        mtWarning, [mbYes, mbNo], 0) = mrYes) then begin
    RealizaEntregaPedidos;
    DeletaBuf;
    PassaPedidosBuf;
  end
  else Abort;
end;

procedure TFormEntregarPedidos.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(Auxiliar) then
    FreeAndNil(Auxiliar);
end;

procedure TFormEntregarPedidos.FormCreate(Sender: TObject);
begin
  Auxiliar := TPedidoEntrega.Create(FormPrincipal.F_Conexao.FDriverConexao);
  BufEntregaPedidos.CreateDataset;
end;

procedure TFormEntregarPedidos.FormShow(Sender: TObject);
begin
 PassaPedidosBuf;
end;

procedure TFormEntregarPedidos.MenuDesmarcarTodosClick(Sender: TObject);
begin
  AcaoMarcarDesmarcarTodos(0);
end;

procedure TFormEntregarPedidos.MenuMarcarTodosClick(Sender: TObject);
begin
  AcaoMarcarDesmarcarTodos(1);
end;

procedure TFormEntregarPedidos.PassaPedidosBuf;
begin
  Auxiliar.ListaPedidosPendentes(DsEntregaPedidos);
  BufEntregaPedidos.Insert;
  DsEntregaPedidos.DataSet.First;
  while not DsEntregaPedidos.DataSet.EOF do begin
    BufEntregaPedidosstatus.Value := 0;
    BufEntregaPedidoscodpedido.Value := DsEntregaPedidos.DataSet.FieldByName('codpedido').AsInteger;
    BufEntregaPedidosnomeFornecedor.Value := DsEntregaPedidos.DataSet.FieldByName('nomeFornecedor').AsString;
    BufEntregaPedidosdataPedido.Value  := DsEntregaPedidos.DataSet.FieldByName('dataPedido').AsDateTime;
    BufEntregaPedidostipoPedido.Value  := DsEntregaPedidos.DataSet.FieldByName('tpPedido').AsString;
    BufEntregaPedidos.Append;
    DsEntregaPedidos.DataSet.Next;
  end;
  BufEntregaPedidos.First;
end;

procedure TFormEntregarPedidos.DeletaBuf;
begin
  BufEntregaPedidos.First;
  while not BufEntregaPedidos.EOF do begin
    BufEntregaPedidos.Delete;
  end;
end;

procedure TFormEntregarPedidos.RealizaEntregaPedidos(CodPedido: Integer);
begin
   Auxiliar.RealizaEntregaPedidos(BufEntregaPedidos);
end;

procedure TFormEntregarPedidos.AcaoMarcarDesmarcarTodos(ValCheck: Integer);
begin
  BufEntregaPedidos.First;
  while not BufEntregaPedidos.EOF do begin
    BufEntregaPedidos.Edit;
     BufEntregaPedidosstatus.Value := ValCheck;
    BufEntregaPedidos.Next;
  end;
  BufEntregaPedidos.First;
end;

end.

