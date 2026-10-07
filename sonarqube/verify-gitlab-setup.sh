#!/bin/bash

# Script de verificación de configuración GitLab + SonarQube
# Este script verifica que todo esté correctamente configurado

set -e

echo "🔍 Verificando configuración de GitLab + SonarQube..."
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
ERRORS=0
WARNINGS=0
SUCCESS=0

# Función para mostrar errores
error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    ((ERRORS++))
}

# Función para mostrar advertencias
warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    ((WARNINGS++))
}

# Función para mostrar éxitos
success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((SUCCESS++))
}

echo "📋 Verificando archivos de configuración..."
echo ""

# Verificar .gitlab-ci.yml
if [ -f ".gitlab-ci.yml" ]; then
    success "Archivo .gitlab-ci.yml existe"
else
    error "Archivo .gitlab-ci.yml no encontrado"
fi

# Verificar sonar-project.properties.example
if [ -f "sonar-project.properties.example" ]; then
    success "Archivo sonar-project.properties.example existe"
    
    # Verificar que no contenga tokens reales
    if grep -q "glpat-" sonar-project.properties.example 2>/dev/null; then
        error "¡Token de GitLab encontrado en sonar-project.properties.example! Esto es un riesgo de seguridad."
    else
        success "No se encontraron tokens expuestos en sonar-project.properties.example"
    fi
else
    warning "Archivo sonar-project.properties.example no encontrado"
fi

# Verificar .gitignore
if [ -f ".gitignore" ]; then
    success "Archivo .gitignore existe"
    
    # Verificar que incluya archivos importantes
    if grep -q "sonar-project.properties" .gitignore; then
        success ".gitignore incluye sonar-project.properties"
    else
        warning ".gitignore no incluye sonar-project.properties"
    fi
    
    if grep -q ".sonar" .gitignore; then
        success ".gitignore incluye .sonar/"
    else
        warning ".gitignore no incluye .sonar/"
    fi
else
    warning "Archivo .gitignore no encontrado"
fi

# Verificar docker-compose.yml
if [ -f "docker-compose.yml" ]; then
    success "Archivo docker-compose.yml existe"
else
    error "Archivo docker-compose.yml no encontrado"
fi

echo ""
echo "🐳 Verificando Docker..."
echo ""

# Verificar si Docker está instalado
if command -v docker &> /dev/null; then
    success "Docker está instalado"
    
    # Verificar si Docker está corriendo
    if docker info &> /dev/null; then
        success "Docker está corriendo"
        
        # Verificar si SonarQube está corriendo
        if docker ps | grep -q "sonarqube"; then
            success "Contenedor de SonarQube está corriendo"
            
            # Verificar si SonarQube responde
            if curl -s http://localhost:9000/api/system/status | grep -q "UP"; then
                success "SonarQube está respondiendo en http://localhost:9000"
            else
                warning "SonarQube no está respondiendo. Puede estar iniciando..."
            fi
        else
            warning "Contenedor de SonarQube no está corriendo"
            echo "   Ejecuta: docker-compose up -d"
        fi
    else
        error "Docker no está corriendo"
    fi
else
    error "Docker no está instalado"
fi

echo ""
echo "📝 Verificando configuración de GitLab CI/CD..."
echo ""

# Verificar si hay un repositorio git
if [ -d ".git" ]; then
    success "Repositorio Git inicializado"
    
    # Verificar si hay un remote de GitLab
    if git remote -v | grep -q "gitlab"; then
        success "Remote de GitLab configurado"
        GITLAB_REMOTE=$(git remote -v | grep gitlab | head -n 1 | awk '{print $2}')
        echo "   Remote: $GITLAB_REMOTE"
    else
        warning "No se encontró un remote de GitLab"
        echo "   Agrega tu repositorio: git remote add origin <url-de-gitlab>"
    fi
else
    warning "No es un repositorio Git"
    echo "   Inicializa: git init"
fi

echo ""
echo "🔐 Recordatorios de seguridad..."
echo ""

# Buscar posibles tokens expuestos
echo "Buscando posibles tokens expuestos..."

if grep -r "glpat-" . --exclude-dir=.git --exclude-dir=node_modules --exclude="verify-gitlab-setup.sh" 2>/dev/null; then
    error "¡Se encontraron tokens de GitLab en el código!"
else
    success "No se encontraron tokens de GitLab expuestos"
fi

if grep -r "squ_" . --exclude-dir=.git --exclude-dir=node_modules --exclude="verify-gitlab-setup.sh" 2>/dev/null; then
    error "¡Se encontraron tokens de SonarQube en el código!"
else
    success "No se encontraron tokens de SonarQube expuestos"
fi

echo ""
echo "📊 Resumen de verificación..."
echo ""
echo -e "${GREEN}✅ Éxitos: $SUCCESS${NC}"
echo -e "${YELLOW}⚠️  Advertencias: $WARNINGS${NC}"
echo -e "${RED}❌ Errores: $ERRORS${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡Todo está configurado correctamente!${NC}"
    echo ""
    echo "Próximos pasos:"
    echo "1. Configura las variables en GitLab CI/CD (SONAR_TOKEN, SONAR_HOST_URL)"
    echo "2. Copia sonar-project.properties.example a sonar-project.properties"
    echo "3. Edita sonar-project.properties con tu configuración"
    echo "4. Crea un Merge Request para probar la integración"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Hay algunas advertencias, pero puedes continuar${NC}"
    echo ""
    echo "Revisa las advertencias arriba y corrígelas si es necesario."
    exit 0
else
    echo -e "${RED}❌ Hay errores que deben ser corregidos${NC}"
    echo ""
    echo "Por favor, corrige los errores antes de continuar."
    exit 1
fi
