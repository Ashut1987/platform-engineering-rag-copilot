$vm_name = << VM Name >>
$rg_name = << Resource Group Name >>

$result = Get-AzVM -ResourceGroupName $rg_name -Name $vm_name

$json_output = $result | ConvertTo-Json

$json_output

#IF we need a particular data key to be retrieved individually

$context = $json_output |convertfrom-Json
$context.<< enter key to get the value >>