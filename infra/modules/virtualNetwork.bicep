@description('Name of the virtual network')
param vnetName string

@description('Location of the virtual network')
param location string

@description('Resource group name where the virtual network will be created')
param resourceGroupName string

@description('Address space for the virtual network')
param addressSpace array

@description('Array of subnet configurations')
param subnets array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: subnet.networkSecurityGroupId != '' ? {
            id: subnet.networkSecurityGroupId
          } : null
        }
      }
    ]
  }
}

output vnetId string = virtualNetwork.id
output subnetIds array = [for subnet in virtualNetwork.properties.subnets: subnet.id]
