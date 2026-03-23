let
  lab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDdjS7qrAzVG2go7ndHik2wljTpslMiJQkwAcE/pzwa5 root@nixos";
  # TODO: Add home host key from /etc/ssh/ssh_host_ed25519_key.pub.
  # home = "ssh-ed25519 AAAA... root@home";
  # TODO: Add work host key from /etc/ssh/ssh_host_ed25519_key.pub.
  # work = "ssh-ed25519 AAAA... root@work";
in
{
  "secrets/zerotier-network-id.age".publicKeys = [
    lab
    # home
    # work
  ];
}
