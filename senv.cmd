@echo off

rem # Check if powershell is in path
where /q pwsh
IF ERRORLEVEL 1 (
    where /q powershell
    IF ERRORLEVEL 1 (
        echo Neither pwsh.exe nor powershell.exe was found in your path.
        echo Please install powershell it is required
        exit /B
    ) ELSE (
        set ps=powershell
    )
) ELSE (
    set ps=pwsh
)

rem ps is the installed powershell

if "%1" == "use" (
    rem 环境配置，设置会话环境变量
    for /f "delims=" %%i in ('%ps% -executionpolicy remotesigned -File "%~dp0/senv.ps1" getEnv %2') do (
        if "%%i" == "None" ( 
            echo Theres no SEnv with name %2, Consider using "senv list".
        ) else ( 
            echo SEnv changed to %2 for the current shell session.
            set "path=%%i;%path%" 
        )
    )
) else (
    rem 非配置环境，属于数据配置，调用 senv.ps1 脚本执行相关功能
    %ps% -executionpolicy remotesigned -File "%~dp0/senv.ps1" %*
)
