$recovery = "R:"
$date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$local_zip = "R:\WindowsImageBackup_$date.zip"
#$cloud_folder = "C:\Users\felip\iCloudDrive\Backup\Frigobar"

# ===== VERIFICA SAÚDE DO HD =====
$disk = Get-PhysicalDisk | Where-Object FriendlyName -eq "SAMSUNG HD502HI"

if ($null -eq $disk) {
    Write-Host "Disco não encontrado."
}
elseif ($disk.HealthStatus -eq "Healthy") {

    Write-Host "HD saudável. Iniciando backup..."

    # ===== EXECUTA BACKUP =====
    wbadmin start backup -backupTarget:$recovery -include:C: -allCritical -quiet

    if ($LASTEXITCODE -eq 0) {

        Write-Host "Backup concluído. Compactando..."

        # ===== COMPACTA LOCALMENTE =====
        tar -a -c -f $local_zip -C "R:\" "WindowsImageBackup"

        #Write-Host "Enviando para nuvem..."

        # ===== MOVE PARA ICLOUD =====
        #robocopy "R:\" $cloud_folder "WindowsImageBackup_$date.zip" /MOV /R:3 /W:5

        Write-Host "Processo concluído com sucesso."
    }
    else {
        Write-Host "Erro no wbadmin. Backup NÃO será compactado."
    }
}
else {
    Write-Host "HD encontrado, mas NÃO está saudável!"
}