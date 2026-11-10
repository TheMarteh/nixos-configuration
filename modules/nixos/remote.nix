{ config, ... }:

let
  llm = import ../../shared/llm.nix;
  tailscale = config.services.tailscale.interfaceName; # tailscale0
in
{
  # Toegang van buitenaf (werk, onderweg) via Tailscale: SSH en llama-swap zijn
  # alleen over de tailnet bereikbaar, niet vanaf internet of het thuisnetwerk.
  # Eenmalig na de switch: `sudo tailscale up` en in de Tailscale-admin
  # "Disable key expiry" voor deze machine, anders valt hij na 180 dagen weg.
  services.tailscale = {
    enable = true;
    openFirewall = true; # UDP 41641, voor directe verbindingen i.p.v. relays
  };

  services.openssh = {
    enable = true;
    openFirewall = false; # poort 22 alleen op de Tailscale-interface (hieronder)
    settings = {
      PasswordAuthentication = false;
      # Staat in NixOS standaard aan en laat via PAM alsnog wachtwoorden toe
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "steal" ];
    };
  };

  # Publieke SSH-sleutels uit 1Password (de privésleutels blijven daar).
  # Eén regel per sleutel, bv. "ssh-ed25519 AAAA... werklaptop".
  users.users.steal.openssh.authorizedKeys.keys = [
  ];

  networking.firewall.interfaces.${tailscale}.allowedTCPPorts = [
    22
    llm.port # llama-swap; vraagt nog steeds de API-sleutel
  ];
}
