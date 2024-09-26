{ pkgs, ... }:

pkgs.iosevka.override {
  privateBuildPlan = ''
    [buildPlans.IosevkaIOCollins]
    family = "IOCollins"
    spacing = "term"
    serifs = "sans"
    noCvSs = true
    exportGlyphNames = true

    [buildPlans.IosevkaIOCollins.variants]
    inherits = "ss15"

    [buildPlans.IosevkaIOCollins.variants.design]
    asterisk = "hex-low"
    number-sign = "upright-open"
    percent = "rings-continuous-slash-also-connected"
    lig-single-arrow-bar = "without-notch"
    caret = "low"

    [buildPlans.IosevkaIOCollins.ligations]
    inherits = "dlig"

    [buildPlans.IosevkaIOCollins.widgths.Condensed]
    shape = 500
    menu = 3
    css = "condensed"

    [buildPlans.IosevkaIOCollins.widths.Normal]
    shape = 600
    menu = 5
    css = "normal"
  '';
  set = "IOCollins";
}
