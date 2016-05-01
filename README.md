# AutoIt - rLauncher
```
     |                        |              
,---.|    ,---..   .,---.,---.|---.,---.,---.
|    |    ,---||   ||   ||    |   ||---'|    
`    `---'`---^`---'`   '`---'`   '`---'`    
```

Portable launcher for removable drives (multi-language via lang file)

<h2>Generic Information
```
Language ..........: AutoIt
Type ..............: Script
Functions .........: 4
Lines .............: 271
```

```
; #INDEX# =====================================================
; Title .........: rLauncher
; Version .......: 1.0
; AutoIt Version : 3.3.14.2
; Language ......: MultiLanguage via config file (.ini)
;                  pt_PT - original, en_US - translated
; Description ...: Small launcher script for removable drives
; Author(s) .....: Eduardo Mota
; Dll ...........: -
; =============================================================
```

###pt_PT

####Configurações gerais
#####launcher.cfg (ini file)

```
# Actualizar lista ao iniciar (1 - sim, 0 - não)
config_updtonlaunch=1
# Linguagem do script (nome da secção no ficheiro de configuração: pt_PT, en_US)
config_scriptlang="en_US"
# Fechar depois de lançar aplicação (0 - não, 1 - sim)
config_clseonlnch=0
# Mantém a janela no topo de outras janelas (0 - não, 1 - sim)
config_topmost=0
```

####Construir categorias e ficheiros associados a categorias 
#####categoria.list
- deve ser introduzido o identificador e o nome da categoria neste formato

Formato:
```
ID,Nome da Categoria
```

Ex:
```
1,Aplicações e Jogos
```

#####bins.list
- deve ser introduzido o id da aplicação dentro da categoria, o id da categoria, o nome da aplicação a mostrar, o executável, a pasta relativa do executável e nada em frente

Formato:
```
ID App, ID Categoria, Nome da Aplicação, Nome Executável, Caminho Relativo, nada
```

Exs:
```
1,1,Exemplo,exemplo.exe,apps\exemplo,nada
2,1,WoW,wow.exe,jogos\wow,nada
```

###en_US

####General aplication options
#####launcher.cfg (ini file)

```
# Update list on startup (1 - yes, 0 - no)
config_updtonlaunch=1
# Script Language (Section name on configuration file: pt_PT, en_US)
config_scriptlang="en_US"
# Close after launching app (0 - no, 1 - yes)
config_clseonlnch=0
# Keep window on top of other (topmost feature) (0 - no, 1 - yes)
config_topmost=0
```

####Build categories and files associated with categories
#####categoria.list
- file where all file categories are stored
- you must input the id and the category name after it

Format:
```
ID, Category name
```

Ex:
```
1,Applications and Games
```

#####bins.list
- file where all binary file paths and names are stored
- you must input the id of the app inside the category, the category id, aplication name shown on the app, the executable name, relative folder of the executable and "nada" at last

Formato:
```
App ID, Category ID, App Name, Executable file, Relative path, "nada"
```

Exs:
```
1,1,Example,example.exe,apps\example,nada
2,1,WoW,wow.exe,games\wow,nada
```
