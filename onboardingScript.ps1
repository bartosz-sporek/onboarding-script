 if(-not(Test-Path -Path "C:\Users\admin\Desktop\pass.txt" -PathType Leaf)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco feature enable -n allowGlobalConfirmation
    choco install googlechrome adobereader firefox 7zip.install notepadplusplus.install anydesk zoom slack googledrive
    choco upgrade all -y

    $HostName = Read-Host -Prompt 'Enter new computer name'
    if (!$HostName) {
        echo "`nHostname stays the same :)"
        cd C:\Users\admin\AppData\Local\Temp | Invoke-Expression; Invoke-RestMethod -Method Get -URI https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/windows/InstallWindowsAgent.ps1 -OutFile InstallWindowsAgent.ps1 | Invoke-Expression; ./InstallWindowsAgent.ps1 -JumpCloudConnectKey "Enter Jumpcloud Connect Key"
    }
    else {
        Rename-Computer -NewName $HostName
        New-Item -Path "C:\Users\admin\Desktop\pass.txt" -ItemType File
	  
        $Action = New-ScheduledTaskAction -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -Argument '-NonInteractive -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\Users\admin\Desktop\CCUniversalPack.ps1"'
	  $Trigger = New-ScheduledTaskTrigger -AtLogOn
	  $Principal = New-ScheduledTaskPrincipal -UserID "$($env:USERDOMAIN)\$($env:USERNAME)" -RunLevel Highest
	  $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable
	  Register-ScheduledTask -TaskName "CCUniversalPack" -Trigger $Trigger -Action $Action -Settings $Settings -Principal $Principal

	  echo "Computer will be restarted in 5 seconds..."
	  Start-Sleep -s 5
	  Restart-Computer
    }
}
else {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    cd C:\Users\admin\AppData\Local\Temp | Invoke-Expression; Invoke-RestMethod -Method Get -URI https://raw.githubusercontent.com/TheJumpCloud/support/master/scripts/windows/InstallWindowsAgent.ps1 -OutFile InstallWindowsAgent.ps1 | Invoke-Expression; ./InstallWindowsAgent.ps1 -JumpCloudConnectKey "Enter Jumpcloud Connect Key"

    Remove-Item "C:\Users\admin\Desktop\pass.txt"
    Get-ScheduledTask -TaskName "CCUniversalPack"
    Unregister-ScheduledTask -TaskName "CCUniversalPack" -Confirm:$false
}