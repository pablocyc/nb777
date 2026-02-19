# Configuración futura para Astro Starlight

## Estructura de archivos compatible

El proyecto está organizado pensando en la migración futura a Astro con Starlight:

### Estructura actual → Estructura Starlight
```
transcripciones/
├── 00-introduccion/     → src/content/docs/00-introduccion/
├── 01-objeto-campo/     → src/content/docs/01-objeto-campo/
├── 02-referencias/      → src/content/docs/02-referencias/
├── 03-definiciones/     → src/content/docs/03-definiciones/
├── 04-documentos/       → src/content/docs/04-documentos/
├── 05-planos/          → src/content/docs/05-planos/
├── 06-circuitos/       → src/content/docs/06-circuitos/
├── 07-demandas/        → src/content/docs/07-demandas/
├── 08-acometidas/      → src/content/docs/08-acometidas/
├── 09-tableros/        → src/content/docs/09-tableros/
└── anexos/             → src/content/docs/anexos/
```

### Preparación para sidebar automático
Los nombres de carpetas siguen el formato: `XX-nombre-descriptivo`
- XX: Número para orden en sidebar
- nombre-descriptivo: Slug para URL

### Metadatos ya incluidos
Los archivos .md ya tienen:
- Títulos estructurados
- Fechas de transcripción
- Referencias a archivos originales

## Comandos para migración futura

```bash
# 1. Inicializar proyecto Astro Starlight (cuando esté listo)
npm create astro@latest -- --template starlight

# 2. Migrar contenido
./migrate-to-starlight.sh

# 3. Configurar sidebar automático basado en estructura actual
```

## Beneficios de la estructura actual
- ✅ Compatible con Starlight desde el inicio
- ✅ URLs semánticas (ej: /01-objeto-campo/requisitos)
- ✅ Orden automático en sidebar
- ✅ Metadatos preservados
- ✅ Imágenes organizadas y referenciadas