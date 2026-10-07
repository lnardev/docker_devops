# 🚦 Docker Setup: Traefik Proxy Inverso

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Traefik Proxy](https://img.shields.io/badge/Traefik%20Proxy-%2324A1C1.svg?style=for-the-badge&logo=traefik%20proxy&logoColor=white)
![Let's Encrypt](https://img.shields.io/badge/Let's%20Encrypt-%23003A70.svg?style=for-the-badge&logo=Let's%20Encrypt&logoColor=white)

Este repositorio contiene la infraestructura como código para desplegar **[Traefik v2/v3]** como proxy inverso principal para todos tus proyectos de Docker. Está configurado como una alternativa a Nginx, enfocada en entornos modernos de contenedores donde los servicios nacen y mueren constantemente.

---

## ✨ ¿Por qué Traefik? (Características)

* 🔄 **Descubrimiento Dinámico:** Traefik escucha la API de Docker. Cuando levantas un nuevo contenedor, Traefik lo detecta y crea las rutas automáticamente sin necesidad de recargar o modificar archivos de configuración.
* 🔐 **SSL Automático (Zero-Config):** Integración nativa con Let's Encrypt. Genera y renueva automáticamente certificados HTTPS seguros para todos tus subdominios.
* 📊 **Dashboard Integrado:** Interfaz gráfica nativa para monitorear el estado de tus rutas, servicios y middlewares en tiempo real.
* 🌐 **Red Compartida:** Permite alojar múltiples aplicaciones (Frontend, Backend, Bases de datos, etc.) en un solo servidor usando diferentes dominios.

---

## 📋 Requisitos Previos

Asegúrate de tener un servidor (o máquina local) con:
* [Docker](https://docs.docker.com/get-docker/) y [Docker Compose](https://docs.docker.com/compose/install/) instalados.
* Los puertos `80` (HTTP) y `443` (HTTPS) abiertos en el firewall de tu servidor.
* Un nombre de dominio apuntando a la IP de tu servidor (Registro A).

---

## 🚀 Cómo levantar el Proxy

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/tu-usuario/docker_traefik.git](https://github.com/tu-usuario/docker_traefik.git)
   cd docker_traefik


