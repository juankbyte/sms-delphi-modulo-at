unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CPort, StdCtrls, uGSM, ExtCtrls, Menus, Grids, DBGrids, DB,
  ADODB, Mask, DBCtrls, ComCtrls;

type
THilo = class(TThread)
  Ejecutar: procedure of object;
  procedure Execute; override;
end;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Archivo2: TMenuItem;
    Salir1: TMenuItem;
    Archivo1: TMenuItem;
    OPENPORT1: TMenuItem;
    mODULO1: TMenuItem;
    ConfigBD: TMenuItem;
    CtrlModOn: TTimer;
    DataSource1: TDataSource;
    ADOQueryMSG: TADOQuery;
    ADOConnection: TADOConnection;
    DBGridCargav: TDBGrid;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Panel2: TPanel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;           
    CheckBox4: TCheckBox;
    MemoMsg: TMemo;
    eCod: TEdit;
    eNum: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button5: TButton;
    Label7: TLabel;
    Panel1: TPanel;
    AQueryMSGaEnviar: TADOQuery;
    ADOConnection1: TADOConnection;
    TimerCONSULTA: TTimer;
    CheckBox5: TCheckBox;
    ADOConnection2: TADOConnection;
    ADOQueryBorrarMSG: TADOQuery;
    N1: TMenuItem;
    RunBD1: TMenuItem;
    procedure CtrlModOnTimer(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OnChangEstado(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerCONSULTATimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBGridCargavCellClick(Column: TColumn);
    procedure ConfigBDClick(Sender: TObject);
    procedure RunBD1Click(Sender: TObject);
  private
    { Private declarations }
    ConnectionString: WideString;
    numMsgAEnviar: Integer;
    sqlSearch: String;
    runHilo: Bool;
    MemoINI: TStrings;

    function LimpiarCadena(cadena: String): String;

    procedure BuscarBD(adoq: TADOQuery; sql: String);
    procedure BuscarMensajesDeHoy();
    procedure CargarConexionInFile();
    procedure GuardarMensageEnviadoBD(numero,msg,enviado: String);
    procedure LeerBuzonEntrada();
    procedure ProcesarDatos;
    procedure EstadoModulo();
    procedure ConfigColumnas();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Hilo: THilo;

implementation

{$R *.dfm}

procedure THilo.Execute;
begin
  Ejecutar;
  Terminate;
end;


function TForm1.LimpiarCadena(cadena: String): String;
var i: integer;
begin
  Result := '';
  cadena := AnsiUpperCase(cadena);
  for i := 1 to length(cadena) do
  begin
    case cadena[i] of
      'Á':  Result := Result + 'A';
      'É':  Result := Result + 'A';
      'Í':  Result := Result + 'A';
      'Ó':  Result := Result + 'A';
      'Ú':  Result := Result + 'A';
    else ;
      if (pos(cadena[i],' QWERTYUIOPASDFGHJKLÑZXCVBNM<>,.:;1234567890"$%()¿?=¡!+-*') > 0) then
        Result := Result + cadena[i];
    end;
  end;
end;


procedure TForm1.ProcesarDatos;
var tel,msg: String; i,cont: integer;
begin
  cont := 0;
  if (FormGSM.ModuloOK()) then
  begin
    // Este es el procedimiento que ejecutará nuestro hilo
    while(runHilo) do
    begin
      sleep(3000);
      cont := cont + 1;
      BuscarBD(AQueryMSGaEnviar,'select * from mensajes where Estado="ENVIAR"');
      //BuscarBD(AQueryMSGaEnviar,'select * from mensajes where Estado="ENVIAR"');
      for i:=1 to AQueryMSGaEnviar.RecordCount do
      begin
        AQueryMSGaEnviar.RecNo := i;

        tel := AQueryMSGaEnviar.FieldByName('Telefono').AsString;
        msg := LimpiarCadena(AQueryMSGaEnviar.FieldByName('Mensaje').AsString);

        if (FormGSM.EnviarMsg(tel,msg)) then
        begin
          AQueryMSGaEnviar.Edit;
          AQueryMSGaEnviar.FieldByName('Estado').AsString := 'ENVIADO';
          AQueryMSGaEnviar.FieldByName('Fecha').AsInteger := strtoint(FormatDateTime('yymmdd', now()));
          AQueryMSGaEnviar.FieldByName('Hora').AsString :=  FormatDateTime('hh:nn:ss', now());
          AQueryMSGaEnviar.Next;
          Panel1.Caption := IntToStr(StrToInt(Panel1.Caption)+1);
          Panel1.Repaint;
        end else begin
          AQueryMSGaEnviar.Edit;
          AQueryMSGaEnviar.FieldByName('Estado').AsString := 'ERROR';
          AQueryMSGaEnviar.FieldByName('Fecha').AsInteger := strtoint(FormatDateTime('yymmdd', now()));
          AQueryMSGaEnviar.FieldByName('Hora').AsString :=  FormatDateTime('hh:nn:ss', now());
          AQueryMSGaEnviar.Next;
        end;

        if (i mod 99 = 0) then LeerBuzonEntrada();
      end;

      if (cont mod 10 = 0) then begin
        LeerBuzonEntrada();
        cont := 0;
      end;
      
    end;
  end;
end;



{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  BD

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TForm1.BuscarBD(adoq: TADOQuery; sql: String);
var empresas: TStrings;
begin
  adoq.Active := False;
  adoq.SQL.Clear;
  adoq.SQL.Add(sql);
  adoq.Active := True;
end;

procedure TForm1.GuardarMensageEnviadoBD(numero,msg, enviado: String);
begin
  ADOQueryMSG.Append;
  ADOQueryMSG.FieldByName('DNI').AsInteger := 0;
  ADOQueryMSG.FieldByName('NombreApellido').AsString := '';
  ADOQueryMSG.FieldByName('Telefono').AsString := numero;
  ADOQueryMSG.FieldByName('Mensaje').AsString := msg;
  ADOQueryMSG.FieldByName('Estado').AsString := enviado;
  ADOQueryMSG.FieldByName('Fecha').AsInteger :=  strtoint(FormatDateTime('yymmdd', now()));
  ADOQueryMSG.Post;
end;

{ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  funcionalidad PROGRAMA

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TForm1.ConfigColumnas();
begin
  ADOQueryMSG.FieldByName('id').Visible := FALSE;
  ADOQueryMSG.FieldByName('DNI').Visible := FALSE;
  ADOQueryMSG.FieldByName('Id_Miembro').Visible := FALSE;
  ADOQueryMSG.FieldByName('NombreApellido').Visible := FALSE;
  ADOQueryMSG.FieldByName('Fecha').Index := 1;
  ADOQueryMSG.FieldByName('Hora').Index := 2;
end;


procedure TForm1.EstadoModulo();
begin
  Panel1.Color := clRed;
  if (FormGSM.ModuloOK()) then
  begin
    if (FormGSM.setModuloModStr()) then
    begin
      CtrlModOn.Enabled := False;
      Panel1.Color := clGreen;
    end;
  end;
end;

procedure TForm1.CtrlModOnTimer(Sender: TObject);
begin
  EstadoModulo();
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  GuardarMensageEnviadoBD(eCod.Text+eNum.Text,MemoMsg.Lines.Text,'ENVIAR');
end;

procedure TForm1.Salir1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := now();
  DateTimePicker2.Date := now();

  Hilo:=THilo.Create(True);
  Hilo.Ejecutar := Form1.ProcesarDatos;
  Hilo.Priority := tpNormal;

  runHilo := true;
  numMsgAEnviar := 0;

  MemoINI := TStringList.Create;
  if fileexists('config.ini') then
  begin
    MemoINI.LoadFromFile('config.ini');
    if (MemoINI.Count = 2) then
      CargarConexionInFile();
  end else begin
    MemoINI.Add('COM1');
    MemoINI.Add(ADOConnection.ConnectionString);
    MemoINI.SaveToFile('config.ini');
  end;

  BuscarMensajesDeHoy();
end;

procedure TForm1.BuscarMensajesDeHoy();
var fecha: String;
begin
  fecha := FormatDateTime('yymmdd', now());
  sqlSearch := 'select * from mensajes where (Estado="RECIVIDO" or Estado="NUEVO") and Fecha<='+fecha+' and Fecha>='+fecha;

  BuscarBD(ADOQueryMSG,sqlSearch);
  ConfigColumnas();
end;


procedure TForm1.LeerBuzonEntrada();
begin
  BuscarBD(ADOQueryBorrarMSG,'select * from mensajes where false');
  FormGSM.leerMsgs(ADOQueryBorrarMSG);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MemoINI.Destroy;
  runHilo := false;
  Hilo.Terminate;
  FreeAndNil(Hilo);
end;

procedure TForm1.OnChangEstado(Sender: TObject);
var estado,e1,e2,e3,e4,en,fechaIni,fechaFin: String;
begin
  e1 := '';
  e2 := '';
  e3 := '';
  e4 := '';
  en := '';

  if CheckBox4.Checked then e4 := 'ENVIAR';
  if CheckBox2.Checked then begin e2 := 'RECIVIDO'; en := 'NUEVO'; end;
  if CheckBox1.Checked then e1 := 'ENVIADO';
  if CheckBox3.Checked then e3 := 'ERROR';

  fechaIni := FormatDateTime('yymmdd', DateTimePicker1.Date);
  fechaFin := FormatDateTime('yymmdd', DateTimePicker2.Date);

  estado := '(Estado="'+e1+'" or Estado="'+en+'" or Estado="'+e2+'" or Estado="'+e3+'" or Estado="'+e4+'")';
  sqlSearch := 'select * from mensajes where '+estado+' and Fecha<='+fechaFin+' and Fecha>='+fechaIni;

  BuscarBD(ADOQueryMSG,sqlSearch);
  ConfigColumnas();
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  BuscarBD(ADOQueryMSG,sqlSearch);
  ConfigColumnas();
end;

procedure TForm1.TimerCONSULTATimer(Sender: TObject);
begin
  if (TimerCONSULTA.Tag = 20) then
  begin
    if (CheckBox5.Checked) then
    begin
      BuscarBD(ADOQueryMSG,sqlSearch);
      ConfigColumnas();
      ADOQueryMSG.Last;
    end;
    TimerCONSULTA.Tag := 0;
  end else begin
    TimerCONSULTA.Tag := TimerCONSULTA.Tag + 1;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  FormGSM.ComPort1.Close;
  FormGSM.ComPort1.Port := MemoINI.Strings[0];
  FormGSM.ComPort1.Open;
  EstadoModulo();
  Hilo.Resume;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  BuscarBD(ADOQueryBorrarMSG,'select * from mensajes where false');
  FormGSM.leerMsgs(ADOQueryBorrarMSG);
end;

procedure TForm1.DBGridCargavCellClick(Column: TColumn);
var rec: integer;
begin

  if (ADOQueryMSG.FieldByName('Estado').AsString = 'NUEVO') then
  begin
    rec := ADOQueryMSG.RecNo;
    ADOQueryMSG.Edit;
    ADOQueryMSG.FieldByName('Estado').AsString := 'RECIVIDO';
    ADOQueryMSG.Next;
    ADOQueryMSG.RecNo := rec;
  end
end;

procedure TForm1.ConfigBDClick(Sender: TObject);
begin
  // D:\Proyectos delphi\Mod GSM\mensajes2.mdb
  ConnectionString := PromptDataSource(Form1.Handle, ADOConnection.ConnectionString);
end;

procedure TForm1.CargarConexionInFile();
begin
  ADOConnection.Close;
  ADOConnection1.Close;
  ADOConnection2.Close;
  ADOConnection.ConnectionString  := MemoINI.Strings[1];
  ADOConnection1.ConnectionString := MemoINI.Strings[1];
  ADOConnection2.ConnectionString := MemoINI.Strings[1];
  ADOConnection.Open;
  ADOConnection1.Open;
  ADOConnection2.Open;
end;

procedure TForm1.RunBD1Click(Sender: TObject);
VAR com:WideString;
begin
  com := MemoINI.Strings[0];
  MemoINI.Clear;
  MemoINI.Add(com);
  MemoINI.Add(ConnectionString);
  MemoINI.SaveToFile('config.ini');
  CargarConexionInFile();
  BuscarMensajesDeHoy();
end;

end.
