#!/bin/bash

# Script inteligente para organizar transcripciones por capítulos
# Uso: ./scripts/organize.sh [archivo_md_corregido] [seccion]

echo "=== Organizador inteligente de transcripciones ==="
echo ""

if [ $# -eq 0 ]; then
    echo "📋 Secciones disponibles:"
    echo "  00 - Introducción"
    echo "  01 - Objeto y campo de aplicación"
    echo "  02 - Referencias normativas"
    echo "  03 - Definiciones y terminología"
    echo "  04 - Documentos del proyecto"
    echo "  05 - Planos"
    echo "  06 - Circuitos derivados"
    echo "  07 - Determinación de demandas máximas"
    echo "  08 - Acometidas y alimentadores"
    echo "  09 - Tableros para instalaciones eléctricas"
    echo "  99 - Anexos"
    echo ""
    echo "💡 Uso: $0 <archivo_corregido.md> <numero_seccion>"
    echo "📁 Ejemplo: $0 temp/transcripcion_123.md 01"
    echo ""

    # Mostrar archivos pendientes
    if ls temp/*.md 1> /dev/null 2>&1; then
        echo "📄 Archivos pendientes en temp/:"
        ls -la temp/*.md
    fi
    exit 1
fi

if [ $# -ne 2 ]; then
    echo "❌ Error: Necesitas especificar archivo y sección"
    echo "💡 Uso: $0 <archivo_corregido.md> <numero_seccion>"
    exit 1
fi

ARCHIVO="$1"
SECCION="$2"

if [ ! -f "$ARCHIVO" ]; then
    echo "❌ Error: No se encontró el archivo '$ARCHIVO'"
    exit 1
fi

# Mapear número de sección a carpeta
case $SECCION in
    00) CARPETA_DOCS="docs/00-introduccion"; CARPETA_IMG="assets/images/00-introduccion" ;;
    01) CARPETA_DOCS="docs/01-objeto-campo"; CARPETA_IMG="assets/images/01-objeto-campo" ;;
    02) CARPETA_DOCS="docs/02-referencias"; CARPETA_IMG="assets/images/02-referencias" ;;
    03) CARPETA_DOCS="docs/03-definiciones"; CARPETA_IMG="assets/images/03-definiciones" ;;
    04) CARPETA_DOCS="docs/04-documentos"; CARPETA_IMG="assets/images/04-documentos" ;;
    05) CARPETA_DOCS="docs/05-planos"; CARPETA_IMG="assets/images/05-planos" ;;
    06) CARPETA_DOCS="docs/06-circuitos"; CARPETA_IMG="assets/images/06-circuitos" ;;
    07) CARPETA_DOCS="docs/07-demandas"; CARPETA_IMG="assets/images/07-demandas" ;;
    08) CARPETA_DOCS="docs/08-acometidas"; CARPETA_IMG="assets/images/08-acometidas" ;;
    09) CARPETA_DOCS="docs/09-tableros"; CARPETA_IMG="assets/images/09-tableros" ;;
    99) CARPETA_DOCS="docs/anexos"; CARPETA_IMG="assets/images/anexos" ;;
    *) echo "❌ Sección '$SECCION' no válida"; exit 1 ;;
esac

echo "🔄 Organizando archivo: $(basename $ARCHIVO)"
echo "📁 Sección: $SECCION"
echo "📂 Destino docs: $CARPETA_DOCS"
echo "🖼️  Destino imágenes: $CARPETA_IMG"
echo "----------------------------------------"

# Extraer información del archivo temporal
TIMESTAMP=$(basename "$ARCHIVO" | sed 's/transcripcion_//' | sed 's/.md//')
TEMP_IMAGE="assets/images/temp/temp_${TIMESTAMP}.png"

# Crear nombre final basado en contenido
TITULO=$(grep -m1 "^#" "$ARCHIVO" | sed 's/^# *//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/-$//')

if [ -z "$TITULO" ]; then
    TITULO="pagina-${TIMESTAMP}"
fi

ARCHIVO_FINAL="${SECCION}-${TITULO}.md"
IMAGEN_FINAL="${SECCION}-${TITULO}.png"

echo "📝 Archivo final: $ARCHIVO_FINAL"
echo "🖼️  Imagen final: $IMAGEN_FINAL"

# Mover y renombrar archivos
cp "$ARCHIVO" "$CARPETA_DOCS/$ARCHIVO_FINAL"
echo "✅ Documento movido a: $CARPETA_DOCS/$ARCHIVO_FINAL"

if [ -f "$TEMP_IMAGE" ]; then
    cp "$TEMP_IMAGE" "$CARPETA_IMG/$IMAGEN_FINAL"
    echo "✅ Imagen movida a: $CARPETA_IMG/$IMAGEN_FINAL"

    # Actualizar referencias en el archivo markdown
    sed -i "s/temp_${TIMESTAMP}.png/${IMAGEN_FINAL}/g" "$CARPETA_DOCS/$ARCHIVO_FINAL"
    echo "✅ Referencias actualizadas en el documento"
else
    echo "⚠️  No se encontró imagen temporal: $TEMP_IMAGE"
fi

echo ""
echo "🎉 ¡Organización completada!"
echo "📂 Documento: $CARPETA_DOCS/$ARCHIVO_FINAL"
echo "🖼️  Imagen: $CARPETA_IMG/$IMAGEN_FINAL"