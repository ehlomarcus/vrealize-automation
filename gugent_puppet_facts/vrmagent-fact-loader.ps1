$vrmWorkitem = "C:\VRMGuestAgent\site\workitem.xml"
$puppetFactsDir = "C:\ProgramData\PuppetLabs\facter\facts.d"
$vraFacts = $puppetFactsDir+"\vrafacts.json"
New-Item -ItemType Directory -Force -Path $puppetFactsDir

$workitemList = [ordered]@{}

[xml]$vraXml = Get-Content $vrmWorkitem
foreach ($prop in $vraXml.workitem.properties.property | Sort-Object -Property name) {
    $workitemList.Add($prop.name.replace(".","_"),$prop.value)
}

$jsonObj = ConvertTo-Json -InputObject $workitemList
[IO.File]::WriteAllLines($vraFacts, $jsonObj, [System.Text.UTF8Encoding]($False))
