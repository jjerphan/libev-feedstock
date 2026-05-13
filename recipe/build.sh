# Get an updated config.sub and config.guess
if [[ -d "${BUILD_PREFIX}/share/libtool/build-aux" ]]; then
	cp "${BUILD_PREFIX}"/share/libtool/build-aux/config.* .
elif [[ -d "${BUILD_PREFIX}/Library/usr/share/libtool/build-aux" ]]; then
	cp "${BUILD_PREFIX}"/Library/usr/share/libtool/build-aux/config.* .
fi
./configure --prefix="${PREFIX}"
if [[ "${target_platform}" == win-* ]]; then
	patch_libtool
fi
make
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi
