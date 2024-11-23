@echo off

title Network Utility Tool - discord.gg/broken

set "logfile=%~dp0NetworkUtilityLog.txt"

:dependency_check
cls
echo ==================================================
echo              System Requirement Check
echo ==================================================
echo Checking for curl...
curl --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING]: curl is not installed. Installing curl now...
    timeout /t 2 >nul
    powershell -Command "& { (New-Object System.Net.WebClient).DownloadFile('https://curl.se/windows/dl-7.88.1/curl-7.88.1-win64-mingw.zip', '%temp%\curl.zip') }"
    powershell -Command "& { Expand-Archive -Path '%temp%\curl.zip' -DestinationPath '%temp%\curl' -Force }"
    setx PATH "%temp%\curl\curl-7.88.1-win64-mingw\bin;%PATH%" >nul
    curl --version >nul 2>&1
    if errorlevel 1 (
        echo [ERROR]: Failed to install curl automatically. Please install it manually.
        pause
        exit
    ) else (
        echo [SUCCESS]: curl installed successfully.
    )
) else (
    echo [SUCCESS]: curl is already installed.
)
echo Checking for Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING]: Python is not installed. Installing Python now...
    powershell -Command "& { Start-Process powershell -ArgumentList '-Command \"(Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.10.9/python-3.10.9-amd64.exe -OutFile python_installer.exe); Start-Process python_installer.exe -ArgumentList /quiet, /passive, InstallAllUsers=1, PrependPath=1 -NoNewWindow; Wait-Process -Name python_installer\"' -NoNewWindow -Wait }"
    python --version >nul 2>&1
    if errorlevel 1 (
        echo [ERROR]: Failed to install Python. Please install it manually.
        pause
        exit
    ) else (
        echo [SUCCESS]: Python installed successfully.
    )
) else (
    echo [SUCCESS]: Python is already installed.
)
timeout /t 2 >nul
goto main_menu

:main_menu
cls
echo ==================================================
echo                Network Utility Menu
echo ==================================================
echo 1. Ping Test
echo 2. Check Public IP Address
echo 3. Network Speed Test
echo 4. Set Network Adapters to DHCP
echo 5. Clear URL Cache
echo 6. Reset IP Settings
echo 7. Reset Winsock
echo 8. Reset Windows Firewall Rules
echo 9. Release and Renew IP Addresses
echo 10. Flush DNS Cache
echo 11. View Network Adapter Information
echo 12. Enable/Disable Network Adapter
echo 13. Advanced Network Diagnostics
echo 14. Trace Route
echo 15. Localhost Connectivity Test
echo 16. View Logs
echo 17. Exit Application
echo ==================================================
set /p "choice=Enter your choice (1-17): "

if "%choice%"=="1" goto ping_test
if "%choice%"=="2" goto check_ip
if "%choice%"=="3" goto speed_test
if "%choice%"=="4" goto dhcp
if "%choice%"=="5" goto clear_url_cache
if "%choice%"=="6" goto reset_ip
if "%choice%"=="7" goto reset_winsock
if "%choice%"=="8" goto reset_firewall
if "%choice%"=="9" goto release_renew
if "%choice%"=="10" goto flush_dns
if "%choice%"=="11" goto adapter_info
if "%choice%"=="12" goto toggle_adapter
if "%choice%"=="13" goto diagnostics
if "%choice%"=="14" goto trace_route
if "%choice%"=="15" goto localhost_test
if "%choice%"=="16" goto view_logs
if "%choice%"=="17" goto exit_application
echo Invalid option. Try again.
timeout /t 2 >nul
goto main_menu

:ping_test
cls
echo Running a ping test...
set /p "host=Enter host to ping (e.g., google.com): "
ping %host% >> "%logfile%" 2>&1
if errorlevel 1 (
    echo [ERROR]: Ping to %host% failed. Check the logs for details.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: Ping to %host% completed successfully.
    timeout /t 5 >nul
)
goto main_menu

:check_ip
cls
echo Fetching your public IP address...
curl -s https://api64.ipify.org/ >> "%logfile%"
if errorlevel 1 (
    echo [ERROR]: Failed to fetch public IP address.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: Successfully fetched public IP.
    timeout /t 5 >nul
)
goto main_menu

