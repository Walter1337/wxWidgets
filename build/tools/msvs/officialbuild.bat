ECHO OFF

if "%1" == "" goto ERR_NOPARM

set curr_dir=%cd%

cd ..\..\msw

rem ================ wxWidgets Official Build ===============
rem
rem Open a command prompt and run this from the build\tools\msvs folder.
rem Specify the compiler version to use.
rem
rem ========================================================

set compvers="Unknown"

if "%1" == "vc140" (
  @echo Building for vc140 / vs2015
  set comp=140
  set compvers=vc140
  call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"
)
if "%1" == "vs2015" (
  @echo Building for vc140 / vs2015
  set comp=140
  set compvers=vc140
  call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat"
)
if "%1" == "vc120" (
  @echo Building for vc120 / vs2013
  set comp=120
  set compvers=vc120
  call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\VsDevCmd.bat"
)
if "%1" == "vs2013" (
  @echo Building for vc120 / vs2013
  set comp=120
  set compvers=vc120
  call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\VsDevCmd.bat"
)
if "%1" == "vc110" (
  @echo Building for vc110 / vs2012
  set comp=110
  set compvers=vc110
  call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\Tools\VsDevCmd.bat"
)
if "%1" == "vs2012" (
  @echo Building for vc110 / vs2012
  set comp=110
  set compvers=vc110
  call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\Tools\VsDevCmd.bat"
)
if "%1" == "vc100" (
  @echo Building for vc100 / vs2010
  set comp=100
  set compvers=vc100
  call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd"
)
if "%1" == "vs2010" (
  @echo Building for vc100 / vs2010
  set comp=100
  set compvers=vc100
  call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd"
)
if "%1" == "vc90" (
  @echo Building for vc90 / vs2008
  set comp=90
  set compvers=vc90
)
if "%1" == "vs2008" (
  @echo Building for vc90 / vs2008
  set comp=90
  set compvers=vc90
)

if %compvers% == "Unknown" goto ERR_UNKNOWNCOMP

if %compvers% == "vc90" (
@echo ============================================================
@echo This will only succeed if run from a SDK 6.1 command prompt.
@echo ============================================================
)

@echo Removing the existing destination so that a complete rebuild occurs.

rmdir %compvers%_mswuddll /s /q
rmdir %compvers%_mswuddll_x64 /s /q
rmdir %compvers%_mswudll /s /q
rmdir %compvers%_mswudll_x64 /s /q

rmdir ..\..\lib\%compvers%_dll /s /q
rmdir ..\..\lib\%compvers%_x64_dll /s /q

@echo Delete the build output files from the last run.

del %compvers%x86_Debug.txt
del %compvers%x86_Release.txt
del %compvers%x64_Debug.txt
del %compvers%x64_Release.txt

if "%compvers%" == "vc140" call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
if "%compvers%" == "vc120" call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
if "%compvers%" == "vc110" call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
if "%compvers%" == "vc100" call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /X64 /Release
if "%compvers%" == "vc100" call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /X64 /Release
if "%compvers%" == "vc90"  call "C:\Program Files\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" /X64 /Release

@echo 64 bit release build

nmake -f makefile.vc BUILD=release SHARED=1 COMPILER_VERSION=%comp% OFFICIAL_BUILD=1 TARGET_CPU=AMD64 >> %compvers%x64_Release.txt

if ERRORLEVEL 1 goto ERR_BUILD

@echo 64 bit debug build

if "%compvers%" == "vc100" call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /X64 /Debug
if "%compvers%" == "vc90"  call "C:\Program Files\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" /X64 /Debug

nmake -f makefile.vc BUILD=debug SHARED=1 COMPILER_VERSION=%comp% OFFICIAL_BUILD=1 TARGET_CPU=AMD64 >> %compvers%x64_Debug.txt

if ERRORLEVEL 1 goto ERR_BUILD

if "%compvers%" == "vc140" call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
if "%compvers%" == "vc120" call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
if "%compvers%" == "vc110" call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\vcvars32.bat"
if "%compvers%" == "vc100" call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /X86 /Release
if "%compvers%" == "vc90"  call "C:\Program Files\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" /X86 /Release

@echo 32 bit release build

nmake -f makefile.vc BUILD=release SHARED=1 COMPILER_VERSION=%comp% OFFICIAL_BUILD=1 CPPFLAGS=/arch:SSE CFLAGS=/arch:SSE >> %compvers%x86_Release.txt

if ERRORLEVEL 1 goto ERR_BUILD

@echo 32 bit debug build

if "%compvers%" == "vc100" call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /X86 /Debug
if "%compvers%" == "vc90"  call "C:\Program Files\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" /X86 /Debug

nmake -f makefile.vc BUILD=debug SHARED=1 COMPILER_VERSION=%comp% OFFICIAL_BUILD=1 CPPFLAGS=/arch:SSE CFLAGS=/arch:SSE >> %compvers%x86_Debug.txt

if ERRORLEVEL 1 goto ERR_BUILD

@echo Building Packages

cd %curr_dir%

call package %compvers%

goto End

:ERR_BUILD

goto End
   @echo.
   @echo BUILD ERROR

:ERR_UNKNOWNCOMP
   @echo.
   @echo UNKNOWN COMPILER VERSION
   goto VERSIONS

goto End

:ERR_NOPARM
   @echo.
   @echo ERROR: NO PARAMETER SUPPLIED
   goto VERSIONS

:VERSIONS
   @echo.
   @echo Compiler Version: One of -
   @echo vc140 or vs2015
   @echo vc120 or vs2013
   @echo vc110 or vs2012
   @echo vc100 or vs2010

:End

@echo Finished.

cd %curr_dir%
