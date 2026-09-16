{ pkgs, ... }:

{
  # Pinentry voor wachtwoord prompts
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  # KDE Wallet service
  systemd.user.services.kwallet = {
    Unit = {
      Description = "KDE Wallet Service";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.packages = with pkgs; [
    kdePackages.kwallet
    kdePackages.kwalletmanager # GUI om wallet te beheren
    _1password-cli
    _1password-gui
  ];
}
