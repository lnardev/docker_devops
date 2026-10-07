# 🚀 Guía Rápida de Configuración GitLab + SonarQube

## ⚠️ IMPORTANTE: Seguridad

**NUNCA** subas tokens o credenciales al repositorio. Usa siempre variables de entorno en GitLab CI/CD.

---

## 📋 Pasos de Configuración

### 1️⃣ Generar Token en GitLab

1. Ve a GitLab → Avatar → **Preferences** → **Access Tokens**
2. Crea un nuevo token con estos permisos:
   - ✅ `api`
   - ✅ `read_api`
   - ✅ `read_repository`
   - ✅ `write_repository`
3. **Copia el token inmediatamente** (solo se muestra una vez)

### 2️⃣ Configurar SonarQube

1. Accede a SonarQube: http://localhost:9000
2. Ve a **Administration** → **Configuration** → **General Settings** → **ALM Integrations** → **GitLab**
3. Crea una nueva configuración:
   - **Configuration name**: `gitlab-main`
   - **GitLab URL**: `https://gitlab.com`
   - **Personal Access Token**: [tu token de GitLab]

### 3️⃣ Crear Proyecto en SonarQube

1. **Projects** → **Create Project** → **Manually**
2. Define:
   - **Project key**: `mi-proyecto-gitlab` (o el nombre de tu proyecto)
   - **Display name**: `Mi Proyecto GitLab`
3. Genera un **token de SonarQube** y guárdalo

### 4️⃣ Configurar Merge Request Decoration

1. En tu proyecto de SonarQube → **Project Settings** → **General Settings**
2. Sección **Merge Request Decoration**:
   - **Configuration**: Selecciona `gitlab-main`
   - **Project ID**: [ID de tu proyecto en GitLab]

**¿Cómo obtener el Project ID?**
- Ve a tu proyecto en GitLab
- El ID aparece debajo del nombre del proyecto
- Ejemplo: `Project ID: 12345678`
- También puedes usar: `usuario/nombre-proyecto`

### 5️⃣ Configurar Variables en GitLab CI/CD

1. Ve a tu proyecto en GitLab
2. **Settings** → **CI/CD** → **Variables** → **Add variable**

Crea estas dos variables:

**Variable 1:**
- **Key**: `SONAR_TOKEN`
- **Value**: [token de SonarQube del paso 3]
- ✅ Protect variable
- ✅ Mask variable

**Variable 2:**
- **Key**: `SONAR_HOST_URL`
- **Value**: `http://localhost:9000` (o tu URL de SonarQube)

### 6️⃣ Configurar tu Proyecto

1. **Copia el archivo de ejemplo:**
   ```bash
   cp sonar-project.properties.example sonar-project.properties
   ```

2. **Edita `sonar-project.properties`:**
   - Cambia `sonar.projectKey` por el key de tu proyecto
   - Cambia `sonar.projectName` por el nombre de tu proyecto
   - **NO agregues el token aquí**, usa la variable de entorno

3. **El archivo `.gitlab-ci.yml` ya está creado** en este repositorio

### 7️⃣ Subir Cambios a GitLab

```bash
git add .gitlab-ci.yml sonar-project.properties
git commit -m "feat: add SonarQube integration"
git push origin main
```

---

## 🧪 Probar la Integración

### Crear un Merge Request de Prueba

```bash
# Crear nueva rama
git checkout -b test-sonarqube

# Hacer un cambio
echo "// Test SonarQube" >> README.md
git add README.md
git commit -m "test: SonarQube integration"
git push origin test-sonarqube
```

### Verificar en GitLab

1. Crea un Merge Request desde la rama `test-sonarqube`
2. Verifica que el pipeline se ejecute
3. Deberías ver:
   - ✅ Job `sonarqube-check` ejecutándose
   - 💬 Comentarios de SonarQube en el código
   - 📊 Widget con métricas de calidad
   - ✅/❌ Estado del Quality Gate

---

## 🎯 Ajustes por Tipo de Proyecto

### JavaScript/TypeScript/Node.js

El archivo `.gitlab-ci.yml` ya está configurado para Node.js. Solo asegúrate de tener:
- `package.json` con script de test
- Configuración de coverage (Jest, Vitest, etc.)

### Python

En `.gitlab-ci.yml`, descomenta la sección `test:python` y comenta `test:node`.

Asegúrate de tener:
- `requirements.txt`
- Tests con pytest
- Coverage configurado

### Java

Modifica `.gitlab-ci.yml` para usar Maven o Gradle. Ver ejemplos en `GITLAB_SETUP.md`.

---

## 🆘 Solución de Problemas

### Error: "Could not find project"
- Verifica el **Project ID** en GitLab
- Usa el formato correcto: `12345678` o `usuario/proyecto`

### Error: "Unauthorized"
- Verifica que el token de GitLab tenga los permisos correctos
- Verifica que el token de SonarQube sea válido
- Verifica que las variables estén configuradas en GitLab CI/CD

### Pipeline falla
- Revisa los logs del job en GitLab
- Verifica que `SONAR_TOKEN` y `SONAR_HOST_URL` estén configurados
- Verifica que el proyecto exista en SonarQube

### No aparecen comentarios en el MR
- Verifica que el token de GitLab tenga permiso `write_repository`
- Verifica que el **Project ID** sea correcto
- Verifica que el análisis se haya completado exitosamente

### SonarQube no es accesible desde GitLab CI
Si usas `localhost:9000`, GitLab CI no podrá acceder. Opciones:
1. Despliega SonarQube en un servidor público
2. Usa ngrok para exponer localhost:
   ```bash
   ngrok http 9000
   # Usa la URL de ngrok en SONAR_HOST_URL
   ```

---

## 📊 ¿Qué Obtienes?

✅ Análisis automático en cada Merge Request  
✅ Comentarios inline en el código  
✅ Métricas de calidad visibles  
✅ Quality Gate automático  
✅ Prevención de bugs antes de merge  
✅ Seguimiento de cobertura de código  
✅ Detección de vulnerabilidades de seguridad  

---

## 📚 Documentación Adicional

- [Guía completa de GitLab](./GITLAB_SETUP.md)
- [Checklist de configuración](./GITLAB_CHECKLIST.md)
- [Documentación oficial de SonarQube](https://docs.sonarqube.org/latest/analysis/gitlab-integration/)

---

## 🔐 Recordatorio de Seguridad

**NUNCA** incluyas tokens o credenciales en:
- ❌ `sonar-project.properties`
- ❌ `.gitlab-ci.yml`
- ❌ Cualquier archivo que se suba al repositorio

**SIEMPRE** usa:
- ✅ Variables de entorno en GitLab CI/CD
- ✅ Variables protegidas y enmascaradas
- ✅ Archivos `.env` (que están en `.gitignore`)

---

**Última actualización**: 2026-01-24

¡Disfruta de tu integración GitLab + SonarQube! 🚀
