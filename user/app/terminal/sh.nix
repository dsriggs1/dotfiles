{userSettings, ...}: let
  myAliases = {
    c = "clear";
    nf = "neofetch";
    pf = "pfetch";
    ll = "eza -al --icons";
    lt = "eza -a --tree --level=1 --icons";
    shutdown = "systemctl poweroff";
    v = "nvim";
    ts = "${userSettings.dotfilesDir}/scripts/snapshot.sh";
    matrix = "cmatrix";
    wifi = "nmtui";
    od = "~/private/onedrive.sh";
    rw = "${userSettings.dotfilesDir}/waybar/reload.sh";
    winclass = "xprop | grep 'CLASS'";
    dot = "cd ${userSettings.dotfilesDir}";
    picom = "picom --config ~/.config/picom/picom.conf";
    dotfiles = "cd ${userSettings.dotfilesDir}";
    vim = "nvim";
    # SCRIPTS
    gr = "python ${userSettings.dotfilesDir}/scripts/growthrate.py";
    ChatGPT = "python ~/mychatgpt/mychatgpt.py";
    chat = "python ~/mychatgpt/mychatgpt.py";
    ascii = "${userSettings.dotfilesDir}/scripts/figlet.sh";

    # VIRTUAL MACHINE
    vm = "~/private/launchvm.sh";
    lg = "${userSettings.dotfilesDir}/scripts/looking-glass.sh";
    vmstart = "virsh --connect qemu:///system start win11";
    vmstop = "virsh --connect qemu:///system destroy win11";

    # EDIT CONFIG FILES
    confq = "nvim ~/.config/qtile/config.py";
    confql = "nvim ~/.local/share/qtile/qtile.log";
    confp = "nvim ${userSettings.dotfilesDir}/picom/picom.conf";
    confb = "nvim ~/.bashrc";
    confn = "nvim ${userSettings.dotfilesDir}/configuration.nix";

    # EDIT NOTES
    notes = "nvim ~/notes.txt";

    # NIX SYSTEM
    rebuild = "sudo nixos-rebuild switch --flake ${userSettings.dotfilesDir}#nixos";

    rebuildTest = "sudo nixos-rebuild test --flake ${userSettings.dotfilesDir}#nixos";
    rebuildBoot = "sudo nixos-rebuild boot --flake ${userSettings.dotfilesDir}#nixos";
    rebuildDryRun = "sudo nixos-rebuild dry-run --flake ${userSettings.dotfilesDir}#nixos";
    rebuildBuild = "nixos-rebuild build --flake ${userSettings.dotfilesDir}#nixos";
    rebuildUpgrade = "sudo nixos-rebuild switch --upgrade --flake ${userSettings.dotfilesDir}#nixos";
    rebuildShowTrace = "sudo nixos-rebuild switch --show-trace --flake ${userSettings.dotfilesDir}#nixos";
    rebuildKeepGoing = "sudo nixos-rebuild switch --keep-going --flake ${userSettings.dotfilesDir}#nixos";
    rebuildFast = "sudo nixos-rebuild switch --fast --flake ${userSettings.dotfilesDir}#nixos";
    rebuildRollback = "sudo nixos-rebuild switch --rollback";
    rebuildFlake = "sudo nixos-rebuild switch --flake ${userSettings.dotfilesDir}#nixos";
    # rebuildChannels = "sudo nix-channel --update && sudo nixos-rebuild switch";

    # SCREEN RESOLUTIONS
    res1 = "xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120";
    res2 = "xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120";
    # TMUX sesssions
    tnix = "tmuxinator nixos";
    tnixn = "tmuxinator nixos_nvim";
  };
  myVariables = {
    EDITOR = "nvim";
  };
in {
  programs.bash = {
    enable = true;
    sessionVariables = myVariables;

    shellAliases = myAliases;
    initExtra = ''
                   zl() {
                      z "$@" && ls -la
                   }

            cd() {
                builtin cd "$@" && ls -la
              }

            eval "$(zoxide init bash)"
            eval "$(starship init bash)"

      if [ -f ~/.bash_completion ]; then
          . ~/.bash_completion
      fi

      eval "$(starship completions bash)"
    '';
  };

  programs.zsh = {
    enable = true;
    sessionVariables = myVariables;

    shellAliases = myAliases;
    initContent = ''
      zl() {
                  z "$@" && ls -la
               }

        cd() {
            builtin cd "$@" && ls -la
          }


        eval "$(zoxide init zsh)"
    '';
  };

  programs.nushell = {
    enable = true;
    #configFile.source = ./../config.nu;
    environmentVariables = {
      env.EDITOR = "nvim";
    };
    shellAliases = myAliases;

    #shellAliases = {
    # c = "clear";
    # confq = "$env.EDITOR ~/.config/qtile/config.py";
    #};
    extraConfig = ''                           $env.config = { edit_mode: vi }

      $env.config = { show_banner:false }
                           def --env cd_func [path: string] {
                               cd $path
                     eza -al --icons

                           }
                           alias cd = cd_func

         #      zoxide init nushell | save -f ~/.zoxide.nu
               source ~/.zoxide.nu
        pfetch
    '';

    #extraConfig = ''
    #             zl() {
    #  	  z "$@" && ls -la
    #       }
    # cd() {
    #   builtin cd "$@" && ls -la
    # }
    # eval "$(zoxide init nu)"
    #'';
  };
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
