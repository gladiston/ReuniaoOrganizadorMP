unit fprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, Menus,
  ExtCtrls, ComCtrls, Buttons, StdCtrls, Types;


type

  { TfmPrincipal }

  TfmPrincipal = class(TForm)
    Abriroexplorernalocalizao1: TMenuItem;
    AcaoAbrir1: TMenuItem;
    AcaoAdicionar1: TMenuItem;
    AcaoMoverAbaixo1: TMenuItem;
    AcaoSalvar1: TMenuItem;
    Acao_Abrir: TAction;
    Acao_Adicionar: TAction;
    Acao_Clipboard: TAction;
    Acao_Explorer: TAction;
    Acao_Fechar: TAction;
    Acao_Inicio: TAction;
    Acao_Inserir_legenda: TAction;
    Acao_Media_Anterior: TAction;
    Acao_Media_Prox: TAction;
    Acao_Minimizar: TAction;
    Acao_Mover_Abaixo: TAction;
    Acao_Mover_Acima: TAction;
    Acao_Remover: TAction;
    Acao_Salvar: TAction;
    Acao_FonteMaior: TAction;
    Acao_FonteMenor: TAction;
    ActionList1: TActionList;
    Alterarlegendadaimagem1: TMenuItem;
    BtnAcao_Inicio: TSpeedButton;
    Copiaralocalizaoparaareadeclipboard1: TMenuItem;
    Figura: TImage;
    ImageList1: TImageList;
    Lista: TListView;
    Menu_Arquivos: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Paginas: TPageControl;
    Painel_Retratil: TPanel;
    Panel1: TPanel;
    Removeroelementoselecionado1: TMenuItem;
    BtnFileName_PDF: TSpeedButton;
    BtnFileName_Video: TSpeedButton;
    StatusBar1: TStatusBar;
    TabFigura: TTabSheet;
    TabPDF: TTabSheet;
    TabVideo: TTabSheet;
    TrayIcon1: TTrayIcon;
    procedure Acao_AbrirExecute(Sender: TObject);
    procedure Acao_AdicionarExecute(Sender: TObject);
    procedure Acao_ClipboardExecute(Sender: TObject);
    procedure Acao_ExplorerExecute(Sender: TObject);
    procedure Acao_FecharExecute(Sender: TObject);
    procedure Acao_FonteMenorExecute(Sender: TObject);
    procedure Acao_InicioExecute(Sender: TObject);
    procedure Acao_Inserir_legendaExecute(Sender: TObject);
    procedure Acao_Media_AnteriorExecute(Sender: TObject);
    procedure Acao_Media_ProxExecute(Sender: TObject);
    procedure Acao_MinimizarExecute(Sender: TObject);
    procedure Acao_Mover_AbaixoExecute(Sender: TObject);
    procedure Acao_Mover_AcimaExecute(Sender: TObject);
    procedure Acao_RemoverExecute(Sender: TObject);
    procedure Acao_SalvarExecute(Sender: TObject);
    procedure Acao_FonteMaiorExecute(Sender: TObject);
    procedure BtnOpenMedia(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormShow(Sender: TObject);
    procedure ListaCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListaDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListaDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListaSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FConfigFile: String;
    FIsPainel_Retratil_Opened: Boolean;
    FJanela_MaxHeight: Integer;
    FJanela_MaxWidth: Integer;
    FLastMediaFile: String;
    FListaFileName: String;
    FModificado: Boolean;
    FLegendas:TStringList;
    FStatusMsg: String;
    FLoading:Boolean;
    procedure SetConfigFile(AValue: String);
    procedure SetIsPainel_Retratil_Opened(AValue: Boolean);
    procedure SetListaFileName(AValue: String);
    procedure SetStatusMsg(AValue: String);
  public
  published
    property ListaFileName:String read FListaFileName write SetListaFileName;
    property ConfigFile:String read FConfigFile write SetConfigFile;
    property Modificado:Boolean read FModificado;
    property LastMediaFile:String read FLastMediaFile;
    property Legendas:TStringList read FLegendas;
    property IsPainel_Retratil_Opened:Boolean read FIsPainel_Retratil_Opened write SetIsPainel_Retratil_Opened;
    property StatusMsg:String read FStatusMsg write SetStatusMsg;
    property Janela_MaxWidth:Integer read FJanela_MaxWidth;
    property Janela_MaxHeight:Integer read FJanela_MaxHeight;
    procedure MediaHide;
    procedure TryResize;
    procedure BlackTheme;
    procedure Painel_Retratil_AutoWidth(AValue:Boolean);
    procedure ReadConfig;
    procedure WriteConfig;
    procedure LoadMediaFile(AArquivo:String='');
    function Lista_ArqIncluir(AArquivo:String):Boolean;
    function ListaSelectFile(AArquivo:String; ALoadMedia:Boolean=false):Integer;
    function IsFileAcceptable(AArquivo:String):Boolean;
    function PlayAsImage(AArquivo:String):String;
    function PlayAsHTML(AArquivo:String=''):String;
    function PlayAsPDF(AArquivo:String=''):String;
    function StopVideo: String;
    function IsImage(AArquivo:String):Boolean;
    function IsVideo(AArquivo:String):Boolean;
    function IsPDF(AArquivo:String):Boolean;
    procedure SalvarLista(ANomeArquivo:String='');
  end;

const
  _APP_EXT='.reuniao';
  _APP_EXT_VIDEO='|.avi|.mp3|.mp4|';
  _APP_EXT_FIG='|.bmp|.png|.jpeg|.jpg|';
  _APP_EXT_PDF='|.pdf|';
  _Min_Width=320;
  _Min_Height=240;
  _Recolher='Recolher';
  _Expandir='Expandir';

var
  fmPrincipal: TfmPrincipal;

  {function MsgDlg(
    AMsg: String;
    ATitle: String;
    ADlgType: TMsgDlgType;
    AButtons: TMsgDlgButtons;
    ACod_Ajuda: Integer=0) : TModalResult;      }

implementation
uses
  inifiles,
  uriparser,
  ClipBrd,
  Process,
  LclIntf,
  StrUtils;


{$R *.lfm}

{function MsgDlg(
  AMsg: String;
  ATitle: String;
  ADlgType: TMsgDlgType;
  AButtons: TMsgDlgButtons;
  ACod_Ajuda: Integer=0) : TModalResult;
var i   : Integer;
begin
  With CreateMessageDialog(AMsg, ADlgType, AButtons) Do
     Try
       Caption := ATitle;
       HelpContext := ACod_Ajuda;

       for i:= 0 To ComponentCount - 1 Do
         If Components[i] Is TButton
         Then
           Case (Components[i] As TButton).ModalResult Of
             mrNone     : (Components[i] As TButton).Caption := '&Ajuda';
             mrAbort    : (Components[i] As TButton).Caption := 'Abortar';
             mrAll      : (Components[i] As TButton).Caption := '&Todos';
             mrCancel   : (Components[i] As TButton).Caption := '&Cancelar';
             mrIgnore   : (Components[i] As TButton).Caption := '&Ignorar';
             mrNo       : (Components[i] As TButton).Caption := '&Não';
             mrNoToAll  : (Components[i] As TButton).Caption := 'Não para todos';
             mrOk       : (Components[i] As TButton).Caption := '&Ok';
             mrRetry    : (Components[i] As TButton).Caption := '&Repetir';
             mrYes      : (Components[i] As TButton).Caption := '&Sim';
             mrYesToAll : (Components[i] As TButton).Caption := 'Sim para todos';
           End;

       RESULT := ShowModal;
     Finally
       Free;
     End;
end;
}

{ TfmPrincipal }

procedure TfmPrincipal.Painel_Retratil_AutoWidth(AValue:Boolean);
const
  _offset=22;
var
  i:Integer;
  w:Integer;
  sCaption:String;
begin
  if AValue then begin
    // todo: A largura do painel deve ser automatica em conformidade com
    //   o tamanho dos nomes dos arquivos e não tem um valor fixo
    // o calculo abaixo está errado, estou compensando acrescentando mais
    // caracteres ao sCaption, mas preciso descobrir uma maneira melhor
    try
      for i:=0 to Pred(Lista.Items.Count) do begin
        sCaption:=Lista.Items[i].Caption;
        w := Lista.Canvas.TextWidth('__'+sCaption+'__')+_offset;
        if w>Painel_Retratil.Width then begin
          //Lista.ClientWidth:=w;
          Painel_Retratil.Width:=w;
        end;
      end;
    finally

    end;

  end
  else
  begin
    Painel_Retratil.Width:=_offset; // quando encolhido
  end;
end;

procedure TfmPrincipal.FormCreate(Sender: TObject);
var
  sParamFileName:String;
  i:Integer;
begin
  Caption:=Application.Title;
  FModificado:=false;
  FListaFileName:='';
  FLastMediaFile:='';
  FConfigFile:=ChangeFileExt(ParamStr(0),'.ini');
  FLegendas:=TStringList.Create;
  FJanela_MaxHeight:=480;
  FJanela_MaxWidth:=640;
  sParamFileName:=ParamStr(1);
  ReadConfig;
  //for i := 0 to Pred(Paginas.PageCount) do
  //begin
  //  Paginas.Pages[i].TabVisible:=false;
  //end;
  Paginas.ShowTabs:=false;
  Paginas.ActivePageIndex:=0;
  if FileExists(sParamFileName) then
    ListaFileName:=sParamFileName;

  BtnAcao_Inicio.ShowHint:=true;
  Lista.Columns[0].Width := 255;
  Lista.Columns[1].Width := 0;
  Lista.Columns[1].Visible:=false;
  Lista.DragMode := dmAutomatic;
  Lista.Visible:=false;
  IsPainel_Retratil_Opened:=true;
  Constraints.MinHeight:=_Min_Height;
  Constraints.MinWidth:=_Min_Width;
  BtnFileName_Video.Visible:=false;
  BtnFileName_PDF.Visible:=false;
  Painel_Retratil.Width:=Lista.Canvas.TextWidth('____'+_Recolher+'____')+22;
  //BlackTheme;
end;



procedure TfmPrincipal.FormDestroy(Sender: TObject);
begin
  try
    if Assigned(Figura.Picture) then
      Figura.Picture:=nil;
  finally

  end;
end;

procedure TfmPrincipal.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var FileName : String;
begin
  for FileName in FileNames do
  begin
    if IsFileAcceptable(FileName) then
    begin
      Lista_ArqIncluir(FileName);
      FModificado:=true;
      StatusMsg:='Você pode usar Ctrl+Seta ou arrastar/soltar para mudar a sequencia deles.';
    end
    else
    begin
      StatusMsg:=FileName+': não é um formato aceitável.';
    end;
  end;
  if Lista.Items.Count>2 then
  begin
    StatusMsg:='Lista foi modificada, use Ctrl+S para salvar a lista atual.';
  end;
end;

procedure TfmPrincipal.FormShow(Sender: TObject);
begin
  Painel_Retratil_AutoWidth(true);
end;

procedure TfmPrincipal.ListaCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if odd(Item.Index) then begin
    Sender.Canvas.Font.Color := clPurple;
    //Sender.Canvas.Brush.Color := clPurple;
  end
  else begin
    Sender.Canvas.Font.Color := clOlive;
    //Sender.Canvas.Brush.Color := clOlive;
  end;
  DefaultDraw:=True;
end;

procedure TfmPrincipal.ListaDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DragItem, DropItem, CurrentItem, NextItem: TListItem;
begin
  if Sender = Source then
    with TListView(Sender) do
    begin
      DropItem    := GetItemAt(X, Y);
      CurrentItem := Selected;
      while CurrentItem <> nil do
      begin
        NextItem := GetNextItem(CurrentItem, SdAll, [lisSelected]);     // lisSelected ou IsSelected(Delphi)
        if DropItem = nil then DragItem := Items.Add
        else
          DragItem := Items.Insert(DropItem.Index);
        DragItem.Assign(CurrentItem);
        CurrentItem.Free;
        CurrentItem := NextItem;
      end;
    end;
end;

procedure TfmPrincipal.ListaDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender = Lista);
  if not Accept then begin
    // conferindo se é um arquivo do explorer
   StatusMsg:='Aceitando '+Sender.ClassName+': '+IfThen(Accept,'Sim','Não');
  end;
