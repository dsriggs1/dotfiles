{
  programs.nixvim = {
    keymaps = [
      #{
      # action = "<cmd>Telescope live_grep<CR>";
      #key = "<leader>g";
      #}
      {
        mode = "n";
        key = "<C-f>";
        action = "!tmux new tmux-sessionizer<CR>";
        options = {
          desc = "Switch between projects";
        };
      }
      {
        key = "<C-n>";
        action = "<CMD>NvimTreeToggle<CR>";
        options.desc = "Toggle NvimTree";
      }
      {
        key = "<leader>gc";
        action = ":Git commit<CR>";
        options.desc = "Commit";
      }
      {
        key = "<leader>ga";
        action = ":Git add";
        options.desc = "Git Add";
      }
      {
        key = "<leader>gca";
        action = ":Git commit --amend<CR>";
        options.desc = "Git Commit Amend";
      }
      {
        key = "<leader>gcan";
        action = ":Git commit --amend --no-edit<CR>";
        options.desc = "Git Commit Amend No Edit";
      }
      {
        key = "<leader>gcl";
        action = ":Git clone<CR>";
        options.desc = "Git Clone";
      }
      {
        key = "<leader>gcm";
        action = ":Git commit -m<CR>";
        options.desc = "Git Commit Message";
      }
      {
        key = "<leader>gco";
        action = ":Git checkout<CR>";
        options.desc = "Git Checkout";
      }
      {
        key = "<leader>gcp";
        action = ":Git cherry-pick<CR>";
        options.desc = "Git Cherry Pick";
      }
      {
        key = "<leader>gcpx";
        action = ":Git cherry-pick -x<CR>";
        options.desc = "Git Cherry Pick X";
      }
      {
        key = "<leader>gd";
        action = ":Git diff<CR>";
        options.desc = "Git Diff";
      }
      {
        key = "<leader>gf";
        action = ":Git fetch<CR>";
        options.desc = "Git Fetch";
      }
      {
        key = "<leader>gfo";
        action = ":Git fetch origin<CR>";
        options.desc = "Git Fetch Origin";
      }
      {
        key = "<leader>gfu";
        action = ":Git fetch upstream<CR>";
        options.desc = "Git Fetch Upstream";
      }
      {
        key = "<leader>ggds";
        action = ":Git diff --staged<CR>";
        options.desc = "Git Diff Staged";
      }
      {
        key = "<leader>glol";
        action = ":Git log --graph --decorate --pretty=oneline --abbrev-commit<CR>";
        options.desc = "Git Log Graph";
      }
      {
        key = "<leader>glola";
        action = ":Git log --graph --decorate --pretty=oneline --abbrev-commit --all<CR>";
        options.desc = "Git Log Graph All";
      }
      {
        key = "<leader>gpl";
        action = ":Git pull<CR>";
        options.desc = "Git Pull";
      }
      {
        key = "<leader>gpr";
        action = ":Git pull -r<CR>";
        options.desc = "Git Pull Rebase";
      }
      {
        key = "<leader>gps";
        action = ":Git push<CR>";
        options.desc = "Git Push";
      }
      {
        key = "<leader>gpsf";
        action = ":Git push -f<CR>";
        options.desc = "Git Push Force";
      }
      {
        key = "<leader>grb";
        action = ":Git rebase<CR>";
        options.desc = "Git Rebase";
      }
      {
        key = "<leader>grbi";
        action = ":Git rebase -i<CR>";
        options.desc = "Git Rebase Interactive";
      }
      {
        key = "<leader>gr";
        action = ":Git remote<CR>";
        options.desc = "Git Remote";
      }
      {
        key = "<leader>gra";
        action = ":Git remote add<CR>";
        options.desc = "Git Remote Add";
      }
      {
        key = "<leader>grr";
        action = ":Git remote rm<CR>";
        options.desc = "Git Remote Remove";
      }
      {
        key = "<leader>grv";
        action = ":Git remote -v<CR>";
        options.desc = "Git Remote Verbose";
      }
      {
        key = "<leader>grs";
        action = ":Git remote show<CR>";
        options.desc = "Git Remote Show";
      }
      {
        key = "<leader>g";
        action = ":Git status<CR>";
        options.desc = "Git Status";
      }
    ];
  };
}
