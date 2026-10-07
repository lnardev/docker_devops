# ⚡ Docker Setup: Redis

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/docker%20compose-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white)
![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)

Este repositorio proporciona una configuración limpia y lista para usar de **[Redis](https://redis.io/)** utilizando Docker Compose. Diseñado para integrarse fácilmente en arquitecturas de microservicios o aplicaciones monolíticas que requieren alta velocidad de lectura/escritura.

---

## ✨ Casos de Uso Comunes

* **Caché de Consultas:** Reduce la carga de tu base de datos principal (PostgreSQL, MySQL) almacenando en memoria los resultados frecuentes.
* **Gestión de Sesiones:** Ideal para almacenar tokens y datos de sesión de usuarios de forma centralizada y extremadamente rápida.
* **Colas de Tareas (Pub/Sub):** Excelente herramienta para manejar trabajos en segundo plano (background jobs) y comunicación entre servicios.

---

## 📋 Requisitos Previos

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

---

## 🚀 Cómo levantar el contenedor

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/tu-usuario/docker_redis.git](https://github.com/tu-usuario/docker_redis.git)
   cd docker_redis
