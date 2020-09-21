
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
Retrieves the status of an Azure Migrate job.
.Description
The Get-AzMigrateJob cmdlet retrives the status of an Azure Migrate job.
.Link
https://docs.microsoft.com/en-us/powershell/module/az.migrate/get-azmigratejob
#>
function Get-AzMigrateJob {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20180110.IJob])]
    [CmdletBinding(DefaultParameterSetName='GetByName', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='GetByID', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the job id for which the details needs to be retrieved.
        ${JobID},

        [Parameter(ParameterSetName='GetByName', Mandatory)]
        [Parameter(ParameterSetName='ListByName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # The name of the resource group where the recovery services vault is present.
        ${ResourceGroupName},

        [Parameter(ParameterSetName='GetByName', Mandatory)]
        [Parameter(ParameterSetName='ListByName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # The name of the migrate project.
        ${ProjectName},

        [Parameter(ParameterSetName='GetByName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Job identifier
        ${JobName},

        [Parameter(ParameterSetName='GetByInputObject', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20180110.IJob]
        # Specifies the job object of the replicating server.
        ${InputObject},

        [Parameter(ParameterSetName='GetByInputObjectMigrationItem', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20180110.IMigrationItem]
        # Specifies the replicating server for which the current job details needs to be initiated. The server object can be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${InputServerObject},

        [Parameter(ParameterSetName='ListById', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Resource Group of the Azure Migrate Project in the current subscription.
        ${ResourceGroupID},

        [Parameter(ParameterSetName='ListById', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Azure Migrate Project in which servers are replicating.
        ${ProjectID},

        [Parameter(ParameterSetName='ListByName')]
        [Parameter(ParameterSetName='ListById')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Query')]
        [System.String]
        # OData filter options.
        ${Filter},
    
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


            $parameterSet = $PSCmdlet.ParameterSetName
            $null = $PSBoundParameters.Remove('JobID')
            $null = $PSBoundParameters.Remove('ResourceGroupName')
            $null = $PSBoundParameters.Remove('ProjectName')
            $null = $PSBoundParameters.Remove('JobName')
            $null = $PSBoundParameters.Remove('InputObject')
            $null = $PSBoundParameters.Remove('ResourceGroupID')
            $null = $PSBoundParameters.Remove('ProjectID')
            $HasFilter = $PSBoundParameters.ContainsKey('Filter')
            $null = $PSBoundParameters.Remove('Filter')

       
            if(($parameterSet -eq 'GetByName') -or ($parameterSet -match 'List')){
                if($parameterSet -eq 'ListById'){
                    $ProjectName = $ProjectID.Split("/")[8]
                    $ResourceGroupName = $ResourceGroupID.Split("/")[4]
                }
                # TODO Get Vault Name from Project Name
                $VaultName = "AzMigrateTestProjectPWSH02aarsvault"
            }else{
                if($parameterSet -eq 'GetByInputObject'){
                    $JobID = $InputObject.Id
                }else{
                    if($InputServerObject.CurrentJobName -eq "None"){
                        throw "No current job running."
                    }
                    $JobID = $InputServerObject.CurrentJobId
                }
                $JobIdArray = $JobID.split('/')
                $JobName = $JobIdArray[10]
                $ResourceName = $JobIdArray[8]
                $ResourceGroupName = $JobIdArray[4]
            }
               
            if($parameterSet -match 'Get'){
                $null = $PSBoundParameters.Add('JobName', $JobName)
                $null = $PSBoundParameters.Add('ResourceName', $ResourceName)
                $null = $PSBoundParameters.Add('ResourceGroupName', $ResourceGroupName)
            
                return Az.Migrate.internal\Get-AzMigrateReplicationJob @PSBoundParameters 
            }else{
                $null = $PSBoundParameters.Add('ResourceName', $ResourceName)
                $null = $PSBoundParameters.Add('ResourceGroupName', $ResourceGroupName)
                if($HasFilter){$null = $PSBoundParameters.Add('Filter', $Filter)}

                return Az.Migrate.internal\Get-AzMigrateReplicationJob @PSBoundParameters 
            }
            
            
    }
}   