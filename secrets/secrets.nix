let
  danya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL2G3zDSgiyz+GiapgO9C9WZFw8zoZgPEuOLZNH8QreS aaron.m.davis@comcast.net";
  legion5 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsoQrs/eMT8VYaYm3NWkt+AXIIN/Q2Bvva+1aSn3ozU aaron.m.davis@comcast.net";
in
{
  "hass-secrets.age".publicKeys = [
    danya
    legion5
  ];
}
