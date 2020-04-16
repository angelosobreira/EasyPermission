unit Sample.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Media,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    btnStart: TButton;
    btnStop: TButton;
    Image1: TImage;
    CameraComponent1: TCameraComponent;
    procedure CameraComponent1SampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetImage;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses EasyPermission.Permission;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  TEasyPermission.GetInstance.RequestPermission([TEasyPermissionType.PermissionCamera],
                                                 procedure(PermissionGranted : Boolean)
                                                 begin
                                                   if PermissionGranted then
                                                   begin
                                                     CameraComponent1.Active := True;
                                                   end
                                                   else
                                                   begin
                                                     ShowMessage('You need do allow to permission to open camera')
                                                   end;
                                                 end);
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  CameraComponent1.Active := False;
end;

procedure TForm1.CameraComponent1SampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(TThread.CurrentThread, GetImage);
end;

procedure TForm1.GetImage;
begin
  CameraComponent1.SampleBufferToBitmap(Image1.Bitmap, True);
end;

end.
