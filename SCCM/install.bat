@echo off
set preconfigured_binary_name=Dynatrace-OneAgent-Windows-[VERSION].msi
set preconfigured_arguments=/L*v "%TEMP%\installation_msiexec_[DATE].log"
set preconfigured_properties=PRECONFIGURED_PARAMETERS="--set-host-group= --set-server={[SERVER]} --set-tenant=[TENANT] --set-tenant-token=[TOKEN]" INTERNAL_LOG_PATH_FEEDBACK=".\dynatrace_log_path_feedback.conf"
set additional_configuration=ADDITIONAL_CONFIGURATION="--set-host-group=DEFAULT --set-infra-only=true"
set msi_path="%~dp0%preconfigured_binary_name%"

@%windir%\system32\msiexec.exe /i %msi_path% %preconfigured_arguments% %preconfigured_properties% %additional_configuration% %~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 /quiet /qn >con:
set msiexec_exit_code=%errorlevel%

exit /b %msiexec_exit_code%