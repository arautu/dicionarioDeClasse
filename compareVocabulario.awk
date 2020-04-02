#!/bin/awk -f

# Mostra a diferença de vocabulários de uma determinada classe.
# O script compara uma lista de vocabulários de uma determinada classe, com o dicionário
# (arquivo .properties), exibindo na tela, os elementos novos (marcados com "+") e os 
# elementos abandonados (marcados com "-") em relação ao dicionário.

# Exemplo de uso:
# awk -F "=" -f % vocabulario.txt messages-beans-gestaoviaria.properties

BEGIN {
  classeVocabulo = ""
}

# Ignora o cabeçalho do arquivo.
#FNR <= 6 {
#  next
#}

# Lê os novos vocabulários e os coloca em um vetor.
FNR == NR &&
!/^$/ {
  if (!classeVocabulo) {
    classeVocabulo = $1
  }
  novosVocabulos[$1] = $1
  next
} 

# Encontra no dicionário o vocabulário da classe e remove do vetor os elementos correspondentes e
# imprime os elementos encontrados apenas no dicionário. 
$0 ~ classeVocabulo {
 if ($1 in novosVocabulos) {
   delete novosVocabulos[$1]
 }
 else {
    print "- " $1
 }
}

# Imprime o vetor com os novos elementos que não constam no dicionário.
END {
  for (i in novosVocabulos) {
    print "+ " novosVocabulos[i]"="
  }
}
