{ pkgs, ... }:
{
  programs.anyrun = {
    enable = true;
    package = pkgs.anyrun;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "top";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = true;
      maxEntries = null;

      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        "${pkgs.anyrun}/lib/libapplications.so"
        # "${pkgs.anyrun}/lib/libkidex.so"
        # shell
      ];
    };

    extraCss = ''
            #window {
              background-color: rgba(0, 0, 0, 0);
              font-size: 20px;
              color: #ffffff;
            }

            box#main {
              background-color: rgba(38, 38, 38, 0.8);
            }

            entry#entry {
              min-height: 40px;
              background: transparent;
              box-shadow: none;
              border: none;
            }

            list#main {
              color: #FFFFFF;
              background-color: rgba(0, 0, 0, 0);
            }

            #plugin {
              background: transparent;
              padding-bottom: 5px;
            }

            #match {
              padding: 2.5px;
            }

            #match:selected {
              background: transparent;
              border-right: 4px solid #7e9cd8;
              border-left: 4px solid #7e9cd8;
              border-radius: 4px;
            }

            #match:selected label#info {
              animation: fade 0.1s linear
            }

            @keyframes fade {
              0% {
                color: transparent;
              }

              100% {
                color: #b0b0b0;
              }
            }
      /*
            #match label#info {
              color: transparent;
            }

            #match:hover {
              background: transparent;
            }

            label#match-desc {
              font-size: 20px;
            }

            label#plugin {
              font-size: 14px;
            }
            */
    '';
 };
};
