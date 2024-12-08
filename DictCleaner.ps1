cd $PSScriptRoot

$fullDictionary = gc .\RawDictWithDefinitions.txt

$words = @()
$fullDictionary[1..($fullDictionary.Length-1)] | %{
    $words += ($_ -split "`t")[0]
}
$words | Out-File "AllWords.txt"

#Trim the dictionary to not include non-english words
$words = @()

$trimPhrases = @(
    "(Hindi)","(Zulu)","(Russian)","(Hawaiian)","(Japanese)","(Slovene)","(Maori)","(French)","(Irish)","(Scots)","(Shakespeare)"
    ,"(Dutch)","(archaic)","(Latin)","(Spenser)","(dialect)","(Australian slang)","(Welsh)","(Spanish)","(Korean)","(Greek)","(Italian)"
    ,"(German)","(obsolete)"
)
$trims = @{}
$trimPhrases | %{$trims[$_] = @()}

$fullDictionary[1..($fullDictionary.Length-1)] | %{ #($fullDictionary.Length-1)
    $line = $_
    $GetsTrimmed = $false
    $trimPhrases | %{
        if($line -match $_){
            $trims[$_] += $line
            $GetsTrimmed = $true
        }
    }

    if(-not $GetsTrimmed){
        $words += $line
    }
}

$words | Out-File "TrimmedDictionary.txt"
$trimPhrases | %{
    $trims[$_] | Out-File ".\Removed Words\$_.txt"
}