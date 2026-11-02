{
  config,
  lib,
  pkgs,
  osConfig,
  secrets,
  ...
}:

let
  home = config.home.homeDirectory;
  username = config.home.username;
  hostName = osConfig.networking.hostName;

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  # ===========================================================================
  # Private-but-not-runtime-secret configuration
  # ===========================================================================
  #
  # The ONLY information command-center consumes from secrets.nix is repository
  # URLs. These values can enter the Nix store, but remain encrypted in Git
  # when secrets.nix is protected with git-crypt.
  #
  commandCenterPrivate = secrets."command-center";


  # ===========================================================================
  # Runtime secret filenames
  # ===========================================================================
  #
  # Every machine uses the SAME filenames inside its host-specific secretsDir.
  #
  # Example resulting directory:
  #
  #   <secretsDir>/
  #   ├── aws_access_key_id
  #   ├── aws_secret_access_key
  #   ├── restic_desktop_password
  #   ├── restic_raspi_password
  #   ├── restic_macbook_password
  #   └── restic_windows_password
  #
  # IMPORTANT:
  # These are only filenames. Nix NEVER reads the contents of these files.
  #
  secretFileNames = {
    awsAccessKeyId = "aws_access_key_id";
    awsSecretAccessKey = "aws_secret_access_key";

    resticPasswords = {
      desktop = "restic_desktop_password";
      raspi = "restic_raspi_password";
      macbook = "restic_macbook_password";
      windows = "restic_windows_password";
    };
  };


  # ===========================================================================
  # Per-host configuration
  # ===========================================================================
  #
  # MODIFY ME:
  #
  # The keys here must match networking.hostName on each machine.
  #
  # secretsDir is the absolute directory containing the runtime secret files
  # listed above.
  #
  # Nothing stored directly in hostProfiles is secret. Values here will appear
  # in the generated Fish script and therefore in the Nix store.
  #
  hostProfiles = {
    nixos = {
      displayName = "NixOS desktop";

      flakePath = "${home}/Documents/GitHub/nix-config";

      flakeTarget = "desktop";

      # Absolute location containing all command-center credential files on
      # this particular machine.
      secretsDir =
        "/home/chris/commandcenterstuff";

      # Every Restic repository mounted from this host mounts here.
      resticMountPoint =
        "/run/media/${username}/resticstuff";

      # This host is only allowed to BACK UP to this repository.
      # It can still mount/browse/rewrite every other repository.
      backupRepo = "desktop";

      backupSources = [ "/" ];

      backupExcludeFile =
        "${home}/Documents/resticstuff.txt";

      backupExtraArgs = [ ];
    };


    nixPi = {
      displayName = "NixOS Pi";

      flakePath = "${home}/Documents/GitHub/nix-config";

      flakeTarget = "raspi";

      secretsDir =
        "/home/dorge/commandcenterstuff";

      resticMountPoint =
        "/run/media/${username}/resticstuff";

      backupRepo = "raspi";
      backupSources = [ "/" ];

      backupExcludeFile =
        "${home}/Documents/excludes.txt";

      backupExtraArgs = [ ];
    };


    Chriss-MacBook-Pro = {
      displayName = "MacBook";

      flakePath = "${home}/GitHub/nix-config";

      flakeTarget = "macbook";

      secretsDir =
        "/Users/chris/commandcenterstuff";

      # Resolves to /Users/<username>/restic.
      resticMountPoint =
        "${home}/restic";

      backupRepo = "macbook";

      # No positional backup sources on macOS.
      #
      # Restic gets all backup sources from --files-from instead.
      backupSources = [ ];

      backupExcludeFile =
        "${home}/exclude-mac.txt";

      backupExtraArgs = [
        "--files-from"
        "${home}/include-mac.txt"

        "--one-file-system"
        "--exclude-cloud-files"
      ];
    };
  };


  host =
    if builtins.hasAttr hostName hostProfiles then
      hostProfiles.${hostName}
    else
      throw ''
        command-center: no host profile exists for "${hostName}".

        Add "${hostName}" to hostProfiles in command-center.nix.
      '';


  # ===========================================================================
  # Repository definitions
  # ===========================================================================
  #
  # Repository URLs are obtained from secrets.nix.
  #
  # Password-file paths are derived from THIS machine's secretsDir, so the
  # structure is identical across all machines even though the root directory
  # can be completely different.
  #
  repos = {
    desktop = {
      displayName = "NixOS machine backup";
      repository = commandCenterPrivate.restic.desktop.repoUrl;

      passwordFile =
        "${host.secretsDir}/${secretFileNames.resticPasswords.desktop}";
    };

    raspi = {
      displayName = "NixOS Pi backup";
      repository = commandCenterPrivate.restic.raspi.repoUrl;

      passwordFile =
        "${host.secretsDir}/${secretFileNames.resticPasswords.raspi}";
    };

    macbook = {
      displayName = "MacBook backup";
      repository = commandCenterPrivate.restic.macbook.repoUrl;

      passwordFile =
        "${host.secretsDir}/${secretFileNames.resticPasswords.macbook}";
    };

    windows = {
      displayName = "Windows machine backup";
      repository = commandCenterPrivate.restic.windows.repoUrl;

      passwordFile =
        "${host.secretsDir}/${secretFileNames.resticPasswords.windows}";
    };
  };


  # ===========================================================================
  # Runtime credential paths
  # ===========================================================================

  awsAccessKeyFile =
    "${host.secretsDir}/${secretFileNames.awsAccessKeyId}";

  awsSecretKeyFile =
    "${host.secretsDir}/${secretFileNames.awsSecretAccessKey}";


  platform =
    if isDarwin then "darwin" else "nixos";

  openCommand =
    if isDarwin then
      "/usr/bin/open"
    else
      "${pkgs.xdg-utils}/bin/xdg-open";

