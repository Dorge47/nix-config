{ pkgs, ... }:
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-vulkan;
    
    modelsDir = "/var/lib/llama-cpp";
    
    host = "127.0.0.1";
    port = 8080;
    openFirewall = false;
    
    extraFlags = [
      "--ctx-size" "32768"
      "--n-gpu-layers" "24"
      "--flash-attn" "on"
      "--cache-type-k" "q8_0"
      "--cache-type-v" "q8_0"
      "--sleep-idle-seconds" "300"
      
      "--jinja"
    ];
  };
  
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    openFirewall = false;
    environment = {
      ENABLE_OLLAMA_API = "False";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";
      SCARF_NO_ANALYTICS = "True";
    };
  };
  
  services.searx = {
    enable = true;

    environmentFile = "/var/lib/searx/searx.env";

    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 8888;
      };

      search = {
        formats = [
          "html"
          "json"
        ];
      };
    };
  };
}
