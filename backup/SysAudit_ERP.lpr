program SysAudit_ERP;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, zcomponent, view.principal,
  view.cad.laudos,
  view.cad.auditoria,
  model.conexao, classe.cad.auditoria,
  types.actions, view.rel.compCadAuditoria,
  view.cad.acoes, classe.cad.acoes
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormCadAcoes, FormCadAcoes);
  Application.Run;
end.

