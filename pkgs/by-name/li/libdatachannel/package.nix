{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  libnice,
  openssl,
  plog,
  srtp,
  usrsctp,
}:

stdenv.mkDerivation rec {
  pname = "libdatachannel";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libdatachannel";
    rev = "v${version}";
    hash = "sha256-bzheNNG6J0tswFZT+Vlqm2FS9MArois46yb8XeL5YqI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    libnice
    openssl
    srtp
    usrsctp
    plog
  ];

  cmakeFlags = [
    "-DUSE_NICE=ON"
    "-DPREFER_SYSTEM_LIB=ON"
    "-DNO_EXAMPLES=ON"
  ];

  postFixup = ''
    # Fix include path that will be incorrect due to the "dev" output
    substituteInPlace "$dev/lib/cmake/LibDataChannel/LibDataChannelTargets.cmake" \
      --replace-fail "\''${_IMPORT_PREFIX}/include" "$dev/include"
  '';

  meta = with lib; {
    description = "C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets";
    homepage = "https://libdatachannel.org/";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ erdnaxe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
