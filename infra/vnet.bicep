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
        }
      }
      {
        name: 'subnet-secure'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
    ]
  }
}
