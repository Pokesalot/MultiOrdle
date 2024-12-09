param($TreeFile=$null, $MaxZeroes=26)
cd $PSScriptRoot
$Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

if($TreeFile -eq $null){
    $tree = Read-Host "Please paste your valid json here" | ConvertFrom-Json
}else{
    $tree = gc $TreeFile | ConvertFrom-Json
}


$keeps = @()
$tree | Get-Member -MemberType NoteProperty| select -First 4 | %{
    $key = $_.Name
    $arr = $tree.$key
    if( ($arr| ?{$_ -eq 0}).Count -gt $MaxZeroes){
        #The tree is too sparse here, and we need to prune it back
        $keeps += $key[0..($key.Length-2)] -join ""

    }
}