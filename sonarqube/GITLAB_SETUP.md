# 🦊 Configuración de GitLab + SonarQube

Esta guía te ayudará a configurar la integración entre **GitLab** y **SonarQube** para habilitar **Merge Request Decoration** (comentarios automáticos en tus Merge Requests).

## 📚 Índice

1. [Ventajas de GitLab vs GitHub](#ventajas-de-gitlab-vs-github)
2. [Generar Personal Access Token en GitLab](#1-generar-personal-access-token-en-gitlab)
3. [Configurar en SonarQube](#2-configurar-en-sonarqube)
4. [Configurar Proyecto en SonarQube](#3-configurar-proyecto-en-sonarqube)
5. [Configurar GitLab CI/CD](#4-configurar-gitlab-cicd)
6. [Verificar Integración](#5-verificar-integración)

---

## ✨ Ventajas de GitLab vs GitHub

La integración con GitLab es **mucho más simple** que con GitHub:

| Característica | GitLab | GitHub |
|----------------|--------|--------|
| **Configuración** | ✅ Solo necesitas un token | ❌ Requiere GitHub App compleja |
| **Pasos** | ✅ 3 pasos | ❌ 7+ pasos |
| **Credenciales** | ✅ 1 token | ❌ App ID, Client ID, Secret, Private Key |
| **Tiempo de setup** | ✅ 5 minutos | ❌ 15-20 minutos |

---

## 1️⃣ Generar Personal Access Token en GitLab

### Paso 1.1: Acceder a GitLab

1. Ve a GitLab: https://gitlab.com (o tu instancia de GitLab)
2. Haz clic en tu **avatar** (esquina superior derecha)
3. Selecciona **Edit profile** o **Preferences**
4. En el menú lateral izquierdo, haz clic en **Access Tokens**

### Paso 1.2: Crear Nuevo Token

Haz clic en **Add new token** y completa:

| Campo | Valor |
|-------|-------|
| **Token name** | `SonarQube Integration` |
| **Expiration date** | Selecciona una fecha (recomendado: 1 año) |

### Paso 1.3: Seleccionar Scopes (Permisos)

Marca las siguientes casillas:

- ✅ **api** - Full access to the API
- ✅ **read_api** - Read-only access to the API
- ✅ **read_repository** - Read access to repositories
- ✅ **write_repository** - Write access to repositories

**Nota:** Si solo quieres lectura (sin comentarios), solo marca `read_api` y `read_repository`.

### Paso 1.4: Crear el Token

1. Haz clic en **Create personal access token**
2. **📝 COPIA EL TOKEN INMEDIATAMENTE** (solo se muestra una vez)
3. Guárdalo en un lugar seguro

Ejemplo de token:
```
glpat-xxxxxxxxxxxxxxxxxxxx
```

---

## 2️⃣ Configurar en SonarQube

### Paso 2.1: Acceder a la Configuración

1. Abre SonarQube: http://localhost:9000
2. Inicia sesión como **admin**
3. Ve a **Administration** (icono de engranaje arriba a la derecha)
4. En el menú lateral, selecciona **Configuration** → **General Settings**
5. Busca la pestaña **ALM Integrations**
6. Selecciona **GitLab**

### Paso 2.2: Crear Nueva Configuración

Haz clic en **Create configuration** y completa los campos:

#### **Configuration name***
```
gitlab-main
```
*Nombre descriptivo para identificar esta configuración*

#### **GitLab URL***

**Si usas GitLab.com:**
```
https://gitlab.com
```

**Si usas GitLab Self-Managed (tu propia instancia):**
```
https://gitlab.tuempresa.com
```

#### **Personal Access Token***
```
glpat-xxxxxxxxxxxxxxxxxxxx
```
*El token que generaste en el paso 1.4*

### Paso 2.3: Guardar Configuración

Haz clic en **Save** o **Create**.

✅ ¡Listo! La configuración de GitLab está completa.

---

## 3️⃣ Configurar Proyecto en SonarQube

### Paso 3.1: Crear o Seleccionar Proyecto

1. En SonarQube, ve a **Projects**
2. Si no tienes un proyecto, haz clic en **Create Project** → **Manually**
3. Completa:
   - **Project key**: `mi-proyecto-gitlab`
   - **Display name**: `Mi Proyecto GitLab`
4. Haz clic en **Set Up**
5. Selecciona **Locally**
6. **Genera un token** y guárdalo

### Paso 3.2: Configurar Merge Request Decoration

1. Ve a tu proyecto en SonarQube
2. Haz clic en **Project Settings** (abajo a la izquierda)
3. Selecciona **General Settings**
4. Busca la sección **Merge Request Decoration**
5. Completa:

| Campo | Valor |
|-------|-------|
| **Configuration** | Selecciona `gitlab-main` |
| **Project ID** | El ID numérico de tu proyecto en GitLab |

#### ¿Cómo encontrar el Project ID?

**Opción 1: Desde la página del proyecto en GitLab**
- Ve a tu proyecto en GitLab
- El Project ID aparece debajo del nombre del proyecto
- Ejemplo: `Project ID: 12345678`

**Opción 2: Desde la URL**
- Si la URL es: `https://gitlab.com/usuario/mi-proyecto`
- El formato es: `usuario/mi-proyecto`
- Puedes usar el formato `namespace/project` o el ID numérico

**Ejemplo:**
```
Project ID: 12345678
```
o
```
Project ID: leonardo/mi-proyecto-react
```

6. Haz clic en **Save**

---

## 4️⃣ Configurar GitLab CI/CD

### Paso 4.1: Crear Variables de Entorno en GitLab

1. Ve a tu proyecto en GitLab
2. Settings → CI/CD → Variables
3. Haz clic en **Add variable**

Agrega estas dos variables:

**Variable 1:**
- **Key**: `SONAR_TOKEN`
- **Value**: [El token que generaste en SonarQube en el paso 3.1]
- **Type**: Variable
- **Flags**: 
  - ✅ Protect variable
  - ✅ Mask variable
  - ⬜ Expand variable reference

**Variable 2:**
- **Key**: `SONAR_HOST_URL`
- **Value**: `http://localhost:9000` (o tu URL de SonarQube)
- **Type**: Variable
- **Flags**: 
  - ⬜ Protect variable
  - ⬜ Mask variable
  - ⬜ Expand variable reference

### Paso 4.2: Crear archivo `.gitlab-ci.yml`

En la raíz de tu proyecto, crea el archivo `.gitlab-ci.yml`:

```yaml
stages:
  - test
  - sonarqube

# Ejecutar tests (ajusta según tu proyecto)
test:
  stage: test
  image: node:20  # Cambia según tu lenguaje
  script:
    - npm ci
    - npm test
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

# Análisis de SonarQube
sonarqube-check:
  stage: sonarqube
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: [""]
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  script:
    - sonar-scanner
      -Dsonar.projectKey=mi-proyecto-gitlab
      -Dsonar.projectName="Mi Proyecto GitLab"
      -Dsonar.sources=.
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.token=${SONAR_TOKEN}
      -Dsonar.exclusions=**/node_modules/**,**/dist/**,**/build/**,**/coverage/**
  allow_failure: true
  only:
    - merge_requests
    - main
    - develop
```

### Paso 4.3: Crear archivo `sonar-project.properties` (Opcional)

Si prefieres usar un archivo de configuración en lugar de parámetros en el CI:

```properties
# Información del proyecto
sonar.projectKey=mi-proyecto-gitlab
sonar.projectName=Mi Proyecto GitLab
sonar.projectVersion=1.0

# Código fuente
sonar.sources=.

# Exclusiones
sonar.exclusions=\
  **/node_modules/**,\
  **/dist/**,\
  **/build/**,\
  **/coverage/**,\
  **/*.test.js,\
  **/*.spec.js

# Tests
sonar.tests=.
sonar.test.inclusions=\
  **/*.test.js,\
  **/*.spec.js

# Cobertura (ajusta según tu proyecto)
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

---

## 5️⃣ Verificar Integración

### Paso 5.1: Crear Merge Request de Prueba

```bash
# Crear nueva rama
git checkout -b test-sonarqube-gitlab

# Hacer un cambio
echo "// Test SonarQube" >> README.md
git add README.md
git commit -m "test: SonarQube integration"
git push origin test-sonarqube-gitlab
```

### Paso 5.2: Crear MR en GitLab

1. Ve a tu proyecto en GitLab
2. Haz clic en **Create merge request**
3. Completa los detalles y crea el MR

### Paso 5.3: Verificar Resultados

En el Merge Request deberías ver:

- ✅ **Pipeline ejecutándose** con el job `sonarqube-check`
- 💬 **Comentarios de SonarQube** en las líneas con problemas
- 📊 **Widget de SonarQube** con métricas de calidad
- ✅/❌ **Estado del Quality Gate**

---

## 🎯 Configuración para Diferentes Lenguajes

### JavaScript/TypeScript (Node.js)

```yaml
sonarqube-check:
  stage: sonarqube
  image: sonarsource/sonar-scanner-cli:latest
  script:
    - sonar-scanner
      -Dsonar.projectKey=mi-proyecto
      -Dsonar.sources=src
      -Dsonar.tests=tests
      -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
```

### Python

```yaml
sonarqube-check:
  stage: sonarqube
  image: sonarsource/sonar-scanner-cli:latest
  script:
    - sonar-scanner
      -Dsonar.projectKey=mi-proyecto
      -Dsonar.sources=.
      -Dsonar.python.coverage.reportPaths=coverage.xml
      -Dsonar.python.version=3.11
```

### Java (Maven)

```yaml
sonarqube-check:
  stage: sonarqube
  image: maven:3.8-openjdk-17
  script:
    - mvn clean verify sonar:sonar
      -Dsonar.projectKey=mi-proyecto
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.token=${SONAR_TOKEN}
```

### Java (Gradle)

```yaml
sonarqube-check:
  stage: sonarqube
  image: gradle:7-jdk17
  script:
    - gradle sonar
      -Dsonar.projectKey=mi-proyecto
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.token=${SONAR_TOKEN}
```

---

## 🔧 Solución de Problemas

### Error: "Could not find project"

**Causa:** El Project ID es incorrecto.

**Solución:**
1. Ve a tu proyecto en GitLab
2. Copia el **Project ID** exacto (número o namespace/project)
3. Actualiza en SonarQube → Project Settings → Merge Request Decoration

### Error: "Unauthorized"

**Causa:** El Personal Access Token es inválido o expiró.

**Solución:**
1. Genera un nuevo token en GitLab
2. Actualiza en SonarQube → Administration → ALM Integrations → GitLab
3. Actualiza la variable `SONAR_TOKEN` en GitLab CI/CD

### No aparecen comentarios en el MR

**Causa:** Configuración incompleta.

**Solución:**
1. Verifica que el token tenga permisos `api` y `write_repository`
2. Verifica que el Project ID sea correcto
3. Verifica que el pipeline se ejecute correctamente

### Pipeline falla en localhost

**Causa:** GitLab CI no puede alcanzar `localhost:9000`.

**Solución:**
- Despliega SonarQube en un servidor accesible
- O usa ngrok para exponer localhost:
  ```bash
  ngrok http 9000
  # Usa la URL de ngrok en SONAR_HOST_URL
  ```

---

## 📊 Ejemplo Completo de Proyecto

### Estructura de archivos:

```
mi-proyecto/
├── .gitlab-ci.yml
├── sonar-project.properties
├── src/
│   └── index.js
├── tests/
│   └── index.test.js
├── package.json
└── README.md
```

### `.gitlab-ci.yml` completo:

```yaml
stages:
  - install
  - test
  - sonarqube

variables:
  npm_config_cache: "$CI_PROJECT_DIR/.npm"

cache:
  paths:
    - .npm/
    - node_modules/

install:
  stage: install
  image: node:20
  script:
    - npm ci
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 hour

test:
  stage: test
  image: node:20
  dependencies:
    - install
  script:
    - npm test -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - coverage/
    expire_in: 1 week

sonarqube:
  stage: sonarqube
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: [""]
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  dependencies:
    - test
  script:
    - sonar-scanner
  allow_failure: true
  only:
    - merge_requests
    - main
    - develop
```

---

## 🎉 Beneficios de la Integración

Una vez configurado, cada Merge Request mostrará:

- ✅ **Quality Gate Status** (Pass/Fail)
- 🐛 **Bugs detectados** con ubicación exacta
- 🔒 **Vulnerabilidades de seguridad**
- 💩 **Code smells** y sugerencias
- 📊 **Cobertura de código**
- 💬 **Comentarios inline** en el código
- 📈 **Tendencias de calidad** a lo largo del tiempo

---

## 📝 Resumen de Credenciales

Guarda esta información:

```yaml
GitLab Configuration:
  Personal Access Token: glpat-xxxxxxxxxxxxxxxxxxxx
  Scopes: api, read_api, read_repository, write_repository
  
SonarQube Configuration:
  Configuration Name: gitlab-main
  GitLab URL: https://gitlab.com
  Personal Access Token: [mismo token de arriba]

Project Configuration:
  Project Key: mi-proyecto-gitlab
  Project ID: [ID numérico o namespace/project]
  SonarQube Token: [token generado en SonarQube]
```

---

## 📚 Referencias

- [Documentación oficial de SonarQube + GitLab](https://docs.sonarqube.org/latest/analysis/gitlab-integration/)
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [SonarScanner CLI](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)

---

## 🆘 ¿Necesitas Ayuda?

Si tienes problemas:
1. Revisa los logs del pipeline en GitLab
2. Revisa los logs de SonarQube: `docker-compose logs -f sonarqube`
3. Verifica que el token tenga los permisos correctos
4. Verifica que el Project ID sea correcto

¡Disfruta de tu integración GitLab + SonarQube! 🚀
