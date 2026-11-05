let
  danya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHOggfEowz3Nvn64IZ1vhmW127LPKQHD5+bH2VFvQpv root@danya";
  legion5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsoQrs/eMT8VYaYm3NWkt+AXIIN/Q2Bvva+1aSn3ozU aaron.m.davis@comcast.net";
in
{
  "hass-secrets.age".publicKeys = [
    danya
    legion5
  ];
}
