param environmentName string
param location string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${environmentName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/8'
      ]
    }
    subnets: [
      {
        name: 'subnet-unsecure'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: nsgUnsecure.id
          }
        }
      }
      {
        name: 'subnet-secure'
        properties: {
          addressPrefix: '10.1.0.0/24'
          networkSecurityGroup: {
            id: nsgSecure.id
          }
        }
      }
    ]
  }
}

resource nsgUnsecure 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${environmentName}-nsg-unsecure'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAllInbound'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
      {
        name: 'AllowAllOutbound'
        properties: {
          priority: 1000
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource nsgSecure 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: '${environmentName}-nsg-secure'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '10.0.0.100'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'AllowAllOutbound'
        properties: {
          priority: 1000
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}
