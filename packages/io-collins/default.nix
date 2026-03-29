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
    lower-lambda = "straight-turn"
    brace = "straight"
    lig-ltgteq = "slanted"
    lig-equal-chain = "without-notch"
    lig-hyphen-chain = "without-notch"
    lig-single-arrow-bar = "without-notch"
    caret = "low"

    [buildPlans.IosevkaIOCollins.variants.italic]
    x = "straight-serifless"

    [buildPlans.IosevkaIOCollins.ligations]
    inherits = "dlig"

    [buildPlans.IosevkaIOCollins.widths.Condensed]
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
