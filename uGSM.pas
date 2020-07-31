unit uGSM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CPort, StdCtrls,ADODB;

type
  TFormGSM = class(TForm)
    ComPort1: TComPort;
    MemoLin: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function ComandoSendOK(): Bool;
    function CtrlModelo(): Bool;
    function CtrlNumSerie(): Bool;
    function CopiarHastaComa(str: String; numComa: Integer = 1): String;
    function CadenaHxToStr(cadena: String): String;
  public
    { Public declarations }
    function ModuloOK(): Bool;
    function setModuloModStr(): Bool;
    function EnviarMsg(numero,msg: String): Bool;
    function LimpiarCadena(cadena: String): String;

    procedure leerMsgs(adq: TADOQuery);
    procedure ComandoAT(comand: String);
    procedure leerPuertoCOM();
    procedure MostrarLecturaPuerto();
  end;

var
  FormGSM: TFormGSM;

implementation

{$R *.dfm}

procedure TFormGSM.FormCreate(Sender: TObject);
begin
  ComPort1.Open;
end;

function TFormGSM.ComandoSendOK(): Bool;
begin
  leerPuertoCOM();
  result := pos('OK',MemoLin.Lines.Text) > 0;
end;

function TFormGSM.ModuloOK(): Bool;
begin
  ComandoAT('AT'+#13);
  result := ComandoSendOK() AND CtrlNumSerie() AND CtrlModelo();
end;

function TFormGSM.CtrlModelo(): Bool;
begin
  ComandoAT('AT+CGMM'+#13);
  if (ComandoSendOK()) then
    result := pos('MODEL=G24',MemoLin.Lines.Text) > 0
  else
    result := false;
end;

function TFormGSM.CtrlNumSerie(): Bool;
begin
  ComandoAT('AT+CGSN'+#13);
  if (ComandoSendOK()) then
    result := pos('356889014735951',MemoLin.Lines.Text) > 0
  else
    result := false;
end;

function TFormGSM.setModuloModStr(): Bool;
begin
  ComandoAT('at+cmgf=1'+#13);
  result := ComandoSendOK();
end;

function TFormGSM.EnviarMsg(numero,msg: String): Bool;
begin
  if ((length(numero) >= 7) or (length(numero) <= 14)) then
  begin
    ComandoAT('at+cmgs="'+numero+'"'+#13);
    ComandoAT(msg+#26);
    result := ComandoSendOK();
  end else begin
    result := true;
  end;
end;

procedure TFormGSM.leerPuertoCOM();
var count,salir,datosCount,primerLectura,segundaLectura: integer; datos: String;
begin
  MemoLin.Lines.Clear;

  salir := 0;
  primerLectura := 0;
  segundaLectura := -1;

  while (salir < 80) do begin
    sleep(100);
    datos := '';
    salir := salir + 1;
    count := ComPort1.InputCount();
    ComPort1.ReadStr(datos, count);
    MemoLin.Lines.Text := MemoLin.Lines.Text + datos;
    if (pos('OK',MemoLin.Lines.Text) > 0) then break;
    if (pos('ERROR',MemoLin.Lines.Text) > 0) then break;
  end;
  //showmessage(inttostr(salir));
end;

procedure TFormGSM.ComandoAT(comand: String);
begin
  ComPort1.WriteStr(comand);
end;

procedure TFormGSM.MostrarLecturaPuerto();
begin
  showmessage(MemoLin.Lines.Text);
end;

function TFormGSM.CopiarHastaComa(str: String; numComa: Integer = 1): String;
var i,numPos: Integer;
begin
  for i:= 1 to numComa do
  begin
    numPos := pos(',',str)+1;
    str := copy(str,numPos,length(str)-numPos);
  end;
  Result := str;
end;

function TFormGSM.CadenaHxToStr(cadena: String): String;
var i,lengCad: integer;  code,msgAux: String; hexc: cardinal;
begin
  code := '';
  msgAux := '';

  lengCad := length(cadena);
  if ((lengCad mod 4 = 0) and (lengCad > 3)) then
  begin
    for i := 1 to lengCad do
    begin
      if (pos(cadena[i],'0123456789ABCDEF') > 0) then
      begin
        code := code+cadena[i];
        if (i mod 4 = 0) then
        begin
          hexc := strtoint('$' + copy(code,3,2));
          msgAux := msgAux+Char(hexc);
          code := '';
        end;
      end else begin
        msgAux := cadena;
        break;
      end;
    end;
    Result := msgAux;
  end else begin
    Result := cadena;
  end;
end;

function TFormGSM.LimpiarCadena(cadena: String): String;
var i: integer;
begin
  Result := '';
  for i := 1 to length(cadena) do
    if (pos(cadena[i],'1234567890') > 0) then
      Result := Result + cadena[i];
end;


procedure TFormGSM.leerMsgs(adq: TADOQuery);
var i: integer; lineaStr,fecha,numTel,hora,msg,numMsg: String;
begin
  ComandoAT('AT+CMGL="ALL"'+#13);
  leerPuertoCOM();

  for i:= 1 to MemoLin.Lines.Count do
  begin
    lineaStr := MemoLin.Lines.Strings[i];
    if ((pos('+CMGL: ',lineaStr) > 0) and (pos('REC READ',lineaStr) = 0)) then
    begin
      try
        numMsg := LimpiarCadena(trim(copy(lineaStr,pos(':',lineaStr)+1,3)));
        lineaStr := CopiarHastaComa(lineaStr,2);
        numTel := copy(lineaStr,6,pos('",',lineaStr)-6);
        lineaStr := CopiarHastaComa(lineaStr,2);
        fecha := copy(lineaStr,2,pos(',',lineaStr)-2);
        hora  := copy(lineaStr,pos(',',lineaStr)+1,8);
        msg := MemoLin.Lines.Strings[i+1];

        fecha := fecha[1]+fecha[2]+fecha[4]+fecha[5]+fecha[7]+fecha[8];
        msg := CadenaHxToStr(msg);

        adq.Append;
        adq.FieldByName('DNI').AsInteger := 0;
        adq.FieldByName('Nombre y Apellido').AsString := '';
        adq.FieldByName('Telefono').AsString := numTel;
        adq.FieldByName('Mensaje').AsString := msg;
        adq.FieldByName('Estado').AsString := 'NUEVO';
        adq.FieldByName('Fecha').AsInteger :=  strtoint(fecha);
        adq.FieldByName('Hora').AsString := hora;
        adq.Post;

        ComandoAT('AT+CMGD='+numMsg+#13);
      except

      end;
    end else begin
      if(pos('+CMGL: ',lineaStr) > 0) then
      begin
        numMsg := LimpiarCadena(trim(copy(lineaStr,pos(':',lineaStr)+1,3)));
        ComandoAT('AT+CMGD='+numMsg+#13);
      end;
    end;
  end;
  leerPuertoCOM();
end;


procedure TFormGSM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ComPort1.Close;
  Close;
end;

end.
