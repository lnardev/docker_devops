# 🐳 DevOps All-in-One: BookStack & Monitoring Stack

Este repositorio contiene una solución completa desplegada con **Docker Compose** que integra dos ecosistemas esenciales:
1.  **Documentación Corporativa:** BookStack (Wiki) + MySQL.
2.  **Observabilidad Completa:** Prometheus, Grafana, Alertmanager y Node Exporter.

---

## 📂 Estructura del Proyecto

El despliegue requiere los siguientes 4 archivos en el directorio raíz:

```text
.
├── docker-compose.yml      # Orquestación de servicios
├── prometheus.yml          # Configuración de métricas
├── alert_rules.yml         # Reglas de alertas (Disco > 80%)
└── alertmanager.yml        # Configuración de notificaciones (Email)
```



## ⚙️ Configuración de Archivos
Crea los siguientes archivos con el contenido detallado a continuación:

1. docker-compose.yml

```yaml
version: "3.8"

services:
  # --- DOCUMENTACIÓN (BookStack) ---
  db:
    image: mysql:8.0
    container_name: db
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=cloud_db
      - MYSQL_USER=leonardo.pernett
      - MYSQL_PASSWORD="Konecta2024**"
    volumes:
      - db_data:/var/lib/mysql
    command: --default-authentication-plugin=mysql_native_password

  bookstack:
    image: linuxserver/bookstack
    container_name: bookstack
    environment:
      - PUID=1000
      - PGID=1000
      - APP_URL=http://localhost:6875
      - APP_KEY=base64:U7yK/S+Wq1g8qYJ9qK5xP9/aL7j1sM3nO8pP1rT5k7I= 
      - DB_HOST=db
      - DB_PORT=3306
      - DB_USER=leonardo.pernett
      - DB_PASS="Konecta2024**"
      - DB_DATABASE=cloud_db
    volumes:
      - ./bookstack_data:/config
    ports:
      - "6875:80"
    restart: unless-stopped
    depends_on:
      - db

  # --- MONITOREO (Prometheus Stack) ---
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    restart: unless-stopped
    depends_on:
      - prometheus

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./alert_rules.yml:/etc/prometheus/alert_rules.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    restart: unless-stopped
    depends_on:
      - alertmanager

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
    restart: unless-stopped

volumes:
  db_data:
    driver: local
  bookstack_data:
  grafana_data:
  prometheus_data:

  ```

  2. prometheus.yml

  ```yaml
   global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "alert_rules.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'mi-servidor'
    static_configs:
      - targets: ['node-exporter:9100']
      # Agregar aquí IPs remotas:
      # - targets: ['192.168.1.50:9100']
  
  ```

  3. alert_rules.yml
 
  ```yaml
  groups:
  - name: alertas-servidor
    rules:
      - alert: DiscoLleno
        # Alerta si el disco supera el 80%
        expr: 100 - ((node_filesystem_avail_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"}) > 80
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Disco casi lleno en el servidor"
          # Sintaxis corregida para Go Templates
          description: 'El uso del disco ha superado el 80%. Valor actual: {{ $value | printf "%.2f" }}%'

  ```

  Aquí tienes el archivo README.md completo y listo. Contiene absolutamente toda la configuración (Docker Compose, Prometheus, Alertas) y los IDs de los dashboards en un solo bloque de texto.

Solo tienes que copiar el siguiente código y guardarlo como README.md en tu repositorio.

Markdown

# 🐳 DevOps All-in-One: BookStack & Monitoring Stack

Este repositorio contiene una solución completa desplegada con **Docker Compose** que integra dos ecosistemas esenciales:
1.  **Documentación Corporativa:** BookStack (Wiki) + MySQL.
2.  **Observabilidad Completa:** Prometheus, Grafana, Alertmanager y Node Exporter.

---

## 📂 Estructura del Proyecto

El despliegue requiere los siguientes 4 archivos en el directorio raíz:

```text
.
├── docker-compose.yml      # Orquestación de servicios
├── prometheus.yml          # Configuración de métricas
├── alert_rules.yml         # Reglas de alertas (Disco > 80%)
└── alertmanager.yml        # Configuración de notificaciones (Email)

  ```
🚀 Despliegue
### Permisos: Asegura que Prometheus pueda leer las configuraciones.

Bash `chmod 644 prometheus.yml alert_rules.yml alertmanager.yml`
### Iniciar Servicios
docker-compose up -d

## 📊 Dashboards de Grafana (IDs)

12486	Node Exporter Full (Fork)	⭐ Mejor opción. Limpio, moderno y detallado.
1860	Node Exporter Full	El clásico estándar.
405	Node Exporter Server Metrics	Ideal para monitorear múltiples servidores a la vez.
11074	Node Exporter Dashboard EN	Minimalista y fácil de leer.
10180	Linux Hosts Metrics Base	Visual, tipo "Gamer/Ejecutivo" con relojes.
15172	Node Exporter Full (Net/Disk)	Diagnóstico profundo de red y discos.
  
