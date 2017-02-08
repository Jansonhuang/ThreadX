@echo off
set SRCTREE=%cd%
for /r %%i in (*.o) do del "%%i" 2>null
for /r %%i in (*.a) do del "%%i" 2>null
del LPC2106.hex LPC2106.axf LPC2106.lst LPC2106.html LPC2106.htm LPC2106.PWI list.txt err.txt 2>null
del null