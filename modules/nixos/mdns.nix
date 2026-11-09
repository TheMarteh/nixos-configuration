{ ... }:

{
  # mDNS: deze pc is op het thuisnetwerk bereikbaar als nixos-steal.local
  # (o.a. voor llama-swap, zie modules/nixos/ai.nix), en .local-namen van
  # andere apparaten zijn hier op te zoeken.
  services.avahi = {
    enable = true;
    nssmdns4 = true; # .local-namen opzoeken via NSS
    allowInterfaces = [ "wlp7s0" ]; # niet op docker0 e.d.
    publish = {
      enable = true;
      addresses = true; # eigen naam en IP aankondigen
    };
    # openFirewall staat standaard aan: UDP 5353
  };
}
