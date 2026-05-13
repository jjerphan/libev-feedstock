@echo on
setlocal EnableExtensions

if "%LIBEV_OUTPUT_INSTALL%" == "1" goto install

if not exist "%SRC_DIR%\build" mkdir "%SRC_DIR%\build"
if errorlevel 1 exit 1

cl.exe /nologo /MD /O2 /D_CRT_SECURE_NO_WARNINGS /I"%SRC_DIR%" /Fo"%SRC_DIR%\build\ev.obj" /c "%SRC_DIR%\ev.c"
if errorlevel 1 exit 1

lib.exe /nologo /OUT:"%SRC_DIR%\libev_static.lib" "%SRC_DIR%\build\ev.obj"
if errorlevel 1 exit 1

> "%SRC_DIR%\libev.def" echo LIBRARY libev
>> "%SRC_DIR%\libev.def" echo EXPORTS
>> "%SRC_DIR%\libev.def" echo     ev_version_major
>> "%SRC_DIR%\libev.def" echo     ev_version_minor
>> "%SRC_DIR%\libev.def" echo     ev_supported_backends
>> "%SRC_DIR%\libev.def" echo     ev_recommended_backends
>> "%SRC_DIR%\libev.def" echo     ev_embeddable_backends
>> "%SRC_DIR%\libev.def" echo     ev_time
>> "%SRC_DIR%\libev.def" echo     ev_sleep
>> "%SRC_DIR%\libev.def" echo     ev_set_allocator
>> "%SRC_DIR%\libev.def" echo     ev_set_syserr_cb
>> "%SRC_DIR%\libev.def" echo     ev_default_loop
>> "%SRC_DIR%\libev.def" echo     ev_default_loop_ptr DATA
>> "%SRC_DIR%\libev.def" echo     ev_loop_new
>> "%SRC_DIR%\libev.def" echo     ev_now
>> "%SRC_DIR%\libev.def" echo     ev_loop_destroy
>> "%SRC_DIR%\libev.def" echo     ev_loop_fork
>> "%SRC_DIR%\libev.def" echo     ev_backend
>> "%SRC_DIR%\libev.def" echo     ev_now_update
>> "%SRC_DIR%\libev.def" echo     ev_walk
>> "%SRC_DIR%\libev.def" echo     ev_run
>> "%SRC_DIR%\libev.def" echo     ev_break
>> "%SRC_DIR%\libev.def" echo     ev_ref
>> "%SRC_DIR%\libev.def" echo     ev_unref
>> "%SRC_DIR%\libev.def" echo     ev_once
>> "%SRC_DIR%\libev.def" echo     ev_invoke_pending
>> "%SRC_DIR%\libev.def" echo     ev_iteration
>> "%SRC_DIR%\libev.def" echo     ev_depth
>> "%SRC_DIR%\libev.def" echo     ev_verify
>> "%SRC_DIR%\libev.def" echo     ev_set_io_collect_interval
>> "%SRC_DIR%\libev.def" echo     ev_set_timeout_collect_interval
>> "%SRC_DIR%\libev.def" echo     ev_set_userdata
>> "%SRC_DIR%\libev.def" echo     ev_userdata
>> "%SRC_DIR%\libev.def" echo     ev_set_invoke_pending_cb
>> "%SRC_DIR%\libev.def" echo     ev_set_loop_release_cb
>> "%SRC_DIR%\libev.def" echo     ev_pending_count
>> "%SRC_DIR%\libev.def" echo     ev_suspend
>> "%SRC_DIR%\libev.def" echo     ev_resume
>> "%SRC_DIR%\libev.def" echo     ev_feed_event
>> "%SRC_DIR%\libev.def" echo     ev_feed_fd_event
>> "%SRC_DIR%\libev.def" echo     ev_feed_signal
>> "%SRC_DIR%\libev.def" echo     ev_feed_signal_event
>> "%SRC_DIR%\libev.def" echo     ev_invoke
>> "%SRC_DIR%\libev.def" echo     ev_clear_pending
>> "%SRC_DIR%\libev.def" echo     ev_io_start
>> "%SRC_DIR%\libev.def" echo     ev_io_stop
>> "%SRC_DIR%\libev.def" echo     ev_timer_start
>> "%SRC_DIR%\libev.def" echo     ev_timer_stop
>> "%SRC_DIR%\libev.def" echo     ev_timer_again
>> "%SRC_DIR%\libev.def" echo     ev_timer_remaining
>> "%SRC_DIR%\libev.def" echo     ev_periodic_start
>> "%SRC_DIR%\libev.def" echo     ev_periodic_stop
>> "%SRC_DIR%\libev.def" echo     ev_periodic_again
>> "%SRC_DIR%\libev.def" echo     ev_signal_start
>> "%SRC_DIR%\libev.def" echo     ev_signal_stop
>> "%SRC_DIR%\libev.def" echo     ev_stat_start
>> "%SRC_DIR%\libev.def" echo     ev_stat_stop
>> "%SRC_DIR%\libev.def" echo     ev_stat_stat
>> "%SRC_DIR%\libev.def" echo     ev_idle_start
>> "%SRC_DIR%\libev.def" echo     ev_idle_stop
>> "%SRC_DIR%\libev.def" echo     ev_prepare_start
>> "%SRC_DIR%\libev.def" echo     ev_prepare_stop
>> "%SRC_DIR%\libev.def" echo     ev_check_start
>> "%SRC_DIR%\libev.def" echo     ev_check_stop
>> "%SRC_DIR%\libev.def" echo     ev_fork_start
>> "%SRC_DIR%\libev.def" echo     ev_fork_stop
>> "%SRC_DIR%\libev.def" echo     ev_cleanup_start
>> "%SRC_DIR%\libev.def" echo     ev_cleanup_stop
>> "%SRC_DIR%\libev.def" echo     ev_embed_start
>> "%SRC_DIR%\libev.def" echo     ev_embed_stop
>> "%SRC_DIR%\libev.def" echo     ev_embed_sweep
>> "%SRC_DIR%\libev.def" echo     ev_async_start
>> "%SRC_DIR%\libev.def" echo     ev_async_stop
>> "%SRC_DIR%\libev.def" echo     ev_async_send

