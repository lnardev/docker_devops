# 🔄 Flujo de Integración GitHub + SonarQube

## Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                         DESARROLLADOR                            │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 │ 1. Push código
                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                          GITHUB                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Repository: usuario/mi-proyecto                          │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Pull Request #123                                  │  │  │
│  │  │  - Código nuevo                                     │  │  │
│  │  │  - Cambios en archivos                              │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  GitHub App: SonarQube DevOps                            │  │
│  │  - App ID: 123456                                        │  │
│  │  - Permisos: Checks, PRs, Commits                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 │ 2. Webhook (opcional)
                 │ 3. API calls
                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                        SONARQUBE                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Docker Container: sonarqube:community                    │  │
│  │  Port: 9000                                               │  │
│  │                                                            │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  ALM Integration (GitHub)                          │  │  │
│  │  │  - Configuration: devops                           │  │  │
│  │  │  - GitHub API URL                                  │  │  │
│  │  │  - App ID, Client ID, Secret                       │  │  │
│  │  │  - Private Key                                     │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                            │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Análisis de Código                                │  │  │
│  │  │  - Bugs                                            │  │  │
│  │  │  - Vulnerabilidades                                │  │  │
│  │  │  - Code Smells                                     │  │  │
│  │  │  - Cobertura                                       │  │  │
│  │  │  - Duplicación                                     │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  PostgreSQL Database                                      │  │
│  │  - Proyectos                                              │  │
│  │  - Métricas                                               │  │
│  │  - Configuraciones                                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 │ 4. Resultados del análisis
                 │ 5. Decoración del PR
                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PULL REQUEST (GitHub)                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ✅ SonarQube Quality Gate: PASSED                        │  │
│  │                                                            │  │
│  │  📊 Métricas:                                             │  │
│  │  - 0 Bugs                                                 │  │
│  │  - 0 Vulnerabilities                                      │  │
│  │  - 3 Code Smells                                          │  │
│  │  - 85% Coverage                                           │  │
│  │  - 0% Duplication                                         │  │
│  │                                                            │  │
│  │  💬 Comentarios en líneas específicas:                    │  │
│  │  "Esta función es muy compleja (Cognitive Complexity 15)" │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Flujo de Trabajo Detallado

### Paso 1: Desarrollador hace Push
```bash
git checkout -b feature/nueva-funcionalidad
# ... hacer cambios ...
git add .
git commit -m "feat: nueva funcionalidad"
git push origin feature/nueva-funcionalidad
```

### Paso 2: Se crea Pull Request en GitHub
- El desarrollador crea un PR desde la rama `feature/nueva-funcionalidad` hacia `main`
- GitHub notifica a la GitHub App instalada

### Paso 3: Análisis de SonarQube

**Opción A: Manual (Local)**
```bash
cd /ruta/al/proyecto
sonar-scanner
```

**Opción B: Automático (GitHub Actions)**
```yaml
# .github/workflows/sonarqube.yml se ejecuta automáticamente
on:
  pull_request:
    types: [opened, synchronize, reopened]
```

### Paso 4: SonarQube analiza el código
1. **Descarga el código** del PR
2. **Ejecuta análisis estático**:
   - Detecta bugs
   - Encuentra vulnerabilidades de seguridad
   - Identifica code smells
   - Calcula métricas de complejidad
   - Mide cobertura de tests
   - Detecta código duplicado
3. **Evalúa Quality Gate**:
   - ¿Cumple con los estándares mínimos?
   - ¿Hay vulnerabilidades críticas?
   - ¿La cobertura es suficiente?

### Paso 5: SonarQube decora el PR
1. **Usa la GitHub App** para autenticarse
2. **Crea un Check** en el PR con el estado del Quality Gate
3. **Publica comentarios** en líneas específicas con problemas
4. **Actualiza el estado** del commit (✅ passed / ❌ failed)

### Paso 6: Desarrollador revisa y corrige
- Ve los comentarios de SonarQube en el PR
- Corrige los problemas identificados
- Hace push de los cambios
- El ciclo se repite hasta que el Quality Gate pase

