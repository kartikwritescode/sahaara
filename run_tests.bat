@echo off
rem ==============================================================================
rem Sahaara (ElderGuard) — Automated Test Suite Runner (Batch)
rem ==============================================================================

echo =====================================================
echo    Sahaara (ElderGuard) Automated Test Suite
echo =====================================================
echo.

echo [1/2] Running Flutter Static Analysis (flutter analyze)...
call flutter analyze
echo.

echo [2/2] Running Flutter Unit ^& Widget Tests (flutter test)...
call flutter test
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Flutter tests failed.
    exit /b 1
)
echo.
echo =====================================================
echo    ALL SAHAARA TEST SUITES PASSED CLEANLY!
echo =====================================================