end;

procedure TfmPrincipal.ListaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then   {check if left mouse button was pressed}
     Lista.BeginDrag(true);  {starting the drag operation}
end;

procedure TfmPrincipal.ListaSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  sArquivo:String;
begin
  if (not FLoading) and (Selected) then
  begin
    sArquivo:=Item.SubItems[0];
    try
      if FileExists(sArquivo) then
      begin
        LoadMediaFile(sArquivo);
      end;

    finally

    end;

  end;
end;

procedure TfmPrincipal.Acao_InicioExecute(Sender: TObject);
begin
  IsPainel_Retratil_Opened:=(not IsPainel_Retratil_Opened);
end;

procedure TfmPrincipal.Acao_Inserir_legendaExecute(Sender: TObject);
var
  sArquivo:String;
  sLegenda:String;
begin
  if Lista.ItemIndex>=0 then
  begin
    sArquivo:=lista.Items[Lista.ItemIndex].Caption;
    sLegenda:=FLegendas.Values[sArquivo];
    if InputQuery('Qual a legenda para a imagem "'+sArquivo+'"?', 'Legenda:', sLegenda) then
    begin
      sLegenda:=Trim(sLegenda);
      if sLegenda<>'' then
      begin
        if not SameText(FLegendas.Values[sArquivo], sLegenda) then
        begin
          FLegendas.Values[sArquivo]:=sLegenda;
          Fmodificado:=true;
        end;
      end;
    end;
  end;

