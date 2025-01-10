$computername = "LAPTOP-I651QOV4"
    Get-CpuUtilization -computername $computername
    Get-MemoryUtilization -computername $computername
    Get-DiskUtilization -computername $computername

    function Get-CpuUtilization {
    try {
        Get-WmiObject Win32_processor -ComputerName $computername |
        Select-Object Name, LoadPercentage, NumberOfCores |
        Format-Table -AutoSize
    }
    catch {
        <#Do this if a terminating exception happens#>
    }
    }
    
    function Get-MemoryUtilization {

    try {
        Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computername |    
        Select-Object PSComputername, @{Name="FreeMemoryGB";Expression={[math]::Round(($_.FreePhysicalMemory/1GB),2)}} |
        Format-Table -AutoSize

        Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computername |
        Select-Object PSComputername, @{Name="TotalMemoryGB";Expression={[math]::Round(($_.TotalVisibleMemorySize/1MB),2)}} |
        Format-Table -AutoSize
    }
    catch {
        <#Do this if a terminating exception happens#>
    }
    }
    
    function Get-DiskUtilization {

    try {
        Get-WmiObject -Class Win32_LogicalDisk -ComputerName $computername |
        Select-Object SystemName, @{Name="SizeGB";Expression={[math]::Round(($_.Size/1GB),2)}}, @{Name="FreeSpaceGB";Expression={[math]::Round(($_FreeSpace/1GB),2)}} |
        Format-Table -AutoSize
    }
    catch {
        <#Do this if a terminating exception happens#>
    }
    }
