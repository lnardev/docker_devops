# SonarQube Community Edition - Docker Setup

Este proyecto contiene la configuración completa de Docker Compose para ejecutar SonarQube Community Edition con PostgreSQL.

## 📚 Documentación

### 🚀 Inicio Rápido
- **[Inicio Rápido](./QUICKSTART.md)** - Empieza aquí para levantar SonarQube en minutos

### 🦊 Integración con GitLab (Recomendado - Más Simple)
- **[🦊 Configuración GitLab](./GITLAB_SETUP.md)** - Guía completa para integrar con GitLab
- **[✅ Checklist GitLab](./GITLAB_CHECKLIST.md)** - Setup en 5 minutos

### 🐙 Integración con GitHub (Más Complejo)
- **[🔗 Configuración GitHub App](./GITHUB_APP_SETUP.md)** - Guía completa para integrar con GitHub
- **[✅ Checklist GitHub](./SETUP_CHECKLIST.md)** - Verifica que todo esté configurado correctamente
- **[🔄 Flujo de Integración](./INTEGRATION_FLOW.md)** - Entiende cómo funciona la integración

### 📝 Recursos Adicionales
- **[Ejemplo de Configuración](./sonar-project.properties.example)** - Plantilla para tus proyectos
- **[⚙️ GitHub Actions Workflow](./.github/workflows/sonarqube.yml)** - Automatización CI/CD

## 📋 Requisitos Previos

- Docker instalado (versión 20.10 o superior)
- Docker Compose instalado (versión 1.29 o superior)
- Al menos 2GB de RAM disponible
- Puertos 9000 disponible

## 🚀 Inicio Rápido

### 1. Levantar los contenedores

```bash
docker-compose up -d
```

### 2. Verificar el estado

```bash
docker-compose ps
```

### 3. Ver los logs

```bash
docker-compose logs -f sonarqube
```

### 4. Acceder a SonarQube

Abre tu navegador en: **http://localhost:9000**

**Credenciales por defecto:**
- Usuario: `admin`
- Contraseña: `admin`

⚠️ **Importante:** Cambia la contraseña en el primer inicio de sesión.

## 🔧 Configuración para Analizar tu Proyecto de GitHub

### Opción 1: Análisis Local (Recomendado)

#### Paso 1: Instalar SonarScanner

**macOS:**
```bash
brew install sonar-scanner
```

**Linux:**
```bash
# Descargar SonarScanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
unzip sonar-scanner-cli-5.0.1.3006-linux.zip
export PATH=$PATH:$PWD/sonar-scanner-5.0.1.3006-linux/bin
```

#### Paso 2: Crear un proyecto en SonarQube

1. Accede a http://localhost:9000
2. Haz clic en **"Create Project"** → **"Manually"**
3. Ingresa:
   - **Project key:** `mi-proyecto-github`
   - **Display name:** `Mi Proyecto GitHub`
4. Haz clic en **"Set Up"**
5. Selecciona **"Locally"**
6. Genera un token y guárdalo

#### Paso 3: Crear archivo de configuración en tu proyecto

En la raíz de tu proyecto de GitHub, crea el archivo `sonar-project.properties`:

```properties
# Información del proyecto
sonar.projectKey=mi-proyecto-github
sonar.projectName=Mi Proyecto GitHub
sonar.projectVersion=1.0

# Ruta del código fuente
sonar.sources=.

# Excluir directorios
sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**,**/.next/**,**/coverage/**

# Configuración del servidor
sonar.host.url=http://localhost:9000

# Token de autenticación (reemplaza con tu token)
sonar.token=TU_TOKEN_AQUI
```

#### Paso 4: Ejecutar el análisis

Desde la raíz de tu proyecto:

```bash
sonar-scanner
```

### Opción 2: Integración con GitHub Actions

Crea el archivo `.github/workflows/sonarqube.yml` en tu repositorio:

```yaml
name: SonarQube Analysis

on:
  push:
    branches:
      - main
      - develop
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  sonarqube:
    name: SonarQube Scan
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0  # Shallow clones should be disabled for better analysis
      
      - name: SonarQube Scan
        uses: sonarsource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
```

**Configurar Secrets en GitHub:**
1. Ve a tu repositorio → Settings → Secrets and variables → Actions
2. Agrega:
   - `SONAR_TOKEN`: El token generado en SonarQube
   - `SONAR_HOST_URL`: `http://TU_IP_PUBLICA:9000` (si expones SonarQube públicamente)

### Opción 3: Análisis con npm/yarn (para proyectos Node.js)

```bash
# Instalar sonarqube-scanner
npm install -D sonarqube-scanner

# Agregar script en package.json
"scripts": {
  "sonar": "sonar-scanner"
}

# Ejecutar
npm run sonar
```

## 📊 Configuración Avanzada

### Análisis de diferentes lenguajes

**JavaScript/TypeScript:**
```properties
sonar.sources=src
sonar.tests=tests
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.typescript.lcov.reportPaths=coverage/lcov.info
```

**Python:**
```properties
sonar.sources=.
sonar.python.coverage.reportPaths=coverage.xml
sonar.python.version=3.9
```

**Java:**
```properties
sonar.sources=src/main/java
sonar.tests=src/test/java
sonar.java.binaries=target/classes
sonar.java.test.binaries=target/test-classes
```

## 🛠️ Comandos Útiles

### Detener los contenedores
```bash
docker-compose down
```

### Detener y eliminar volúmenes (⚠️ Elimina todos los datos)
```bash
docker-compose down -v
```

### Reiniciar SonarQube
```bash
docker-compose restart sonarqube
```

### Ver logs en tiempo real
```bash
docker-compose logs -f
```

### Actualizar a la última versión
```bash
docker-compose pull
docker-compose up -d
```

## 🔍 Solución de Problemas

### SonarQube no inicia

1. Verifica los logs:
```bash
docker-compose logs sonarqube
```

2. Aumenta los límites del sistema (Linux):
```bash
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536
```

Para hacerlo permanente, edita `/etc/sysctl.conf`:
```
vm.max_map_count=262144
fs.file-max=65536
```

### Error de conexión a la base de datos

```bash
# Reinicia los contenedores
docker-compose restart
```

### Puerto 9000 ocupado

Edita `docker-compose.yml` y cambia el puerto:
```yaml
ports:
  - "9001:9000"  # Cambia 9001 por el puerto que prefieras
```

## 📁 Estructura de Volúmenes

Los datos se persisten en los siguientes volúmenes Docker:

- `sonarqube_data`: Datos de SonarQube
- `sonarqube_extensions`: Plugins y extensiones
- `sonarqube_logs`: Logs de SonarQube
- `postgresql_data`: Base de datos PostgreSQL

## 🔐 Seguridad

1. **Cambia las credenciales por defecto** inmediatamente después del primer inicio
2. **Usa variables de entorno** para credenciales sensibles
3. **No expongas SonarQube directamente a Internet** sin configurar HTTPS y autenticación adecuada
4. **Actualiza regularmente** las imágenes Docker

## 📚 Recursos Adicionales

- [Documentación oficial de SonarQube](https://docs.sonarqube.org/)
- [SonarScanner CLI](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)
- [Reglas de análisis](https://rules.sonarsource.com/)

## 🤝 Contribuir

Si encuentras algún problema o tienes sugerencias, no dudes en crear un issue o pull request.

## 📄 Licencia

Este proyecto está bajo la licencia MIT.
