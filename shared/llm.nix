# Lokale LLM's via llama-swap + llama.cpp. Eén bron voor poort, modelnamen en
# contextgroottes: modules/nixos/ai.nix maakt er de llama-swap-config van,
# home/ai.nix de OpenCode-provider, `claude-local` en `llm-download`.
#
# Modellen staan buiten /home (de service draait met ProtectHome) en worden
# niet door Nix gedownload: draai `llm-download` na een rebuild.
rec {
  port = 8012;
  baseUrl = "http://127.0.0.1:${toString port}";
  modelDir = "/srv/models";

  # API-sleutel (alleen de sleutel, eigenaar steal, 0600). Wordt bij de eerste
  # start aangemaakt door llama-swap-api-key.service; nieuwe sleutel: bestand
  # verwijderen en `systemctl restart llama-swap`.
  apiKeyFile = "/etc/llama-swap/api-key";

  # Standaardmodel voor agents (OpenCode, claude-local)
  defaultModel = "qwen3.6-35b-a3b";

  # Qwen-aanbeveling voor thinking-modus / precies codeerwerk
  qwenSampling = [
    "--temp"
    "0.6"
    "--top-p"
    "0.95"
    "--top-k"
    "20"
    "--min-p"
    "0"
    "--presence-penalty"
    "0"
  ];

  models = {
    # MoE: aandacht + KV-cache op de GPU, experts in het RAM (ca. 17 GB).
    # `--fit` (standaard aan) kiest zelf hoeveel experts naar de CPU gaan;
    # --fit-target houdt marge vrij voor de desktop.
    "qwen3.6-35b-a3b" = {
      name = "Qwen3.6 35B-A3B";
      repo = "unsloth/Qwen3.6-35B-A3B-GGUF";
      file = "qwen36/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf"; # 22,4 GB
      # OpenCode's systeemprompt alleen is al ~14K tokens
      ctx = 131072;
      output = 16384;
      ttl = 900; # na 15 min zonder verzoeken uit het geheugen
      flags = [
        "--load-mode"
        "none" # experts vooraf in RAM (vervangt --no-mmap)
        "--threads"
        "6" # fysieke kernen van de 7600X
        "--fit-target"
        "1536"
      ]
      ++ qwenSampling;
    };

    # Klein model dat volledig in de 8 GB VRAM past
    "qwen3.5-9b" = {
      name = "Qwen3.5 9B";
      repo = "unsloth/Qwen3.5-9B-GGUF";
      file = "qwen35/Qwen3.5-9B-Q4_K_M.gguf"; # 5,7 GB
      ctx = 32768;
      output = 8192;
      ttl = 600;
      flags = qwenSampling;
    };
  };
}
