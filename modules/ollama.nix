{ config, pkgs, lib, ... }: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = pkgs.ollama-cuda.overrideAttrs (oldAttrs: rec {
      version = "0.11.2";
      src = pkgs.fetchFromGitHub {
        owner = "ollama";
        repo = "ollama";
        rev = "v${version}";
        hash = "sha256-NZaaCR6nD6YypelnlocPn/43tpUz0FMziAlPvsdCb44=";
        fetchSubmodules = true;
      };
      vendorHash = "sha256-SlaDsu001TUW+t9WRp7LqxUSQSGDF1Lqu9M1bgILoX4=";
    });
    host = "127.0.0.1";
    port = 11434;
  };
}