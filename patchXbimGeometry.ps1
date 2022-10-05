using namespace System

$xmlsettings = New-Object System.Xml.XmlWriterSettings
$xmlsettings.Indent = $true
$xmlsettings.IndentChars = "    "

$versionNumber = '5.2.70'

# function AddRepositoryUrl($path) {
#     $propertyGroup = Select-Xml -Path $path -XPath '/Project/PropertyGroup[1]'
#     if ($propertyGroup) {
#         $doc = $propertyGroup.Node.OwnerDocument

#         $urlNode = $doc.CreateNode("element", "RepositoryUrl", $null)
#         $urlNode.InnerText = 'https://github.com/novorender/novorender-backend'
#         $propertyGroup.node.AppendChild($urlNode)

#         $version = $doc.CreateNode("element", "Version", $null)
#         $version.InnerText = $versionNumber
#         $propertyGroup.node.AppendChild($version)

#         # Set the File Name Create The Document
#         $XmlWriter = [System.XML.XmlWriter]::Create($path, $xmlsettings)
#         $doc.Save($XmlWriter)
#         $XmlWriter.Dispose()
#     }
# }

# Get-ChildItem -Path .\ -Filter *.csproj -Recurse -File | ForEach-Object {
#     AddRepositoryUrl($_.FullName)
#     ((Get-Content -path $_.FullName -Raw) -replace '5.1.314', $versionNumber) | Set-Content -Path $_.FullName
#     ((Get-Content -path $_.FullName -Raw) -replace '5.1.324', $versionNumber) | Set-Content -Path $_.FullName
#     ((Get-Content -path $_.FullName -Raw) -replace '5.1.329', $versionNumber) | Set-Content -Path $_.FullName
#     ((Get-Content -path $_.FullName -Raw) -replace '5.2.3', $versionNumber) | Set-Content -Path $_.FullName
# }
# $file = get-item -path 'nuget.config'
# $configuration = Select-Xml -Path $file -XPath '/configuration'
# $packageSources = $configuration.Node['packageSources']
# $packageSources.InnerXml = '<add key="github" value="https://nuget.pkg.github.com/novorender/index.json" />'
# $doc = $configuration.Node.OwnerDocument
# $packageSourceCredentials = $doc.CreateNode("element", "packageSourceCredentials", $null)
# $packageSourceCredentials.InnerXml = '<github><add key="Username" value="SigveBergslien" /><add key="ClearTextPassword" value="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" /></github>'
# $configuration.Node.AppendChild($packageSourceCredentials)

# $doc.Save($file.FullName)

# ((Get-Content -path xbim.geometry.nuspec -Raw) -replace '5.2.3', $versionNumber) | Set-Content -Path .\xbim.geometry.nuspec
nuget pack .\xbim.geometry.nuspec


dotnet pack --configuration Release
Get-ChildItem -Path .\ -Filter *$versionNumber.nupkg -Recurse -File | ForEach-Object {
    dotnet nuget push $_.FullName --source "github" --skip-duplicate -k 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
}
