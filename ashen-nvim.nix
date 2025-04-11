{ buildVimPlugin, fetchFromGitHub }:
let
    version = "v0.11.0";
in 
    buildVimPlugin {
        name = "ashen-nvim";
        src = fetchFromGitHub {
          owner = "ficcdaf";
          repo = "ashen.nvim";
          rev = version;
          hash = "sha256-mZqEEw376+QjbgQ6/08flbe3CPXpTS5mObNZn99Rrbw=";
        };
    }
