# 🐳 Docker Setup: Excalidraw (Self-Hosted)

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/docker%20compose-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white)
![React](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB)

Este repositorio contiene la infraestructura como código (usando Docker Compose) para desplegar una instancia privada de **[Excalidraw](https://excalidraw.com/)**. Ideal para equipos de desarrollo y arquitectura que necesitan una pizarra virtual de estilo "dibujado a mano" asegurando que los datos no salgan de su propia red.

---

## ✨ Características de este despliegue

* 🔒 **Privacidad Total (Self-Hosted):** Todos tus diagramas de arquitectura, esquemas de bases de datos y bocetos de UI se mantienen dentro de tu propio servidor.
* 🚀 **Despliegue Rápido:** Listo para correr en menos de un minuto usando Docker Compose.
* ⚡ **Ligero y Rápido:** La interfaz gráfica (Frontend) se sirve de manera eficiente.
* 👥 **Colaboración (Opcional):** Preparado para integrarse con el servidor de salas (Room Server) si se requiere trabajar de forma síncrona con otros miembros del equipo.

---

## 📋 Requisitos Previos

Asegúrate de tener instalado en tu servidor o máquina local:
* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

---

## 🚀 Cómo usar este repositorio

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/tu-usuario/docker_excalidraw.git](https://github.com/tu-usuario/docker_excalidraw.git)
   cd docker_excalidraw