in
{
  home.packages =
    lib.optionals (!isDarwin) [
      pkgs.xdg-utils
    ];


  # ===========================================================================
  # Generated command-center
  # ===========================================================================

  home.file."command-center.fish" = {
    executable = true;

    text = ''
      #!${pkgs.fish}/bin/fish

      # =========================================================================
      # command-center.fish
      #
      # GENERATED BY HOME MANAGER.
      #
      # Do not edit this generated file directly. Edit command-center.nix and
      # rebuild instead.
      # =========================================================================


      # =========================================================================
      # Host configuration
      # =========================================================================

      set -g HOST_NAME ${lib.escapeShellArg hostName}
      set -g HOST_DISPLAY_NAME ${lib.escapeShellArg host.displayName}
      set -g PLATFORM ${lib.escapeShellArg platform}

      set -g FLAKE_PATH ${lib.escapeShellArg host.flakePath}
      set -g FLAKE_TARGET ${lib.escapeShellArg host.flakeTarget}

      set -g SECRETS_DIR ${lib.escapeShellArg host.secretsDir}

      set -g RESTIC_MOUNT_POINT ${lib.escapeShellArg host.resticMountPoint}

      set -g HOST_BACKUP_REPO ${lib.escapeShellArg host.backupRepo}

      # These are Fish arrays.
      set -g BACKUP_SOURCES ${lib.escapeShellArgs host.backupSources}
      set -g BACKUP_EXTRA_ARGS ${lib.escapeShellArgs host.backupExtraArgs}
      set -g BACKUP_EXCLUDE_FILE ${lib.escapeShellArg host.backupExcludeFile}


      # =========================================================================
      # Runtime secret paths
      # =========================================================================
      #
      # Nix knows these PATHS, but never evaluates the contents.
      #
      # Actual credential contents are read only at runtime after sudo
      # authentication.
      #

      set -g AWS_ACCESS_KEY_FILE ${lib.escapeShellArg awsAccessKeyFile}
      set -g AWS_SECRET_KEY_FILE ${lib.escapeShellArg awsSecretKeyFile}


      # =========================================================================
      # Repository metadata
      # =========================================================================
      #
      # Repository URLs came from the git-crypt-protected secrets.nix.
      #
      # The passwords themselves did NOT.
      #

      set -g REPO_DESKTOP ${lib.escapeShellArg repos.desktop.repository}
      set -g REPO_DESKTOP_PASSWORD ${lib.escapeShellArg repos.desktop.passwordFile}

      set -g REPO_RASPI ${lib.escapeShellArg repos.raspi.repository}
      set -g REPO_RASPI_PASSWORD ${lib.escapeShellArg repos.raspi.passwordFile}

      set -g REPO_MACBOOK ${lib.escapeShellArg repos.macbook.repository}
      set -g REPO_MACBOOK_PASSWORD ${lib.escapeShellArg repos.macbook.passwordFile}

      set -g REPO_WINDOWS ${lib.escapeShellArg repos.windows.repository}
      set -g REPO_WINDOWS_PASSWORD ${lib.escapeShellArg repos.windows.passwordFile}


      # =========================================================================
      # Immutable executable paths supplied by Nix
      # =========================================================================

      set -g NIX (command -s nix)
      set -g RESTIC (command -s restic)
      set -g ROOT_FISH ${pkgs.fish}/bin/fish

      set -g CAT ${pkgs.coreutils}/bin/cat
      set -g DATE ${pkgs.coreutils}/bin/date
      set -g MKDIR ${pkgs.coreutils}/bin/mkdir
      set -g READLINK ${pkgs.coreutils}/bin/readlink
      set -g STAT ${pkgs.coreutils}/bin/stat
      set -g TEST ${pkgs.coreutils}/bin/test

      set -g OPEN_URL ${lib.escapeShellArg openCommand}

      # Find the platform's sudo executable once at startup.
      set -g SUDO (command -s sudo)


      # =========================================================================
      # UI helpers
      # =========================================================================

      function pause_any_key
          echo
          read -n 1 -P 'Press any key to return...' ignored
          echo
      end


      function read_menu_key --argument-names prompt
          read -n 1 -P "$prompt" COMMAND_CENTER_KEY
          echo

          set -g COMMAND_CENTER_KEY (
              string lower -- "$COMMAND_CENTER_KEY"
          )
      end


      function ordinal_suffix --argument-names day
          set -l mod100 (math "$day % 100")

          if test "$mod100" -ge 11 -a "$mod100" -le 13
              echo 'th'
              return
          end

          switch (math "$day % 10")
              case 1
                  echo 'st'
              case 2
                  echo 'nd'
              case 3
                  echo 'rd'
              case '*'
                  echo 'th'
          end
      end


      function today_string
          # Note the three single quotes at the end.
          #
          # The desired generated Fish source contains an empty single-quoted
          # string. Nix indented strings require ''' to emit that literal pair.
          set -l day ($DATE '+%d' | string replace -r '^0' ''')
          set -l suffix (ordinal_suffix "$day")

          printf '%s, %s %s%s' \
              ($DATE '+%A') \
              ($DATE '+%B') \
              "$day" \
              "$suffix"
      end


      function rebuild_age
          set -l profile /nix/var/nix/profiles/system

          if not test -e "$profile"
              echo 'unknown'
              return
          end

          set -l then ($STAT -c '%Y' "$profile" 2>/dev/null)

          if test -z "$then"
              echo 'unknown'
              return
          end

          set -l now ($DATE '+%s')
          set -l days (math "floor(($now - $then) / 86400)")

          echo "$days"
      end


      # =========================================================================
      # Privilege / runtime secret helpers
      # =========================================================================

      function authenticate_sudo
          if test -z "$SUDO"
              echo 'ERROR: sudo could not be found in PATH.'
              return 1
          end

          # This is the normal point where the user enters:
          #
          #   sudo password + Enter
          #
          # All normal menu interaction otherwise uses single keys.
          "$SUDO" -v
      end


      function secret_file_exists --argument-names path
          # The secret directory itself may be root-only, so an ordinary
          # `test -f` cannot reliably determine whether this file exists.
          #
          # Check it through sudo instead.
          "$SUDO" "$TEST" -f "$path"
      end


      function validate_secret_file --argument-names path
          if not secret_file_exists "$path"
              echo
              echo 'ERROR: required runtime secret file is unavailable:'
              echo "  $path"
              return 1
          end

          return 0
      end


      function validate_restic_secrets --argument-names password_file
          validate_secret_file "$AWS_ACCESS_KEY_FILE"; or return 1
          validate_secret_file "$AWS_SECRET_KEY_FILE"; or return 1
          validate_secret_file "$password_file"; or return 1

          return 0
      end


      function read_root_secret --argument-names path
          "$SUDO" "$CAT" "$path"
      end


      # =========================================================================
      # Restic execution helpers
      # =========================================================================

      function restic_user
          set -l repo "$argv[1]"
          set -l password_file "$argv[2]"
          set -l restic_args $argv[3..-1]

          validate_restic_secrets "$password_file"; or return 1

          set -l access_key (
              read_root_secret "$AWS_ACCESS_KEY_FILE"
          )

          if test $status -ne 0
              return 1
          end


          set -l secret_key (
              read_root_secret "$AWS_SECRET_KEY_FILE"
          )

          if test $status -ne 0
              return 1
          end


          # Exported only within this function and its child processes.
          set -lx AWS_ACCESS_KEY_ID "$access_key"
          set -lx AWS_SECRET_ACCESS_KEY "$secret_key"


          # Do NOT load the Restic password into Fish.
          #
          # Restic executes this command when it needs its password. Since sudo
          # has already been authenticated, it can read the root-only file.
          set -lx RESTIC_PASSWORD_COMMAND (
              string join ' ' \
                  (string escape -- "$SUDO") \
                  (string escape -- "$CAT") \
                  (string escape -- "$password_file")
          )


          "$RESTIC" \
              -r "$repo" \
              $restic_args
      end


      function restic_root
          set -l repo "$argv[1]"
          set -l password_file "$argv[2]"
          set -l restic_args $argv[3..-1]

          validate_restic_secrets "$password_file"; or return 1


          # Whole-machine backups need elevated filesystem access.
          #
          # The root Fish process reads the credentials itself, so credential
          # values are never put into:
          #
          #   - command-line arguments
          #   - this generated script
          #   - the Nix store
          #
          "$SUDO" "$ROOT_FISH" -c '
              set -lx AWS_ACCESS_KEY_ID (
                  $argv[1] $argv[2]
              )

              set -lx AWS_SECRET_ACCESS_KEY (
                  $argv[1] $argv[3]
              )

              exec \
                  $argv[5] \
                  -r $argv[6] \
                  --password-file $argv[4] \
                  $argv[7..-1]
          ' \
              "$CAT" \
              "$AWS_ACCESS_KEY_FILE" \
              "$AWS_SECRET_KEY_FILE" \
              "$password_file" \
              "$RESTIC" \
              "$repo" \
              $restic_args
      end


      # =========================================================================
      # Rebuild functions
      # =========================================================================

      function rebuild_system
          clear

          echo "Rebuilding $HOST_DISPLAY_NAME..."
          echo

          authenticate_sudo; or begin
              echo
              echo 'sudo authentication failed.'
              pause_any_key
              return 1
          end


          if test "$PLATFORM" = 'darwin'
              set -l rebuild_bin (command -s darwin-rebuild)

              if test -z "$rebuild_bin"
                  echo 'ERROR: darwin-rebuild could not be found in PATH.'
                  pause_any_key
                  return 1
              end

              "$SUDO" "$rebuild_bin" switch \
                  --flake "$FLAKE_PATH#$FLAKE_TARGET"

          else
              set -l rebuild_bin (command -s nixos-rebuild)

              if test -z "$rebuild_bin"
                  echo 'ERROR: nixos-rebuild could not be found in PATH.'
                  pause_any_key
                  return 1
              end

              "$SUDO" "$rebuild_bin" switch \
                  --flake "$FLAKE_PATH#$FLAKE_TARGET"
          end


          set -l result $status
          pause_any_key
          return $result
      end


      function update_and_rebuild
          clear

          echo 'Updating flake:'
          echo "  $FLAKE_PATH"
          echo

          "$NIX" flake update \
              --flake "$FLAKE_PATH"

          if test $status -ne 0
              echo
              echo 'Flake update failed. Rebuild cancelled.'
              pause_any_key
              return 1
          end

          rebuild_system
      end


      # =========================================================================
      # Webpage shortcuts
      # =========================================================================

      function open_url --argument-names url
          "$OPEN_URL" "$url" >/dev/null 2>&1 &
      end


      function webpage_menu
          while true
              clear

              echo 'Webpage shortcuts'
              echo

              # MODIFY ME:
              echo '1) NixOS package/options search'
              echo '2) Home Manager options'
              echo '3) GitHub'

              echo
              echo 'b) Back'
              echo

              read_menu_key '> '

              switch "$COMMAND_CENTER_KEY"
                  case 1
                      open_url 'https://search.nixos.org/'

                  case 2
                      open_url \
                          'https://nix-community.github.io/home-manager/options.xhtml'

                  case 3
                      open_url 'https://github.com/'

                  case b q
                      return
              end
          end
      end


      # =========================================================================
      # Repository selection
      # =========================================================================

      function select_repo --argument-names key
          switch "$key"
              case desktop
                  set -g SELECTED_REPO_KEY 'desktop'
                  set -g SELECTED_REPO_NAME 'NixOS machine backup'
                  set -g SELECTED_REPO "$REPO_DESKTOP"
                  set -g SELECTED_PASSWORD_FILE "$REPO_DESKTOP_PASSWORD"

              case raspi
                  set -g SELECTED_REPO_KEY 'raspi'
                  set -g SELECTED_REPO_NAME 'NixOS Pi backup'
                  set -g SELECTED_REPO "$REPO_RASPI"
                  set -g SELECTED_PASSWORD_FILE "$REPO_RASPI_PASSWORD"

              case macbook
                  set -g SELECTED_REPO_KEY 'macbook'
                  set -g SELECTED_REPO_NAME 'MacBook backup'
                  set -g SELECTED_REPO "$REPO_MACBOOK"
                  set -g SELECTED_PASSWORD_FILE "$REPO_MACBOOK_PASSWORD"

              case windows
                  set -g SELECTED_REPO_KEY 'windows'
                  set -g SELECTED_REPO_NAME 'Windows machine backup'
                  set -g SELECTED_REPO "$REPO_WINDOWS"
                  set -g SELECTED_PASSWORD_FILE "$REPO_WINDOWS_PASSWORD"

              case '*'
                  return 1
          end

          return 0
      end


      # =========================================================================
      # Restic actions
      # =========================================================================

      function require_restic
          if test -z "$RESTIC"
              clear
              echo 'WARNING: restic is not installed or is not available in PATH.'
              echo
              echo 'Restic commands are unavailable on this host.'
              pause_any_key
              return 1
          end

          return 0
      end


      function mount_selected_repo
          clear

          echo 'Repository:'
          echo "  $SELECTED_REPO_NAME"
          echo
          echo 'Mountpoint on this host:'
          echo "  $RESTIC_MOUNT_POINT"
          echo


          "$MKDIR" -p "$RESTIC_MOUNT_POINT"

          if test $status -ne 0
              echo
              echo 'ERROR: could not create/access Restic mountpoint.'
              pause_any_key
              return 1
          end


          echo 'Restic will remain attached to this terminal while mounted.'
          echo 'Press Ctrl-C when you want to stop the mount.'
          echo


          restic_user \
              "$SELECTED_REPO" \
              "$SELECTED_PASSWORD_FILE" \
              mount \
              "$RESTIC_MOUNT_POINT"


          pause_any_key
      end


      function show_snapshots
          clear

          echo 'Snapshots in:'
          echo "  $SELECTED_REPO_NAME"
          echo


          restic_user \
              "$SELECTED_REPO" \
              "$SELECTED_PASSWORD_FILE" \
              snapshots


          pause_any_key
      end


      # Free-form text input without Enter.
      #
      # Type the desired value and press | to submit it.
      #
      # The | character itself is not included in the result.
      function read_text_without_enter --argument-names prompt
          set -l value

          printf '%s' "$prompt" >&2

          while true
              read -n 1 char

              if test $status -ne 0
                  printf '\n' >&2
                  return 1
              end


              if test "$char" = '|'
                  printf '\n' >&2
                  printf '%s\n' "$value"
                  return 0
              end


              set value "$value$char"
          end
      end


      function rewrite_excluding_path
          clear

          echo 'Repository:'
          echo "  $SELECTED_REPO_NAME"
          echo
          echo 'Enter the path/pattern to remove from historical snapshots.'
          echo 'Press | when finished. Enter is not required.'
          echo


          set -l exclusion (
              read_text_without_enter 'Path/pattern: '
          )


          if test -z "$exclusion"
              echo
              echo 'No path was entered.'
              pause_any_key
              return
          end


          clear

          echo 'Repository:'
          echo "  $SELECTED_REPO_NAME"
          echo
          echo 'Exclude:'
          echo "  $exclusion"
          echo
          echo '1) Dry-run only'
          echo '2) Dry-run, then optionally perform real rewrite'
          echo '3) Perform real rewrite immediately'
          echo
          echo 'b) Cancel'
          echo


          read_menu_key '> '


          switch "$COMMAND_CENTER_KEY"
              case 1
                  restic_user \
                      "$SELECTED_REPO" \
                      "$SELECTED_PASSWORD_FILE" \
                      rewrite \
                      --exclude "$exclusion" \
                      --dry-run

                  pause_any_key


              case 2
                  restic_user \
                      "$SELECTED_REPO" \
                      "$SELECTED_PASSWORD_FILE" \
                      rewrite \
                      --exclude "$exclusion" \
                      --dry-run


                  if test $status -ne 0
                      echo
                      echo 'Dry-run failed. Real rewrite cancelled.'
                      pause_any_key
                      return
                  end


                  echo
                  echo 'Perform the REAL rewrite and forget superseded snapshots?'
                  echo
                  echo 'y) Yes'
                  echo 'n) No'
                  echo

                  read_menu_key '> '


                  if test "$COMMAND_CENTER_KEY" = y
                      restic_user \
                          "$SELECTED_REPO" \
                          "$SELECTED_PASSWORD_FILE" \
                          rewrite \
                          --exclude "$exclusion" \
                          --forget
                  end


                  pause_any_key


              case 3
                  restic_user \
                      "$SELECTED_REPO" \
                      "$SELECTED_PASSWORD_FILE" \
                      rewrite \
                      --exclude "$exclusion" \
                      --forget

                  pause_any_key


              case b q
                  return
          end
      end


      function backup_current_machine
          clear


          if test "$SELECTED_REPO_KEY" != "$HOST_BACKUP_REPO"
              echo 'Backup unavailable.'
              echo
              echo "$HOST_DISPLAY_NAME backs up only to its own repository."
              echo
              echo 'Selected repository:'
              echo "  $SELECTED_REPO_NAME"
              pause_any_key
              return 1
          end


          if not test -f "$BACKUP_EXCLUDE_FILE"
              echo 'Refusing backup because the configured exclusion file'
              echo 'does not exist:'
              echo
              echo "  $BACKUP_EXCLUDE_FILE"
              pause_any_key
              return 1
          end


          echo "Back up $HOST_DISPLAY_NAME?"
          echo
          echo 'Repository:'
          echo "  $SELECTED_REPO_NAME"
          echo
          echo 'Backup configuration:'

          if test (count $BACKUP_SOURCES) -gt 0
              echo '  Sources:'
              for source in $BACKUP_SOURCES
                  echo "    $source"
              end
          end

          if test (count $BACKUP_EXTRA_ARGS) -gt 0
              echo '  Additional arguments:'
              for arg in $BACKUP_EXTRA_ARGS
                  echo "    $arg"
              end
          end

          echo '  Exclude file:'
          echo "    $BACKUP_EXCLUDE_FILE"
          echo
          echo 'y) Run dry-run first'
          echo 'n) Skip dry-run and BACK UP NOW'
          echo 'b) Cancel'
          echo


          read_menu_key '> '


          switch "$COMMAND_CENTER_KEY"
              case y
                  clear

                  echo 'Running Restic dry-run...'
                  echo


                  restic_root \
                      "$SELECTED_REPO" \
                      "$SELECTED_PASSWORD_FILE" \
                      backup \
                      $BACKUP_SOURCES \
                      --exclude-file "$BACKUP_EXCLUDE_FILE" \
                      $BACKUP_EXTRA_ARGS \
                      --dry-run \
                      --verbose


                  if test $status -ne 0
                      echo
                      echo 'Dry-run failed. Real backup cancelled.'
                      pause_any_key
                      return 1
                  end


                  echo
                  echo 'Run the REAL backup?'
                  echo
                  echo 'y) Yes'
                  echo 'n) No'
                  echo


                  read_menu_key '> '


                  if test "$COMMAND_CENTER_KEY" != y
                      return
                  end


              case n
                  # Intentionally continue directly to the real backup.


              case b q
                  return


              case '*'
                  return
          end


          clear

          echo "Backing up $HOST_DISPLAY_NAME..."
          echo


          restic_root \
              "$SELECTED_REPO" \
              "$SELECTED_PASSWORD_FILE" \
              backup \
              $BACKUP_SOURCES \
              --exclude-file "$BACKUP_EXCLUDE_FILE" \
              $BACKUP_EXTRA_ARGS \
              --verbose


          pause_any_key
      end


      function repo_action_menu
          while true
              clear

              echo "$SELECTED_REPO_NAME"
              echo
              echo 'Mountpoint on this host:'
              echo "  $RESTIC_MOUNT_POINT"
              echo

              echo '1) Mount repository'
              echo '2) Exclude path from historical snapshots'

              if test "$SELECTED_REPO_KEY" = "$HOST_BACKUP_REPO"
                  echo '3) Back up this machine'
              else
                  echo '3) Backup unavailable — repository belongs to another host'
              end

              echo '4) List snapshots'
              echo
              echo 'b) Back'
              echo


              read_menu_key '> '


              switch "$COMMAND_CENTER_KEY"
                  case 1
                      mount_selected_repo

                  case 2
                      rewrite_excluding_path

                  case 3
                      if test "$SELECTED_REPO_KEY" = "$HOST_BACKUP_REPO"
                          backup_current_machine
                      end

                  case 4
                      show_snapshots

                  case b q
                      return
              end
          end
      end


      function restic_menu
          require_restic; or return

          clear


          # Authenticate once before anything attempts to inspect/read the
          # root-only runtime secret directory.
          authenticate_sudo; or begin
              echo
              echo 'sudo authentication failed.'
              pause_any_key
              return
          end


          while true
              clear

              echo "Restic — $HOST_DISPLAY_NAME"
              echo
              echo 'Which repository would you like to use?'
              echo
              echo '1) NixOS machine backup'
              echo '2) NixOS Pi backup'
              echo '3) MacBook backup'
              echo '4) Windows machine backup'
              echo
              echo 'b) Back'
              echo


              read_menu_key '> '


              switch "$COMMAND_CENTER_KEY"
                  case 1
                      select_repo desktop
                      repo_action_menu

                  case 2
                      select_repo raspi
                      repo_action_menu

                  case 3
                      select_repo macbook
                      repo_action_menu

                  case 4
                      select_repo windows
                      repo_action_menu

                  case b q
                      return
              end
          end
      end


      # =========================================================================
      # Miscellaneous commands
      # =========================================================================

      function misc_menu
          while true
              clear

              echo 'Misc commands'
              echo
              echo '1) Check flake'
              echo '2) Show current system generation'
              echo
              # MODIFY ME: add other commands here.
              echo
              echo 'b) Back'
              echo


              read_menu_key '> '


              switch "$COMMAND_CENTER_KEY"
                  case 1
                      clear
                      "$NIX" flake check "$FLAKE_PATH"
                      pause_any_key

                  case 2
                      clear
                      "$READLINK" /run/current-system
                      pause_any_key

                  case b q
                      return
              end
          end
      end


      # =========================================================================
      # Main menu
      # =========================================================================

      function main_menu
          while true
              clear

              set -l age (rebuild_age)


              if test "$age" = unknown
                  printf \
                      'Today is %s. Last system rebuild: unknown.\n' \
                      (today_string)
              else
                  set -l noun 'days'

                  if test "$age" -eq 1
                      set noun 'day'
                  end

                  printf \
                      'Today is %s. Your last system rebuild was %s %s ago.\n' \
                      (today_string) \
                      "$age" \
                      "$noun"
              end


              echo "Host: $HOST_DISPLAY_NAME"
              echo
              echo '1) Update flake and rebuild system'
              echo '2) Rebuild system without updating flake'
              echo '3) Webpage shortcuts'
              echo '4) Restic commands'
              echo '5) Misc commands'
              echo
              echo 'q) Quit'
              echo


              read_menu_key '> '


              switch "$COMMAND_CENTER_KEY"
                  case 1
                      update_and_rebuild

                  case 2
                      rebuild_system

                  case 3
                      webpage_menu

                  case 4
                      restic_menu

                  case 5
                      misc_menu

                  case q
                      return
              end
          end
      end


      main_menu
    '';
  };
}
