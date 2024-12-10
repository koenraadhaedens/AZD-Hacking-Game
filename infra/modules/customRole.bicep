@description('Subscription ID where the custom role will be assigned')
param subscriptionId string

@description('Unique name for the custom role')
param customRoleName string = 'Resource Policy Contributor - Custom'

@description('Actions allowed for this role')
param allowedActions array = [
  'Microsoft.Authorization/policyassignments/*'
  'Microsoft.Authorization/policydefinitions/*'
  'Microsoft.Authorization/policyexemptions/*'
  'Microsoft.Authorization/policysetdefinitions/*'
  'Microsoft.PolicyInsights/remediations/*'
]

@description('Assignable scopes for the custom role')
param assignableScopes array = [
  subscriptionId
]

@description('Description of the custom role')
param roleDescription string = 'Custom role for managing resource policies in the subscription'

output roleDefinitionId string = guid(subscriptionId, customRoleName)

resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscriptionId, customRoleName)
  properties: {
    roleName: customRoleName
    description: roleDescription
    permissions: [
      {
        actions: allowedActions
        notActions: [] // Add restrictions here if needed
      }
    ]
    assignableScopes: assignableScopes
  }
}
