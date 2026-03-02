$recovery = "R:"
$date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$local_zip = "R:\WindowsImageBackup_$date.zip"

$currentBackup = "R:\WindowsImageBackup"
$oldBackup     = "R:\WindowsImageBackup_OLD"

# ===== VERIFICA SAÚDE DO HD =====
$disk = Get-PhysicalDisk | Where-Object FriendlyName -eq "SAMSUNG HD502HI"

if ($null -eq $disk) {
    Write-Host "Disco não encontrado."
}
elseif ($disk.HealthStatus -eq "Healthy") {

    Write-Host "HD saudável. Iniciando processo..."

    # ===== SE EXISTIR BACKUP ATUAL, RENOMEIA PARA _OLD =====
    if (Test-Path $currentBackup) {

        # Se já existir um OLD antigo, remove
        if (Test-Path $oldBackup) {
            Remove-Item $oldBackup -Recurse -Force
        }

        Rename-Item $currentBackup $oldBackup
        Write-Host "Backup anterior renomeado para _OLD."
    }

    # ===== EXECUTA BACKUP =====
    wbadmin start backup -backupTarget:$recovery -include:C: -allCritical -quiet

    if ($LASTEXITCODE -eq 0) {

        Write-Host "Backup concluído com sucesso."

        # ===== REMOVE O OLD =====
        if (Test-Path $oldBackup) {
            Remove-Item $oldBackup -Recurse -Force
            Write-Host "Backup antigo removido."
        }

        # ===== COMPACTA O NOVO =====
        Write-Host "Compactando novo backup..."
        tar -a -c -f $local_zip -C "R:\" "WindowsImageBackup"

        Write-Host "Processo concluído com sucesso."
    }
    else {
        Write-Host "Erro no wbadmin!"

        # ===== RESTAURA O OLD SE DER ERRO =====
        if (Test-Path $oldBackup) {
            Rename-Item $oldBackup $currentBackup
            Write-Host "Backup anterior restaurado."
        }
    }
}
else {
    Write-Host "HD encontrado, mas NÃO está saudável!"
}