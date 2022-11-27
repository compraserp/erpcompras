program Compras_ERP;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, pckUserControlRuntime, lazcontrols,
  zcomponent, view.principal,
  view.entidade.cadComprador,
  view.entidade.analise,
  view.login,
  model.conexao,
  types.actions,
  classe.cad.compradores,
  classe.usuarios.login,
  view.cad.itens,
  classe.cad.produto,
  classe.funcoesAuxiliares,
  view.cad.medias.produto,
  classe.cad.medias,
  view.rel.produtosemsaida,
  view.rel.produtosemcompra,
  view.resumo.produtos,
  view.pesquisa.multiselecao,
  classe.resumo.produtos,
  classe.analise,
  classe.pesquisa,
  view.pedido.entregar,
  classe.pedido.entrega,
  view.sobre,
  view.rel.pedido;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);

  Application.Run;
end.

