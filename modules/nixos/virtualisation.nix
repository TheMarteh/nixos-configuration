{ ... }:

{
  # Virtual Machine Manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "steal" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
