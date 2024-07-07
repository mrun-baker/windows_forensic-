# Define the output file
$outputFile = "forensic_report.txt"

# Function to append command output to the file
function Append-Output {
    param (
        [string]$command,
        [string]$description
    )
    Write-Output "### $description ###" | Out-File -Append -FilePath $outputFile
    Write-Output "Running: $description" | Out-File -Append -FilePath $outputFile
    try {
        $output = Invoke-Expression $command 2>&1
        Write-Output $output | Out-File -Append -FilePath $outputFile
    } catch {
        Write-Output "Error executing command: $_" | Out-File -Append -FilePath $outputFile
    }
    Write-Output "`n" | Out-File -Append -FilePath $outputFile
}

# Clear previous content
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Log start time
Write-Output "Script started at $(Get-Date)" | Out-File -FilePath $outputFile

# Get the local IP address and subnet
$networkInterface = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" } | Select-Object -First 1
if ($networkInterface) {
    $localIP = $networkInterface.IPAddress
    $lastDotIndex = $localIP.LastIndexOf('.')
    if ($lastDotIndex -gt 0) {
        $subnet = $localIP.Substring(0, $lastDotIndex)
    } else {
        Write-Output "Invalid IP format: $localIP" | Out-File -Append -FilePath $outputFile
        $subnet = $null
    }
} else {
    Write-Output "No suitable network interface found." | Out-File -Append -FilePath $outputFile
}

# Network Discovery - Handling network-related errors
if ($localIP -and $subnet) {
    Append-Output "net view /all" "Network Discovery: Net View All"
    Append-Output "net view" "Network Discovery: Net View"
    Append-Output "net view \\$(hostname)" "Network Discovery: Net View Hostname"
    Append-Output "net share" "Network Discovery: Net Share"
    Append-Output "net session" "Network Discovery: Net Session"
    Append-Output "wmic volume list brief" "Network Discovery: WMIC Volume List Brief"
    Append-Output "wmic share get" "Network Discovery: WMIC Share Get"
    Append-Output "wmic logicaldisk get" "Network Discovery: WMIC Logical Disk Get"

    # Scan only the first 10 IPs
    Append-Output "nbtstat -A $localIP" "Scan: NBTStat -A"
    for ($i = 1; $i -le 10; $i++) {
        $ip = "$subnet.$i"
        Write-Output "Pinging $ip" | Out-File -Append -FilePath $outputFile
        $pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue
        if ($pingResult) {
            Append-Output "nbtstat -A $ip" "Scan: NBTStat -A $ip"
        } else {
            Write-Output "Ping to $ip failed or timed out." | Out-File -Append -FilePath $outputFile
        }
    }
    Append-Output "nbtstat -c" "Scan: NBTStat -c"
    for ($i = 1; $i -le 10; $i++) {
        $ip = "$subnet.$i"
        Append-Output "nbtstat -An $ip" "Scan: NBTStat -An $ip"
    }
} else {
    Write-Output "Skipping network commands due to missing network configuration." | Out-File -Append -FilePath $outputFile
}

# Network Information
Append-Output "netsh wlan show profile" "Network: Show Wi-Fi Profiles"
Append-Output "netsh wlan show profile name=* key=clear" "Network: Show Wi-Fi Passwords"
Append-Output "netstat -e" "Network: Netstat -e"
Append-Output "netstat -nr" "Network: Netstat -nr"
Append-Output "netstat -naob" "Network: Netstat -naob"
Append-Output "netstat -S" "Network: Netstat -S"
Append-Output "netstat -vb" "Network: Netstat -vb"
Append-Output "route print" "Network: Route Print"
Append-Output "arp -a" "Network: ARP -a"
Append-Output "ipconfig /all" "Network: IPConfig All"
Append-Output "netsh wlan show interfaces" "Network: Show WLAN Interfaces"
Append-Output "netsh wlan show all" "Network: Show All WLAN"

# Firewall
Append-Output "netsh advfirewall show rule name=all" "Firewall: Show All Rules"
Append-Output "netsh advfirewall set allprofiles state off" "Firewall: Set All Profiles State Off"
Append-Output "netsh advfirewall set allprofiles state on" "Firewall: Set All Profiles State On"
Append-Output "netsh advfirewall set publicprofile state on" "Firewall: Set Public Profile State On"
Append-Output "netsh advfirewall set privateprofile state on" "Firewall: Set Private Profile State On"
Append-Output "netsh advfirewall set domainprofile state on" "Firewall: Set Domain Profile State On"
Append-Output "netsh advfirewall firewall add rule name='Open Port 80' dir=in action=allow protocol=TCP localport=80" "Firewall: Add Rule to Open Port 80"
Append-Output "netsh advfirewall firewall add rule name='My Application' dir=in action=allow program='C:\MyApp\MyApp.exe' enable=yes" "Firewall: Add Rule for My Application"

