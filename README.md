
## Breve script de Backup utilizando [wbadmin]([http://example.com](https://learn.microsoft.com/pt-br/windows-server/administration/windows-commands/wbadmin)) 

O Script segue algumas etapas; 

1. Verifica a saude do HD
2. Caso exista uma pasta **WindowsImageBackup** que sobrou de um Backup antigo, ela é renomeada com _OLD
3.  Backup é iniciado
4.  Se for bem sucedido, a pasta _OLD é removida
5.  O arquivo é compactado e renomeado com a data atual
6.  Talvez, o arquivo compactado seja enviado para uma pasta em nuvem 

<img width="1749" height="759" alt="tutorial" src="https://github.com/user-attachments/assets/9b524daf-03ca-43b4-b81c-e02a43098699" />
