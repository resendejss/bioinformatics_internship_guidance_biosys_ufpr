#!/bin/bash

# Function to check if fastp is installed
check_fastp() {
    if ! command -v fastp &> /dev/null
    then
        echo "fastp not found. Please install fastp."
        exit 1
    fi
}

# Function to process FASTQ files with fastp
run_fastp() {
    local input_r1=$1
    local input_r2=$2
    local output_paired_r1=$3
    local output_unpaired_r1=$4
    local output_paired_r2=$5
    local output_unpaired_r2=$6

    fastp -i "$input_r1" -I "$input_r2" \
          -o "$output_paired_r1" -O "$output_paired_r2" \
          -u "$output_unpaired_r1" -U "$output_unpaired_r2" \
          --html "${output_paired_r1%.*}.html" \
          --json "${output_paired_r1%.*}.json" \
          --verbose
}

# Solicita o diretório onde os arquivos FASTQ estão localizados
read -p "Insira o caminho do diretório onde os arquivos FASTQ estão localizados: " input_dir

# Solicita o diretório onde os resultados do fastp serão salvos
read -p "Insira o caminho do diretório onde os resultados do fastp serão salvos: " output_dir

# Verifica se o diretório de entrada existe
if [ ! -d "$input_dir" ]; then
    echo "O diretório de entrada não existe. Verifique o caminho e tente novamente."
    exit 1
fi

# Cria o diretório de saída se ele não existir
mkdir -p "$output_dir"

# Verifica se o fastp está instalado
check_fastp

# Loop para processar cada par de arquivos R1 e R2 encontrados no diretório de entrada
for r1_file in "$input_dir"/*_1.{fq,fastq,fastq.gz}; do
    if [ -f "$r1_file" ]; then
        # Extrai o nome da amostra do arquivo R1
        sample_name=$(basename "$r1_file" | sed 's/_1\..*//')
        
        # Constrói o nome do arquivo R2 com base no nome da amostra e várias extensões possíveis
        r2_file="${input_dir}/${sample_name}_2"{.fq,.fastq,.fq.gz,.fastq.gz}
        
        if [ -f "$r2_file" ]; then
            echo "Processando $r1_file e $r2_file com fastp ..."
            
            # Constrói os nomes de saída baseados nos nomes dos arquivos de entrada
            output_paired_r1="$output_dir/${sample_name}_1_fastp.fastq.gz"
            output_unpaired_r1="$output_dir/${sample_name}_1_fastp_unpaired.fastq.gz"
            output_paired_r2="$output_dir/${sample_name}_2_fastp.fastq.gz"
            output_unpaired_r2="$output_dir/${sample_name}_2_fastp_unpaired.fastq.gz"
            
            # Executa fastp para pré-processamento dos arquivos
            run_fastp "$r1_file" "$r2_file" \
                      "$output_paired_r1" "$output_unpaired_r1" \
                      "$output_paired_r2" "$output_unpaired_r2"
        else
            echo "Arquivo correspondente R2 não encontrado para $r1_file. Pulando para o próximo."
        fi
    fi
done

echo "Processamento com fastp concluído. Os resultados foram salvos em $output_dir"
