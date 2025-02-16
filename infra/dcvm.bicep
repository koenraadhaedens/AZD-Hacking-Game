param environmentName string
param location string
param vnetName string
param subnetName string
param privateIP string
param domainName string
param adminUsername string
param adminPassword string

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${environmentName}-dc-publicIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${environmentName}-dc-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: privateIP
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'DCvm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    osProfile: {
      computerName: 'DCvm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource domainControllerExtension 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: '${vm.name}/ADDomainExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: domainName
      OUPath: 'OU=Domain Controllers,DC=contoso,DC=com'
      DnsIpAddresses: [
        privateIP
      ]
    }
    protectedSettings: {
      AdminUsername: adminUsername
      AdminPassword: adminPassword
    }
  }
}
