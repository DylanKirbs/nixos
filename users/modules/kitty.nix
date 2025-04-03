{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    extraConfig = ''
    # Example custom key binding: copy using Ctrl+Shift+c
    map ctrl+shift+c copy_to_clipboard
    # Add further configuration options as desired

    # Molokai Color Scheme
    background            #121212
    foreground            #bbbbbb
    cursor                #bbbbbb
    selection_background  #b4d5ff
    color0                #121212
    color8                #545454
    color1                #fa2573
    color9                #f5669c
    color2                #97e123
    color10               #b0e05e
    color3                #dfd460
    color11               #fef26c
    color4                #0f7fcf
    color12               #00afff
    color5                #8700ff
    color13               #af87ff
    color6                #42a7cf
    color14               #50cdfe
    color7                #bbbbbb
    color15               #ffffff
    selection_foreground #121212

    font_family "FiraCode Nerd Font"
    bold_font auto
    italic_font auto
    bold_italic_font auto
   '';
  };
}

