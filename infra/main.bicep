targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@secure()
@description('Password for the Windows VM')
param HackVMPassword string //no value specified, so user will get prompted for it during deployment

var tags = {
  'azd-env-name': environmentName
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module vnet './vnet.bicep' = {
  scope: rg
  name: 'vnetDeployment'
  params: {
    environmentName: environmentName
    location: location
    }
}

module hackvm './hackvm.bicep' = {
  name: 'hackvmDeployment'
  scope: resourceGroup(rg.name)
  dependsOn: [
    vnet
  ]
  params: {
    environmentName: environmentName
    location: location
    vnetName: '${environmentName}-vnet'
    subnetName: 'subnet-unsecure'
    privateIP: '10.0.0.100'
    hackeruser: 'hacker1'
    HackVMPassword: HackVMPassword
  }
}

module dcvm './dcvm.bicep' = {
  name: 'dcvmDeployment'
  scope: resourceGroup(rg.name)
  dependsOn: [
    vnet
  ]
  params: {
    environmentName: environmentName
    location: location
    vnetName: '${environmentName}-vnet'
    subnetName: 'subnet-secure'
    privateIP: '10.0.1.250'
    domainName: 'contoso.com'
    adminUsername: 'DCadmin'
    adminPassword: 'SecurePass123'
  }
}
