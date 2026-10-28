$vm_name = "<<vm_name>>"
$rg_name = "<< RG Name>>"

$result = Get-AzVM -ResourceGroupName $rg_name -Name $vm_name

$json_output = $result | ConvertTo-Json

$json_output

#IF we need a particular data key to be retrieved individually

$context = $json_output |convertfrom-Json
$context.tags.app_name