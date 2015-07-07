@echo OFF

SET ISCC="C:\Programmation\InnoSetup5\ISCC"

SET DELPHI=C:\Programmation\Borland\Delphi7

set UPXX="C:\Programmation\upx391w\upx"

SET DCC32="%DELPHI%\Bin\DCC32"
SET VIRTUAL_TREEVIEW="%DELPHI%\Imports\VirtualTreeview"
SET VIRTUAL_TREEVIEW_SOURCE="%VIRTUAL_TREEVIEW%\Source"
SET VIRTUAL_TREEVIEW_COMMON="%VIRTUAL_TREEVIEW%\Common"
SET WAVE_AUDIO="%DELPHI%\Imports\waveaudio"
SET DELPHI_UNITS=%VIRTUAL_TREEVIEW_SOURCE%;%VIRTUAL_TREEVIEW_COMMON%;%WAVE_AUDIO%

:DELPHI
cd Src\Bin
%DCC32% -B -U%DELPHI_UNITS% -D"PORTABLE" OrganBuilder.dpr || goto DELPHI_ERROR
%UPXX% --best ..\..\Release\OrganBuilder.exe || goto UPX_ERROR
rm ..\..\Release\OrganBuilderPortable.exe
mv ..\..\Release\OrganBuilder.exe ..\..\Release\OrganBuilderPortable.exe
%DCC32% -B -U%DELPHI_UNITS% OrganBuilder.dpr || goto DELPHI_ERROR
goto HELP

:DELPHI_ERROR
echo =========================================================
echo Erreur de compilation Delphi
goto END

:UPX_ERROR
echo =========================================================
echo Erreur de compression UPX
goto END

:HELP
cd ..\Help
:HELP_LOOP
cp Manual-English.aux Manual-English.old.aux
cp Manual-English.toc Manual-English.old.toc
pdflatex -interaction=nonstopmode Manual-English || goto LATEX_ERROR
cp Manual-English.aux Manual-English.old.aux || goto HELP_LOOP
cmp Manual-English.toc Manual-English.old.toc || goto HELP_LOOP
rem rm ..\..\Release\Help\Manual-English.pdf
cp Manual-English.pdf ..\..\Release\Help || goto LATEX_ERROR
goto INSTALL

:LATEX_ERROR
echo =========================================================
echo Erreur de compilation du manuel
goto END

:INSTALL
cd ..\Install
%ISCC% OrganBuilder.iss || goto INSTALL_ERROR
goto SUCCESS

:INSTALL_ERROR
echo =========================================================
echo Erreur de compilation de l'installeur
goto END

:SUCCESS
echo =========================================================
echo Compilation OK (pas d'erreur detectee)

:END
cd %~dp0
pause