end;

procedure TfmPrincipal.Acao_Media_AnteriorExecute(Sender: TObject);
begin
  if Lista.ItemIndex>0 then
    Lista.ItemIndex:=Lista.ItemIndex-1;
end;

procedure TfmPrincipal.Acao_Media_ProxExecute(Sender: TObject);
begin
  if Lista.ItemIndex<Pred(Lista.Items.Count) then
    Lista.ItemIndex:=Lista.ItemIndex+1;
end;

procedure TfmPrincipal.Acao_MinimizarExecute(Sender: TObject);
begin
  if self.windowstate = wsNormal then
    self.windowstate:=wsMinimized
  else
    self.windowstate:=wsNormal;
end;

procedure TfmPrincipal.Acao_Mover_AbaixoExecute(Sender: TObject);
var
  i:Integer;
  ItemPosterior: String;
  ItemAtual: String;
begin
  // mover para baixo
  i:=Lista.ItemIndex;
  if i<Pred(Lista.Items.Count) then
  begin
    try
      ItemPosterior:=Lista.Items[i+1].SubItems[0];
      ItemAtual:=Lista.Items[i].SubItems[0];
      Lista.Items[i+1].Caption:=ExtractFileName(ItemAtual);
      Lista.Items[i+1].SubItems[0]:=ItemAtual;
      Lista.Items[i].Caption:=ExtractFileName(ItemPosterior);
      Lista.Items[i].SubItems[0]:=ItemPosterior;
      Lista.ItemIndex:=i+1;
      FModificado:=true;
    finally

    end;
  end;
end;

procedure TfmPrincipal.Acao_Mover_AcimaExecute(Sender: TObject);
var
  i:Integer;
  ItemAnterior: String;
  ItemAtual: String;
begin
  // mover para cima
  i:=Lista.ItemIndex;
  if i>0 then
  begin
    try
      ItemAnterior:=Lista.Items[i-1].SubItems[0];
      ItemAtual:=Lista.Items[i].SubItems[0];
      Lista.Items[i-1].Caption:=ExtractFileName(ItemAtual);
      Lista.Items[i-1].SubItems[0]:=ItemAtual;
      Lista.Items[i].Caption:=ExtractFileName(ItemAnterior);
      Lista.Items[i].SubItems[0]:=ItemAnterior;
      Lista.ItemIndex:=i-1;
      FModificado:=true;
      StatusMsg:='Dica: Você pode usar a tecla DEL para remover arquivos da lista.';
    finally

    end;
  end;
end;

procedure TfmPrincipal.Acao_RemoverExecute(Sender: TObject);
var
  i:Integer;
  ItemAtual: TListItem;
