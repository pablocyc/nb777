# nb777 - Transcripción de libro a texto

Herramienta para transcribir imágenes de un libro usando OCR (Tesseract).

## Instalación rápida

```bash
# Clonar el repositorio
git clone <url-del-repo>
cd nb777

# Instalar dependencias
./install.sh
```

## Requisitos

- Linux (Ubuntu/Debian/WSL2) o macOS
- Tesseract OCR con idiomas español e inglés

### Instalación manual (si el script no funciona)

**Ubuntu/Debian/WSL2:**
```bash
sudo apt update
sudo apt install tesseract-ocr tesseract-ocr-spa tesseract-ocr-eng
```

**Fedora:**
```bash
sudo dnf install tesseract tesseract-langpack-spa tesseract-langpack-eng
```

**Arch Linux:**
```bash
sudo pacman -S tesseract tesseract-data-spa tesseract-data-eng
```

**macOS:**
```bash
brew install tesseract tesseract-lang
```

## Uso

### 1. Procesar una imagen
```bash
# Coloca tu imagen como 'image.png' en la raíz del proyecto
./scripts/process.sh
```

### 2. Editar la transcripción
Revisa el archivo generado en `temp/` y corrige los errores del OCR.

### 3. Organizar el archivo
```bash
./scripts/finalize.sh
```

## Estructura del proyecto

```
nb777/
├── scripts/          # Scripts de procesamiento
│   ├── process.sh    # Script principal
│   ├── organize.sh   # Organizador por secciones
│   ├── finalize.sh   # Finalizar y mover archivos
│   └── transcribe.sh # Script básico
├── docs/             # Documentación organizada
├── assets/images/    # Imágenes organizadas
├── temp/             # Archivos temporales
└── install.sh        # Instalador de dependencias
```

## Licencia

Proyecto personal de transcripción.
