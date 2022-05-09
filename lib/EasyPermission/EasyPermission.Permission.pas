unit EasyPermission.Permission;

interface

uses System.SysUtils, System.Generics.Collections, System.Permissions,
  FMX.DialogService, System.UITypes
{$IF CompilerVersion >= 35.0}
  // Delphi 11 Alexandria
  ,System.Types
{$ENDIF}
  {$IFDEF ANDROID},Androidapi.Helpers, Androidapi.JNI.Os, Androidapi.JNI.JavaTypes
  {$ENDIF};

const C_PERMISSION_NEED_MESSAGE = 'You need to allow access on resources for app work correctly';


type
  TEasyPermissionType = class
  public
    class function PermissionAccessCoarseLocation : String;
    class function PermissionAccessFineLocation : String;
    class function PermissionAccessReadPhoneState : String;
    class function PermissionAccessReadSMS : String;
    class function PermissionReadExternalStorage : String;
    class function PermissionWriteExternalStorage : String;
    class function PermissionCamera : String;
  end;

  TEasyPermission = class
  private
    class var
      FEasyPermission : TEasyPermission;
    var
      FListaProc : TDictionary<String,TProc<Boolean>>;


{$IF CompilerVersion >= 35.0}
    // after Delphi 11 Alexandria
    procedure PermissionsResultHandler(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
    {$IFDEF ANDROID}
    procedure DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    {$ENDIF}
{$ELSE}
    // before Delphi 11 Alexandria
    procedure PermissionsResultHandler(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
    {$IFDEF ANDROID}
    procedure DisplayRationale(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    {$ENDIF}
{$ENDIF}
  public
    class function GetInstance : TEasyPermission;

    procedure RequestPermission(pPermission : TArray<String>; pProc : TProc<Boolean>);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TEasyPermission }

constructor TEasyPermission.Create;
begin

  FListaProc := TDictionary<String,TProc<Boolean>>.Create;
end;

destructor TEasyPermission.Destroy;
begin

  FListaProc.DisposeOf;
  inherited;
end;

{$IFDEF ANDROID}
{$IF CompilerVersion >= 35.0}
    // after Delphi 11 Alexandria
procedure TEasyPermission.DisplayRationale(Sender: TObject;
  const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
{$ELSE}
    // before Delphi 11 Alexandria
procedure TEasyPermission.DisplayRationale(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
{$ENDIF}
begin
  TDialogService.ShowMessage(C_PERMISSION_NEED_MESSAGE,
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc
    end)
end;
{$ENDIF}

class function TEasyPermission.GetInstance: TEasyPermission;
begin
  if not Assigned(FEasyPermission) then
  begin
    FEasyPermission := TEasyPermission.Create;
  end;
  Result := FEasyPermission;
end;

{$IF CompilerVersion >= 35.0}
    // after Delphi 11 Alexandria
procedure TEasyPermission.PermissionsResultHandler(Sender: TObject;
  const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
{$ELSE}
    // before Delphi 11 Alexandria
procedure TEasyPermission.PermissionsResultHandler(Sender: TObject;
  const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
{$ENDIF}
var
  pProc : TProc<Boolean>;
  bPermissao : Boolean;
  pPermissao : TPermissionStatus;
begin
  bPermissao := True;

  for pPermissao in AGrantResults do
  begin
    if not (pPermissao = TPermissionStatus.Granted) then
    begin
      bPermissao := False;
    end;
  end;

  if Length(APermissions) > 0 then
  begin
    if FListaProc.TryGetValue(APermissions[0], pProc) then
    begin
      pProc(bPermissao);
    end;
  end;
end;

procedure TEasyPermission.RequestPermission(
  pPermission: TArray<String>; pProc: TProc<Boolean>);
var
  s : String;
begin
  {$IFDEF ANDROID}
  if Assigned(pProc) then
  begin
    for s in pPermission do
    begin
      FListaProc.AddOrSetValue(s, pProc);
    end;
  end;

  PermissionsService.RequestPermissions(pPermission, PermissionsResultHandler, DisplayRationale);
  {$ELSE}
  if Assigned(pProc) then
  begin
    for s in pPermissao do
    begin
      FListaProc.AddOrSetValue(s, pProc);
    end;
  end;

  PermissionsResultHandler(Self, pPermissao, [TPermissionStatus.Granted]);
  {$ENDIF}
end;

{ TEasyPermissionType }

class function TEasyPermissionType.PermissionAccessCoarseLocation: String;
begin
  {$IFDEF ANDROID}
  Result := JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION);
  {$ELSE}
  Result := 'PermissionAccessCoarseLocation';
  {$ENDIF}
end;

class function TEasyPermissionType.PermissionAccessFineLocation: String;
begin
  {$IFDEF ANDROID}
  Result := JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION);
  {$ELSE}
  Result := 'PermissionAccessFineLocation';
  {$ENDIF}
end;

class function TEasyPermissionType.PermissionAccessReadPhoneState: String;
begin
  {$IFDEF ANDROID}
  Result := JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE);
  {$ELSE}
  Result := 'PermissionAccessReadPhoneState';
  {$ENDIF}
end;

class function TEasyPermissionType.PermissionAccessReadSMS: String;
begin
  {$IFDEF ANDROID}
  Result := JStringToString(TJManifest_permission.JavaClass.READ_SMS);
  {$ELSE}
  Result := 'PermissionAccessReadSMS'
  {$ENDIF}
end;

class function TEasyPermissionType.PermissionCamera: String;
begin
  {$IFDEF ANDROID}
  Result := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  {$ELSE}
  Result := 'PermissionCamera';
  {$ENDIF}
end;

class function TEasyPermissionType.PermissionReadExternalStorage: String;
begin
  {$IFDEF ANDROID}
  Result := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  {$ELSE}
  Result := 'PermissionReadExternalStorage';
  {$ENDIF}
end;

class function TEasyPermissionType.PermissionWriteExternalStorage: String;
begin
  {$IFDEF ANDROID}
  Result := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  {$ELSE}
  Result := 'PermissionWriteExternalStorage';
  {$ENDIF}
end;

end.
