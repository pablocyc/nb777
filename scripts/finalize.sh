#!/bin/bash

# Script para organizar definitivamente todos los archivos temporales.
# Los archivos del mismo capítulo (misma sección y título) se fusionan en un solo archivo.
# Uso: ./scripts/finalize.sh

echo "=== ORGANIZADOR FINAL ==="
echo ""

# Verificar si hay archivos temporales
if ! ls temp/*.md 1>/dev/null 2>&1; then
    echo "No se encontraron archivos .md en temp/"
    exit 1
fi

echo "Archivos temporales encontrados:"
ls temp/*.md
echo ""

# Función para mapear sección a carpetas doc:imagen
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

# Función para generar slug desde título
make_slug() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g'
}

# --- Primera pasada: agrupar archivos por sección+slug ---
declare -A grupos_archivos   # clave "seccion:slug" -> archivos separados por |
declare -A grupos_titulo     # clave -> título original

for archivo_temp in temp/*.md; do
    [ -f "$archivo_temp" ] || continue

    SECCION=$(grep "^seccion:" "$archivo_temp" | awk '{print $2}' | tr -d ' \r\n')
    TITULO=$(grep  "^titulo:"  "$archivo_temp" | cut -d'"' -f2)
    PAGINA=$(grep  "^pagina:"  "$archivo_temp" | awk '{print $2}' | tr -d ' \r\n')

    if [ -z "$SECCION" ] || [ -z "$TITULO" ] || [ -z "$PAGINA" ]; then
        echo "ADVERTENCIA: metadatos incompletos en $(basename "$archivo_temp"), saltando..."
        continue
    fi

    SLUG=$(make_slug "$TITULO")
    CLAVE="${SECCION}:${SLUG}"

    grupos_titulo[$CLAVE]="$TITULO"

    if [ -z "${grupos_archivos[$CLAVE]}" ]; then
        grupos_archivos[$CLAVE]="$archivo_temp"
    else
        grupos_archivos[$CLAVE]="${grupos_archivos[$CLAVE]}|$archivo_temp"
    fi
done

# --- Segunda pasada: procesar cada grupo ---
for clave in "${!grupos_archivos[@]}"; do
    SECCION=$(echo "$clave" | cut -d':' -f1)
    SLUG=$(echo "$clave" | cut -d':' -f2-)
    TITULO="${grupos_titulo[$clave]}"

    CARPETAS=$(get_carpetas "$SECCION")
    if [ -z "$CARPETAS" ]; then
        echo "ERROR: sección '$SECCION' no válida, saltando grupo..."
        continue
    fi

    CARPETA_DOCS=$(echo "$CARPETAS" | cut -d':' -f1)
    CARPETA_IMG=$(echo "$CARPETAS"  | cut -d':' -f2)
    ARCHIVO_FINAL="$CARPETA_DOCS/${SECCION}-${SLUG}.md"

    # Ordenar archivos del grupo por número de página
    IFS='|' read -ra archivos_grupo <<< "${grupos_archivos[$clave]}"

    sorted_list=$(for f in "${archivos_grupo[@]}"; do
        p=$(grep "^pagina:" "$f" | awk '{print $2}' | tr -d ' \r\n')
        echo "${p} ${f}"
    done | sort -n)

    num_paginas=$(echo "$sorted_list" | wc -l)
    echo "Procesando: ${SECCION}-${SLUG}.md ($num_paginas página(s))"

    # Metadatos del primer archivo
    first_file=$(echo "$sorted_list" | head -1 | awk '{print $2}')
    FECHA=$(grep "^fecha:" "$first_file" | cut -d' ' -f2-)

    # Escribir frontmatter unificado
    {
        echo "---"
        echo "seccion: $SECCION"
        echo "titulo: \"$TITULO\""
        echo "paginas: $num_paginas"
        echo "fecha: $FECHA"
        echo "---"
        echo ""
    } > "$ARCHIVO_FINAL"

    # Concatenar contenido de cada página en orden
    first_page=true
    while IFS=' ' read -r pagina archivo; do
        [ -z "$archivo" ] && continue

        IMAGEN_ORIGINAL=$(grep "^imagen:" "$archivo" | cut -d'"' -f2)

        # Nombre final de imagen: sin sufijo en p1, con -pN en el resto
        if [ "$pagina" -eq 1 ]; then
            IMAGEN_FINAL="${SECCION}-${SLUG}.png"
        else
            IMAGEN_FINAL="${SECCION}-${SLUG}-p${pagina}.png"
        fi

        # Separador entre páginas (excepto antes de la primera)
        if [ "$first_page" = false ]; then
            echo ""          >> "$ARCHIVO_FINAL"
            echo "<!-- página $pagina -->" >> "$ARCHIVO_FINAL"
            echo ""          >> "$ARCHIVO_FINAL"
        fi
        first_page=false

        # Agregar contenido sin frontmatter (las primeras 7 líneas son el bloque ---)
        tail -n +8 "$archivo" >> "$ARCHIVO_FINAL"

        # Mover imagen a su carpeta final
        IMAGEN_TEMP="assets/images/temp/$IMAGEN_ORIGINAL"
        if [ -f "$IMAGEN_TEMP" ]; then
            cp "$IMAGEN_TEMP" "$CARPETA_IMG/$IMAGEN_FINAL"
            rm "$IMAGEN_TEMP"
            echo "   Imagen p${pagina}: $CARPETA_IMG/$IMAGEN_FINAL"
        else
            echo "   ADVERTENCIA: imagen no encontrada: $IMAGEN_TEMP"
        fi

        # Eliminar archivo temporal
        rm "$archivo"

    done <<< "$sorted_list"

    echo "   Documento: $ARCHIVO_FINAL"
    echo ""
done

echo "=== ORGANIZACION COMPLETADA ==="
echo ""
echo "Archivos organizados por sección:"
for seccion_dir in docs/*/; do
    if ls "$seccion_dir"*.md 1>/dev/null 2>&1; then
        count=$(ls "$seccion_dir"*.md | wc -l)
        echo "   $(basename "$seccion_dir"): $count archivos"
    fi
done

echo ""
echo "Listo para continuar!"
