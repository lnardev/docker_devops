# 🔗 Configuración de GitHub App para SonarQube

Esta guía te ayudará a configurar una GitHub App para habilitar **Pull Request Decoration** en SonarQube, lo que te permite ver los resultados del análisis directamente en tus Pull Requests.

## 📚 Índice

1. [Crear GitHub App](#1-crear-github-app)
2. [Configurar Permisos](#2-configurar-permisos)
3. [Generar Credenciales](#3-generar-credenciales)
4. [Configurar en SonarQube](#4-configurar-en-sonarqube)
5. [Instalar la App en tu Repositorio](#5-instalar-la-app-en-tu-repositorio)
6. [Verificar Configuración](#6-verificar-configuración)

---

## 1️⃣ Crear GitHub App

### Paso 1.1: Acceder a GitHub Developer Settings

1. Ve a GitHub y haz clic en tu foto de perfil (esquina superior derecha)
2. Selecciona **Settings**
3. En el menú lateral izquierdo, baja hasta **Developer settings**
4. Haz clic en **GitHub Apps**
5. Haz clic en **New GitHub App**

### Paso 1.2: Configuración Básica

Completa el formulario con la siguiente información:

| Campo | Valor |
|-------|-------|
| **GitHub App name** | `SonarQube DevOps` (o el nombre que prefieras, debe ser único) |
| **Homepage URL** | `http://localhost:9000` (o tu URL de SonarQube) |
| **Webhook URL** | `http://localhost:9000/api/alm_integration/github/webhook` |
| **Webhook secret** | Genera uno con: `openssl rand -hex 32` (guárdalo) |

**⚠️ Importante:** Si SonarQube está en localhost, GitHub no podrá enviar webhooks. Para desarrollo local, puedes:
- Dejar el webhook deshabilitado (desmarca "Active")
- O usar un túnel como ngrok (ver sección avanzada al final)

---

## 2️⃣ Configurar Permisos

### Permisos de Repositorio (Repository permissions)

Configura los siguientes permisos:

| Permiso | Nivel de Acceso |
|---------|----------------|
| **Checks** | Read & write |
| **Commit statuses** | Read & write |
| **Contents** | Read-only |
| **Issues** | Read & write |
| **Metadata** | Read-only (automático) |
| **Pull requests** | Read & write |

### Permisos de Organización (Organization permissions)

| Permiso | Nivel de Acceso |
|---------|----------------|
| **Members** | Read-only |
| **Projects** | Read-only |

### Suscripciones a Eventos (Subscribe to events)

Marca las siguientes casillas:

- ✅ **Pull request**
- ✅ **Push**

### Where can this GitHub App be installed?

Selecciona:
- 🔘 **Any account** (si quieres usarla en múltiples organizaciones)
- 🔘 **Only on this account** (si solo la usarás en tu cuenta)

### Paso 2.3: Crear la App

Haz clic en **Create GitHub App** al final de la página.

---

## 3️⃣ Generar Credenciales

Después de crear la app, serás redirigido a la página de configuración. Ahora necesitas obtener las credenciales:

### 3.1: Obtener App ID

En la página de tu GitHub App, encontrarás:

```
App ID: 123456
```

**📝 Copia este número**, lo necesitarás para SonarQube.

### 3.2: Obtener Client ID

En la misma página, busca:

```
Client ID: Iv1.a1b2c3d4e5f6g7h8
```

**📝 Copia este valor**.

### 3.3: Generar Client Secret

1. En la sección **Client secrets**, haz clic en **Generate a new client secret**
2. **📝 Copia el secret inmediatamente** (solo se muestra una vez)
3. Guárdalo en un lugar seguro

### 3.4: Generar Private Key

1. Baja hasta la sección **Private keys**
2. Haz clic en **Generate a private key**
3. Se descargará un archivo `.pem` (por ejemplo: `sonarqube-devops.2026-01-24.private-key.pem`)
4. **📝 Guarda este archivo en un lugar seguro**

---

## 4️⃣ Configurar en SonarQube

### Paso 4.1: Acceder a la Configuración

1. Abre SonarQube: http://localhost:9000
2. Inicia sesión como **admin**
3. Ve a **Administration** (icono de engranaje arriba a la derecha)
4. En el menú lateral, selecciona **Configuration** → **General Settings**
5. Busca la pestaña **ALM Integrations**
6. Selecciona **GitHub**

### Paso 4.2: Crear Nueva Configuración

Haz clic en **Create configuration** y completa los campos:

#### **Configuration name***
```
devops
```
*Nombre descriptivo para identificar esta configuración*

#### **GitHub API URL***

**Si usas GitHub.com:**
```
https://api.github.com/
```

**Si usas GitHub Enterprise:**
```
https://github.tuempresa.com/api/v3
```

#### **GitHub App ID***
```
123456
```
*El App ID que copiaste en el paso 3.1*

#### **Client ID***
```
Iv1.a1b2c3d4e5f6g7h8
```
*El Client ID que copiaste en el paso 3.2*

#### **Client Secret***
```
[El secret que generaste en el paso 3.3]
```

#### **Private Key***

Abre el archivo `.pem` que descargaste y copia **TODO** su contenido:

```bash
# En tu terminal, ejecuta:
cat ~/Downloads/sonarqube-devops.*.private-key.pem
```

Copia la salida completa, incluyendo las líneas:
```
-----BEGIN RSA PRIVATE KEY-----
[contenido de la clave]
-----END RSA PRIVATE KEY-----
```

Pega todo esto en el campo **Private Key**.

#### **Webhook Secret** (Opcional)

Si configuraste un webhook secret en el paso 1.2, pégalo aquí. Si no, déjalo vacío.

### Paso 4.3: Guardar Configuración

Haz clic en **Save** o **Create**.

---

## 5️⃣ Instalar la App en tu Repositorio

### Paso 5.1: Instalar la GitHub App

1. Ve a GitHub → Settings → Developer settings → GitHub Apps
2. Haz clic en tu app **SonarQube DevOps**
3. En el menú lateral, haz clic en **Install App**
4. Selecciona tu cuenta u organización
5. Elige:
   - **All repositories** (todas las repos)
   - **Only select repositories** (solo algunas repos específicas)
6. Haz clic en **Install**

### Paso 5.2: Configurar el Proyecto en SonarQube

1. En SonarQube, ve a tu proyecto
2. Ve a **Project Settings** → **General Settings** → **Pull Request Decoration**
3. Selecciona la configuración **devops** que creaste
4. Ingresa el nombre de tu repositorio en formato: `usuario/repositorio` o `organizacion/repositorio`

Ejemplo:
```
leonardo/mi-proyecto-react
```

5. Haz clic en **Save**

---

## 6️⃣ Verificar Configuración

### Prueba la Integración

1. Crea un nuevo branch en tu repositorio:
```bash
git checkout -b test-sonarqube
```

2. Haz un cambio pequeño y commitea:
```bash
echo "// Test" >> README.md
git add README.md
git commit -m "Test SonarQube integration"
git push origin test-sonarqube
```

3. Crea un Pull Request en GitHub

4. Ejecuta el análisis de SonarQube:
```bash
sonar-scanner
```

5. Ve al Pull Request en GitHub y deberías ver:
   - ✅ Un check de SonarQube
   - 💬 Comentarios con los resultados del análisis
   - 📊 Métricas de calidad de código

---

## 🔧 Solución de Problemas

### Error: "GitHub App configuration is invalid"

**Causa:** Las credenciales no son correctas.

**Solución:**
1. Verifica que el App ID, Client ID y Client Secret sean correctos
2. Asegúrate de copiar la Private Key completa (incluyendo BEGIN y END)
3. Verifica que la GitHub API URL sea correcta

### Error: "Could not create Github check"

**Causa:** Permisos insuficientes.

**Solución:**
1. Ve a tu GitHub App
2. Verifica que tenga permisos de **Checks: Read & write**
3. Reinstala la app en tu repositorio

### No aparecen comentarios en el PR

**Causa:** La configuración del proyecto no está completa.

**Solución:**
1. Ve a Project Settings → Pull Request Decoration
2. Verifica que el nombre del repositorio sea correcto
3. Asegúrate de que el formato sea `usuario/repo` o `org/repo`

### Webhook no funciona (localhost)

**Causa:** GitHub no puede enviar webhooks a localhost.

**Solución temporal:**
```bash
# Instala ngrok
brew install ngrok

# Expón tu SonarQube
ngrok http 9000

# Usa la URL de ngrok en la configuración de la GitHub App
# Ejemplo: https://abc123.ngrok.io
```

**Solución permanente:**
- Despliega SonarQube en un servidor con IP pública
- Usa un servicio como AWS, DigitalOcean, o Heroku

---

## 📝 Resumen de Credenciales

Guarda esta información en un lugar seguro:

```yaml
GitHub App Configuration:
  App Name: SonarQube DevOps
  App ID: [tu-app-id]
  Client ID: [tu-client-id]
  Client Secret: [tu-client-secret]
  Private Key: [guardada en archivo .pem]
  Webhook Secret: [tu-webhook-secret]

SonarQube Configuration:
  Configuration Name: devops
  GitHub API URL: https://api.github.com/
```

---

## 🎯 Próximos Pasos

Una vez configurado, cada vez que:
1. Crees un Pull Request
2. Hagas push a un branch con PR abierto
3. Ejecutes el análisis de SonarQube

Verás automáticamente:
- ✅ Estado del Quality Gate
- 🐛 Bugs encontrados
- 🔒 Vulnerabilidades
- 💩 Code smells
- 📊 Cobertura de código

Todo directamente en tu Pull Request de GitHub! 🎉

---

## 📚 Referencias

- [Documentación oficial de SonarQube](https://docs.sonarqube.org/latest/analysis/github-integration/)
- [GitHub Apps Documentation](https://docs.github.com/en/developers/apps)
- [Pull Request Decoration](https://docs.sonarqube.org/latest/analysis/pr-decoration/)

---

## 🆘 ¿Necesitas Ayuda?

Si tienes problemas, revisa:
1. Los logs de SonarQube: `docker-compose logs -f sonarqube`
2. La configuración de la GitHub App en GitHub
3. Los permisos de la app instalada en tu repositorio
