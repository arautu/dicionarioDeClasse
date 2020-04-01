#!/bin/awk -f

# Retorna o nome do package.
# Input: package -> Linha de texto contendo o package (ex. com.arauto.aff;).
# Output: O nome do package.
function obtemNomeDoPackage(package) {
  gsub(";.*", "",package)
    return package
}

# Retorna o nome da classe.
# Input: Linha de texto
# Output: Nome da classe
function obtemNomeDaClasse(frase,  i, lista) {
  split(frase, lista, /\s/)
    for (i in lista) {
      if (lista[i] == "class") {
        sub("{", "", lista[i+1])
          return lista[i+1]
      }
    }
}

# Obtém o nome do atributo pelo nome do seu respectivo método get ou is.
# Input: texto -> Ex. public MessageSourceResolvable getDescricao() {
# Retorno: Nome do atributo. Ex. descricao
function obtemAtributoPeloMetodo(texto,   lista) {
  split(texto, lista, " ")
  for (i in lista) {
    if (match(lista[i], /^(get|is)/)) {
      sub(/(get|is)/, "", lista[i])
      gsub(/\(.*/, "", lista[i])
      return tolower(substr(lista[i], 1, 1)) substr(lista[i], 2)
    }
  }
}
