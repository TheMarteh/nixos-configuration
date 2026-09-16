{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      name = "TheMarteh";
      email = "martijnfs@me.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  home.packages = [ pkgs.lazygit ];
}
