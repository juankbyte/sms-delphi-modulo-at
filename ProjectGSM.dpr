program ProjectGSM;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uGSM in 'uGSM.pas' {FormGSM};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormGSM, FormGSM);
  Application.Run;
end.