begin
  i:=Lista.ItemIndex;
  if i>=0 then
  begin
    ItemAtual:=Lista.Items[i];
    if SameText(TabFigura.Caption, ItemAtual.Caption) then
    begin
      figura.Picture:=nil;
    end;

    Lista.Items.Delete(Lista.ItemIndex);
    FModificado:=true;
    if i<=Pred(Lista.Items.Count) then
    begin
      Lista.ItemIndex:=i;
    end
    else
    begin
      if i-1<=Pred(Lista.Items.Count) then
        Lista.ItemIndex:=i-1;
    end;

  end;

end;

procedure TfmPrincipal.Acao_SalvarExecute(Sender: TObject);
begin
    SalvarLista;
end;

procedure TfmPrincipal.Acao_FonteMaiorExecute(Sender: TObject);
begin
  if Font.Size<20 then
    Font.Size:=Font.Size+1;
end;

procedure TfmPrincipal.BtnOpenMedia(Sender: TObject);
var
  sArquivo:String;
  sUrlPathMedia:String;
begin
  sArquivo:=TSpeedButton(Sender).Hint;
  if FileExists(sArquivo) then begin
    sUrlPathMedia := UTF8Decode(UriParser.FilenameToURI(sArquivo));
    StatusMsg:='Abrindo '+sUrlPathMedia;
    OpenUrl(sUrlPathMedia);
  end;
end;

procedure TfmPrincipal.Acao_ClipboardExecute(Sender: TObject);
var
  sArquivo:String;
  sys_last_error:String;
  sMsg:String;
begin
  sys_last_error:='';
  if Lista.ItemIndex<0 then
    sys_last_error:='Nenhum arquivo selecionado!';

  if sys_last_error='' then
  begin
    sArquivo:= lista.ItemS[Lista.ItemIndex].SubItems[0];
    sMsg:='';
    if not FileExists(sArquivo) then
    begin
      sys_last_error:='Arquivo não encontrado: '+sLineBreak+sArquivo;
    end;
  end;

  if (sys_last_error='') then
  begin
    try
      Clipboard.AsText:=sArquivo;
    except
    on e:exception do sys_last_error:=e.Message;
    end;
  end;


  if (sys_last_error='') and (Acao_Clipboard.Tag=0) then
  begin
    try
      sMsg:=ExtractFileName(sArquivo)+' foi copiado para clipboard, agora dê ctrl+v '+
        'na jenela de seleção de arquivo.';
      StatusMsg:=sMsg;
      //TrayIcon1.BalloonTitle:=ExtractFileName(sArquivo);
      //TrayIcon1.BalloonHint:=sMsg;
      //TrayIcon1.BalloonFlags := bfInfo;
      //TrayIcon1.Visible := true;
      //TrayIcon1.Animate := True;
      //TrayIcon1.ShowBalloonHint;
      Acao_Clipboard.Tag:=1;
    finally

    end;
  end
  else
  begin
    StatusMsg:=sys_last_error;
  end;

end;

procedure TfmPrincipal.Acao_AbrirExecute(Sender: TObject);
var
  OpenDialog1:TOpenDialog;
begin
  OpenDialog1:=TOpenDialog.Create(Self);
  try
    OpenDialog1.Filter:='Lista de tópicos|*'+_APP_EXT;
    OpenDialog1.FileName:=FListaFileName;
    if OpenDialog1.Execute() then
    begin
      if FileExists(OpenDialog1.FileName) then
      begin
        ListaFileName:=OpenDialog1.FileName;
      end;
    end;

  finally
  end;
  OpenDialog1.Free;
end;

procedure TfmPrincipal.Acao_AdicionarExecute(Sender: TObject);
var
  sArquivo:String;
  sLista:String;
  OpenDialog1:TOpenDialog;
begin
  OpenDialog1:=TOpenDialog.Create(Self);
  //_APP_EXT_VIDEO='|.avi|.mp3|.mp4|';
  //_APP_EXT_FIG='|.bmp|.png|.jpeg|.jpg|';
  sLista:=StringReplace(_APP_EXT_VIDEO+_APP_EXT_FIG+_APP_EXT_PDF,'|',';*',[rfReplaceAll]);
  if LeftStr(sLista,1)=';' then
    while LeftStr(sLista,1)=';' do sLista:=RightStr(sLista, Length(sLista)-1);
  if RightStr(sLista,1)='*' then
    while RightStr(sLista,1)='*' do sLista:=LeftStr(sLista, Length(sLista)-1);
  if RightStr(sLista,1)=';' then
    while RightStr(sLista,1)=';' do sLista:=LeftStr(sLista, Length(sLista)-1);
  try
    OpenDialog1.Filter:='Arquivos suportados|'+sLista;
    OpenDialog1.FileName:=FListaFileName;
    if OpenDialog1.Execute() then
    begin
      sArquivo:=OpenDialog1.FileName;
      if FileExists(sArquivo) then
      begin
        if IsFileAcceptable(sArquivo) then
        begin
          //Lista.Items.Add(sArquivo);
          Lista_ArqIncluir(sArquivo);
        end;
      end;
    end;

  finally
  end;
  OpenDialog1.Free;
end;

procedure TfmPrincipal.Acao_ExplorerExecute(Sender: TObject);
var
  sArquivo:String;
  sys_last_error:String;
  S:Ansistring;
  bDone:Boolean;
