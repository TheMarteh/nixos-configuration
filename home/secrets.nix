{ pkgs, ... }:

{
  # Pinentry voor wachtwoord prompts
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
