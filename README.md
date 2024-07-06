# windows_forensic-



# Windows Forensic Commands Script

This PowerShell script executes a series of Windows forensic commands and saves the output into a file named `forensic_report.txt`. The script is designed to gather network information, user details, service statuses, system information, and more for forensic analysis.

## Prerequisites

- PowerShell 5.0 or higher
- Appropriate permissions to execute system commands and access network information

## Usage

1. **Clone the Repository:**

   ```sh
   git clone https://github.com/your-username/forensic-commands.git
   cd forensic-commands
   ```

2. **Save the Script:**

   Save the PowerShell script as `Windowsforensic.ps1`.

3. **Open PowerShell:**

   Open PowerShell with administrative privileges:

   - Press `Win + X` and select `Windows PowerShell (Admin)`

4. **Set Execution Policy:**

   Set the execution policy for the session to allow running the script:

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```

5. **Execute the Script:**

   Navigate to the directory where the script is saved and run the script:

   ```powershell
   cd C:\Path\To\Your\Script
   .\Windowsforensic.ps1
   ```

## Script Details

The script performs the following actions:

1. **Network Discovery:**

   - Executes commands like `net view`, `net share`, and `wmic` to gather network-related information.

2. **Network Scanning:**

   - Uses `nbtstat` and `ping` commands to scan the network and identify active devices.

3. **Network Information:**

   - Collects detailed network information using commands like `netsh`, `netstat`, `arp`, and `ipconfig`.

4. **Firewall Management:**

   - Retrieves and modifies firewall rules using `netsh advfirewall`.

5. **User Management:**

   - Gathers user and group information using `net user`, `net localgroup`, and `wmic`.

6. **File and Services Management:**

   - Lists services and tasks using `tasklist`, `schtasks`, and `wmic`.

7. **Registry Operations:**

   - Queries and modifies Windows registry settings using `reg` commands.

8. **Shadow Copy Management:**

   - Lists shadow copies and manages Volume Shadow Copy Service (VSS) using `vssadmin`.

9. **Policies and Patches:**

   - Retrieves system policies and patches information using `gpresult`, `systeminfo`, and `wmic qfe`.

10. **System Information:**

    - Collects system information such as hostname, date, time, BIOS serial number, and more.

## Output

The script saves all command outputs and any errors encountered into a file named `forensic_report.txt` in the same directory where the script is executed. You can adjust the output file path by modifying the `$outputFile` variable at the beginning of the script.

## Example Output

```
### Network Discovery: Net View All ###


### Network Discovery: Net View ###


### Network Discovery: Net View Hostname ###
There are no entries in the list.



### Network Discovery: Net Share ###

Share name   Resource                        Remark

-------------------------------------------------------------------------------
C$           C:\                             Default share                     
IPC$                                         Remote IPC                        
ADMIN$       C:\Windows                      Remote Admin                      
The command completed successfully.




## Troubleshooting

- Ensure you have administrative privileges when running the script.
- Check the execution policy if you encounter execution policy errors.
- Verify network settings if network-related commands fail.

## Contributing

Feel free to contribute to this project by submitting issues or pull requests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

```

This README provides a comprehensive overview of the script, instructions for usage, and details about the output and functionality. Adjust the repository URL and other specific details as needed.
