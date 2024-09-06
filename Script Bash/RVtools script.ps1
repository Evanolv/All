########################################################################################################################
#                                                                                                                      #
#                                            Novasys script RVTools                                                    #
#                                                                                                                      #
########################################################################################################################
#                                                                                                                      #
#                                           Créateur : Oliveira Evan                                                   #
#                                                                                                                      #
########################################################################################################################

$User = "nvsinventory"
$EncryptedPassword = "_RVToolsPWDnkW2Vic9FhjHivO6I3CUrq0earyy2J3tncRHKNNOyR7uEPYb7FMsPvwQ7/yLGhovsYx34GAnItD3VfmMCdVU/gQqgTup/wOsJb8/1Hn8taw=" # use RVToolsPasswordEncryption.exe to encrypt your password
$fichier = "C:\Users\$env:USERNAME\Documents\RVtools\xlsv"
$date = Get-Date -Format yyyy-MM-dd


## Test l'existence du répertoire "RVtools"
$test_dir = Test-Path "C:\Users\$env:USERNAME\Documents\RVtools\"
if (-not $test_dir) {
    # Création du répertoire s'il n'existe pas
    mkdir "C:\Users\$env:USERNAME\Documents\RVtools\"
    mkdir "C:\Users\$env:USERNAME\Documents\RVtools\csv"
}

# Chemin du fichier liste.txt
$liste = "C:\Users\$env:USERNAME\Documents\RVtools\liste.txt"

# Teste si le fichier liste.txt existe
$test_liste = Test-Path $liste
if (-not $test_liste) {
    # Si la liste n'existe pas, demande à l'utilisateur de la créer
    $content = Read-Host "Rentrer votre liste, 1 ligne = 1 hôte"
    # Crée le fichier liste.txt avec le contenu
    New-Item -Path $liste -ItemType "file" -Value $content
    Write-Host "Fichier liste.txt créé avec succès."
} else {
    Write-Host "Le fichier liste.txt existe déjà."
}

# Navigation dans le répertoire de RVTools
cd "C:\Program Files (x86)\Robware\RVTools"

# Pour chaque ligne dans le fichier liste.txt, exécute RVTools
foreach ($line in Get-Content $liste) {
    $ESXServer = $line
    $nom_report = $date + "_" + "$ESXServer.xlsx"
    Write-Host "Export du $ESXServer dans $fichier/$nom_report" -ForegroundColor Yellow
    
    # Arguments pour exécuter RVTools avec les paramètres spécifiés
    $Arguments = "-u $User -p $EncryptedPassword -s $ESXServer -c ExportAll2xlsx -d $fichier -f $nom_report"
    Write-Host $Arguments

    # Lancement du processus RVTools
    $Process = Start-Process -FilePath ".\RVTools.exe" -ArgumentList $Arguments -NoNewWindow -Wait -PassThru
}