begin
  sys_last_error:='';
  if Lista.ItemIndex<0 then
    sys_last_error:='Selecione um arquivo para executar esta operação.';
  if sys_last_error='' then
  begin
    sArquivo:= lista.Items[Lista.ItemIndex].SubItems[0];
    if not FileExists(sArquivo) then
    begin
      sys_last_error:='Arquivo não encontrado: '+sLineBreak+sArquivo;
    end;
  end;

  if (sys_last_error='') then
  begin
    //ShellExecute(0, nil, 'explorer.exe', pWideChar('/select,'+sArquivo), nil, SW_SHOWNORMAL);  //ShellApi
    // RunCommand('/bin/bash',['-c','alias'],s)  // Process
    bDone:=RunCommand('explorer.exe', ['/select,'+QuotedStr(sArquivo)], S);
    if bDone then
      StatusMsg:=S;
  end;

  if sys_last_error<>'' then
  begin
    StatusMsg:=sys_last_error;
  end;

end;

procedure TfmPrincipal.Acao_FecharExecute(Sender: TObject);
begin
  close;
end;

procedure TfmPrincipal.Acao_FonteMenorExecute(Sender: TObject);
begin
  if Font.Size>8 then
    Font.Size:=Font.Size-1;
end;

procedure TfmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  try
    CanClose:=true;
    if FModificado then
    begin
        if MessageDlg(
          'Deseja salvar antes de sair?',
          'A lista foi alterada',
          mtConfirmation,
          [mbYes, mbNo],
          '') = mrYes then
        begin
          SalvarLista;
        end;
    end;

    WriteConfig;
    ModalResult:=mrClose;
  finally

  end;
end;

procedure TfmPrincipal.SetConfigFile(AValue: String);
var
  i:integer;
  sArqLegendas:String;
  L:TStringList;
begin
  if FileExists(AValue) then
  begin
    FListaFileName := AValue;
    sArqLegendas:=FListaFileName+'.legendas';
    Caption:=Application.Title+'['+ExtractFileName(FListaFileName)+']';
    L:=TStringList.Create;
    try
      if FileExists(sArqLegendas) then
        FLegendas.LoadFromFile(sArqLegendas);

      L.LoadFromFile(FListaFileName);
      for i := 0 to Pred(L.Count) do
      begin
        Lista_ArqIncluir(L[i]);
      end;
      i:=Lista.Columns.Count;
      if i>0 then
      begin
        //Lista.Columns[0].Width:=-1;
        Lista.Columns[0].AutoSize:=true;
        if i>1 then  begin
          Lista.Columns[1].Width:=0;
          Lista.Columns[1].Visible:=false;
        end;

      end;

      if FileExists(FLastMediaFile) then
        ListaSelectFile(FLastMediaFile);
    finally
      L.Free;
    end;
  end;
end;

procedure TfmPrincipal.SetIsPainel_Retratil_Opened(AValue: Boolean);
var
  sArquivo:String;
  i:Integer;
begin
  FIsPainel_Retratil_Opened:=AValue;
  sArquivo:='';
  i:=Lista.ItemIndex;
  if i>=0 then
    sArquivo:=Lista.Items[i].SubItems[0];
  if FIsPainel_Retratil_Opened then
  begin
    Painel_Retratil_AutoWidth(true);
    Acao_Inicio.Caption:=_Recolher;
    Acao_Inicio.Hint:='Clique aqui para recolher o painel de arquivos';
    StatusBar1.Visible:=true;
    if Lista.Items.Count=0 then begin
      Lista.Visible:=false;
      Painel_Retratil.Caption:='Arraste seus arquivos para cá';
    end
    else
    begin
      Lista.Visible:=true;
      Lista.Column[1].Visible:=false;
      Painel_Retratil.Caption:='';
    end;
    LoadMediaFile(sArquivo);
  end
  else
  begin
    Painel_Retratil_AutoWidth(false);

    Painel_Retratil.Caption:='';
    Acao_Inicio.Caption:=_Expandir;
    Acao_Inicio.Hint:='Clique aqui para expandir o painel de arquivos';
    StatusBar1.Visible:=false;
    Lista.Visible:=false;
    LoadMediaFile(sArquivo);
  end;
end;

procedure TfmPrincipal.SetListaFileName(AValue: String);
var
  i:integer;
  sArqLegendas:String;
  L:TStringList;
begin
  if FileExists(AValue) then
  begin
    FListaFileName := AValue;
    sArqLegendas:=FListaFileName+'.legendas';
    Caption:=Application.Title+'['+ExtractFileName(FListaFileName)+']';
    L:=TStringList.Create;
    try
      if FileExists(sArqLegendas) then
        FLegendas.LoadFromFile(sArqLegendas);

      L.LoadFromFile(FListaFileName);
      // limpa a lista atual
      for i := Pred(Lista.Items.Count) downto 0 do
        Lista.Items.Delete(i);
      // acrescenta nova lista
      for i := 0 to Pred(L.Count) do
      begin
        Lista_ArqIncluir(L[i]);
      end;
      i:=Lista.Columns.Count;
      if i>0 then
      begin
        //Lista.Columns[0].Width:=-1;
        Lista.Columns[0].AutoSize:=true;
        if i>1 then
          Lista.Columns[1].Width:=0;
      end;
      //Painel_Retratil_AutoWidth(true);
      if FileExists(FLastMediaFile) then
        ListaSelectFile(FLastMediaFile);
    finally
      L.Free;
    end;
  end;
end;

procedure TfmPrincipal.ReadConfig;
var
  MyIni:TIniFile;
  sListaFileName:String;
