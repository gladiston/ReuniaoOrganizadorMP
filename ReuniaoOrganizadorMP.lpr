program ReuniaoOrganizadorMP;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, fprincipal;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Organizador de reunião';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfmPrincipal, fmPrincipal);
  Application.Run;
end.

