(
echo #!/usr/bin/env bash
echo set -ex
echo.
echo if [[ ${LIBEV_OUTPUT_INSTALL:-} == 1 ]]; then
echo     make install
echo.
echo     if [[ $PKG_NAME == *static ]]; then
echo         if [[ -f ${PREFIX}/lib/libev.lib ]]; then
echo             mv ${PREFIX}/lib/libev.lib ${PREFIX}/lib/libev_static.lib
echo         fi
echo         rm -f ${PREFIX}/lib/libev.dll.lib ${PREFIX}/bin/libev*.dll
echo     else
echo         rm -f ${PREFIX}/lib/libev.lib ${PREFIX}/lib/libev_static.lib
echo     fi
echo.
echo     rm -f ${PREFIX}/include/event.h
echo     exit 0
echo fi
echo.
echo # Get an updated config.sub and config.guess
echo if [[ -d ${BUILD_PREFIX}/Library/usr/share/libtool/build-aux ]]; then
echo     cp ${BUILD_PREFIX}/Library/usr/share/libtool/build-aux/config.* .
echo elif [[ -d ${BUILD_PREFIX}/share/libtool/build-aux ]]; then
echo     cp ${BUILD_PREFIX}/share/libtool/build-aux/config.* .
echo fi
echo.
echo ./configure --prefix=${PREFIX}
echo patch_libtool
echo make
echo if [[ ${CONDA_BUILD_CROSS_COMPILATION:-} != 1 ]]; then
echo     make check
echo fi
) > "%RECIPE_DIR%\bld-win.sh"
if %ERRORLEVEL% neq 0 exit 1

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Join-Path $env:RECIPE_DIR 'bld-win.sh'; $t = [IO.File]::ReadAllText($p); $t = $t -replace [Environment]::NewLine, [string][char]10; [IO.File]::WriteAllText($p, $t, [Text.Encoding]::ASCII)"
if %ERRORLEVEL% neq 0 exit 1

call "%BUILD_PREFIX%\Library\bin\run_autotools_clang_conda_build.bat" bld-win.sh
if %ERRORLEVEL% neq 0 exit 1
