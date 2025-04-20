{ buildGoModule
, fetchFromGitHub
, lib
, udev
, nix-update-script
}:

buildGoModule rec {
  pname = "openlinkhub";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "jurkovic-nikola";
    repo = "OpenLinkHub";
    tag = version;
    hash = "sha256-cfnijxmn4Oe/t+K/N1JDTSQ3JSYyzB85gXj7OJ5hqr4=";
  };

  proxyVendor = true;

  vendorHash = "sha256-nDE3GUZl5OBSlhRpJBixUbWhhFMeieidNrSIzOOB/9g=";

  buildInputs = [
    udev
  ];

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    mkdir -p $out/share/OpenLinkHub
    cp -r database $out/share/OpenLinkHub
    cp -r static $out/share/OpenLinkHub
    cp -r web $out/share/OpenLinkHub

    mkdir -p $out/lib/udev/rules.d/
    cp *.rules $out/lib/udev/rules.d/
  '';

  meta = {
    homepage = "https://github.com/jurkovic-nikola/OpenLinkHub";
    platforms = lib.platforms.linux;
    description = "Open source interface for iCUE LINK Hub and other Corsair AIOs, Hubs for Linux";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.gpl3Only;
    mainProgram = "OpenLinkHub";
    changelog = "https://github.com/jurkovic-nikola/OpenLinkHub/releases/tag/${version}";
  };
}