begin
  try
    MyIni:=TIniFile.Create(FConfigFile);

    sListaFileName:=MyIni.ReadString('Config', 'ListaFileName', FListaFileName);
    if FileExists(sListaFileName) then
      ListaFileName:=sListaFileName;

    FLastMediaFile:=MyIni.ReadString('Config', 'LastMediaFile', FLastMediaFile);
    if FileExists(FLastMediaFile) then
    begin
      ListaSelectFile(FLastMediaFile)
    end;

    Top:=MyIni.ReadInteger('Config', 'Top', Self.Top);
    Left:=MyIni.ReadInteger('Config', 'Left', Self.Left);
    Width:=MyIni.ReadInteger('Config', 'Width', Self.Width);
    Height:=MyIni.ReadInteger('Config', 'Height', Self.Height);
    //Paginas.Height:=MyIni.ReadInteger('Config', 'Paginas_Height', Paginas.Height);
  finally
    if Assigned(MyIni) then
      FreeAndNil(MyIni);
  end;

end;

procedure TfmPrincipal.WriteConfig;
var
  sLastFileName:String;
  MyIni:TIniFile;
begin
  try
    myIni:=TIniFile.Create(FConfigFile);
    MyIni.WriteString('Config', 'ListaFileName', FListaFileName);
    MyIni.WriteInteger('Config', 'Top', Self.Top);
    MyIni.WriteInteger('Config', 'Left', Self.Left);
    MyIni.WriteInteger('Config', 'Width', Self.Width);
    MyIni.WriteInteger('Config', 'Height', Self.Height);
    //MyIni.WriteInteger('Config', 'Paginas_Height', Paginas.Height);
    if Lista.ItemIndex>=0 then begin
      FLastMediaFile:=Lista.Items[Lista.ItemIndex].Caption;
      MyIni.WriteString('Config', 'LastMediaFile', FLastMediaFile);
    end;
    //if IsPainel_Retratil_Opened then
    //begin
    //  MyIni.WriteInteger('Config', 'Painel_Retratil_Width', Painel_Retratil.Width);
    //end;
    if Lista.ItemIndex>=0 then
    begin
      sLastFileName:=Lista.ItemFocused.Caption;
      MyIni.WriteString('Config', 'LastFileName', sLastFileName);
    end;
  finally
    if Assigned(MyIni) then
      FreeAndNil(MyIni);
  end;

end;

procedure TfmPrincipal.SetStatusMsg(AValue: String);
begin
  if FStatusMsg=AValue then Exit;
  FStatusMsg:=AValue;
  StatusBar1.Visible:=(FStatusMsg<>'');
  StatusBar1.Panels[0].Text:=FStatusMsg;
end;

function TfmPrincipal.PlayAsHTML(AArquivo: String):String;
var
  sUrlPathIndex:String;
  sUrlPathVideo:String;
  sMimeExt:String;
  sIndexHTML:String;
  L:TStringList;
begin
  Result:='';
  sIndexHTML:=GetEnvironmentVariable('TEMP')+'\index.htm';
  //sUrlPathIndex:=FilePathToURL(sIndexHTML);
  //sUrlPathVideo:=FilePathToURL(AArquivo);
  sUrlPathIndex := UTF8Decode(UriParser.FilenameToURI(sIndexHTML));
  sUrlPathVideo := UTF8Decode(UriParser.FilenameToURI(AArquivo));
  sMimeExt:=ExtractFileExt(AArquivo);
  while LeftStr(sMimeExt,1)='.' do
    sMimeExt:=RightStr(sMimeExt, Length(sMimeExt)-1);

  if Result='' then begin
    //Result:=StopVideo;
    MediaHide;
  end;

  L:=TStringList.Create;

  if Result='' then begin
    try
      L.Add('<html>');
      L.Add('<head>');
      L.Add('<meta http-equiv="X-UA-Compatible" content="IE=9" />');
      L.Add('</head>');
      L.Add('<style>');
      L.Add('html');
      L.Add('{');
      L.Add(' position:fixed;');
      L.Add(' overflow:hidden;');
      L.Add(' -ms-overflow-style: none;');
      L.Add('    border:0px;');
      L.Add(' }</style>');

      L.Add('  <body style="background-color:black;margin=0px;padding=0px;">');
      if AArquivo='' then
      begin
        L.Add('<p><h3>Copie o endereço da localização do arquivo para a área de '+
          'clipboard e depois cole (ctrl+v) na janela de seleção de arquivo desejada.</h3></p>');
      end
      else
      begin
        if FileExists(AArquivo) then
        begin
          L.Add('  <video id=video width=100% autobuffer controls fullscreen="true">');  //controls
          L.Add('  <source src="'+sUrlPathVideo+'" type="video/'+sMimeExt+'">');
          L.Add('  <object type="video/mp4" data="media_v/video.mp4"  min-width: 100% min-height: 100%">');
          L.Add('  </object>');
          L.Add('  Seu navegador padrão não suporta a tag video.');
          L.Add('  </video>');
        end
        else
        begin
          L.Add('<p><h3>Arquivo não encontrado:</h3></p> ');
          L.Add('<p>'+AArquivo+'</p> ');
          L.Add('<p>'+sUrlPathVideo+'</p> ');
        end;
      end;
      L.Add('  </body>');
      L.Add('</html>');
      L.SaveToFile(sIndexHTML);
      if FileExists(sIndexHTML) then begin
        Paginas.ActivePage:=TabVideo;
        TabVideo.Caption:=ExtractFileName(AArquivo);
        //todo: embutir o navegador na Tab usando as dimensões que o video dispuser
        //WebBrowser1.OleObject.document.body.Scroll := 'no';
        //WebBrowser1.FullScreen:=true;
        //WebBrowser1.Navigate(sIndexHTML);
        Clipboard.AsText:=AArquivo;
        StatusMsg:='Endereço de "'+ExtractFileName(AArquivo)+'" foi copiado para a '+
          'clipboard, use Ctrl+V onde for possível.' ;
        BtnFileName_Video.Caption:='Abrir '+ExtractFileName(AArquivo);
        BtnFileName_Video.Hint:=AArquivo;
        BtnFileName_Video.Visible:=true;
      end;

    except
    on e:exception do Result:=e.Message;
    end;
  end;
  L.Free;
