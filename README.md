
## Breve script de Backup utilizando wbadmin 

O Script segue algumas etapas; 

1. Verifica a saude do HD
2. Caso exista uma pasta **WindowsImageBackup** que sobrou de um Backup antigo, ela é renomeada com _OLD
3.  Backup é iniciado
4.  Se for bem sucedido, a pasta _OLD é removida
5.  O arquivo é  duplicado compactado e renomeado com a data atual e salvo na unidade de backup
6.  Talvez, o arquivo compactado seja enviado para uma pasta em nuvem
7.  A ultima pasta **WindowsImageBackup** se mantem disponivel para restauracao imediata
---

Recomendo que nao tenha arquivos desnecessarios no disco C:, e que tenha um volume dedicado apenas para armazenar o arquivo do wbadmin

---
Para utilizacao em outros ambientes, é necessario alterar as variaveis com a letra da unidade de recovery (onde fica o backup), alterar a letra da unidade que será feito o Backup e alterar o nome do disco de armazenamento em que o backup é salvo

```powershell
$recovery = "R:"
$bkp_disk = "C:"
$hd_name = "SAMSUNG HD502HI"
```
---

<img width="1749" height="759" alt="tutorial" src="https://github.com/user-attachments/assets/9b524daf-03ca-43b4-b81c-e02a43098699" />

 ---

 Algumas condicoes chatas acontecem, como muito espaco no disco necessario e permissao de admin para execucao. 
