$auditJson = yarn audit --groups dependencies --json | ConvertFrom-Json
$auditJson = $auditJson.data.vulnerabilities
$severityCount = 0

#echo $auditJson.PSObject.Properties
foreach ($vulnerability in $auditJson.PSObject.Properties) {
  $severityCount++
  if($vulnerability.Name -eq "critical" -And $vulnerability.Value -gt 0) {
    $severityCount++
  }
  if($vulnerability.Name -eq "high" -And $vulnerability.Value -gt 0) {
    $severityCount++
  }
}

if($severityCount -gt 0) {
  echo "Total Severity Count is $severityCount"
  exit 1
}

