{ stdenv, fetchgit, pkgconfig, wget, cacert, perl, automake, autoconf, libtool, which, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "zcashd";
  version = "1.0.9";

  src = fetchgit {
    "url" = "https://github.com/zcash/zcash.git";
    "rev" = "a410f124b24f1ebd763015492b029af09b1872a9";
    "sha256" = "0zrnmivxm00x6yffk6kk0c1zqrw9zdfpscr5s6x6dm13lgnwc31c";
    "fetchSubmodules" = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ wget cacert perl automake autoconf libtool which utillinux ];

  patchPhase = ''
    sed -i 's|wget|wget --ca-certificate=${cacert.out}/etc/ssl/certs/ca-bundle.crt|' \
      depends/builders/linux.mk \
      zcutil/fetch-params.sh
  '';

  configureScript = "true";

  buildPhase = ''
    zcutil/build.sh --disable-rust
  '';

  meta = {
    description = "Anonymous peer-to-peer electronic cash system";
    longDescription= ''
      Zcash is an implementation of the "Zerocash" protocol. Based on Bitcoin's
      code, it intends to offer a far higher standard of privacy through a
      sophisticated zero-knowledge proving scheme that preserves
      confidentiality of transaction metadata. Technical details are available
      in our Protocol Specification.
      
      This software is the Zcash client. It downloads and stores the entire 
      history of Zcash transactions; depending on the speed of your computer
      and network connection, the synchronization process could take a day or
      more once the blockchain has reached a significant size.
    '';
    homepage = "https://z.cash/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
