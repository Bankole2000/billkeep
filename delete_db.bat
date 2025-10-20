@echo off
echo Deleting BillKeep database files...
del /Q "%USERPROFILE%\AppData\Local\Packages\com.example.billkeep*\LocalState\billkeep.sqlite" 2>nul
del /Q "%USERPROFILE%\AppData\Local\Packages\com.example.billkeep*\LocalState\billkeep.sqlite-wal" 2>nul
del /Q "%USERPROFILE%\AppData\Local\Packages\com.example.billkeep*\LocalState\billkeep.sqlite-shm" 2>nul
echo Database files deleted (if they existed)
echo.
echo You can now run the app again.
pause
