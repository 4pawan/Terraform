
# Connect-AzureRmAccount
$rg = New-AzResourceGroup -Name 'RG01' -Location "South Central US"
$publicIp = New-AzPublicIpAddress -Name 'piblicApAddres_test' -ResourceGroupName $rg.ResourceGroupName -AllocationMethod Static -DomainNameLabel 'demo_local' -Location $rg.Location
$subnet = New-AzVirtualNetworkSubnetConfig -Name ApplicationSubnet -AddressPrefix "10.0.1.0/24"
$vn = New-AzVirtualNetwork -Name 'MyVirtualNetwork' -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -AddressPrefix "10.0.0.0/16" -Subnet $subnet

$adminPassword ="########"
$rgName ="#######"
$location="southcentralus"
$UserName = "########"
$Password = ConvertTo-SecureString $adminPassword  -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($UserName, $Password)

$Vnet = $(Get-AzVirtualNetwork -ResourceGroupName $rgName -Name 'MyVirtualNetwork')
$PIP = (Get-AzPublicIpAddress -ResourceGroupName $rgName -Name 'publicIpName')

$NIC = GET-AzNetworkInterface -Name 'NICname' -ResourceGroupName $rgName
#$NIC = New-AzNetworkInterface -Name NICname -ResourceGroupName ResourceGroup2 -Location SouthCentralUS -SubnetId $Vnet.Subnets[1].Id -PublicIpAddressId $PIP.Id
$VirtualMachine = New-AzVMConfig -VMName VirtualMachineName -VMSize Standard_D4s_v3
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName computerName -Credential $psCred -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMBootDiagnostic -VM $VirtualMachine  -Disable 
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsDesktop' -Offer 'Windows-10' -Skus 'win10-21h2-pro' -Version latest
New-AzVm -ResourceGroupName $rgName -Location $location -VM $VirtualMachine
    

#######
Get-AzVMImageOffer -Location $location -PublisherName 'MicrosoftWindowsDesktop'
Get-AzVMImageSku -Location $location -PublisherName 'MicrosoftWindowsDesktop' -Offer 'Windows-10'
Get-AzVMImagePublisher -Location $location | Where-Object { $_.PublisherName.Contains("Windows")} | Select-Object PublisherName
help "PropertyName"
Remove-AzVM -Name $VirtualMachine.Name -ResourceGroupName  $rgName 
Remove-AzResourceGroup -Name $rgName -Confirm        
help Set-AzVMBootDiagnostic
Get-AzLocation | Where-Object { $_.Location.Contains("south") } | Select-Object Location 

