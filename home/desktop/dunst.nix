{ ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#2D2B40";
        geometry = "350x200-18+20";
        padding = 16;
        horizontal_padding = 16;
        separator_color = "#585273";
      };

      urgency_low = {
        background = "#2D2B40";
      };

      urgency_normal = {
        background = "#2D2B40";
      };

      urgency_high = {
        background = "#2D2B40";
      };

      discord = {
        appname = "Discord";
        urgency = "low";
      };
    };
  };
}
