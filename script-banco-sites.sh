#!/bin/bash

# Configurações
DB_USER="lorraine"
DB_PASSWORD="HEAZU6c)]1N)bm.4"
BACKUP_PARENT_DIR="/var/www/backup-banco"

# Nome da pasta baseada na data atual
BACKUP_DIR="$BACKUP_PARENT_DIR/$(date +%Y%m%d)"

# Lista de bases de dados para backup 
DATABASES+=("atvbox")
DATABASES+=("altomax")
DATABASES+=("agfarmus")
DATABASES+=("blocosceramicos")
DATABASES+=("bebebistro")
DATABASES+=("barbeariafaccin")
DATABASES+=("casafoz")
DATABASES+=("cemel")
DATABASES+=("churrascariapremium")
DATABASES+=("conceitoarquitetura")
DATABASES+=("construfour")
DATABASES+=("crowtech")
DATABASES+=("donfrances")
DATABASES+=("estacaojk")
DATABASES+=("hartman")
DATABASES+=("ifcforest")
DATABASES+=("ikigai")
DATABASES+=("integralab")
DATABASES+=("kempler")
DATABASES+=("magnitude")
DATABASES+=("maskking")
DATABASES+=("natucci")
DATABASES+=("noelifaccin")
DATABASES+=("ouroverde")
DATABASES+=("preventina")
DATABASES+=("publicarpaineis")
DATABASES+=("worldofvape")

# Cria o diretório de backup se não existir
mkdir -p "$BACKUP_DIR"

# Loop através das bases de dados
for DB_NAME in "${DATABASES[@]}"
do
    # Gera o nome do arquivo de backup com base na data e nome do banco de dados
    BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$(date +%Y%m%d%H%M%S).sql"

    # Comando para fazer o backup usando o mysqldump
    mysqldump --user="$DB_USER" --password="$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"

    # Verifica se o comando foi executado com sucesso
    if [ $? -eq 0 ]; then
        echo "Backup do banco de dados $DB_NAME criado com sucesso em $BACKUP_FILE"
    else
        echo "Erro ao criar o backup do banco de dados $DB_NAME"
        continue
    fi
done

# Gera o nome do arquivo compactado com base na data
COMPRESSED_BACKUP_FILE="$BACKUP_PARENT_DIR/backup-$(date +%Y%m%d).tar.gz"

# Compacta a pasta de backup usando o tar e gzip
tar czf "$COMPRESSED_BACKUP_FILE" -C "$BACKUP_PARENT_DIR" "$(date +%Y%m%d)"

# Verifica se o comando foi executado com sucesso
if [ $? -eq 0 ]; then
    echo "Pasta de backup do dia $(date +%Y%m%d) comprimida com sucesso em $COMPRESSED_BACKUP_FILE"
else
    echo "Erro ao compactar a pasta de backup do dia $(date +%Y%m%d)"
fi

# Remove a pasta de backup original
rm -r "$BACKUP_DIR"

echo "Pasta de backup do dia $(date +%Y%m%d) removida"