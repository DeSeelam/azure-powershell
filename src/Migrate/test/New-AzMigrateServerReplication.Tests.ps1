$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)
$TestRecordingFile = Join-Path $PSScriptRoot 'New-AzMigrateServerReplication.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'New-AzMigrateServerReplication' {
    It 'ByNameDefaultUser' -skip {
        { throw [System.NotImplementedException] } | Should -Not -Throw
    }

    It 'ByNamePowerUser' -skip {
        { throw [System.NotImplementedException] } | Should -Not -Throw
    }

    It 'ByInputObjectDefaultUser' -skip {
        { throw [System.NotImplementedException] } | Should -Not -Throw
    }

    It 'ByIdDefaultUser' -skip {
        { throw [System.NotImplementedException] } | Should -Not -Throw
    }

    It 'ByIdPowerUser' -skip {
        { throw [System.NotImplementedException] } | Should -Not -Throw
    }

    It 'ByInputObjectPowerUser' -skip {
        { throw [System.NotImplementedException] } | Should -Not -Throw
    }
}
