{ buildVimPlugin, fetchFromGitHub }:
buildVimPlugin {
    name = "lazydev.nvim";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "lazydev.nvim";
      rev = "371cd7434cbf95606f1969c2c744da31b77fcfa6";
      hash = "sha256-WxcJyUROhvPe2rVflFNMQQ6gCaU1e/HnbjmnqPTAxqM=";
    };
}
