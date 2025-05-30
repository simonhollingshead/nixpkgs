{
  lib,
  replaceVars,
  mkDerivation,
  fetchFromGitHub,
  gitUpdater,
  mobile-broadband-provider-info,
  qmake,
  qtbase,
  qtdeclarative,
}:

mkDerivation rec {
  pname = "libqofono";
  version = "0.124";

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "libqofono";
    rev = version;
    hash = "sha256-fI7RS0V8wrsJ2AZAyjVgHmG+c13DXdo6xTjIlGbOHI8=";
  };

  patches = [
    (replaceVars ./0001-NixOS-provide-mobile-broadband-provider-info-path.patch {
      mobileBroadbandProviderInfo = mobile-broadband-provider-info;
    })
    ./0001-NixOS-Skip-tests-they-re-shock-full-of-hardcoded-FHS.patch
  ];

  # Replaces paths from the Qt store path to this library's store path.
  postPatch = ''
    substituteInPlace src/src.pro \
      --replace /usr $out \
      --replace '$$[QT_INSTALL_PREFIX]' "$out" \
      --replace 'target.path = $$[QT_INSTALL_LIBS]' "target.path = $out/lib"

    substituteInPlace plugin/plugin.pro \
      --replace '$$[QT_INSTALL_QML]' $out'/${qtbase.qtQmlPrefix}'
  '';

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Library for accessing the ofono daemon, and declarative plugin for it";
    homepage = "https://git.sailfishos.org/mer-core/libqofono/";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
