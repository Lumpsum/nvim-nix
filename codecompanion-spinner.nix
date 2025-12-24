{ buildVimPlugin, fetchFromGitHub }:
buildVimPlugin {
    name = "codecompanion-spinner.nvim";
    src = fetchFromGitHub {
      owner = "franco-ruggeri";
      repo = "codecompanion-spinner.nvim";
      rev = "c1fa2a84ea1aed687aaed60df65e347c280f4f22";
      hash = "sha256-+lalwWE02YlLlU5zSqBotI5YstDuXtF8k0e6b7lxnhU=";
    };
}
