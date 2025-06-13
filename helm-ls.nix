{ buildVimPlugin, fetchFromGitHub }:
buildVimPlugin {
    name = "helm-ls.nvim";
    src = fetchFromGitHub {
      owner = "qvalentin";
      repo = "helm-ls.nvim";
      rev = "2bf45466c26a24e05b5266f82a3abead13e32c16";
      hash = "sha256-2pf8YrLJgnX92JZrlxQPCq6Rl/Xh5TOyX0Sf4vC4FUA=";
    };
}
