let
  lab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdjS7qrAzVG2go7ndHik2wljTpslMiJQkwAcE/pzwa5 root@nixos";
  home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj7lWp0/L1l2qqRcSDN+HQvgkXLSXjmsQr3HcQQEm3C root@nixos";
in
{
  "secrets/zerotier-network-id.age".publicKeys = [
    lab
    home
  ];
}
