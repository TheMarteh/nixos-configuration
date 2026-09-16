{ ... }:

{
  users.users.steal = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "docker" # docker zonder sudo
      "libvirtd" # virt-manager zonder wachtwoordprompt
    ];
    # Gebruikerspakketten staan in ./home
  };
}
