#!/bin/sh

# Sair imediamente caso aconteça algum erro.
set -e

DICIONARIO="/home/leandro/Sliic/git/sliic-erp/Sliic_ERP/Sliic_ERP_Beans/resources/i18n/messages-beans-gestaoviaria.properties"
VOCABULARIO="compare.txt"

# Copia o arquivo para a pasta src_utf8, convertendo-o para utf-8.
fileName="src_utf8/$(echo $1 | rev | cut -f 1 -d / | rev)"
# echo -e "Nome do arquivo=$fileName"
iconv -f iso-8859-1 -t utf8 $1 > $fileName

# Cria o dicionário de um arquivo.
awk -f criarDicionario.awk -v vocabularioDeClasse="$VOCABULARIO" $fileName

# Compara dicionário
awk -F "=" -f compareVocabulario.awk $VOCABULARIO $DICIONARIO 
