# Ansible playbook for Application deployment


## Create Roles 

````bash
cd roles
ansible-galaxy init windows_iis
````

## Run ansible 

````bash
ansible-playbook -i inventories/dev   myapp.yml --extra-vars="ansible_password=\"password\""
````
## Ansible Server - Setup WinRM

```` bash
sudo apt install python3-pip
pip install "pywinrm>=0.3.0"
````

## Windows Host - Basic Auth enable - [ Not used ]

```` powershell
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
````

## Windows Host - NTLM  enable 
https://docs.ansible.com/archive/ansible/2.5/user_guide/windows_setup.html

Execute below script in Azure Windows virtual machine to enable WinRM

````
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
$file = "$env:temp\Upgrade-PowerShell.ps1"
$username = "ansibleadmin"
$password = ""

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
