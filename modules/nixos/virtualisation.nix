{ ... }:

{
  # Virtual Machine Manager
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
