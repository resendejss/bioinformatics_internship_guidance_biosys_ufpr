#!/bin/bash

# Definindo variáveis
FASTQ_DIR="caminho/para/arquivos/fastq"  # Substitua pelo caminho para seus arquivos FASTQ
FASTQC_OUT_DIR="fastqc_results"
MULTIQC_OUT_DIR="multiqc_results"

# Verificando se os diretórios de saída existem, caso contrário, cria-os
mkdir -p $FASTQC_OUT_DIR
mkdir -p $MULTIQC_OUT_DIR

# Rodando FastQC
echo "Executando FastQC em arquivos FASTQ no diretório $FASTQ_DIR..."
fastqc -o $FASTQC_OUT_DIR $FASTQ_DIR/*.fastq.gz

# Verificando se FastQC executou com sucesso
if [ $? -ne 0 ]; then
  echo "Erro ao executar FastQC. Verifique os arquivos e tente novamente."
  exit 1
fi

echo "FastQC completado. Resultados salvos em $FASTQC_OUT_DIR."

# Rodando MultiQC
echo "Executando MultiQC para consolidar os relatórios do FastQC..."
multiqc -o $MULTIQC_OUT_DIR $FASTQC_OUT_DIR

# Verificando se MultiQC executou com sucesso
if [ $? -ne 0 ]; then
  echo "Erro ao executar MultiQC. Verifique os arquivos e tente novamente."
  exit 1
fi

echo "MultiQC completado. Relatório consolidado salvo em $MULTIQC_OUT_DIR."

echo "Controle de qualidade dos dados de RNA-Seq completo!"
