{ pkgs, ... }:
{
  programs.anyrun = {
    enable = true;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.4;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "top";
      hidePluginInfo = false;
      closeOnClick = true;
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
      * {
        font-size: 28px;
        color: #cdd6f4;
      }

      window {
        background-color: transparent;
      }

      box.main {
        background-color: transparent;
        padding: 0;
      }

      entry {
        min-height: 64px;
        padding: 16px 24px;
        background: rgba(30, 30, 46, 0.9);
        border-radius: 16px;
        box-shadow: none;
        border: 1px solid rgba(69, 71, 90, 0.6);
        color: #cdd6f4;
        font-size: 32px;
        caret-color: #cdd6f4;
      }

      box.matches {
        background: transparent;
        padding: 12px 0;
        margin-top: 16px;
      }

      box.plugin {
        background: transparent;
        padding: 8px 16px;
      }

      box.plugin box.info {
        margin-bottom: 12px;
        margin-left: 8px;
      }

      box.match {
        padding: 14px 24px;
        margin: 4px 12px;
        border-radius: 8px;
      }

      list row:selected,
      listview row:selected {
        background: rgba(69, 71, 90, 0.5);
        background-color: rgba(69, 71, 90, 0.5);
        border-left: 4px solid #cba6f7;
        border-radius: 8px;
      }

      list row:selected box.match,
      listview row:selected box.match {
        background: transparent;
        background-color: transparent;
        border: none;
      }

      box.match label.title {
        font-size: 28px;
      }

      box.match label.description {
        font-size: 20px;
        color: #a6adc8;
      }
    '';
  };
}
