{ lib, pkgs-unstable, ... }:

let
  llm = import ../../shared/llm.nix;

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
  services.llama-swap = {
    enable = true;
    listenAddress = "127.0.0.1";
    inherit (llm) port;
    settings = {
      healthCheckTimeout = 300; # 22 GB inladen zonder mmap duurt even
      models = lib.mapAttrs (id: m: {
        cmd = mkCmd id m;
        # standaard is localhost, dat eerst via IPv6 (::1) faalt
        proxy = "http://127.0.0.1:\${PORT}";
        inherit (m) ttl;
      }) llm.models;
    };
  };

  # Bij geheugentekort eerst llama-server afschieten, niet de browser of sessie
  # (het llama-server-proces erft dit van llama-swap)
  systemd.services.llama-swap.serviceConfig.OOMScoreAdjust = 500;

  # Modelmap: van steal (downloaden zonder sudo), leesbaar voor de service
  systemd.tmpfiles.rules = [ "d ${llm.modelDir} 0755 steal users - -" ];

  # llama-bench, llama-cli e.d. uit dezelfde build als de service
  environment.systemPackages = [ llama-cpp ];

  # Open WebUI: lokale modellen via llama-swap, cloudmodellen via Ollama.
  # Let op: deze variabelen leest Open WebUI alleen bij de allereerste start;
  # daarna gelden de instellingen in Admin → Settings → Connections.
  services.open-webui = {
    enable = true;
    environment = {
      # standaardwaarden van de module (worden anders overschreven)
      SCARF_NO_ANALYTICS = "True";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";

      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      OPENAI_API_BASE_URL = "${llm.baseUrl}/v1";
      OPENAI_API_KEY = "none";
    };
  };
}
