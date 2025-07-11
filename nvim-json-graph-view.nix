{ buildVimPlugin, fetchFromGitHub }:
buildVimPlugin {
    name = "nvim_json_graph_view";
    src = fetchFromGitHub {
      owner = "Owen-Dechow";
      repo = "nvim_json_graph_view";
      rev = "93d6609728214b1180b3aa68dfd3d4ca277da996";
      hash = "sha256-/cK4QtvyGU/Y0L+go918TlY/zLqq2qxc8NJlCI2B0X4=";
    };
}
