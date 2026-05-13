#!/usr/bin/env bash

make install

if [[ "${target_platform}" == win-* ]]; then
	if [[ "$PKG_NAME" == *static ]]; then
		if [[ -f "${PREFIX}/lib/libev.lib" ]]; then
			mv "${PREFIX}/lib/libev.lib" "${PREFIX}/lib/libev_static.lib"
		fi
		rm -f "${PREFIX}"/lib/libev.dll.lib "${PREFIX}"/bin/libev*.dll
	else
		rm -f "${PREFIX}/lib/libev.lib" "${PREFIX}/lib/libev_static.lib"
	fi
elif [[ "$PKG_NAME" == *static ]]; then
	# relying on conda to dedup package
	echo "Keeping all files, conda will dedupe"
else
	rm -rf "${PREFIX}/lib/libev.a"
fi

if [[ "$PKG_NAME" != *-libevent ]]; then
	rm -f "${PREFIX}/include/event.h"
fi
