unit view.cad.laudos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms,
  Controls, Graphics, Dialogs,
  ExtCtrls, ComCtrls, Buttons,
  DBGrids, EditBtn, StdCtrls,
  ZDataset;

type

  { TFormCadLaudos }

  TFormCadLaudos = class(TForm)
    ButtonAlterar: TSpeedButton;
    ButtonAPagar: TSpeedButton;
    ButtonCancelar: TSpeedButton;
    ButtonNovo: TSpeedButton;
    ButtonSair: TSpeedButton;
    ButtonSalvar: TSpeedButton;
    DsListagem: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    EditCod: TLabeledEdit;
    EditTitulo: TLabeledEdit;
    EditCliente: TLabeledEdit;
    EditCPFCNPJ: TLabeledEdit;
    EditAssEscopo: TLabeledEdit;
    EditAssForaEscopo: TLabeledEdit;
    MemoRetornoPerito: TMemo;
    PagePrincipal: TPageControl;
    Panel2: TPanel;
    Panel3: TPanel;
    TabListagem: TTabSheet;
    TabAlteracoes: TTabSheet;
    Query: TZQuery;
    procedure ButtonAlterarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonSairClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     procedure ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
     procedure PassaDadosAosCampos;

  public

  end;

var
  FormCadLaudos: TFormCadLaudos;

implementation

{$R *.lfm}

{ TFormCadLaudos }

procedure TFormCadLaudos.ButtonSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCadLaudos.ButtonSalvarClick(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
end;

procedure TFormCadLaudos.ButtonNovoClick(Sender: TObject);
begin
  ControlaPage(TabAlteracoes, TabListagem);
end;

procedure TFormCadLaudos.ButtonAlterarClick(Sender: TObject);
begin
  ControlaPage(TabAlteracoes, TabListagem);
  PassaDadosAosCampos;
end;

procedure TFormCadLaudos.ButtonCancelarClick(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
end;

procedure TFormCadLaudos.FormShow(Sender: TObject);
begin
  ControlaPage(TabListagem, TabAlteracoes);
end;

procedure TFormCadLaudos.ControlaPage(TabVisivel, TabInvisivel: TTabSheet);
begin
  TabVisivel.TabVisible := True;
  TabInvisivel.TabVisible := False;
end;

procedure TFormCadLaudos.PassaDadosAosCampos;
begin
  EditCod.Text := DsListagem.DataSet.FieldByName('codauditoria').AsString;
  EditTitulo.Text  := DsListagem.DataSet.FieldByName('titulo').AsString;
  EditCliente.Text := DsListagem.DataSet.FieldByName('cliente').AsString;
  EditCPFCNPJ.Text := DsListagem.DataSet.FieldByName('cpfcnpj').AsString;
  EditAssEscopo.Text := DsListagem.DataSet.FieldByName('assuntoescopo').AsString;
  EditAssForaEscopo.Text := DsListagem.DataSet.FieldByName('assuntoforadoescopo').AsString;

  MemoRetornoPerito.Lines.Clear;
  MemoRetornoPerito.Lines.Add(DsListagem.DataSet.FieldByName('feedbackperito').AsString);

  if(EditTitulo.Enabled) then
    EditTitulo.SetFocus;
end;

end.

