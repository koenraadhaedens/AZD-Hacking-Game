param environmentName string
param location string
param vnetName string
param subnetName string
param privateIP string
param domainName string
param adminUsername string
@secure()
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
    dnsSettings: {
      dnsServers: [
        '10.0.1.250'
      ] 
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'DCvm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
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


