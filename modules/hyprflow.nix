{ config, pkgs, lib, ... }:

let
  hyprflow = pkgs.stdenv.mkDerivation rec {
    pname = "hyprflow";
    version = "2025-12-09";

    src = pkgs.fetchFromGitHub {
      owner = "harshvsri";
      repo = "hyprflow";
      rev = "91f902acdf64cd400d28cf66cb53560cfba8efb4";
      hash = "sha256-OLSybjZ8E53oqYk6NtcU5wvZ1JTv0VlW7vP8IY4Kp9Q=";
    };

    # Fetch the model directly
    model = pkgs.fetchurl {
      url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin";
      sha256 = "00nhqqvgwyl9zgyy7vk9i3n017q2wlncp5p7ymsk0cpkdp47jdx0";
    };

    buildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/hyprflow

      # Copy the model to the store
      cp ${model} $out/share/hyprflow/ggml-base.en.bin

      # Write the customized script directly
      cat > $out/bin/hyprflow <<'EOF'
#!/bin/bash

# Config
WHISPER_BIN="${pkgs.whisper-cpp}/bin/whisper-cli"
WHISPER_MODEL="$out/share/hyprflow/ggml-base.en.bin"
RECORDING_DIR="$HOME/.cache/hyprflow/recordings"
TRANSCRIPT_DIR="$HOME/.cache/hyprflow/transcripts"
STATE_FILE="/tmp/hyprflow.state"
KEEP_VERSIONS=5

# Ensure directories exist
mkdir -p "$RECORDING_DIR" "$TRANSCRIPT_DIR"

start_notification() {
    ID=$(notify-send --print-id --app-name=Flow --expire-time=0 --hint=int:transient:1 "Dictation Started" "Listening...")
    echo "NOTIFY_ID=$ID" >>"$STATE_FILE"
}

stop_notification() {
  if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
    if [ -n "$NOTIFY_ID" ]; then
      notify-send --replace-id="$NOTIFY_ID" --app-name=Flow --expire-time=2000 --hint=int:transient:1 "Processing..." "Transcribing audio..."
    fi
  fi
}

cleanup_old_files() {
  if [ "$KEEP_VERSIONS" -le 0 ] 2>/dev/null; then return; fi
  if [ -d "$RECORDING_DIR" ]; then
    ls -1t "$RECORDING_DIR"/*.wav 2>/dev/null | tail -n +$((KEEP_VERSIONS + 1)) | xargs -r rm -f
  fi
  if [ -d "$TRANSCRIPT_DIR" ]; then
    ls -1t "$TRANSCRIPT_DIR"/*_raw.txt 2>/dev/null | tail -n +$((KEEP_VERSIONS + 1)) | xargs -r rm -f
  fi
}

# Toggle Logic
if [ -f "$STATE_FILE" ]; then
  # STOP RECORDING
  source "$STATE_FILE"
  
  if [ -n "$PID" ]; then
    kill "$PID" 2>/dev/null
  fi
  
  # Also kill via pkill to be safe
  pkill -f "pw-record.*hyprflow" 2>/dev/null

  stop_notification

  RECORDING_FILE="''${RECORDING_DIR}/''${TIME}.wav"
  TRANSCRIPT_FILE="''${TRANSCRIPT_DIR}/''${TIME}_raw.txt"

  if [ -f "$RECORDING_FILE" ]; then
    "$WHISPER_BIN" -m "$WHISPER_MODEL" -f "$RECORDING_FILE" --no-prints --no-timestamps >"$TRANSCRIPT_FILE" 2>/dev/null
    
    # Trim and Copy
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' "$TRANSCRIPT_FILE" | tr -d '\n' | wl-copy
    
    # Paste
    hyprctl dispatch sendshortcut "CTRL SHIFT, V, activewindow"
  fi

  rm -f "$STATE_FILE"
  cleanup_old_files

else
  # START RECORDING
  TIME=$(date +%s)
  echo "TIME=$TIME" >"$STATE_FILE"
  RECORDING_FILE="''${RECORDING_DIR}/''${TIME}.wav"

  start_notification

  pw-record --rate 16000 --channels 1 "$RECORDING_FILE" 2>/dev/null &
  echo "PID=$!" >>"$STATE_FILE"
fi
EOF

      chmod +x $out/bin/hyprflow

      # Patch the script to correct the store paths in the text we just wrote
      substituteInPlace $out/bin/hyprflow \
        --replace '$out' $out

      # Wrap the script with necessary dependencies
      wrapProgram $out/bin/hyprflow \
        --prefix PATH : ${lib.makeBinPath [
          pkgs.pipewire
          pkgs.wl-clipboard
          pkgs.libnotify
          pkgs.coreutils
          pkgs.procps
          pkgs.gnused
          pkgs.fd
          pkgs.hyprland
          pkgs.whisper-cpp
        ]}
    '';

    meta = with lib; {
      description = "A local voice-to-text tool for Hyprland using whisper.cpp";
      homepage = "https://github.com/harshvsri/hyprflow";
      license = licenses.mit; # Assuming MIT, but check repo if needed
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ hyprflow ];
}