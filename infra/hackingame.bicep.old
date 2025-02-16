@description('Location for all resources')
param location string = resourceGroup().location

@description('Address space for the virtual network')
param vnetAddressSpace array = ['10.1.0.0/16']

@description('Subnet configurations')
param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '10.1.0.0/24'
    networkSecurityGroupId: ''
  }
]

@description('Name of the custom role to create')
param customRoleName string = 'Resource Policy Contributor - Custom'

@description('Description of the custom role')
param customRoleDescription string = 'Custom role for managing resource policies'

@description('Principal ID of the managed identity')
param principalId string

@description('Admin username for the virtual machine')
param adminUsername string = 'cohackadmin'

@description('Admin password for the virtual machine')
param adminPassword string

// Create Virtual Network
module virtualNetwork './modules/virtualNetwork.bicep' = {
  name: 'vnetModule'
  params: {
    vnetName: 'vnet-cohack1'
    location: location
    resourceGroupName: resourceGroup().name
    addressSpace: vnetAddressSpace
    subnets: subnets
  }
}

// Create Managed Identity
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'mi-sentinel1'
  location: location
}

output managedIdentityId string = managedIdentity.id

// Create Custom Role
module customRole './modules/customRole.bicep' = {
  name: 'customRoleDefinition'
  params: {
    subscriptionId: subscription().id
    customRoleName: customRoleName
    roleDescription: customRoleDescription
  }
}

// Assign Custom Role to Managed Identity
module roleAssignment './modules/roleAssignment.bicep' = {
  name: 'assignCustomRoleToMI'
  params: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: customRole.outputs.roleDefinitionId
    scope: subscription().id
  }
}

// Create Virtual Machine
resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'vm-cohack1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'windows-11'
        sku: 'win11-21h2-pro'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'cohack-vm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'nic-cohack1')
        }
      ]
    }
  }
}

output virtualNetworkId string = virtualNetwork.outputs.vnetId
output virtualMachineId string = virtualMachine.id
output customRoleId string = customRole.outputs.roleDefinitionId
