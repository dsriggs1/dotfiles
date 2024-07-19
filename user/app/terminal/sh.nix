{
  config,
  pkgs,
  ...
}: let
  myAliases = {
    c = "clear";
    nf = "neofetch";
    pf = "pfetch";
    ll = "eza -al --icons";
    lt = "eza -a --tree --level=1 --icons";
    shutdown = "systemctl poweroff";
    v = "$EDITOR";
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
    confq = "$EDITOR ~/.config/qtile/config.py";
    confql = "$EDITOR ~/.local/share/qtile/qtile.log";
    confp = "$EDITOR ~/dotfiles/picom/picom.conf";
    confb = "$EDITOR ~/.bashrc";
    confn = "$EDITOR ~/Downloads/dotfiles/configuration.nix";

    # EDIT NOTES
    notes = "$EDITOR ~/notes.txt";

    # NIX SYSTEM
    rebuild = "sudo nixos-rebuild switch";

    # SCREEN RESOLUTIONS
    res1 = "xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120";
    res2 = "xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120";
  };
  myVariables = {
    EDITOR = "code";
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
}
