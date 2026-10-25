@echo off
rem Windows entry point for ax; Windows ignores the #! line in bin\ax.
rem Prefers the py launcher that python.org installs, then python on PATH.
where py >nul 2>nul
if %errorlevel%==0 (
  py -3 "%~dp0ax" %*
) else (
  python "%~dp0ax" %*
)
exit /b %errorlevel%
