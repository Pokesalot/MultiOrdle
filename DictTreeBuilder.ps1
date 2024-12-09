param ($inputFile = $null, $outputFile = "DictionaryTree.json")

cd $PSScriptRoot
$Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

$dict = @{
    #"null" = @(3,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
    #The only 1-letter words are A and I
    #Values are bitwise representations
        #MSB is whether the current last letter makes a word
        #LSB is whether there exist words starting with the last letter

        #e.g. at $dict["wor"] the 's' position will be 1 (not a word, but the start of "worse")
                             #the 'd' position will be 3 (word is a word, and the start of "words")
                             #the 'a' position will be 0 (not a word or the start of one)
    #This feature is temporarily out of action until I can decide what I want the key to be for 0-letter words
}

function AddWordToDict($ArrayOfLetters){
    0..($ArrayOfLetters.Count -2) | %{

        if(-not $dict.ContainsKey($($ArrayOfLetters[0..$_] -join ""))){
            $dict[$($ArrayOfLetters[0..$_] -join "")] = @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
        }

        if($_ -eq $ArrayOfLetters.Count -2){
            $dict[$($ArrayOfLetters[0..$_] -join "")][$Letters.IndexOf($ArrayOfLetters[$_+1])] = $dict[$($ArrayOfLetters[0..$_] -join "")][$Letters.IndexOf($ArrayOfLetters[$_+1])] -bor 2
        }else{
            $dict[$($ArrayOfLetters[0..$_] -join "")][$Letters.IndexOf($ArrayOfLetters[$_+1])] = $dict[$($ArrayOfLetters[0..$_] -join "")][$Letters.IndexOf($ArrayOfLetters[$_+1])] -bor 1
        }
    }

}

if($inputFile -eq $null){
    Write-Host "Entering words manually. Enter a blank word to finish"
    $word = (Read-Host "Enter a valid word").ToUpper() -split "" | ?{$_ -ne ""}
    while($word -ne $null){
        AddWordToDict $word

        $word = (Read-Host "Enter a valid word").ToUpper() -split "" | ?{$_ -ne ""}
    }
}else{
    $words = gc $inputFile
    $words | %{AddWordToDict $($_.ToUpper() -split "" | ?{$_ -ne ""}) }
}

$dictLines = $($dict | ConvertTo-Json -Depth 15 -Compress) -replace ",`"","`n`"" -replace "{","{`n" -replace "}","`n}" -split "`n"
$dictLines = $($dictLines[1..($dictLines.Count-2)] | Sort-Object)

$writeString = "{`n"

$dictLines[0..($dictLines.Count-2)] | %{ $writeString += $($_ -replace ":"," : ") + ",`n`t"}
$writeString += $($dictLines[$dictLines.Count-1] + "`n}")
$writeString | Out-File $outputFile