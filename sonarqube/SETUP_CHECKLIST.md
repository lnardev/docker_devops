# ✅ Checklist de Configuración GitHub App + SonarQube

Usa este checklist para asegurarte de que todo esté configurado correctamente.

## 📋 Fase 1: Preparación

- [ ] SonarQube está corriendo en `http://localhost:9000`
- [ ] Puedes iniciar sesión en SonarQube (admin/admin)
- [ ] Tienes acceso a GitHub (cuenta personal u organización)
- [ ] Tienes permisos para crear GitHub Apps

## 🔧 Fase 2: Generar Credenciales

- [ ] Ejecutar script de generación:
  ```bash
  cd /Users/leonardo/Desktop/docker_sonarqube
  ./generate-credentials.sh
  ```
- [ ] Guardar el **Webhook Secret** generado
- [ ] Guardar el archivo `github-app-credentials.txt` en lugar seguro

## 🐙 Fase 3: Crear GitHub App

### Acceso
- [ ] Ir a GitHub → Settings → Developer settings → GitHub Apps
- [ ] Clic en **New GitHub App**

### Configuración Básica
- [ ] **GitHub App name**: `SonarQube DevOps` (o tu nombre preferido)
- [ ] **Homepage URL**: `http://localhost:9000`
- [ ] **Webhook URL**: `http://localhost:9000/api/alm_integration/github/webhook`
- [ ] **Webhook secret**: [Pegar el generado en Fase 2]
- [ ] **Webhook**: Desmarcar "Active" (si usas localhost)

### Permisos de Repositorio
- [ ] **Checks**: Read & write ✅
- [ ] **Commit statuses**: Read & write ✅
- [ ] **Contents**: Read-only ✅
- [ ] **Issues**: Read & write ✅
- [ ] **Metadata**: Read-only ✅ (automático)
- [ ] **Pull requests**: Read & write ✅

### Permisos de Organización (opcional)
- [ ] **Members**: Read-only
- [ ] **Projects**: Read-only

### Eventos
- [ ] **Pull request** ✅
- [ ] **Push** ✅

### Instalación
- [ ] **Where can this GitHub App be installed?**: Seleccionar opción
- [ ] Clic en **Create GitHub App**

## 🔑 Fase 4: Obtener Credenciales de GitHub

- [ ] **App ID**: Copiar de la página de la app
  ```
  App ID: __________________
  ```

- [ ] **Client ID**: Copiar de la página de la app
  ```
  Client ID: __________________
  ```

- [ ] **Client Secret**: 
  - [ ] Clic en "Generate a new client secret"
  - [ ] Copiar inmediatamente (solo se muestra una vez)
  ```
  Client Secret: __________________
  ```

- [ ] **Private Key**:
  - [ ] Clic en "Generate a private key"
  - [ ] Descargar archivo `.pem`
  - [ ] Guardar en lugar seguro
  ```
  Private Key file: __________________
  ```

## 🎯 Fase 5: Configurar en SonarQube

### Acceso a Configuración
- [ ] Ir a http://localhost:9000
- [ ] Login como admin
- [ ] Administration → Configuration → General Settings
- [ ] Pestaña **ALM Integrations**
- [ ] Seleccionar **GitHub**

### Crear Configuración
- [ ] Clic en **Create configuration**

- [ ] **Configuration name**: `devops`

- [ ] **GitHub API URL**: 
  - [ ] GitHub.com: `https://api.github.com/`
  - [ ] GitHub Enterprise: `https://github.tuempresa.com/api/v3`

- [ ] **GitHub App ID**: [Pegar de Fase 4]

- [ ] **Client ID**: [Pegar de Fase 4]

- [ ] **Client Secret**: [Pegar de Fase 4]

- [ ] **Private Key**: 
  - [ ] Abrir archivo `.pem` descargado
  - [ ] Copiar TODO el contenido (incluir BEGIN y END)
  - [ ] Pegar en el campo

- [ ] **Webhook Secret**: [Pegar de Fase 2] (opcional)

- [ ] Clic en **Save** o **Create**

## 📦 Fase 6: Instalar GitHub App en Repositorio

