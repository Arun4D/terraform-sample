# Ansible playbook for Application deployment


## Create Roles 

````bash
cd roles
ansible-galaxy init windows_iis
````

## Run ansible 

````bash
ansible-galaxy collection install -r requirements.yml
````

## Run ansible collections 

````bash
ansible-playbook -i inventories/dev   myapp.yml --extra-vars="ansible_password=\"password\""

ansible-playbook -i inventories/dev   qradar_wincollect.yml

ansible-playbook -i inventories/dev filebeat.yml -kK --extra-vars '{"elastic_ver": "7.3.2", "logstash_host":"localhost"}'

ansible-playbook -i inventories/dev winlogbeat.yml  --extra-vars '{"ansible_password": "Ans!ble@dmin123", "logstash_host":"localhost"}'

ansible-playbook -i inventories/dev azure_vm_win_extension.yml  --extra-vars '{"ansible_password": ""}'

````

## Ansible Server - Setup WinRM

```` bash
sudo apt install python3-pip
pip install "pywinrm>=0.3.0"
````
## Ansible Server - Setup pywinrm and requests

```` bash
pip install pywinrm 
pip install requests
pip install msrest
````
Full azure module install
````bash
pip install ansible
wget -nv -q https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
pip install -r requirements-azure.txt
````

## Windows Host - Basic Auth enable - [ Not used ]

```` powershell
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
````

## Windows Host - NTLM  enable 
https://docs.ansible.com/archive/ansible/2.5/user_guide/windows_setup.html

Execute below script in Azure Windows virtual machine to enable WinRM

Powershell tls error run the below script

````
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
````

````
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
$file = "$env:temp\Upgrade-PowerShell.ps1"
$username = "ansibleadmin"
$password = "&2PxdX]kw)e_%q"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force


&$file -Version 5.1 -Username $username -Password $password -Verbose

````

Remove auto login

````
Set-ExecutionPolicy -ExecutionPolicy Restricted -Force

$reg_winlogon_path = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $reg_winlogon_path -Name AutoAdminLogon -Value 0
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultUserName -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultPassword -ErrorAction SilentlyContinue
````

# Tools to install 

## QRADAR Agent

Download link

https://www.ibm.com/support/fixcentral/swg/downloadFixes?parent=IBM%20Security&product=ibm/Other+software/IBM+Security+QRadar+SIEM&release=7.5.0&platform=Linux&function=fixId&fixids=7.5.0-QRADAR-AGENT_x86_WINCOLLECT-10.1.6-3.msi,7.5.0-QRADAR-AGENT_x64_WINCOLLECT-10.1.6-3.msi&includeRequisites=1&includeSupersedes=0&downloadMethod=http&source=fc


# Reference

## Ansbible Built in
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html