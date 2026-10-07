# Docker Images — Stack VPS

Colección de servicios Docker Compose que uso en mi VPS. Cada carpeta es independiente: tiene su propio `docker-compose.yml` (y `.env` cuando aplica) y se levanta por separado.

La red externa `db_net` la comparten Postgres y GlitchTip. La red externa `web` la usa Traefik como entrypoint para el resto de aplicaciones.

## Servicios

| Carpeta | Servicio | Imagen | Puerto host |
|---|---|---|---|
| `traefik` | Proxy inverso + apps demo | traefik:v3.5 | 80, 443, 8080 |
| `postgres` | Base de datos compartida | postgres:16-alpine | interno |
| `redis` | Caché | bitnami/redis:7.0.10 | 6381 |
| `grafana_prometheus` | Observabilidad | grafana, prometheus, alertmanager, node-exporter | 3000, 9090, 9093, 9100 |
| `uptime-kuma` | Monitoreo de uptime | louislam/uptime-kuma:2 | 3002 |
| `beszel` | Monitoreo de recursos | henrygd/beszel | 9000 |
| `glitchtip` | Error tracking (Sentry alternativo) | glitchtip/glitchtip:6 | 8000 |
| `umami` | Analítica web | ghcr.io/umami-software/umami | 3000 |
| `langfuse` | Observabilidad LLM | langfuse (stack completo) | varios |
| `sonarqube` | Calidad de código | sonarqube:community | 9000 |
| `jenkins` | CI/CD | jenkins/jenkins:lts-jdk21 | 8080 |
| `bootstack` | Wiki/documentación (BookStack) | lscr.io/linuxserver/bookstack | 6875 |
| `excalidraw` | Pizarra/diagramas | excalidraw/excalidraw | 8080 |

## Arranque

Cada stack se levanta desde su carpeta:

```bash
cd <carpeta>
docker compose up -d
```

Detener y borrar contenedores:

```bash
docker compose down
```

## Configuración previa

Antes de levantar un stack, revisa su `.env` o `.env.example`:

- `traefik`: define `MYSQL_*` para el servicio MySQL. La red `web` debe existir.
- `redis`: `REDIS_PASSWORD`, `REDIS_PORT`, `REDIS_CONTAINER_NAME`, `ALLOW_EMPTY_PASSWORD`.
- `glitchtip`: `DATABASE_URL`, `SECRET_KEY`, `GLITCHTIP_DOMAIN`, `EMAIL_URL`. Necesita la red externa `db_net` y un Postgres corriendo.
- `umami`: `DATABASE_URL`, `APP_SECRET`, `TWO_FACTOR_ENCRYPTION_KEY`.
- `postgres`: crea la red compartida antes de arrancar:

```bash
docker network create db_net
```

## Notas

- Varias credenciales de ejemplo (`admin/admin`, contraseñas `password`) están hardcodeadas en los compose. Cámbialas antes de exponer estos servicios en internet.
- Los servicios que corren detrás de Traefik no necesitan publicar puertos; se enrutan por labels y nombre de host.
- `beszel` incluye un agente con `network_mode: host` para leer métricas del sistema y el socket de Docker.
- `langfuse`, `umami`, `sonarqube` y otros incluyen el código fuente clonado del proyecto. Solo se requiere el `docker-compose.yml` para desplegar el stack.

## Estructura

```text
docker images/
├── traefik/             # Proxy inverso y demo apps
├── postgres/            # Postgres compartido
├── redis/               # Caché Redis
├── grafana_prometheus/  # Métricas y alertas
├── uptime-kuma/         # Monitoreo de uptime
├── beszel/              # Monitoreo de recursos
├── glitchtip/           # Error tracking
├── umami/               # Analítica
├── langfuse/            # Observabilidad LLM
├── sonarqube/           # Calidad de código
├── jenkins/             # CI/CD
├── bootstack/           # Wiki
└── excalidraw/          # Diagramas
```
