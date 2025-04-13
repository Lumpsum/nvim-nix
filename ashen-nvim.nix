{ buildVimPlugin, fetchFromGitHub }:
buildVimPlugin {
    name = "ashen-nvim";
    src = fetchFromGitHub {
      owner = "ficcdaf";
      repo = "ashen.nvim";
      rev = "v0.11.0";
      hash = "sha256-mZqEEw376+QjbgQ6/08flbe3CPXpTS5mObNZn99Rrbw=";
    };
}
