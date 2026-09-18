{ ... }:

{
  users.users.steal = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "docker" # docker zonder sudo
      "libvirtd" # virt-manager zonder wachtwoordprompt
      "networkmanager" # netwerken beheren zonder polkit-prompt
    ];
    # Gebruikerspakketten staan in ./home
  };
}
