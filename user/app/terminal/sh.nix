{...}: let
  myAliases = {
    c = "clear";
    nf = "neofetch";
    pf = "pfetch";
    ll = "eza -al --icons";
    lt = "eza -a --tree --level=1 --icons";
    shutdown = "systemctl poweroff";
    v = "nvim";
    ts = "~/dotfiles/scripts/snapshot.sh";
    matrix = "cmatrix";
    wifi = "nmtui";
    od = "~/private/onedrive.sh";
    rw = "~/dotfiles/waybar/reload.sh";
    winclass = "xprop | grep 'CLASS'";
    dot = "cd ~/dotfiles";
    picom = "picom --config ~/.config/picom/picom.conf";
    dotfiles = "cd ~/Downloads/dotfiles";
    vim = "nvim";
    # SCRIPTS
    gr = "python ~/dotfiles/scripts/growthrate.py";
    ChatGPT = "python ~/mychatgpt/mychatgpt.py";
    chat = "python ~/mychatgpt/mychatgpt.py";
    ascii = "~/dotfiles/scripts/figlet.sh";

    # VIRTUAL MACHINE
    vm = "~/private/launchvm.sh";
    lg = "~/dotfiles/scripts/looking-glass.sh";
    vmstart = "virsh --connect qemu:///system start win11";
    vmstop = "virsh --connect qemu:///system destroy win11";

    # EDIT CONFIG FILES
    confq = "nvim ~/.config/qtile/config.py";
    confql = "nvim ~/.local/share/qtile/qtile.log";
    confp = "nvim ~/dotfiles/picom/picom.conf";
    confb = "nvim ~/.bashrc";
    confn = "nvim ~/Downloads/dotfiles/configuration.nix";

    # EDIT NOTES
    notes = "nvim ~/notes.txt";

    # NIX SYSTEM
    rebuild = "sudo nixos-rebuild switch";

    rebuildTest = "sudo nixos-rebuild test";
    rebuildBoot = "sudo nixos-rebuild boot";
    rebuildDryRun = "sudo nixos-rebuild dry-run";
    rebuildBuild = "nixos-rebuild build";
    rebuildUpgrade = "sudo nixos-rebuild switch --upgrade";
    rebuildShowTrace = "sudo nixos-rebuild switch --show-trace";
    rebuildKeepGoing = "sudo nixos-rebuild switch --keep-going";
    rebuildFast = "sudo nixos-rebuild switch --fast";
    rebuildRollback = "sudo nixos-rebuild switch --rollback";
    rebuildFlake = "sudo nixos-rebuild switch --flake .#hostname";
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
    initExtra = ''
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
