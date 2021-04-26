program ReuniaoOrganizadorMP;

{$mode objfpc}{$H+}

uses
{$IFDEF DELPHI16_UP}
Vcl.Forms,
WinApi.Windows,
{$ELSE}
Forms, Windows,
LCLIntf, LCLType, LMessages,
{$IFDEF UNIX}{$IFDEF UseCThreads}
cthreads,
{$ENDIF}{$ENDIF}
Interfaces, // this includes the LCL widgetset
{$ENDIF }
uCEFApplication,
fprincipal;


{$R *.res}
begin
  CreateGlobalCEFApp;

  if GlobalCEFApp.StartMainProcess then
    begin
      RequireDerivedFormResource:=True;  // ? para que serve
      Application.Title:='Organizador de reunião';
      Application.Scaled:=True;       // ? para que serve
      Application.Initialize;
      Application.CreateForm(TfmPrincipal, fmPrincipal);
      Application.Run;
    end;

  DestroyGlobalCEFApp;
end.
