mkdir OctopusDeploy | Out-Null

function Invoke-OctopusDeployApi ($endpoint) {
    $url = "https://octopus.mindbox.ru" + $endpoint
    $WebClient = New-Object net.webclient
    $WebClient.Encoding = [System.Text.Encoding]::UTF8
    $WebClient.Headers.Add("accept","application/json")
    $WebClient.Headers.Add("X-Octopus-ApiKey", "API-PXMJGXURSEOKTJI7HTK3JJIPUQQKWCJS")
    $WebClient.DownloadString($url) | ConvertFrom-Json | ConvertTo-Csv
}

$OctopusDeployTemplatesFolder = [io.path]::combine("./", "OctopusDeploy", "ScriptModules")
mkdir $OctopusDeployTemplatesFolder | Out-Null
cd $OctopusDeployTemplatesFolder

$templates = Invoke-OctopusDeployApi "/api/Spaces-1/libraryvariablesets?ContentType=ScriptModule"
#$templates = Invoke-OctopusDeployApi "/api/Spaces-1/variables/variableset-LibraryVariableSets-361"

$variables = $templates.Items | Select-Object -ExpandProperty Links | Select-Object -ExpandProperty Variables

#$variables = $variables -replace '\[','' -replace '\]','' -replace 'Octopus.Script.Module','' -replace '\.',''

$variables | Out-File -FilePath "variables_list.txt" -Encoding UTF8
#$variables | Out-File -FilePath "test.txt" -Encoding UTF8
