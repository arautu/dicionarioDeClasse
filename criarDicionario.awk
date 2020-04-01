#!/bin/awk -f

@include "funcoesGerais"

BEGIN {
  cntClass = 0
  cntEnum = 0
  cntAtributos = 0
}

# Obtém o nome do pacote.
/^\<package\>/ {
  nomeDoPackage = obtemNomeDoPackage($2)
  next
}

# Obtém o nome da classe e faz a contagem dela e das classes aninhadas.
/\sclass\s/ {
  cntClass++
  if (cntClass == 1) {
    nomeDaClasse = obtemNomeDaClasse($0)
    next
  }
}

# Conta os enums aninhados, mas não analisa se for um arquivo de enum.
/\senum\s/ {
  if (cntClass) {
    cntEnum++
  }
  else {
    nomeDaClasse = "** enum **"
    nextfile
  }
}

# Não analisa o arquivo se for interface ou enum.
/\sinterface\s/ {
  nomeDaClasse = "** interface **"
  nextfile
}

# Obtém os atributos pelo nome dos métodos. 
/public .* (is|get)/ &&
!/getId/ &&
!/getDataAlteracaoAuditoria/ &&
!/getUsuarioAuditoria/ && 
!/^\/.*/ {
  nomeDosAtributos[++cntAtributos] = obtemAtributoPeloMetodo($0)
  next
}

END {
  # Informações
  print "Arquivo: " ARGV[1]
  print "Nome do package: " nomeDoPackage;
  print "Nome da classe: " nomeDaClasse;
  print "Número de classes: " cntClass;
  print "Número de enums aninhados: " cntEnum;
  print "Número de métodos: " cntAtributos;

  # Dicionário
  print nomeDoPackage"."nomeDaClasse"="

  asort(nomeDosAtributos)
  for (i in nomeDosAtributos) {
    print nomeDoPackage"."nomeDaClasse"."nomeDosAtributos[i]"="
  }
  printf "\n"
}
