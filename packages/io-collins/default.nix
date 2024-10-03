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
    zero = "slashed"
    at = "fourfold"
    asterisk = "hex-low"
    number-sign = "upright-open"
    percent = "rings-segmented-slash"
    lig-single-arrow-bar = "without-notch"
    caret = "low"

    [buildPlans.IosevkaIOCollins.variants.italic]
    x = "straight-serifless"

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
