@description('Principal ID (Object ID) of the user, group, or managed identity to assign the role to')
param principalId string

@description('Role Definition ID (GUID of the role) to assign')
param roleDefinitionId string

@description('Scope of the role assignment (e.g., subscription, resource group, or specific resource)')
param scope string

@description('Unique name for the role assignment')
param roleAssignmentName string = guid(principalId, roleDefinitionId, scope)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleAssignmentName
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    scope: scope
  }
}

output roleAssignmentId string = roleAssignmentName
