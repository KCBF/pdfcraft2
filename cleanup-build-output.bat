@echo off
setlocal
set "PDFCRAFT_CLEANUP_ROOT=%~dp0"
echo Removing target and dist build output from:
echo %PDFCRAFT_CLEANUP_ROOT%
echo Source files and Git history will be preserved.
echo.
powershell.exe -NoProfile -Command "$ErrorActionPreference = 'Stop'; try { $root = [IO.Path]::GetFullPath($env:PDFCRAFT_CLEANUP_ROOT).TrimEnd('\'); if (-not (Test-Path -LiteralPath (Join-Path $root 'Cargo.toml') -PathType Leaf)) { throw 'Run this script from the PdfCraft repository.' }; foreach ($name in @('target', 'dist')) { $path = [IO.Path]::GetFullPath((Join-Path $root $name)); if ([IO.Path]::GetDirectoryName($path) -ne $root) { throw 'Cleanup path is outside the repository.' }; if (Test-Path -LiteralPath $path) { $item = Get-Item -LiteralPath $path -Force; if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw ('Refusing to delete a linked directory: ' + $path) }; Remove-Item -LiteralPath $path -Recurse -Force; Write-Host ('Removed ' + $path) } else { Write-Host ('Already absent: ' + $path) } }; exit 0 } catch { Write-Host ('Cleanup failed: ' + $_.Exception.Message) -ForegroundColor Red; exit 1 }"
if errorlevel 1 (
    echo.
    echo Cleanup did not finish. See the error above.
    pause
    exit /b 1
)
echo.
echo Cleanup complete.
pause
exit /b 0