### Paso 7: Merge del PR
- Una vez que el Quality Gate pasa y el código es aprobado
- El PR puede ser mergeado a la rama principal
- El código de calidad llega a producción ✅

## 🔐 Autenticación y Seguridad

```
┌─────────────────────────────────────────────────────────────┐
│  GitHub App Authentication Flow                              │
└─────────────────────────────────────────────────────────────┘

1. SonarQube genera JWT usando:
   ┌──────────────────────────────────────┐
   │  - App ID                             │
   │  - Private Key (.pem)                 │
   │  - Timestamp                          │
   └──────────────────────────────────────┘
                 │
                 ▼
2. Intercambia JWT por Installation Access Token:
   ┌──────────────────────────────────────┐
   │  POST /app/installations/:id/tokens  │
   │  Authorization: Bearer <JWT>         │
   └──────────────────────────────────────┘
                 │
                 ▼
3. Usa Access Token para operaciones:
   ┌──────────────────────────────────────┐
   │  - Crear checks                       │
   │  - Comentar en PRs                    │
   │  - Actualizar commit status           │
   │  Authorization: Bearer <AccessToken> │
   └──────────────────────────────────────┘
```

## 📊 Datos que se Comparten

### De GitHub a SonarQube:
- ✅ Código fuente del PR
- ✅ Metadatos del PR (número, branch, autor)
- ✅ Commits incluidos en el PR
- ✅ Archivos modificados

### De SonarQube a GitHub:
- ✅ Estado del Quality Gate (pass/fail)
- ✅ Métricas de calidad
- ✅ Ubicación de problemas (archivo, línea)
- ✅ Descripción de problemas encontrados
- ✅ Sugerencias de corrección

## 🎯 Beneficios de la Integración

1. **Feedback Inmediato**: Los desarrolladores ven problemas antes de merge
2. **Prevención de Bugs**: Se bloquean PRs con problemas críticos
3. **Mejora Continua**: Las métricas se rastrean en cada PR
4. **Revisión Automatizada**: Reduce carga en code reviews manuales
5. **Estándares Consistentes**: Todos los PRs pasan por las mismas reglas

## 🚀 Ejemplo Completo

```bash
# 1. Desarrollador trabaja en una feature
git checkout -b feature/login-social
# ... código ...
git commit -m "feat: agregar login con Google"
git push origin feature/login-social

# 2. Crea PR en GitHub
# (desde la interfaz web)

# 3. GitHub Actions ejecuta análisis automáticamente
# (o ejecutas manualmente: sonar-scanner)

# 4. SonarQube analiza y encuentra:
#    - 2 Code Smells
#    - 0 Bugs
#    - 1 Security Hotspot
#    - 78% Coverage (debajo del umbral de 80%)

# 5. Quality Gate: FAILED ❌

# 6. Desarrollador ve en el PR:
#    "❌ SonarQube Quality Gate failed"
#    "Coverage on New Code is 78% (required ≥ 80%)"

# 7. Desarrollador agrega tests
git add tests/
git commit -m "test: agregar tests para login social"
git push origin feature/login-social

# 8. Nuevo análisis:
#    - Coverage: 85% ✅
#    - Quality Gate: PASSED ✅

# 9. PR puede ser mergeado 🎉
```

## 📝 Notas Importantes

- **Private Key**: Nunca la compartas ni la subas a Git
- **Webhook Secret**: Úsalo para verificar que los webhooks vienen de GitHub
- **Permisos**: La GitHub App solo tiene acceso a lo que le permites
- **Tokens**: Los access tokens expiran automáticamente (1 hora)
- **Rate Limits**: GitHub tiene límites de API, SonarQube los respeta

## 🔗 Referencias

- [GitHub Apps vs OAuth Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps)
- [SonarQube PR Decoration](https://docs.sonarqube.org/latest/analysis/pr-decoration/)
- [GitHub Checks API](https://docs.github.com/en/rest/checks)
