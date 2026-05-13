if [[ "${LIBEV_OUTPUT_INSTALL:-}" == "1" ]]; then
	make install

	if [[ "$PKG_NAME" == *static ]]; then
		if [[ -f "${PREFIX}/lib/libev.lib" ]]; then
			mv "${PREFIX}/lib/libev.lib" "${PREFIX}/lib/libev_static.lib"
		fi
		rm -f "${PREFIX}"/lib/libev.dll.lib "${PREFIX}"/bin/libev*.dll
	else
		rm -f "${PREFIX}/lib/libev.lib" "${PREFIX}/lib/libev_static.lib"
	fi

	rm -f "${PREFIX}/include/event.h"
	return 0 2>/dev/null || exit 0
fi

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
