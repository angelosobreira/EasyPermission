#Easy Permisson Library

A small library to request permission in Android with Embarcadero Delphi Development.

To use in your project, add EasyPermission.Permission.pas in your project.

To request camera permission, just do it:
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