end;

function TfmPrincipal.PlayAsImage(AArquivo: String): String;
var
  imgH:Longint;
  imgW:Longint;
begin
  Result:='';
  if not FileExists(AArquivo) then
    Result:='Arquivo não existe: '+AArquivo;
  if Result='' then
    Result:=StopVideo;
  if Result='' then
  begin
    try
      Paginas.ActivePage:=TabFigura;
      TabFigura.Caption:=ExtractFileName(AArquivo);
      figura.picture:=nil;
      figura.Stretch:=false;
      figura.AutoSize:=true;
      figura.Picture.LoadFromFile(AArquivo);
      imgH:=figura.Picture.Graphic.Height;
      imgW:=figura.Picture.Graphic.Width;
      if imgW>FJanela_MaxWidth then
        imgW:=FJanela_MaxWidth;
      if imgH>FJanela_MaxHeight then
        imgH:=FJanela_MaxHeight;
      Self.Height:=imgH+StatusBar1.Height+0;
      Self.Width:= imgW+(0+Painel_Retratil.Width);
      figura.AutoSize:=false;
      figura.Width:=TabFigura.ClientWidth;
      figura.Height:=TabFigura.ClientHeight;
      figura.Stretch:=true;
      imgH:=figura.Picture.Graphic.Height;
      imgW:=figura.Picture.Graphic.Width;
      Self.Height:=imgH+StatusBar1.Height+0;
      Self.Width:= imgW+(0+Painel_Retratil.Width);
      TryResize;
    except
    on e:exception do Result:=e.Message;
    end;
  end;
end;

function TfmPrincipal.PlayAsPDF(AArquivo: String): String;
begin
  Result:='';
  // todo: exibir um conteúdo PDF, pelas minhas perspectivas
  //   só mesmo através de um browser
  if not FileExists(AArquivo) then
    Result:='Arquivo não existe: '+AArquivo;
  if Result='' then begin
    MediaHide;
    //Result:=StopVideo;
  end;

  if Result='' then
  begin
    try
      Paginas.ActivePage:=TabPDF;
      TabPDF.Caption:=ExtractFileName(AArquivo);
      //todo: embutir o leitor/pdf na Tab usando as dimensões que o video dispuser
      Clipboard.AsText:=AArquivo;
      StatusMsg:='Endereço de "'+ExtractFileName(AArquivo)+'" foi copiado para a '+
        'clipboard, use Ctrl+V onde for possível.' ;
        BtnFileName_PDF.Caption:='Abrir '+ExtractFileName(AArquivo);
        BtnFileName_PDF.Hint:=AArquivo;
        BtnFileName_PDF.Visible:=true;
      TryResize;
    except
    on e:exception do Result:=e.Message;
    end;
  end;

end;

procedure TfmPrincipal.SalvarLista(ANomeArquivo:String='');
var
  i:integer;
  sArqLegendas:String;
  L:TStringList;
  SaveDialog1:TSaveDialog;
begin
  L:=TStringList.Create;
  SaveDialog1:=TSaveDialog.Create(Self);
  if ANomeArquivo='' then
    ANomeArquivo:=FListaFileName;
  SaveDialog1.Filter:='Lista de tópicos|*'+_APP_EXT;
  SaveDialog1.FileName:=ANomeArquivo;
  if SaveDialog1.Execute() then
  begin
    FListaFileName:=SaveDialog1.FileName;
    if ExtractFileExt(FListaFileName)='' then
      FListaFileName:=FListaFileName+_APP_EXT;
    if Pos('..'+_APP_EXT, FListaFileName)>0 then
      FListaFileName:=StringReplace(FListaFileName, '..'+_APP_EXT, '.'+_APP_EXT, [rfIgnoreCase]);
    for i := 0 to Pred(Lista.Items.Count) do
    begin
      L.Add(Lista.Items[i].SubItems[0]);
    end;
    try
      L.SaveToFile(FListaFileName);
      FModificado:=false;
      // salvamos as legendas tambem
      sArqLegendas:=FListaFileName+'.legendas';
      if FLegendas.Count>0 then
        FLegendas.SaveToFile(sArqLegendas);
    finally

    end;
  end;
  L.Free;
  SaveDialog1.Free;
end;

procedure TfmPrincipal.MediaHide;
begin
  try
    Figura.Picture:=nil;
    BtnFileName_Video.Visible:=false;
    BtnFileName_PDF.Visible:=false;
    StopVideo;
  finally
  end;
end;

function TfmPrincipal.StopVideo: String;
begin
  Result:='';
  if Result='' then
  begin
    try
      // todo: se estiver tocando musica/video então deverá pará-lo
      //WebBrowser1.Stop;
    except
    on e:exception do Result:=e.Message;
    end;
  end;