- [ ] GitHub → Settings → Developer settings → GitHub Apps
- [ ] Seleccionar tu app **SonarQube DevOps**
- [ ] Clic en **Install App**
- [ ] Seleccionar cuenta/organización
- [ ] Elegir repositorios:
  - [ ] All repositories, o
  - [ ] Only select repositories
- [ ] Clic en **Install**

## 🎨 Fase 7: Configurar Proyecto en SonarQube

### Crear Proyecto (si no existe)
- [ ] SonarQube → Projects → Create Project
- [ ] **Project key**: `mi-proyecto`
- [ ] **Display name**: `Mi Proyecto`
- [ ] Generar token y guardarlo

### Configurar Pull Request Decoration
- [ ] Ir al proyecto en SonarQube
- [ ] Project Settings → General Settings
- [ ] Sección **Pull Request Decoration**
- [ ] **Configuration**: Seleccionar `devops`
- [ ] **Repository identifier**: `usuario/repositorio` o `org/repositorio`
  ```
  Ejemplo: leonardo/mi-proyecto-react
  ```
- [ ] Clic en **Save**

## 🧪 Fase 8: Probar la Integración

### Preparar Proyecto Local
- [ ] Clonar repositorio de GitHub:
  ```bash
  git clone https://github.com/USUARIO/REPOSITORIO.git
  cd REPOSITORIO
  ```

- [ ] Crear archivo `sonar-project.properties`:
  ```properties
  sonar.projectKey=mi-proyecto
  sonar.projectName=Mi Proyecto
  sonar.sources=.
  sonar.host.url=http://localhost:9000
  sonar.token=TU_TOKEN_AQUI
  sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**
  ```

### Crear Pull Request de Prueba
- [ ] Crear nueva rama:
  ```bash
  git checkout -b test-sonarqube-integration
  ```

- [ ] Hacer un cambio pequeño:
  ```bash
  echo "// Test SonarQube" >> README.md
  git add README.md
  git commit -m "test: SonarQube integration"
  git push origin test-sonarqube-integration
  ```

- [ ] Crear Pull Request en GitHub

### Ejecutar Análisis
- [ ] Instalar SonarScanner (si no está instalado):
  ```bash
  brew install sonar-scanner
  ```

- [ ] Ejecutar análisis:
  ```bash
  sonar-scanner
  ```

### Verificar Resultados
- [ ] Ir al Pull Request en GitHub
- [ ] Verificar que aparezca:
  - [ ] ✅ Check de SonarQube
  - [ ] 💬 Comentarios (si hay problemas)
  - [ ] 📊 Métricas de calidad

## ✅ Verificación Final

- [ ] El Quality Gate aparece en el PR
- [ ] Los comentarios de SonarQube son visibles
- [ ] El estado del commit se actualiza (✅/❌)
- [ ] Las métricas son correctas
- [ ] No hay errores en los logs de SonarQube

### Verificar Logs (si hay problemas)
```bash
cd /Users/leonardo/Desktop/docker_sonarqube
docker-compose logs -f sonarqube
```

## 🎉 ¡Configuración Completa!

Si todos los checkboxes están marcados, ¡felicitaciones! Tu integración está funcionando correctamente.

## 🆘 Solución de Problemas

Si algo no funciona, revisa:

1. **Logs de SonarQube**:
   ```bash
   docker-compose logs sonarqube | grep -i error
   ```

2. **Configuración de GitHub App**:
   - Verifica permisos
   - Verifica que esté instalada en el repositorio correcto

3. **Credenciales en SonarQube**:
   - App ID correcto
   - Client ID correcto
   - Client Secret correcto
   - Private Key completa (con BEGIN y END)

4. **Repository identifier**:
   - Formato correcto: `usuario/repo` o `org/repo`
   - Sin espacios
   - Case-sensitive

## 📚 Recursos

- [Guía completa de configuración](./GITHUB_APP_SETUP.md)
- [Diagrama de flujo](./INTEGRATION_FLOW.md)
- [Documentación oficial](https://docs.sonarqube.org/latest/analysis/github-integration/)

---

**Última actualización**: 2026-01-24
