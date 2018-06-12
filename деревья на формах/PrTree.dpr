program PrTree;

uses
  Vcl.Forms,
  LabTreeForm in 'LabTreeForm.pas' {FTree};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFTree, FTree);
  Application.Run;
end.