# Various User Commands
Append-Output "net users" "Various: Net Users"
Append-Output "net localgroup administrators" "Various: Net Localgroup Administrators"
Append-Output "net group administrators" "Various: Net Group Administrators"
Append-Output "wmic rdtoggle list" "Various: WMIC RD Toggle List"
Append-Output "wmic useraccount list" "Various: WMIC User Account List"
Append-Output "wmic group list" "Various: WMIC Group List"
Append-Output "wmic netlogin get name,lastlogin,badpasswordcount" "Various: WMIC Netlogin Get"
Append-Output "wmic netclient list brief" "Various: WMIC Netclient List Brief"
Append-Output "wmic nicconfig get" "Various: WMIC NICConfig Get"
Append-Output "wmic netuse get" "Various: WMIC Netuse Get"

# File and Services
Append-Output "type C:\Path\To\File.txt" "Show Content of File"
Append-Output "at" "Services: At"
Append-Output "tasklist" "Services: Tasklist"
Append-Output "tasklist /svc" "Services: Tasklist /SVC"
Append-Output "schtasks" "Services: Schtasks"
Append-Output "net start" "Services: Net Start"
Append-Output "sc query" "Services: SC Query"
Append-Output "wmic service list brief | findstr 'Running'" "Services: WMIC Service List Brief Running"
Append-Output "wmic service list brief | findstr 'Stopped'" "Services: WMIC Service List Brief Stopped"
Append-Output "wmic service list config" "Services: WMIC Service List Config"
Append-Output "wmic service list brief" "Services: WMIC Service List Brief"
Append-Output "wmic service list status" "Services: WMIC Service List Status"
Append-Output "wmic service list memory" "Services: WMIC Service List Memory"
Append-Output "wmic job list brief" "Services: WMIC Job List Brief"

# Start/Stop Services
Append-Output "sc config 'servicename' start= disable" "Start/Stop Service: SC Config Disable"
Append-Output "sc stop 'servicename'" "Start/Stop Service: SC Stop"
Append-Output "wmic service where name='servicename' call ChangeStartMode Disabled" "Start/Stop Service: WMIC Service Change Start Mode Disabled"

# Autorun and Autoload
Append-Output "wmic startup list full" "Autorun and Autoload: WMIC Startup List Full"
Append-Output "wmic ntdomain list brief" "Autorun and Autoload: WMIC NTDomain List Brief"

# Registry Operations
Append-Output "reg query 'HKCU\Control Panel\Desktop'" "Registry Operations: Query Desktop"
Append-Output "reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server' /v fDenyTSConnections /t REG_DWORD /d 0 /f" "Registry Operations: Enable RDP"
Append-Output "reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server' /v fDenyTSConnections /t REG_DWORD /d 1 /f" "Registry Operations: Disable RDP"
Append-Output "reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server' /v fAllowToGetHelp /t REG_DWORD /d 1 /f" "Registry Operations: Enable Remote Assistance"

# Shadow Copy
Append-Output "vssadmin List ShadowStorage" "Shadow Copy: List Shadow Storage"
Append-Output "vssadmin List Shadows" "Shadow Copy: List Shadows"
Append-Output "net start VSS" "Shadow Copy: Start VSS"

# Policies and Patches
Append-Output "set" "Policies and Patches: Set"
Append-Output "gpresult /r" "Policies and Patches: GPResult"
Append-Output "systeminfo" "Policies and Patches: Systeminfo"
Append-Output "wmic qfe" "Policies and Patches: WMIC QFE"

# Reboot
Append-Output "shutdown.exe /r" "Reboot: Shutdown"

# Security Log Settings
Append-Output "wevtutil gl Security" "Security Log Settings: Wevtutil"

# Audit Policies
Append-Output "auditpol /get /category:*" "Audit Policies: Get Audit Policies"

# System Info
Append-Output "echo %DATE% %TIME%" "System Info: Date and Time"
Append-Output "hostname" "System Info: Hostname"
Append-Output "systeminfo" "System Info: System Info"
Append-Output "wmic csproduct get name" "System Info: WMIC CS Product"
Append-Output "wmic bios get serialnumber" "System Info: WMIC BIOS Serial Number"
Append-Output "wmic computersystem list brief" "System Info: WMIC Computer System List Brief"

# Log end time
Write-Output "Script ended at $(Get-Date)" | Out-File -Append -FilePath $outputFile
