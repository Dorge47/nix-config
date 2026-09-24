{ config, lib, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = { allowUnfree = true; };
  };
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;

  llamaModelsDir =
    "${home}/Library/Application Support/llama.cpp/models";

  openWebuiDataDir =
    "${home}/Library/Application Support/open-webui";

  searxSecretFile =
    "${home}/secrets/searxng-secret";

  # This file contains no secret, so putting it in /nix/store is fine.
  searxSettings = pkgs.writeText "searxng-settings.yml" ''
  use_default_settings:
    engines:
      keep_only:
        - bing
        - google
        - wikipedia
  
  server:
    bind_address: "127.0.0.1"
    port: 8888
    limiter: false
    public_instance: false
  
  search:
    formats:
      - html
      - json
  
  engines:
    - name: bing
      disabled: false
  
    - name: google
      disabled: false
  
    - name: wikipedia
      disabled: false
      display_type:
        - infobox
        - list
  '';

  llamaStart = pkgs.writeShellScript "start-llama-cpp" ''
    mkdir -p ${lib.escapeShellArg llamaModelsDir}

    exec ${pkgs.llama-cpp}/bin/llama-server \
      --host 127.0.0.1 \
      --port 8080 \
      --models-dir ${lib.escapeShellArg llamaModelsDir} \
      --models-max 1 \
      --ctx-size 131072 \
      --n-gpu-layers all \
      --parallel 1 \
      --flash-attn on \
      --cache-type-k q8_0 \
      --cache-type-v q8_0 \
      --sleep-idle-seconds 300 \
      --jinja
  '';

  openWebuiStart = pkgs.writeShellScript "start-open-webui" ''
    mkdir -p ${lib.escapeShellArg openWebuiDataDir}
    cd ${lib.escapeShellArg openWebuiDataDir}

    export DATA_DIR=${lib.escapeShellArg openWebuiDataDir}

    exec ${pkgs.open-webui}/bin/open-webui serve \
      --host 127.0.0.1 \
      --port 3000
  '';

  searxStart = pkgs.writeShellScript "start-searxng" ''
    export SEARXNG_SETTINGS_PATH=${searxSettings}

    if [ ! -r ${lib.escapeShellArg searxSecretFile} ]; then
      echo "Cannot read SearXNG secret: ${searxSecretFile}" >&2
      exit 1
    fi

    export SEARXNG_SECRET="$(
      /bin/cat ${lib.escapeShellArg searxSecretFile}
    )"

    exec ${unstable.searxng}/bin/searxng-run
  '';

in
{
  environment.systemPackages = [
    pkgs.llama-cpp
    pkgs.open-webui
    unstable.searxng
  ];

  launchd.user.agents = {
    llama-cpp = {
      serviceConfig = {
        ProgramArguments = [ "${llamaStart}" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    open-webui = {
      serviceConfig = {
        ProgramArguments = [ "${openWebuiStart}" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    searxng = {
      serviceConfig = {
        ProgramArguments = [ "${searxStart}" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
