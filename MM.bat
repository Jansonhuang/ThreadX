@echo off
rem #################################################################
rem # RVCT40
rem #################################################################
set ARMROOT=C:\ARM
set LM_LICENSE_FILE=%ARMROOT%\RVCT\license.dat
set PATH=%ARMROOT%\bin\win_32-pentium;%ARMROOT%\RVCT\Programs\4.0\400\win_32-pentium;%PATH%
set RVCT40BIN=%ARMROOT%\RVCT\Programs\4.0\400\win_32-pentium
set RVCT40INC=%ARMROOT%\RVCT\Data\4.0\400\include\windows
set RVCT40LIB=%ARMROOT%\RVCT\Data\4.0\400\lib

rem #################################################################
rem # MAKE
rem #################################################################
make -f Makefile all || pause