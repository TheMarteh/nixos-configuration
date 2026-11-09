{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  llm = import ../shared/llm.nix;

  # Claude Code tegen het lokale model, zonder je normale `claude` te raken.
  # Alle modelniveaus naar hetzelfde model, anders wisselt llama-swap steeds.
  # Ander model: CLAUDE_LOCAL_MODEL=qwen3.5-9b claude-local
  claude-local = pkgs.writeShellScriptBin "claude-local" ''
    model="''${CLAUDE_LOCAL_MODEL:-${llm.defaultModel}}"
    export ANTHROPIC_BASE_URL=${llm.baseUrl}
    ANTHROPIC_AUTH_TOKEN="$(cat ${llm.apiKeyFile})" || exit 1
    export ANTHROPIC_AUTH_TOKEN
    export ANTHROPIC_API_KEY=""
    export ANTHROPIC_MODEL="$model"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="$model"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="$model"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="$model"
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
    exec ${lib.getExe pkgs-unstable.claude-code} "$@"
  '';

  # Haalt de GGUF's uit shared/llm.nix op naar /srv/models (slaat bestaande over)
  llm-download = pkgs.writeShellScriptBin "llm-download" ''
    set -euo pipefail
    ${lib.concatMapStringsSep "\n" (m: ''
      echo "==> ${m.repo} ${baseNameOf m.file}"
      ${pkgs.python3Packages.huggingface-hub}/bin/hf download ${m.repo} ${baseNameOf m.file} \
        --local-dir ${llm.modelDir}/${dirOf m.file}
    '') (lib.attrValues llm.models)}
  '';
in
{
  # Ollama alleen nog voor de cloudmodellen (*:cloud); lokale modellen draaien
  # via llama-swap (modules/nixos/ai.nix). Daarom geen CUDA-build meer.
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama;
  };

  programs.opencode = {
    enable = true;
    settings = {
      model = "llamaswap/${llm.defaultModel}";
      # zelfde model: een ander klein model zou llama-swap laten wisselen
      small_model = "llamaswap/${llm.defaultModel}";
      enabled_providers = [ "llamaswap" ];
      autoupdate = false;
      share = "disabled";
      provider.llamaswap = {
        npm = "@ai-sdk/openai-compatible";
        name = "llama-swap (lokaal)";
        options = {
          baseURL = "${llm.baseUrl}/v1";
          # OpenCode leest de sleutel bij het starten uit het bestand
          apiKey = "{file:${llm.apiKeyFile}}";
        };
        models = lib.mapAttrs (_: m: {
          inherit (m) name;
          tool_call = true;
          reasoning = true;
          # moet gelijk zijn aan --ctx-size, anders weet OpenCode niet wanneer
          # de context vol raakt
          limit = {
            context = m.ctx;
            inherit (m) output;
          };
        }) llm.models;
      };
      permission = {
        edit = "ask";
        webfetch = "deny";
        bash = {
          "*" = "ask";
          "git status*" = "allow";
          "git diff*" = "allow";
        };
      };
    };
  };

  # Geen modellenlijst van models.dev ophalen
  home.sessionVariables.OPENCODE_DISABLE_MODELS_FETCH = "1";

  home.packages = [
    pkgs-unstable.claude-code
    claude-local
    llm-download
  ];
}
