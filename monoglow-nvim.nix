{ buildVimPlugin, fetchFromGitHub }:
buildVimPlugin {
    name = "monoglow-nvim";
    src = fetchFromGitHub {
      owner = "wnkz";
      repo = "monoglow.nvim";
      rev = "95a2595f5ea3b8ee94d7030f7970746b363ad47f";
      hash = "sha256-GqrD+DnzIOHeBRRWR2qszOcPt2BMfelJLrCVu+2g0Ww=";
    };
}
