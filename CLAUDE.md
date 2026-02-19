# Proyecto: Transcripción de imágenes a texto

Realizar un script sencillo para transcribir el texto de las imágenes que iré subiendo. El proyecto consiste en transcribir todo un libro

## Estado actual: ✅ Proyecto reorganizado y listo para Astro

### Estructura del proyecto:
```
📁 nb777/
├── 📁 scripts/           - Scripts de procesamiento
│   ├── process.sh        - SCRIPT PRINCIPAL: Procesa image.png
│   ├── organize.sh       - Organizador inteligente por secciones
│   ├── transcribe.sh     - Script básico de transcripción
│   └── starlight-config.md - Configuración para migración Astro
├── 📁 docs/             - Documentación organizada (compatible Astro)
│   ├── 00-introduccion/ - Índice y introducción
│   ├── 01-objeto-campo/ - Objeto y campo de aplicación
│   ├── 02-referencias/  - Referencias normativas
│   ├── 03-definiciones/ - Definiciones y terminología
│   ├── 04-documentos/   - Documentos del proyecto
│   ├── 05-planos/       - Planos
│   ├── 06-circuitos/    - Circuitos derivados
│   ├── 07-demandas/     - Determinación de demandas máximas
│   ├── 08-acometidas/   - Acometidas y alimentadores
│   ├── 09-tableros/     - Tableros para instalaciones eléctricas
│   └── anexos/          - Anexos A, B, C, D, E
├── 📁 assets/images/    - Imágenes organizadas por sección
│   ├── 00-introduccion/ - Imágenes del índice ✅
│   ├── 01-objeto-campo/
│   ├── 02-referencias/
│   ├── 03-definiciones/
│   ├── 04-documentos/
│   ├── 05-planos/
│   ├── 06-circuitos/
│   ├── 07-demandas/
│   ├── 08-acometidas/
│   ├── 09-tableros/
│   ├── anexos/
│   └── temp/           - Imágenes temporales
└── 📁 temp/            - Transcripciones pendientes
```

## Flujo de trabajo optimizado

### 1. Procesar nueva imagen:
```bash
# Sube tu archivo como 'image.png' y ejecuta:
./scripts/process.sh
```

### 2. Organizar después de revisión:
```bash
# Especifica archivo y número de sección (00-09, 99=anexos)
./scripts/organize.sh temp/transcripcion_123.md 01
```

### Archivos ya organizados:
- ✅ **Índice**: `docs/00-introduccion/index.md`
- ✅ **Imágenes índice**: `00-indice-parte1.png`, `00-indice-parte2.png`

## Dependencias instaladas:
- Tesseract OCR con soporte para español e inglés

## Ventajas de la nueva estructura:
- ✅ **100% compatible con Astro Starlight** desde el inicio
- ✅ URLs semánticas automáticas (`/01-objeto-campo/pagina`)
- ✅ Sidebar automático ordenado
- ✅ Imágenes organizadas por sección
- ✅ Referencias automáticas actualizadas
- ✅ Raíz del proyecto limpia

# Contexto
Estamos trabajando en WSL2, tengo conocimientos en herramientas de terminal, así que procura que en lo posible el comando a ejecutar sea en bash. El programa para transcribir puede ser a libre criterio tuyo. Todos los programas o scripts déjalos en el mismo proyecto, que todo sea fácil de ir organizando a medida que vaya avanzando el proyecto, así que irás actualizando el proyecto incluido este archivo a medida que avancemos. Tomará varios días supongo, así que no hay apuro en hacerlo todo bien a la primera

# Flujo actual (optimizado para múltiples páginas)

## Flujo para una sección completa:

### 1. Primera imagen de la sección:
```bash
./scripts/process.sh                    # Procesa image.png
# Edita temp/transcripcion_XXXXX.md:
# - Cambia seccion: 01
# - Cambia titulo: "Objeto y campo de aplicación"
# - Mantén pagina: 1
```

### 2. Si hay más páginas de la misma sección:
```bash
# Renombra la imagen procesada para mantener secuencia:
mv assets/images/temp/temp_XXXXX.png assets/images/temp/temp_capitulo01_p1.png

# Sube nueva image.png y procesa:
./scripts/process.sh

# Edita el nuevo temp/transcripcion_YYYYY.md:
# - seccion: 01 (mismo capítulo)
# - titulo: "Objeto y campo de aplicación" (mismo título)
# - pagina: 2 (incrementa)
```

### 3. Cuando termines todas las páginas:
```bash
./scripts/finalize.sh                   # Organiza TODO automáticamente
```

## Resultado automático:
- ✅ **Archivos MD**: `01-objeto-campo-aplicacion.md`, `01-objeto-campo-aplicacion-p2.md`
- ✅ **Imágenes**: `01-objeto-campo-aplicacion.png`, `01-objeto-campo-aplicacion-p2.png`
- ✅ **Organizados** en carpetas correctas
- ✅ **Referencias actualizadas** automáticamente

## Metadatos editables en cada archivo:
```yaml
---
seccion: 01                           # 00-09, 99=anexos
titulo: "Objeto y campo de aplicación" # Título descriptivo
pagina: 1                             # Número de página
imagen: "temp_123456.png"             # Se actualiza automáticamente
fecha: 2026-02-18 20:30:45           # Automático
---
```