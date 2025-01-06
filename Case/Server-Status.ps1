$IC_ScriptBlock = {
    $CIM_CS = Get-CimInstance -ClassName CIM_ComputerSystem
    $CIM_BE = Get-CimInstance -ClassName CIM_BIOSElement
    $CIM_Processor = Get-CimInstance -ClassName CIM_Processor
    $CIM_Processor2 = WmiObject -class win32_processor
    $CIM_OS = Get-CimInstance -ClassName CIM_OperatingSystem
    $CIM_Ram = Get-CimInstance -ClassName CIM_PhysicalMemory

    [PSCustomObject]@{
        ComputerName = $CIM_CS.Name
        # this may be an array in a multi-processor system
        Processor = $CIM_Processor.Name
        ProcessorSpeed_Mhz = $CIM_Processor.MaxClockSpeed
        ProcessorID = $CIM_Processor2.DeviceID
        ProcessorCores = $CIM_Processor2.NumberofCores
        ProcessorLogicalCores = $CIM_Processor2.NumberofLogicalProcessors
        InstalledRAM_GB = [math]::Round(($CIM_Ram.Capacity |
            Measure-Object -Sum).Sum / 1GB, 2)
        RamSlot = $CIM_Ram.DeviceLocator
        RamSpeed = $CIM_Ram.Speed
        RamType = $CIM_Ram.MemoryType
        Manufacturer = $CIM_CS.Manufacturer
        Model = $CIM_CS.Model
        SerialNumber = $CIM_BE.SerialNumber
        OS_Name = $CIM_OS.Caption
        OS_Version = $CIM_OS.Version
        OS_InstallDate = $CIM_OS.InstallDate.ToString('yyyy-MM-dd')
    }
}

$Computers = ""
Invoke-Command -ComputerName $Computers -ScriptBlock $IC_ScriptBlock -ErrorAction SilentlyContinue