{ ... }:

{
  # Secret service voor VS Code, Rider, GitHub CLI, Chromium/Electron apps, ...
  services.gnome.gnome-keyring.enable = true;
  # Ontgrendel de keyring met het wachtwoord van de login in tuigreet
  security.pam.services.greetd.enableGnomeKeyring = true;
  # GUI om de keyring te beheren
  programs.seahorse.enable = true;

  # 1Password op systeemniveau: nodig voor systeemauthenticatie,
  # CLI-integratie en browserintegratie
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "steal" ];
  };
}
