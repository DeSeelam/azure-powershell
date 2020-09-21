
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Stops replication for the migrated server. 
.Description
The Remove-AzMigrateServerReplication cmdlet stops the replication for a migrated server. 
.Link
https://docs.microsoft.com/en-us/powershell/module/az.migrate/remove-azmigrateserverreplication
#>
function Remove-AzMigrateServerReplication {
    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName='ByNameVMwareCbt', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='ByIDVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the replcating server for which the replicatio needs to be disabled. The ID should be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${TargetObjectID},

        [Parameter(ParameterSetName='ByNameVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the resource group of the replicating server.
        ${ResourceGroupName},

        [Parameter(ParameterSetName='ByNameVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the migrate project name of the replicating server.
        ${ProjectName},

        [Parameter(ParameterSetName='ByNameVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the machine name of the replicating server.
        ${MachineName},

        [Parameter(ParameterSetName='ByInputObjectVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20180110.IMigrationItem]
        # Specifies the machine object of the replicating server.
        ${InputObject},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Query')]
        [System.String]
        # Specifies whether the replication needs to be force removed.
        ${ForceRemove},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # Azure Subscription ID.
        ${SubscriptionId},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Returns true when the command succeeds
        ${PassThru},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {            
            $hasDeleteOption = $PSBoundParameters.ContainsKey('ForceRemove')
            $null = $PSBoundParameters.Remove('ForceRemove')
            $null = $PSBoundParameters.Remove('TargetObjectID')
            $null = $PSBoundParameters.Remove('ResourceGroupName')
            $null = $PSBoundParameters.Remove('ProjectName')
            $null = $PSBoundParameters.Remove('MachineName')
            $null = $PSBoundParameters.Remove('InputObject')
            $parameterSet = $PSCmdlet.ParameterSetName

            if ($parameterSet -eq 'ByNameVMwareCbt') {
                # TODO Get Vault Name from Project Name
                $VaultName = "AzMigrateTestProjectPWSH02aarsvault"
                $applianceName = "AzMigratePWSHT"
                $null = $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
                $null = $PSBoundParameters.Add('ResourceName', $VaultName)
                $allFabrics = Az.Migrate.internal\Get-AzMigrateReplicationFabric @PSBoundParameters
                $FabricName = ""
                if($allFabrics -and ($allFabrics.length -gt 0)){
                    foreach ($fabric in $allFabrics) {
                        if($fabric.Name -match $applianceName){
                            $FabricName = $fabric.Name
                            break
                        }
                    }
                }
                if($FabricName -eq ""){
                    throw "Fabric not found for given resource group"
                }

                $null = $PSBoundParameters.Add('FabricName', $FabricName)
                $peContainers = Az.Migrate.internal\Get-AzMigrateReplicationProtectionContainer @PSBoundParameters
                $ProtectionContainerName = ""
                if($peContainers -and ($peContainers.length -gt 0)){
                    foreach ($peContainer in $peContainers) {
                        if($peContainer.Name -match $applianceName){
                            $ProtectionContainerName = $peContainer.Name
                            break
                        }
                    }
                }

                if($ProtectionContainerName -eq ""){
                    throw "Container not found for given resource group"
                }

                $null = $PSBoundParameters.Remove('ResourceGroupName')
                $null = $PSBoundParameters.Remove('ResourceName')
                $null = $PSBoundParameters.Remove('FabricName')

            }else {
                if($parameterSet -eq 'ByInputObjectVMwareCbt'){
                    $TargetObjectID = $InputObject.Id
                }
                $MachineIdArray = $TargetObjectID.Split("/")
                $ResourceGroupName = $MachineIdArray[4]
                $VaultName = $MachineIdArray[8]
                $FabricName = $MachineIdArray[10]
                $ProtectionContainerName = $MachineIdArray[12]
                $MachineName = $MachineIdArray[14]
            }

            $null = $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
            $null = $PSBoundParameters.Add("ResourceName", $VaultName)
            $null = $PSBoundParameters.Add("FabricName", $FabricName)
            $null = $PSBoundParameters.Add("MigrationItemName", $MachineName)
            $null = $PSBoundParameters.Add("ProtectionContainerName", $ProtectionContainerName)
            if($hasDeleteOption){$null = $PSBoundParameters.Add('DeleteOption', $ForceRemove)}
            return Az.Migrate.internal\Remove-AzMigrateReplicationMigrationItem @PSBoundParameters      
    }
}   