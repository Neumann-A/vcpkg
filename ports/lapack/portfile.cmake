SET(VCPKG_POLICY_EMPTY_PACKAGE enabled)

vcpkg_acquire_msys(msys_root
    DIRECT_PACKAGES
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-gcc-fortran-11.2.0-8-any.pkg.tar.zst"
        d56483e090f86410b87526dda7774e010d0bd6beda97edcaeb1dead1128fd5ad870bc761a8a190759c48d58c2526b6975fb849f9c03a6be193741a0fd0bf2812
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-gcc-libgfortran-11.2.0-8-any.pkg.tar.zst"
        8537b55633bc83d81d528378590e417ffe8c26b6c327d8b6d7ba50a8b5f4e090fbe2dc500deb834120edf25ac3c493055f4de2dc64bde061be23ce0f625a8893
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-gcc-libs-11.2.0-8-any.pkg.tar.zst"
        2481f7c8db7cca549911bc71715af86ca287ffed6d673c9a6c3a4c792b68899a129dd959214af7067f434e74fc518c43749e7d928cbd2232ab4fbc65880dad98
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-gmp-6.2.1-3-any.pkg.tar.zst"
        d0d4ed1a046b64f437e72bbcf722b30311dde5f5e768a520141423fc0a3127b116bd62cfd4b5cf5c01a71ee0f9cf6479fcc31277904652d8f6ddbf16e33e0b72
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-libwinpthread-git-9.0.0.6373.5be8fcd83-1-any.pkg.tar.zst"
        a2c9e60d23b1310a6cec1fadd2b15a8c07223f3fe90d41b1579e9fc27ee2b0b408456291a55fad54a156e6a247efc20f6fcc247cc567e64fe190938aa3b672e9
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-winpthreads-git-9.0.0.6373.5be8fcd83-1-any.pkg.tar.zst"
        be03433e6006166e5b4794f2a01730cdb6c9f19fa96bd10a8bc50cf06ad389cbc66d44ea3eda46f53c3b2c89e2fc86aec21a372828e9527b24480c87ed88348c
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-mpc-1.2.1-1-any.pkg.tar.zst"
        f2c137dbb0b6feea68dde9739c38b44dcb570324e3947adf991028e8f63c9ff50a11f47be15b90279ff40bcac7f320d952cfc14e69ba8d02cf8190c848d976a1
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-mpfr-4.1.0.p13-1-any.pkg.tar.zst"
        a1425169c1570dbd736c31d50bedfab88636bf9565376e2da566be67fcc771e6c76f95895f382d81097e7c0580acb42aa49e34dec5d7a868d73a5dc6a7461c95
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-gcc-11.2.0-8-any.pkg.tar.zst"
        26ab2cab684206978a254f1e1595b1ce688e6db12e57ed1d243a5f1b3b21b314f640c7c6fe90eedccb6b9788e1886415ca3290d03b1e71f67f8a99108068336a
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-binutils-2.37-4-any.pkg.tar.zst"
        f09ea70810fb337d7f3ec673342ab90df511e6af451e273fe88fe41a2f30bd972b79c830b61bb5388743d00a0ba7885503e143987413db5170c4befffef66303
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-crt-git-9.0.0.6373.5be8fcd83-1-any.pkg.tar.zst"
        63d081fedd1f70e8d58670d4d0698535a67f04c31caf02d0b23026ac23fc5064e9423d73c79854bbce41cc99dd0b70e4137af3a609e05cdd867fdcea120d356e
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-headers-git-9.0.0.6373.5be8fcd83-1-any.pkg.tar.zst"
        05860f2bcfacf54089b750099f9ddc52d9b4b8ae8f69028a198dfb51fab09c37a941ae551e5d361a2a11302d48bd4fa95c44131ddee4c1df5a14f28013398f63
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-libiconv-1.16-2-any.pkg.tar.zst"
        542ed5d898a57a79d3523458f8f3409669b411f87d0852bb566d66f75c96422433f70628314338993461bcb19d4bfac4dadd9d21390cb4d95ef0445669288658
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-windows-default-manifest-6.4-3-any.pkg.tar.xz"
        77d02121416e42ff32a702e21266ce9031b4d8fc9ecdb5dc049d92570b658b3099b65d167ca156367d17a76e53e172ca52d468e440c2cdfd14701da210ffea37
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-zlib-1.2.11-9-any.pkg.tar.zst"
        f386d3a8d8c169a62a4580af074b7fdc0760ef0fde22ef7020a349382dd374a9e946606c757d12da1c1fe68baf5e2eaf459446e653477035a63e0e20df8f4aa0
        "https://repo.msys2.org/mingw/x86_64/mingw-w64-x86_64-zstd-1.5.2-1-any.pkg.tar.zst"
        38ec5ca99c5b955bf8a892a3edaf4e18572977736809b7671c554526b13cb4e53d45c5b83e37e0fb7628483ba98831b3203e3e404dac720d5b2ed95cfe4505c4
)
# Make sure LAPACK can be found
vcpkg_configure_cmake(SOURCE_PATH ${CURRENT_PORT_DIR}
                      PREFER_NINJA
                      OPTIONS -DCMAKE_PREFIX_PATH="${CURRENT_PACKAGES_DIR}" -DMINGW_ROOT=${msys_root})
