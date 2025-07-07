# n8n Self-Hosted Stack con Ollama, Qdrant y PostgreSQL

Este repositorio proporciona una configuración `docker-compose` completa y lista para producción para autoalojar **n8n**. El stack incluye una base de datos PostgreSQL optimizada, Redis para caché, capacidades de IA locales con **Ollama** y una base de datos vectorial **Qdrant** para flujos de trabajo de RAG.

!n8n Logo

## ✨ Características

- **n8n**: La herramienta principal de automatización de flujos de trabajo.
- **PostgreSQL 16**: Base de datos persistente y optimizada para n8n.
- **Redis**: Integrado para el almacenamiento en caché, mejorando el rendimiento.
- **Ollama**: Permite ejecutar Modelos de Lenguaje Grandes (LLMs) de forma local. Preconfigurado para descargar el modelo `gemma3:4b`.
- **Qdrant**: Base de datos vectorial para almacenar y consultar embeddings, ideal para casos de uso de RAG (Retrieval-Augmented Generation).
- **Seguridad**: Gestión de secretos y configuraciones a través de un archivo `.env`.
- **Backups**: Un servicio bajo demanda para realizar copias de seguridad de la base de datos PostgreSQL.
- **Healthchecks**: Comprobaciones de estado robustas para todos los servicios críticos.

## 📂 Estructura del Proyecto
```
.
├── backups/
│   └── .gitkeep
├── postgres-init/
│   └── .gitkeep
├── .env.example
├── .gitignore
├── docker-compose.yaml
└── README.md
```

## 🚀 Cómo Empezar

### Prerrequisitos
- Docker
- Docker Compose

### Instalación
1.  **Clona el repositorio:**
    ```bash
    git clone https://github.com/tu-usuario/tu-repositorio.git
    cd tu-repositorio
    ```
2.  **Crea tu archivo de entorno:**
    ```bash
    cp .env.example .env
    ```
3.  **Edita el archivo `.env`:**
    Abre `.env` y modifica las variables. **Es muy importante que cambies `POSTGRES_PASSWORD` y, opcionalmente, definas una `QDRANT_API_KEY` segura.**

4.  **Inicia el stack:**
    ```bash
    docker-compose up -d
    ```
5.  **Inicialización de Ollama:**
    La primera vez que inicies el stack, el servicio `ollama-init` descargará el modelo de IA. Puedes monitorear el progreso con:
    ```bash
    docker-compose logs -f ollama-init
    ```
    Una vez que el modelo se haya descargado, el servicio se detendrá.

## ⚙️ Uso

### Acceder a los Servicios
- **n8n**: http://localhost:5678
- **Qdrant UI**: http://localhost:6333/dashboard

### Conectar n8n con los Servicios de IA

#### Ollama
1.  En un flujo de n8n, añade el nodo **Ollama**.
2.  Configúralo con:
    - **Base URL**: `http://ollama:11434`
    - **Model**: `gemma3:4b`

#### Qdrant
1.  Añade el nodo **Qdrant** a tu flujo de trabajo.
2.  En la configuración de las credenciales:
    - **Host**: `qdrant`
    - **Port**: `6333`
    - **API Key**: La clave que definiste en tu archivo `.env` para `QDRANT_API_KEY`.

### Realizar un Backup Manual
Para crear una copia de seguridad de tu base de datos PostgreSQL, ejecuta:
```bash
docker-compose run --rm postgres-backup
```
El archivo `.sql` se guardará en la carpeta `backups/`.

### Detener el Stack
```bash
docker-compose down
```

## 📄 Licencia
[!License: MIT](https://opensource.org/licenses/MIT)

Este proyecto está bajo la Licencia MIT.
