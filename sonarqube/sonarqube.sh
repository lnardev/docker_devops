#!/bin/bash

# Script de ayuda para gestionar SonarQube

set -e

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para mostrar el menú
show_menu() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   SonarQube Docker - Menú de Ayuda    ║${NC}"
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo ""
    echo "1) Iniciar SonarQube"
    echo "2) Detener SonarQube"
    echo "3) Reiniciar SonarQube"
    echo "4) Ver logs en tiempo real"
    echo "5) Ver estado de los contenedores"
    echo "6) Abrir SonarQube en el navegador"
    echo "7) Limpiar todo (⚠️  Elimina datos)"
    echo "8) Actualizar imágenes"
    echo "9) Salir"
    echo ""
}

# Función para iniciar SonarQube
start_sonarqube() {
    echo -e "${GREEN}🚀 Iniciando SonarQube...${NC}"
    docker-compose up -d
    echo -e "${GREEN}✅ SonarQube iniciado correctamente${NC}"
    echo -e "${YELLOW}⏳ Espera unos 30-60 segundos para que SonarQube esté completamente listo${NC}"
    echo -e "${BLUE}🌐 Accede a: http://localhost:9000${NC}"
    echo -e "${BLUE}👤 Usuario: admin | Contraseña: admin${NC}"
}

# Función para detener SonarQube
stop_sonarqube() {
    echo -e "${YELLOW}⏸️  Deteniendo SonarQube...${NC}"
    docker-compose down
    echo -e "${GREEN}✅ SonarQube detenido${NC}"
}

# Función para reiniciar SonarQube
restart_sonarqube() {
    echo -e "${YELLOW}🔄 Reiniciando SonarQube...${NC}"
    docker-compose restart
    echo -e "${GREEN}✅ SonarQube reiniciado${NC}"
}

# Función para ver logs
view_logs() {
    echo -e "${BLUE}📋 Mostrando logs de SonarQube (Ctrl+C para salir)...${NC}"
    docker-compose logs -f sonarqube
}

# Función para ver estado
view_status() {
    echo -e "${BLUE}📊 Estado de los contenedores:${NC}"
    docker-compose ps
}

# Función para abrir en navegador
open_browser() {
    echo -e "${BLUE}🌐 Abriendo SonarQube en el navegador...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open http://localhost:9000
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open http://localhost:9000
    else
        echo -e "${YELLOW}Por favor abre manualmente: http://localhost:9000${NC}"
    fi
}

# Función para limpiar todo
clean_all() {
    echo -e "${RED}⚠️  ADVERTENCIA: Esto eliminará todos los datos de SonarQube${NC}"
    read -p "¿Estás seguro? (escribe 'SI' para confirmar): " confirm
    if [ "$confirm" = "SI" ]; then
        echo -e "${RED}🗑️  Eliminando contenedores y volúmenes...${NC}"
        docker-compose down -v
        echo -e "${GREEN}✅ Todo limpio${NC}"
    else
        echo -e "${YELLOW}❌ Operación cancelada${NC}"
    fi
}

# Función para actualizar imágenes
update_images() {
    echo -e "${BLUE}⬇️  Descargando últimas versiones...${NC}"
    docker-compose pull
    echo -e "${GREEN}✅ Imágenes actualizadas${NC}"
    echo -e "${YELLOW}💡 Ejecuta 'Reiniciar SonarQube' para aplicar los cambios${NC}"
}

# Loop principal
while true; do
    show_menu
    read -p "Selecciona una opción: " choice
    echo ""
    
    case $choice in
        1) start_sonarqube ;;
        2) stop_sonarqube ;;
        3) restart_sonarqube ;;
        4) view_logs ;;
        5) view_status ;;
        6) open_browser ;;
        7) clean_all ;;
        8) update_images ;;
        9) 
            echo -e "${GREEN}👋 ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opción inválida${NC}"
            ;;
    esac
    
    echo ""
    read -p "Presiona Enter para continuar..."
    clear
done
