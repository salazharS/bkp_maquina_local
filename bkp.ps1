$recovery = "R:"
$bkp_disk = "C:"
$hd_name = "SAMSUNG HD502HI"

$date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$local_zip = "$recovery\WindowsImageBackup_$date.zip"
$bkp_atual = "$recovery\WindowsImageBackup"
$old_bkp     = "$recovery\WindowsImageBackup_OLD"

# ===== VERIFICA SAÚDE DO HD =====
$disk = Get-PhysicalDisk | Where-Object FriendlyName -eq $hd_name

if ($null -eq $disk) {
    Write-Host "Disco não encontrado."
}
elseif ($disk.HealthStatus -eq "Healthy") {

    Write-Host "HD saudável. Iniciando processo..."

    # ===== SE EXISTIR BACKUP ATUAL, RENOMEIA PARA _OLD =====
    if (Test-Path $bkp_atual) {

        # Se já existir um OLD antigo, remove
        if (Test-Path $old_bkp) {
            Remove-Item $old_bkp -Recurse -Force
        }

        Rename-Item $bkp_atual $old_bkp
        Write-Host "Backup anterior renomeado para _OLD."
    }

    # ===== EXECUTA BACKUP =====
    wbadmin start backup -backupTarget:$recovery -include:$bkp_disk -allCritical -quiet

    if ($LASTEXITCODE -eq 0) {

        Write-Host "Backup concluído com sucesso."

        # ===== REMOVE O OLD =====
        if (Test-Path $old_bkp) {
            Remove-Item $old_bkp -Recurse -Force
            Write-Host "Backup antigo removido."
        }

        # ===== COMPACTA O NOVO =====
        Write-Host "Compactando novo backup..."
        tar -a -c -f $local_zip -C "$recovery\" "WindowsImageBackup"

        Write-Host "Processo concluído com sucesso."
    }
    else {
        Write-Host "Erro no wbadmin!"

        # ===== RESTAURA O OLD SE DER ERRO =====
        if (Test-Path $old_bkp) {
            Rename-Item $old_bkp $bkp_atual
            Write-Host "Backup anterior restaurado."
        }
    }
}
else {
    Write-Host "HD encontrado, mas NÃO está saudável!"
}