#!/bin/bash

# Script mejorado para procesamiento automático de imágenes
# Uso desde la raíz: ./scripts/process.sh

IMAGE_FILE="image.png"
PROCESSED_DIR="assets/images/temp"
TEMP_DIR="temp"

# Crear directorios si no existen
mkdir -p "$PROCESSED_DIR" "$TEMP_DIR"

if [ ! -f "$IMAGE_FILE" ]; then
    echo "❌ No se encontró el archivo '$IMAGE_FILE'"
    echo "Sube tu imagen con el nombre 'image.png' y ejecuta este script desde la raíz"
    exit 1
fi

# Generar nombre único basado en timestamp
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
NEW_IMAGE_NAME="temp_${TIMESTAMP}.png"
MD_FILE="transcripcion_${TIMESTAMP}.md"

echo "🔄 Procesando: $IMAGE_FILE"
echo "📁 Se guardará como: $NEW_IMAGE_NAME"
echo "📝 Transcripción: $MD_FILE"
echo "----------------------------------------"

# Transcribir imagen
echo "🤖 Ejecutando OCR..."
{
    echo "---"
    echo "seccion: 01"
    echo "titulo: \"title\""
    echo "pagina: 1"
    echo "imagen: \"$NEW_IMAGE_NAME\""
    echo "fecha: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "---"
    echo ""
    tesseract "$IMAGE_FILE" stdout -l spa+eng 2>/dev/null
} > "$TEMP_DIR/$MD_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Transcripción completada"

    # Mover imagen a carpeta temporal con nombre único
    cp "$IMAGE_FILE" "$PROCESSED_DIR/$NEW_IMAGE_NAME"
    echo "📁 Imagen archivada: $PROCESSED_DIR/$NEW_IMAGE_NAME"

    echo "🔍 Archivo temporal creado: $TEMP_DIR/$MD_FILE"
    echo "✏️  Revisa y corrige el archivo, luego ejecuta: ./scripts/organize.sh"
else
    echo "❌ Error durante la transcripción"
    exit 1
fi