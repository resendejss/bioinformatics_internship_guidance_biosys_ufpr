#!/bin/bash

# Verifica se foi fornecido o diretório como argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <diretório_das_amostras>"
    exit 1
fi

# Armazena o diretório fornecido pelo usuário
diretorio=$1

# Verifica se o diretório existe
if [ ! -d "$diretorio" ]; then
    echo "Diretório $diretorio não encontrado."
    exit 1
fi

# Executa o fastp para cada par de arquivos fastq no diretório
for arquivo1 in ${diretorio}/*.{fq,fastq,fq.gz,fastq.gz}; do
    if [ -f "$arquivo1" ]; then
        # Verifica se há um segundo arquivo pareado
        arquivo2=$(echo "$arquivo1" | sed 's/_1\./_2\./')
        if [ -f "$arquivo2" ]; then
            echo "Processando arquivos: $arquivo1 e $arquivo2"
            fastp -i "$arquivo1" -I "$arquivo2" \
                  -o "${arquivo1%.*}_fastp.fastq" -O "${arquivo2%.*}_fastp.fastq" \
                  --verbose
        else
            echo "Aviso: Arquivo pareado não encontrado para $arquivo1"
        fi
    fi
done

echo "Processamento concluído."
