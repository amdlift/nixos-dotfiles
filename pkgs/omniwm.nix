{
  lib,
  fetchurl,
  libarchive,
  stdenvNoCC,
}:

# Vendored from DavSanchez's packaging rather than taken as a flake input,
# because upstream ships it inside a personal dotfiles repo whose outputs are
# not a stable API. Bumping a release means editing `version` + `hash` here.
#
# The bsdtar extraction is the important part: `unzip` does not preserve the
# release's Developer ID signature, and a valid signature is the entire reason
# OmniWM is usable on a managed/MDM Mac.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "omniwm";
  version = "0.5.10";

  src = fetchurl {
    url = "https://github.com/BarutSRB/OmniWM/releases/download/v${finalAttrs.version}/OmniWM-v${finalAttrs.version}.zip";
    hash = "sha256-wAPcUl4yvm71YGY4GK8T+FdkUPMMwhZHcOI0V5inpto=";
  };

  dontUnpack = true;

  strictDeps = true;

  nativeBuildInputs = [ libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/
    bsdtar -xf $src -C $out/Applications/

    mkdir -p $out/bin
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/OmniWM $out/bin/OmniWM
    ln -s $out/Applications/OmniWM.app/Contents/MacOS/omniwmctl $out/bin/omniwmctl

    runHook postInstall
  '';

  meta = {
    description = "macOS tiling window manager inspired by Niri and Hyprland";
    longDescription = ''
      OmniWM is a macOS tiling window manager that is developer signed and
      notarized. It features Niri-style scrolling columns and Hyprland-style
      dwindle layouts, with a built-in quake terminal, command palette,
      overview mode, and more.
    '';
    homepage = "https://github.com/BarutSRB/OmniWM";
    license = lib.licenses.gpl2Only;
    mainProgram = "OmniWM";
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
