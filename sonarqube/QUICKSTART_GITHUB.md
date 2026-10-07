# 🚀 Inicio Rápido - SonarQube

## ✅ Estado Actual

SonarQube está **CORRIENDO** en tu máquina:
- 🌐 URL: http://localhost:9000
- 👤 Usuario: `admin`
- 🔑 Contraseña: `admin`

## 📝 Próximos Pasos

### 1️⃣ Accede a SonarQube

```bash
# Abre en tu navegador
open http://localhost:9000
```

### 2️⃣ Cambia la contraseña por defecto

Al iniciar sesión por primera vez, SonarQube te pedirá cambiar la contraseña.

### 3️⃣ Crea tu primer proyecto

1. Haz clic en **"Create Project"** → **"Manually"**
2. Ingresa:
   - **Project key:** `mi-proyecto`
   - **Display name:** `Mi Proyecto`
3. Genera un **token** y guárdalo en un lugar seguro

### 4️⃣ Analiza tu proyecto de GitHub

#### Opción A: Análisis Local

```bash
# 1. Clona tu repositorio de GitHub
cd ~/Desktop
git clone https://github.com/TU_USUARIO/TU_REPOSITORIO.git
cd TU_REPOSITORIO

# 2. Crea el archivo sonar-project.properties
cat > sonar-project.properties << 'EOF'
sonar.projectKey=mi-proyecto
sonar.projectName=Mi Proyecto
sonar.sources=.
sonar.host.url=http://localhost:9000
sonar.token=TU_TOKEN_AQUI
sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**
EOF

# 3. Instala SonarScanner (solo una vez)
brew install sonar-scanner

# 4. Ejecuta el análisis
sonar-scanner
```

#### Opción B: GitHub Actions (CI/CD)

1. Copia el archivo `.github/workflows/sonarqube.yml` a tu repositorio
2. Configura los secrets en GitHub:
   - `SONAR_TOKEN`: El token que generaste
   - `SONAR_HOST_URL`: `http://TU_IP:9000` (necesitas exponer SonarQube)

### 5️⃣ Ver resultados

Después del análisis, ve a http://localhost:9000 y verás:
- 🐛 Bugs detectados
- 🔒 Vulnerabilidades de seguridad
- 💩 Code smells
- 📊 Cobertura de código
- 🔄 Duplicación de código

## 🛠️ Comandos Útiles

```bash
# Usar el script interactivo
./sonarqube.sh

# O comandos directos:
docker-compose ps              # Ver estado
docker-compose logs -f         # Ver logs
docker-compose restart         # Reiniciar
docker-compose down            # Detener
docker-compose up -d           # Iniciar
```

## 📚 Documentación

- [README completo](./README.md)
- [Ejemplo de configuración](./sonar-project.properties.example)
- [Workflow de GitHub Actions](./.github/workflows/sonarqube.yml)

## 🆘 Ayuda Rápida

**¿SonarQube no responde?**
```bash
docker-compose logs sonarqube
```

**¿Quieres reiniciar todo?**
```bash
docker-compose restart
```

**¿Necesitas más memoria?**
Edita `docker-compose.yml` y agrega:
```yaml
environment:
  - SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true
```

---

**🎉 ¡Todo listo! Ahora puedes empezar a analizar tu código.**
