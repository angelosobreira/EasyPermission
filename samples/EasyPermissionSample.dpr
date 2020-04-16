program EasyPermissionSample;

uses
  System.StartUpCopy,
  FMX.Forms,
  Sample.Main in 'src\Sample.Main.pas' {Form1},
  EasyPermission.Permission in '..\lib\EasyPermission\EasyPermission.Permission.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
