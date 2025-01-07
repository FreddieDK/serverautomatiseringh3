$computername = ""
    Get-CpuUtilization -computername $computername
    Get-MemoryUtilization -computername $computername
    Get-DiskUtilization -computername $computername
    [string]$computername

    function Get-CpuUtilization {

    Get-WmiObject Win32_processor -ComputerName $computername |
    Select-Object LoadPercentage, Name, NumberOfCores |
    Format-Table -AutoSize
    }
    
    function Get-MemoryUtilization {

    Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computername |
    Select-Object PSComputername, @{Name="TotalMemoryGB";Expression={[math]::Round(($_.TotalVisibleMemorySize/1GB),2)}}, @{Name="FreeMemoryGB";Expression={[math]::Round(($_.FreePhysicalMemory/1GB),2)}} |
    Format-Table -AutoSize
    }
    
    function Get-DiskUtilization {

    Get-WmiObject -Class Win32_LogicalDisk -ComputerName $computername |
    Select-Object SystemName, DeviceID, MediaType, @{Name="SizeGB";Expression={[math]::Round(($_.Size/1GB),2)}}, @{Name="FreeSpaceGB";Expression={[math]::Round(($_FreeSpace/1GB),2)}} |
    Format-Table -AutoSize
    }