end;

function TfmPrincipal.IsImage(AArquivo: String): Boolean;
var
  sExt:String;
begin
  sExt:=ExtractFileExt(AArquivo);
  Result:=ContainsText(_APP_EXT_FIG, sExt);
end;

function TfmPrincipal.IsVideo(AArquivo: String): Boolean;
var
  sExt:String;
begin
  sExt:=ExtractFileExt(AArquivo);
  Result:=ContainsText(_APP_EXT_VIDEO, sExt);
end;

function TfmPrincipal.IsPDF(AArquivo: String): Boolean;
var
  sExt:String;
begin
  sExt:=ExtractFileExt(AArquivo);
  Result:=ContainsText(_APP_EXT_PDF, sExt);
end;

procedure TfmPrincipal.LoadMediaFile(AArquivo: String);
var
  //sExt:String;
  sys_last_error:String;
  bSeVideo:Boolean;
  bSeFigura:Boolean;
  bSePDF:Boolean;
begin
  sys_last_error:='';
  FLoading:=true;
  try
    if AArquivo='' then
    begin
      if Lista.ItemIndex < 0 then
      begin
        sys_last_error:='Nenhum arquivo foi selecionado!';
      end
      else
      begin
        AArquivo:= lista.Items[Lista.ItemIndex].SubItems[0];
      end;
    end;

    if sys_last_error='' then
    begin
      if not FileExists(AArquivo) then
        sys_last_error:='Arquivo não existe: '+AArquivo;

    end;

    if sys_last_error='' then
    begin
      if FLegendas.Values[ExtractFileName(AArquivo)]<>'' then
      begin
        StatusMsg:=FLegendas.Values[ExtractFileName(AArquivo)];
      end;
    end;

    if sys_last_error='' then
    begin
      bSeVideo:=IsVIdeo(AArquivo);
      bSeFigura:=IsImage(AArquivo);
      bSePDF:=IsPDF(AArquivo);
      Caption:=ExtractFileName(AArquivo);
      if bSeFigura then
      begin
        bSeVideo:=false;
        bSePDF:=false;
        sys_last_error:=PlayAsImage(AArquivo);
      end;

      if bSeVideo then
      begin
        sys_last_error:=PlayAsHTML(AArquivo);
      end;

      if bSePDF then
      begin
        try
          sys_last_error:=PlayAsPDF(AArquivo);
        except
        on e:exception do sys_last_error:=e.Message;
        end;
      end;
    end;

    if sys_last_error<>'' then
    begin
      StatusMsg:=sys_last_error;
    end;

  finally
    FLoading:=false;
  end;

end;

function TfmPrincipal.Lista_ArqIncluir(AArquivo: String): Boolean;
var
  bSePDF:Boolean;
  bSeVideo:Boolean;
  bSeFigura:Boolean;
  Item: TListItem;
begin
  Result:=false;
  if FileExists(AArquivo) then
  begin
    try
      Item := Lista.Items.Add;
      Item.Caption := ExtractFilename(AArquivo);
      Item.SubItems.Add(AArquivo);
      bSePDF:=IsPDF(AArquivo);
      bSeVideo:=IsVIdeo(AArquivo);
      bSeFigura:=IsImage(AArquivo);
      if bSePDF then
        Item.ImageIndex:=17
      else if bSeVideo then
        Item.ImageIndex:=18
      else
        Item.ImageIndex:=-1; //19;
      Lista.Visible:=true;
      Painel_Retratil_AutoWidth(true);
      Result:=true;
    finally

    end;
  end;

end;

function TfmPrincipal.ListaSelectFile(AArquivo: String; ALoadMedia: Boolean
  ): Integer;
var
  sArquivo:String;
  i:Integer;
  tmpProc: TLVSelectItemEvent;
begin
  tmpProc:=Lista.OnSelectItem;
  Lista.OnSelectItem:=nil;
  i:=0;
  while i<Pred(Lista.Items.Count) do
  begin
    sArquivo:=Lista.Items[i].SubItems[0];
    if Sametext(sArquivo, AArquivo) then
    begin
      Lista.ItemIndex:=i;
      Result:=i;
      if ALoadMedia then
        LoadMediaFile(sArquivo);
      break;
    end;
    Inc(i);
    Application.ProcessMessages;
  end;
  Lista.OnSelectItem:=tmpProc;
end;

function TfmPrincipal.IsFileAcceptable(AArquivo: String): Boolean;
var
  sExt:String;
begin
  Result:=false;
  sExt:=ExtractFileExt(AArquivo);
  Result:=ContainsText(_APP_EXT_VIDEO, sExt);
  if not Result then
    Result:=ContainsText(_APP_EXT_FIG, sExt);
  if not Result then
    Result:=ContainsText(_APP_EXT_PDF, sExt);
end;


procedure TfmPrincipal.TryResize;
begin
  // todo: tenta redimencionar a janela para o tamanho ideal
  //   da imagem ou video que estiver sendo exibido
end;

procedure TfmPrincipal.BlackTheme;
var
  i:Integer;
begin
  Self.Color:=clBlack;
  Self.Font.Color:=ClWhite;
  Lista.Color:=clBlack;
  Lista.Font.Color:=ClWhite;
  Paginas.Color:=clBlack;
  for i:=0 to Pred(Paginas.PageCount) do begin
    Paginas.Pages[i].Color:=clBlack;
    Paginas.Pages[i].Font.Color:=clWhite;
  end;
  figura.Color:=clBlack;
end;



end.

