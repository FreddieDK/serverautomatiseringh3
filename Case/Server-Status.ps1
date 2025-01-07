# Henter info fra hardware
$IC_ScriptBlock = {
    $CIM_CS = Get-CimInstance -ClassName CIM_ComputerSystem
    $CIM_Processor = Get-CimInstance -ClassName CIM_Processor
    $CIM_Ram = Get-CimInstance -ClassName CIM_PhysicalMemory

    [PSCustomObject]@{
        ComputerName = $CIM_CS.Name
        Processor = $CIM_Processor.Name
        ProcessorSpeed_Mhz = $CIM_Processor.MaxClockSpeed
        RamSpeed = $CIM_Ram.Speed
    }
    $IC_ScriptBlock | Export-Csv 
}

$Computers = "LAPTOP-I651QOV4"
Invoke-Command -ComputerName $Computers -ScriptBlock $IC_ScriptBlock -ErrorAction SilentlyContinue