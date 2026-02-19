#!/bin/bash

# Script para organizar definitivamente todos los archivos temporales
# Uso: ./scripts/finalize.sh

echo "🎯 === ORGANIZADOR FINAL === 🎯"
echo ""

# Verificar si hay archivos temporales
if ! ls temp/*.md 1> /dev/null 2>&1; then
    echo "❌ No se encontraron archivos .md en temp/"
    exit 1
fi

echo "📄 Archivos temporales encontrados:"
ls -la temp/*.md
echo ""

# Función para mapear sección a carpetas
get_carpetas() {
    local seccion="$1"
    case $seccion in
        00) echo "docs/00-introduccion:assets/images/00-introduccion" ;;
        01) echo "docs/01-objeto-campo:assets/images/01-objeto-campo" ;;
        02) echo "docs/02-referencias:assets/images/02-referencias" ;;
        03) echo "docs/03-definiciones:assets/images/03-definiciones" ;;
        04) echo "docs/04-documentos:assets/images/04-documentos" ;;
        05) echo "docs/05-planos:assets/images/05-planos" ;;
        06) echo "docs/06-circuitos:assets/images/06-circuitos" ;;
        07) echo "docs/07-demandas:assets/images/07-demandas" ;;
        08) echo "docs/08-acometidas:assets/images/08-acometidas" ;;
        09) echo "docs/09-tableros:assets/images/09-tableros" ;;
        99) echo "docs/anexos:assets/images/anexos" ;;
        *) echo "" ;;
    esac
}

# Procesar cada archivo temporal
for archivo_temp in temp/*.md; do
    if [ ! -f "$archivo_temp" ]; then continue; fi

    echo "🔄 Procesando: $(basename "$archivo_temp")"

    # Extraer metadatos del archivo
    SECCION=$(grep "^seccion:" "$archivo_temp" | cut -d' ' -f2)
    TITULO=$(grep "^titulo:" "$archivo_temp" | cut -d'"' -f2)
    PAGINA=$(grep "^pagina:" "$archivo_temp" | cut -d' ' -f2)
    IMAGEN_ORIGINAL=$(grep "^imagen:" "$archivo_temp" | cut -d'"' -f2)

    if [ -z "$SECCION" ] || [ -z "$TITULO" ] || [ -z "$PAGINA" ]; then
        echo "⚠️  Metadatos incompletos en $(basename "$archivo_temp"), saltando..."
        continue
    fi

    # Obtener carpetas de destino
    CARPETAS=$(get_carpetas "$SECCION")
    if [ -z "$CARPETAS" ]; then
        echo "❌ Sección '$SECCION' no válida en $(basename "$archivo_temp")"
        continue
    fi

    CARPETA_DOCS=$(echo "$CARPETAS" | cut -d':' -f1)
    CARPETA_IMG=$(echo "$CARPETAS" | cut -d':' -f2)

    echo "   📁 Sección: $SECCION"
    echo "   📝 Título: $TITULO"
    echo "   📄 Página: $PAGINA"
    echo "   🖼️  Imagen: $IMAGEN_ORIGINAL"

    # Generar nombres finales
    TITULO_SLUG=$(echo "$TITULO" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

    if [ "$PAGINA" -eq 1 ]; then
        ARCHIVO_FINAL="${SECCION}-${TITULO_SLUG}.md"
        IMAGEN_FINAL="${SECCION}-${TITULO_SLUG}.png"
    else
        ARCHIVO_FINAL="${SECCION}-${TITULO_SLUG}-p${PAGINA}.md"
        IMAGEN_FINAL="${SECCION}-${TITULO_SLUG}-p${PAGINA}.png"
    fi

    echo "   ➡️  Archivo final: $ARCHIVO_FINAL"
    echo "   ➡️  Imagen final: $IMAGEN_FINAL"

    # Crear contenido final del archivo markdown
    {
        # Copiar metadatos actualizados
        echo "---"
        echo "seccion: $SECCION"
        echo "titulo: \"$TITULO\""
        echo "pagina: $PAGINA"
        echo "imagen: \"$IMAGEN_FINAL\""
        echo "fecha: $(grep "^fecha:" "$archivo_temp" | cut -d' ' -f2-)"
        echo "---"
        echo ""

        # Copiar contenido después del segundo --- (línea 8 en adelante)
        tail -n +8 "$archivo_temp"

    } > "$CARPETA_DOCS/$ARCHIVO_FINAL"

    # Mover imagen si existe
    IMAGEN_TEMP="assets/images/temp/$IMAGEN_ORIGINAL"
    if [ -f "$IMAGEN_TEMP" ]; then
        cp "$IMAGEN_TEMP" "$CARPETA_IMG/$IMAGEN_FINAL"
        echo "   ✅ Imagen movida: $CARPETA_IMG/$IMAGEN_FINAL"
        rm "$IMAGEN_TEMP"  # Limpiar temporal
    else
        echo "   ⚠️  Imagen temporal no encontrada: $IMAGEN_TEMP"
    fi

    # Mover archivo temporal procesado
    echo "   ✅ Documento creado: $CARPETA_DOCS/$ARCHIVO_FINAL"
    rm "$archivo_temp"  # Limpiar temporal

    echo ""
done

echo "🎉 ¡ORGANIZACIÓN COMPLETADA!"
echo ""
echo "📂 Archivos organizados por sección:"
for seccion_dir in docs/*/; do
    if ls "$seccion_dir"*.md 1> /dev/null 2>&1; then
        echo "   $(basename "$seccion_dir"): $(ls "$seccion_dir"*.md | wc -l) archivos"
    fi
done

echo ""
echo "🚀 ¡Listo para continuar con más transcripciones!"