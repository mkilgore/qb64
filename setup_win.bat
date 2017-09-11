@echo off
echo QB64 Setup
echo.

del /q /s internal\c\libqb\*.o >nul 2>nul
del /q /s internal\c\libqb\*.a >nul 2>nul
del /q /s internal\c\parts\*.o >nul 2>nul
del /q /s internal\c\parts\*.a >nul 2>nul
del /q /s internal\temp\*.* >nul 2>nul

cd internal/c/c_compiler
if exist bin\c++.exe goto skipccompextract
echo Extracting C++ compiler
7z\7za.exe x -y c_compiler.7z >nul
:skipccompextract
cd ../../..

copy source\qb64.ico internal\temp\ >nul
copy source\icon.rc internal\temp\ >nul
copy internal\source\*.* internal\temp\ >nul

internal\c\c_compiler\bin\make.exe OS=win BUILD_QB64=y

rem echo Building library 'LibQB'
rem cd internal/c/libqb/os/win
rem if exist libqb_setup.o del libqb_setup.o
rem call setup_build.bat
rem cd ../../../../..
rem 
rem echo Building library 'FreeType'
rem cd internal/c/parts/video/font/ttf/os/win
rem if exist src.o del src.o
rem call setup_build.bat
rem cd ../../../../../../../..
rem 
rem echo Building User Additions
rem cd internal/c/parts/user_mods/os/win
rem if exist src.a del src.a
rem call setup_build.bat
rem cd ../../../../../..
rem 
rem echo Building library 'Core:FreeGLUT'
rem cd internal/c/parts/core/os/win
rem if exist src.a del src.a
rem call setup_build.bat
rem cd ../../../../../..
rem 
rem echo Building 'QB64'
rem cd internal\c
rem c_compiler\bin\windres.exe -i ..\temp\icon.rc -o ..\temp\icon.o
rem c_compiler\bin\g++ -mconsole -s -Wfatal-errors -w -Wall qbx.cpp libqb\os\win\libqb_setup.o ..\temp\icon.o parts\user_mods\os\win\src.a -D DEPENDENCY_USER_MODS -D DEPENDENCY_LOADFONT  parts\video\font\ttf\os\win\src.o -D DEPENDENCY_SOCKETS -D DEPENDENCY_NO_PRINTER -D DEPENDENCY_ICON -D DEPENDENCY_NO_SCREENIMAGE parts\core\os\win\src.a -lopengl32 -lglu32   -mwindows -static-libgcc -static-libstdc++ -D GLEW_STATIC -D FREEGLUT_STATIC     -lws2_32 -lwinmm -lgdi32 -o "..\..\qb64.exe"
rem cd ..\..
rem 
rem echo.
rem echo Launching 'QB64'
rem qb64

echo.
pause
