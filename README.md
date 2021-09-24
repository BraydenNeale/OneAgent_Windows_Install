# Dynatrace Windows Agent Install - SCCM

## Dynatrace Documentation
[Install Oneagent on Windows](https://www.dynatrace.com/support/help/technology-support/operating-systems/windows/installation/install-oneagent-on-windows/)

[Customize Oneagent Installation on Windows](https://www.dynatrace.com/support/help/technology-support/operating-systems/windows/installation/customize-oneagent-installation-on-windows/)

## SCCM Install

These instructions are for installing a generic - default Dynatrace OneAgent to Windows servers through SCCM (Microsoft System Center Configuration Manager).

The agent installed will be in Infrastructure-Only mode (No code level injection) and will have a default Host_Group of DEFAULT.

You can then use the Dynatrace tenant, automation or manual changes to refine agent properties such as the monitoring mode and host group.

See **example** install and uninstall scripts under the SCCM folder:
* [SCCM/install.bat](SCCM/install.bat)
* [SCCM/uninstall.bat](SCCM/uninstall.bat)

### Basic steps
1. Download the Oneagent installer from your Dynatrace environment
    
    You can automate the download with Powershell:
    `powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://<ENV_ID>.live.dynatrace.com/api/v1/deployment/installer/agent/windows/default/latest?arch=x86&flavor=default' -Headers @{ 'Authorization' = 'Api-Token <PAAS_TOKEN>' } -OutFile 'Dynatrace-OneAgent-Windows.exe'"`
    
    Where: ENV_ID is your Dynatrace environment ID. e.g. abc12345 and PAAS_TOKEN is a Dynatrace PAAS token for that environment
    
    Then unpack the MSI package with:

    `Dynatrace-OneAgent-Windows.exe --unpack-msi`

    This will produce an msi package and an install.bat script. 

    Note: This .bat script will be preconfigured with Dynatrace sever endpoints, tenant and token.

2. Add additional_configuration to the install.bat file for Host-Group and Infra-Only mode:
   Where DEFAULT is the example host group shown here. Set this to something meaningful

    ADD LINE:

    `set additional_configuration=ADDITIONAL_CONFIGURATION="--set-host-group=DEFAULT --set-infra-only=true"`

    REPLACE

    `@%windir%\system32\msiexec.exe /i %msi_path% %preconfigured_arguments% %preconfigured_properties% %~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 >con:`

    WITH


    `@%windir%\system32\msiexec.exe /i %msi_path% %preconfigured_arguments% %preconfigured_properties% %additional_configuration% %~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 /quiet /qn >con:`

    We have added **%additional_configuration%** **/quiet** and **/qn**

3. You can use [SCCM/uninstall.bat](SCCM/uninstall.bat) as is, for uninstalling the agent [Uninstall OneAgent Windows](https://www.dynatrace.com/support/help/shortlink/oneagent-uninstall-windows#uninstall-oneagent-silently_)

4. Provide an SCCM folder to your Windows/SCCM administrator to create a Dynatrace-OneAgent SCCM package. containing:
    * Dynatrace-OneAgent-Windows.msi
    * install.bat
    * uninstall.bat

5. In SCCM, create a Dynatrace OneAgent SCCM collection with this package

6. Add the required servers to this Dynatrace OneAgent SCCM collection to install the agent

7. You can refine and toggle agent properties using a utility such as [Oneagentctl-Wrapper](https://github.com/BraydenNeale/Oneagentctl-Wrapper).
