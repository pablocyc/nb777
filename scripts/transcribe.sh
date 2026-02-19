#!/bin/bash

# Script para transcribir imágenes a texto usando OCR
# Uso: ./transcribe.sh <imagen>

if [ $# -eq 0 ]; then
    echo "Uso: $0 <ruta_de_imagen>"
    echo "Ejemplo: $0 imagen.jpg"
    exit 1
fi

IMAGE_PATH="$1"
BASE_NAME=$(basename "$IMAGE_PATH" | sed 's/\.[^.]*$//')
OUTPUT_FILE="${BASE_NAME}.md"

if [ ! -f "$IMAGE_PATH" ]; then
    echo "Error: La imagen '$IMAGE_PATH' no existe."
    exit 1
fi

echo "Transcribiendo: $IMAGE_PATH"
echo "Archivo de salida: $OUTPUT_FILE"
echo "----------------------------------------"

# Ejecutar OCR y formatear como Markdown
{
    echo "# Transcripción de $(basename "$IMAGE_PATH")"
    echo ""
    echo "**Archivo original:** \`$(basename "$IMAGE_PATH")\`"
    echo ""
    echo "**Fecha de transcripción:** $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "---"
    echo ""
    tesseract "$IMAGE_PATH" stdout -l spa+eng 2>/dev/null
} > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Transcripción completada exitosamente"
    echo "✓ Archivo guardado: $OUTPUT_FILE"
    echo ""
    echo "Contenido transcrito:"
    echo "===================="
    cat "$OUTPUT_FILE"
else
    echo "✗ Error durante la transcripción"
    exit 1
fi