{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  llm = import ../../shared/llm.nix;

  # Alleen via deze interface is llama-swap vanaf het thuisnetwerk bereikbaar
  lanInterface = "wlp7s0";
  # systemd leest dit bestand (KEY=waarde) als root, vóór DynamicUser
  apiKeyEnvFile = "/etc/llama-swap/api-key.env";

  # CUDA-build van unstable: bevat CPU-varianten met runtime-dispatch (o.a.
  # zen4/AVX-512). Dat telt, want de MoE-experts rekent de CPU uit. Stable
  # bouwt zonder die varianten. Staat op cache.nixos-cuda.org.
  llama-cpp = pkgs-unstable.llama-cpp.override { cudaSupport = true; };
  llama-server = lib.getExe' llama-cpp "llama-server";

  mkCmd =
    id: m:
    lib.concatStringsSep " " (
      [
        llama-server
        "--host"
        "127.0.0.1"
        "--port"
        "\${PORT}" # door llama-swap ingevuld
        "--model"
        "${llm.modelDir}/${m.file}"
        "--alias"
        id
        "--ctx-size"
        (toString m.ctx)
        "--parallel"
        "1" # één gesprek; anders reserveert llama-server meer slots
        "--cache-type-k"
        "q8_0"
        "--cache-type-v"
        "q8_0"
        "--no-webui" # chat via Open WebUI of de UI van llama-swap
      ]
      ++ m.flags
    );
in
{
  # llama-swap: OpenAI- en Anthropic-compatibele proxy die een model pas laadt
  # bij het eerste verzoek en het na `ttl` seconden weer opruimt (zoals Ollama).
  # Er draait maar één model tegelijk.
  #
  # Bereikbaar vanaf het thuisnetwerk, dus elke API-aanroep vraagt de sleutel
  # (Authorization: Bearer, x-api-key of Basic), ook lokaal. Verkeer is
  # onversleuteld HTTP: alleen voor je eigen netwerk.
  services.llama-swap = {
    enable = true;
    listenAddress = "0.0.0.0";
    inherit (llm) port;
    settings = {
      # ingevuld uit apiKeyEnvFile; ontbreekt die, dan start llama-swap niet
      apiKeys = [ "\${env.LLAMA_SWAP_API_KEY}" ];
      healthCheckTimeout = 300; # 22 GB inladen zonder mmap duurt even
      models = lib.mapAttrs (id: m: {
        cmd = mkCmd id m;
        # standaard is localhost, dat eerst via IPv6 (::1) faalt
        proxy = "http://127.0.0.1:\${PORT}";
        inherit (m) ttl;
      }) llm.models;
    };
  };

  systemd.services.llama-swap = {
    requires = [ "llama-swap-api-key.service" ];
    after = [ "llama-swap-api-key.service" ];
    serviceConfig = {
      EnvironmentFile = apiKeyEnvFile;
      # Bij geheugentekort eerst llama-server afschieten, niet de browser of
      # sessie (het llama-server-proces erft dit van llama-swap)
      OOMScoreAdjust = 500;
    };
  };

  # Maakt eenmalig een willekeurige sleutel aan, buiten de Nix-store en git.
  # Twee vormen: alleen de sleutel voor clients (steal), KEY=waarde voor systemd.
  systemd.services.llama-swap-api-key = {
    description = "API-sleutel voor llama-swap";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [
      pkgs.coreutils
      pkgs.openssl
    ];
    script = ''
      umask 077
      install -d -m 0755 /etc/llama-swap
      if [ ! -s ${llm.apiKeyFile} ]; then
        openssl rand -hex 32 > ${llm.apiKeyFile}
      fi
      chown steal:users ${llm.apiKeyFile}
      chmod 0600 ${llm.apiKeyFile}
      echo "LLAMA_SWAP_API_KEY=$(cat ${llm.apiKeyFile})" > ${apiKeyEnvFile}
    '';
  };

  networking.firewall.interfaces.${lanInterface}.allowedTCPPorts = [ llm.port ];

  # Modelmap: van steal (downloaden zonder sudo), leesbaar voor de service
  systemd.tmpfiles.rules = [ "d ${llm.modelDir} 0755 steal users - -" ];

  # llama-bench, llama-cli e.d. uit dezelfde build als de service
  environment.systemPackages = [ llama-cpp ];

  # Open WebUI: lokale modellen via llama-swap, cloudmodellen via Ollama.
  # Let op: deze variabelen leest Open WebUI alleen bij de allereerste start;
  # daarna gelden de instellingen in Admin → Settings → Connections. De
  # API-sleutel (cat /etc/llama-swap/api-key) vul je daar zelf in.
  services.open-webui = {
    enable = true;
    environment = {
      # standaardwaarden van de module (worden anders overschreven)
      SCARF_NO_ANALYTICS = "True";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";

      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      OPENAI_API_BASE_URL = "${llm.baseUrl}/v1";
    };
  };
}
