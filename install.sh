#!/bin/bash

# Script de instalación de dependencias para nb777
# Compatible con Ubuntu/Debian (WSL2)

set -e

echo "=== Instalador de dependencias para nb777 ==="
echo ""

# Detectar el sistema
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
else
    echo "Sistema de paquetes no soportado automáticamente."
    echo "Instala manualmente: tesseract-ocr tesseract-ocr-spa tesseract-ocr-eng"
    exit 1
fi

echo "Detectado gestor de paquetes: $PKG_MANAGER"
echo ""

# Verificar si tesseract ya está instalado
if command -v tesseract &> /dev/null; then
    echo "Tesseract ya está instalado:"
    tesseract --version | head -1
    echo ""
    echo "Idiomas disponibles:"
    tesseract --list-langs 2>/dev/null | tail -n +2
    echo ""

    # Verificar idiomas necesarios
    if tesseract --list-langs 2>/dev/null | grep -q "spa" && tesseract --list-langs 2>/dev/null | grep -q "eng"; then
        echo "Los idiomas requeridos (spa, eng) ya están instalados."
        echo "No hay nada más que instalar."
        exit 0
    else
        echo "Faltan algunos idiomas. Instalando..."
    fi
fi

echo "Instalando tesseract-ocr y paquetes de idiomas..."
echo ""

case $PKG_MANAGER in
    apt)
        sudo apt-get update
        sudo apt-get install -y tesseract-ocr tesseract-ocr-spa tesseract-ocr-eng
        ;;
    dnf)
        sudo dnf install -y tesseract tesseract-langpack-spa tesseract-langpack-eng
        ;;
    pacman)
        sudo pacman -S --noconfirm tesseract tesseract-data-spa tesseract-data-eng
        ;;
esac

echo ""
echo "=== Instalación completada ==="
echo ""
echo "Verificando instalación:"
tesseract --version | head -1
echo ""
echo "Idiomas disponibles:"
tesseract --list-langs 2>/dev/null | tail -n +2
echo ""
echo "Listo para usar. Ejecuta: ./scripts/process.sh"