:speed_test
cls
echo Performing network speed test...
python -m pip install speedtest-cli >nul 2>&1
if errorlevel 1 (
    echo [ERROR]: Failed to install speedtest-cli module.
    timeout /t 5 >nul
    goto main_menu
)
cls
python -c "import speedtest; s = speedtest.Speedtest(); print(f'Download Speed: {round(s.download() / 1_000_000, 2)} Mbps'); print(f'Upload Speed: {round(s.upload() / 1_000_000, 2)} Mbps');" >> "%logfile%"
timeout /t 5 >nul
goto main_menu

:dhcp
cls
echo Setting all connected network adapters to DHCP...
for /f "tokens=2 delims=:" %%i in ('netsh interface show interface ^| findstr /i "connected"') do (
    set "adapter=%%i"
    setlocal enabledelayedexpansion
    set "adapter=!adapter:~1!"
    netsh int ip set address name="!adapter!" source=dhcp >nul
    netsh int ip set dns name="!adapter!" source=dhcp >nul
    endlocal
)
echo [SUCCESS]: Network adapters configured to DHCP.
timeout /t 5 >nul
goto main_menu

:clear_url_cache
cls
echo Clearing URL cache...
certutil -URLCache * delete >> "%logfile%" 2>&1
if errorlevel 1 (
    echo [ERROR]: Failed to clear URL cache.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: URL cache cleared successfully.
    timeout /t 5 >nul
)
goto main_menu

:reset_ip
cls
echo Resetting IP settings...
netsh int ip reset >> "%logfile%" 2>&1
if errorlevel 1 (
    echo [ERROR]: Failed to reset IP settings.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: IP settings reset successfully.
    timeout /t 5 >nul
)
goto main_menu

:reset_winsock
cls
echo Resetting Winsock catalog...
netsh winsock reset >> "%logfile%" 2>&1
if errorlevel 1 (
    echo [ERROR]: Failed to reset Winsock.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: Winsock reset completed successfully.
    timeout /t 5 >nul
)
goto main_menu

:reset_firewall
cls
echo Resetting Windows Firewall to default settings...
netsh advfirewall reset >> "%logfile%" 2>&1
if errorlevel 1 (
    echo [ERROR]: Failed to reset firewall rules.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: Firewall reset successfully.
    timeout /t 5 >nul
)
goto main_menu

:release_renew
cls
echo Releasing and renewing IP addresses...
ipconfig /release >> "%logfile%" 2>&1
ipconfig /renew >> "%logfile%" 2>&1
if errorlevel 1 (
    echo [ERROR]: Failed to release/renew IP addresses.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: IP addresses released and renewed successfully.
    timeout /t 5 >nul
)
goto main_menu

:flush_dns
cls
echo Flushing DNS cache...
ipconfig /flushdns >> "%logfile%" 2>&1
if errorlevel 1 (
    echo [ERROR]: Failed to flush DNS cache.
    timeout /t 5 >nul
) else (
    echo [SUCCESS]: DNS cache flushed successfully.
    timeout /t 5 >nul
)
goto main_menu

:adapter_info
cls
echo Displaying network adapter information...
ipconfig /all >> "%logfile%" 2>&1
type "%logfile%" | more
timeout /t 5 >nul
goto main_menu

:toggle_adapter
cls
echo Enable or disable a network adapter:
netsh interface show interface
set /p "adapter_name=Enter the adapter name: "
set /p "action=Enter action (enable/disable): "
if /i "%action%"=="disable" (
    netsh interface set interface name="%adapter_name%" admin=disable >> "%logfile%" 2>&1
) else if /i "%action%"=="enable" (
    netsh interface set interface name="%adapter_name%" admin=enable >> "%logfile%" 2>&1
)
timeout /t 5 >nul
goto main_menu

:diagnostics
cls
echo Running advanced diagnostics...
netstat -e >> "%logfile%" 2>&1
ipconfig /displaydns >> "%logfile%" 2>&1
timeout /t 5 >nul
goto main_menu

:trace_route
cls
echo Running traceroute...
set /p "host=Enter the host to trace route (e.g., google.com): "
tracert %host% >> "%logfile%" 2>&1
timeout /t 5 >nul
goto main_menu

:localhost_test
cls
echo Testing localhost connectivity...
ping 127.0.0.1 -n 4 >> "%logfile%" 2>&1
timeout /t 5 >nul
goto main_menu

:view_logs
cls
type "%logfile%"
timeout /t 10 >nul
goto main_menu

:exit_application
cls
echo Closing Network Utility Menu, Thank You For Choosing Our Tool, Support Us By Joining discord.gg/broken!
exit
