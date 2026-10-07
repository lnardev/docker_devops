# ✅ Checklist de Configuración GitLab + SonarQube

Usa este checklist para configurar la integración GitLab + SonarQube en **5 minutos**.

## 🎯 Ventaja: ¡Mucho más simple que GitHub!

- ✅ Solo necesitas **1 token** (vs 4 credenciales en GitHub)
- ✅ Solo **3 pasos principales** (vs 7+ en GitHub)
- ✅ **5 minutos** de configuración (vs 15-20 en GitHub)

---

## 📋 Fase 1: Generar Token en GitLab

### Acceder a GitLab
- [ ] Ir a https://gitlab.com (o tu instancia de GitLab)
- [ ] Clic en tu **avatar** → **Edit profile** o **Preferences**
- [ ] Menú lateral → **Access Tokens**

### Crear Token
- [ ] Clic en **Add new token**
- [ ] **Token name**: `SonarQube Integration`
- [ ] **Expiration date**: Seleccionar fecha (recomendado: 1 año)

### Seleccionar Permisos (Scopes)
- [ ] ✅ **api** - Full access to the API
- [ ] ✅ **read_api** - Read-only access to the API
- [ ] ✅ **read_repository** - Read access to repositories
- [ ] ✅ **write_repository** - Write access to repositories

### Guardar Token
- [ ] Clic en **Create personal access token**
- [ ] **COPIAR EL TOKEN INMEDIATAMENTE** (solo se muestra una vez)
  ```
  Token: glpat-_________________________
  ```

---

## 🎯 Fase 2: Configurar en SonarQube

### Acceder a Configuración
- [ ] Ir a http://localhost:9000
- [ ] Login como **admin**
- [ ] Administration → Configuration → General Settings
- [ ] Pestaña **ALM Integrations**
- [ ] Seleccionar **GitLab**

### Crear Configuración
- [ ] Clic en **Create configuration**

- [ ] **Configuration name**: `gitlab-main`

- [ ] **GitLab URL**:
  - [ ] GitLab.com: `https://gitlab.com`
  - [ ] GitLab Self-Managed: `https://gitlab.tuempresa.com`

- [ ] **Personal Access Token**: [Pegar el token de Fase 1]

- [ ] Clic en **Save** o **Create**

✅ ¡Configuración de GitLab completa!

---

## 📦 Fase 3: Configurar Proyecto en SonarQube

### Crear/Seleccionar Proyecto
- [ ] SonarQube → **Projects** → **Create Project** → **Manually**
- [ ] **Project key**: `mi-proyecto-gitlab`
- [ ] **Display name**: `Mi Proyecto GitLab`
- [ ] Clic en **Set Up**
- [ ] Seleccionar **Locally**
- [ ] **Generar token** y guardarlo
  ```
  SonarQube Token: squ_________________________
  ```

### Configurar Merge Request Decoration
- [ ] Ir al proyecto en SonarQube
- [ ] **Project Settings** → **General Settings**
- [ ] Sección **Merge Request Decoration**
- [ ] **Configuration**: Seleccionar `gitlab-main`
- [ ] **Project ID**: [Ver cómo obtenerlo abajo]

#### ¿Cómo obtener el Project ID?

**Opción 1: Desde GitLab**
- [ ] Ve a tu proyecto en GitLab
- [ ] El Project ID aparece debajo del nombre del proyecto
  ```
  Project ID: 12345678
  ```

**Opción 2: Usar namespace/project**
- [ ] Formato: `usuario/nombre-proyecto` o `grupo/nombre-proyecto`
  ```
  Ejemplo: leonardo/mi-proyecto-react
  ```

- [ ] Clic en **Save**

---

## 🔧 Fase 4: Configurar GitLab CI/CD

### Crear Variables en GitLab
- [ ] Ve a tu proyecto en GitLab
- [ ] Settings → CI/CD → Variables → **Add variable**

**Variable 1:**
- [ ] **Key**: `SONAR_TOKEN`
- [ ] **Value**: [Token de SonarQube de Fase 3]
- [ ] **Type**: Variable
- [ ] ✅ Protect variable
- [ ] ✅ Mask variable

**Variable 2:**
- [ ] **Key**: `SONAR_HOST_URL`
- [ ] **Value**: `http://localhost:9000` (o tu URL)
- [ ] **Type**: Variable

### Crear archivo `.gitlab-ci.yml`

- [ ] En la raíz de tu proyecto, crear `.gitlab-ci.yml`