link.exe /nologo /DLL /OUT:"%SRC_DIR%\libev.dll" /IMPLIB:"%SRC_DIR%\libev.lib" /DEF:"%SRC_DIR%\libev.def" "%SRC_DIR%\build\ev.obj" ws2_32.lib
if errorlevel 1 exit 1

exit 0

:install
if not exist "%LIBRARY_INC%" mkdir "%LIBRARY_INC%"
if errorlevel 1 exit 1
if not exist "%LIBRARY_BIN%" mkdir "%LIBRARY_BIN%"
if errorlevel 1 exit 1
if not exist "%LIBRARY_LIB%" mkdir "%LIBRARY_LIB%"
if errorlevel 1 exit 1

copy /Y "%SRC_DIR%\ev.h" "%LIBRARY_INC%\ev.h"
if errorlevel 1 exit 1
copy /Y "%SRC_DIR%\ev++.h" "%LIBRARY_INC%\ev++.h"
if errorlevel 1 exit 1

if "%PKG_NAME%" == "libev-static" (
    copy /Y "%SRC_DIR%\libev_static.lib" "%LIBRARY_LIB%\libev_static.lib"
    if errorlevel 1 exit 1
) else (
    copy /Y "%SRC_DIR%\libev.dll" "%LIBRARY_BIN%\libev.dll"
    if errorlevel 1 exit 1
    copy /Y "%SRC_DIR%\libev.lib" "%LIBRARY_LIB%\libev.lib"
    if errorlevel 1 exit 1
)
