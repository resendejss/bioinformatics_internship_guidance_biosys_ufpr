#!/bin/bash

#sudo apt-get install sra-toolkit

mkdir Amostras

# Diretório de destino para salvar os dados
output_dir="Amostras"

# Ler o arquivo de texto contendo a lista de amostras
while IFS= read -r accession; do
    # Remover as aspas dos nomes das amostras
    accession=$(echo "$accession" | tr -d '"')
    echo "Baixando $accession..."
    fastq-dump -O "$output_dir" --split-files "$accession"
done < lista_amostras.txt

echo "Download concluído."