**Para Node.js/JavaScript:**
```yaml
stages:
  - test
  - sonarqube

test:
  stage: test
  image: node:20
  script:
    - npm ci
    - npm test -- --coverage
  artifacts:
    paths:
      - coverage/

sonarqube:
  stage: sonarqube
  image: sonarsource/sonar-scanner-cli:latest
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
      -Dsonar.sources=.
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.token=${SONAR_TOKEN}
      -Dsonar.exclusions=**/node_modules/**,**/dist/**,**/build/**
  only:
    - merge_requests
    - main
```

**Para Python:**
```yaml
stages:
  - test
  - sonarqube

test:
  stage: test
  image: python:3.11
  script:
    - pip install -r requirements.txt
    - pytest --cov=. --cov-report=xml
  artifacts:
    paths:
      - coverage.xml

sonarqube:
  stage: sonarqube
  image: sonarsource/sonar-scanner-cli:latest
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  script:
    - sonar-scanner
      -Dsonar.projectKey=mi-proyecto-gitlab
      -Dsonar.sources=.
      -Dsonar.python.coverage.reportPaths=coverage.xml
      -Dsonar.host.url=${SONAR_HOST_URL}
      -Dsonar.token=${SONAR_TOKEN}
  only:
    - merge_requests
    - main
```

- [ ] Commit y push del archivo `.gitlab-ci.yml`

---

## 🧪 Fase 5: Probar la Integración

### Crear Merge Request de Prueba
- [ ] Crear nueva rama:
  ```bash
  git checkout -b test-sonarqube
  ```

- [ ] Hacer un cambio:
  ```bash
  echo "// Test SonarQube" >> README.md
  git add README.md
  git commit -m "test: SonarQube integration"
  git push origin test-sonarqube
  ```

- [ ] Crear Merge Request en GitLab

### Verificar Resultados
- [ ] Pipeline se ejecuta automáticamente
- [ ] Job `sonarqube` aparece en el pipeline
- [ ] Job completa exitosamente
- [ ] En el MR, aparecen:
  - [ ] ✅ Widget de SonarQube
  - [ ] 💬 Comentarios en líneas con problemas
  - [ ] 📊 Métricas de calidad
  - [ ] ✅/❌ Estado del Quality Gate

---

## ✅ Verificación Final

### Checklist de Funcionamiento
- [ ] Token de GitLab tiene los permisos correctos
- [ ] Configuración en SonarQube está guardada
- [ ] Project ID es correcto
- [ ] Variables de CI/CD están configuradas
- [ ] Archivo `.gitlab-ci.yml` está en el repositorio
- [ ] Pipeline se ejecuta en MRs
- [ ] Comentarios de SonarQube aparecen en el MR

### Verificar Logs (si hay problemas)
```bash
# Logs de SonarQube
cd /Users/leonardo/Desktop/docker_sonarqube
docker-compose logs -f sonarqube

# Logs del pipeline en GitLab
# (Ver en la interfaz web de GitLab)
```

---

## 🎉 ¡Configuración Completa!

Si todos los checkboxes están marcados, ¡tu integración está funcionando!

### Lo que ahora tienes:

✅ Análisis automático en cada Merge Request
✅ Comentarios inline en el código
✅ Métricas de calidad visibles
✅ Quality Gate automático
✅ Prevención de bugs antes de merge

---

## 🆘 Solución de Problemas Rápida

### Error: "Could not find project"
- [ ] Verifica el Project ID en GitLab
- [ ] Usa el formato correcto: `12345678` o `usuario/proyecto`

### Error: "Unauthorized"
- [ ] Verifica que el token tenga permisos `api` y `write_repository`
- [ ] Regenera el token si expiró

### Pipeline falla
- [ ] Verifica que `SONAR_TOKEN` y `SONAR_HOST_URL` estén configurados
- [ ] Verifica que el proyecto exista en SonarQube
- [ ] Revisa los logs del job en GitLab

### No aparecen comentarios
- [ ] Verifica que el token tenga permiso `write_repository`
- [ ] Verifica que el Project ID sea correcto
- [ ] Verifica que el análisis se haya completado exitosamente

---

## 📊 Comparación: GitLab vs GitHub

| Aspecto | GitLab | GitHub |
|---------|--------|--------|
| **Credenciales** | 1 token | 4 credenciales |
| **Pasos** | 5 fases | 8 fases |
| **Tiempo** | ~5 min | ~20 min |
| **Complejidad** | ⭐ Fácil | ⭐⭐⭐ Complejo |
| **Mantenimiento** | Renovar token | Renovar múltiples credenciales |

---

## 📚 Recursos

- [Guía completa de GitLab](./GITLAB_SETUP.md)
- [Documentación oficial](https://docs.sonarqube.org/latest/analysis/gitlab-integration/)
- [GitLab CI/CD Docs](https://docs.gitlab.com/ee/ci/)

---

**Última actualización**: 2026-01-24

¡Disfruta de tu integración GitLab + SonarQube! 🚀
