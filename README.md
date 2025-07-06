# n8n Self-Hosted Stack con Ollama y PostgreSQL

Este repositorio proporciona una configuración `docker-compose` completa y lista para producción para autoalojar **n8n**. El stack incluye una base de datos PostgreSQL optimizada para el rendimiento, Redis para el almacenamiento en caché y capacidades de IA locales impulsadas por **Ollama**.

!n8n Logo

## ✨ Características

- **n8n**: La herramienta principal de automatización de flujos de trabajo.
- **PostgreSQL 16**: Base de datos persistente y optimizada para n8n.
- **Redis**: Integrado para el almacenamiento en caché, mejorando el rendimiento de la ejecución de flujos de trabajo.
- **Ollama**: Permite ejecutar Modelos de Lenguaje Grandes (LLMs) de forma local. Preconfigurado para descargar e iniciar el modelo `gemma3:4b`.
- **Seguridad**: Gestión de secretos y configuraciones a través de un archivo `.env`.
- **Backups**: Un servicio bajo demanda para realizar copias de seguridad de la base de datos PostgreSQL.
- **Healthchecks**: Comprobaciones de estado robustas para todos los servicios críticos, asegurando un orden de arranque correcto y estable.

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

Sigue estos pasos para poner en marcha todo el stack.

### Prerrequisitos

- Docker
- Docker Compose (generalmente incluido con Docker Desktop)

### Instalación

1.  **Clona el repositorio:**
    ```bash
    git clone https://github.com/tu-usuario/tu-repositorio.git
    cd tu-repositorio
    ```

2.  **Crea tu archivo de configuración de entorno:**
    Copia el archivo de ejemplo para crear tu propia configuración local.
    ```bash
    cp .env.example .env
    ```

3.  **Edita el archivo `.env`:**
    Abre el archivo `.env` y modifica las variables según tus necesidades. **Es muy importante que cambies `POSTGRES_PASSWORD` por una contraseña segura.**

4.  **(Opcional) Scripts de inicialización de la base de datos:**
    Si tienes scripts `.sql` o `.sh` que deseas ejecutar cuando la base de datos se cree por primera vez, colócalos en el directorio `postgres-init/`.

5.  **Inicia el stack:**
    ```bash
    docker-compose up -d
    ```

6.  **Inicialización de Ollama:**
    La primera vez que inicies el stack, el servicio `ollama-init` descargará el modelo de IA (`gemma3:4b`). Este proceso puede tardar varios minutos dependiendo de tu conexión a internet. Puedes monitorear el progreso con el siguiente comando:
    ```bash
    docker-compose logs -f ollama-init
    ```
    Una vez que veas el mensaje "Modelo descargado correctamente", el servicio se detendrá y todo estará listo.

## ⚙️ Uso

### Acceder a n8n
- **URL**: Abre tu navegador y ve a http://localhost:5678

### Conectar n8n con Ollama
1.  Dentro de n8n, crea un nuevo flujo de trabajo y añade el nodo **Ollama**.
2.  En la configuración del nodo:
    - **Base URL**: `http://ollama:11434`
    - **Model**: `gemma3:4b`

### Realizar un Backup Manual
Para crear una copia de seguridad de tu base de datos PostgreSQL, ejecuta el siguiente comando. El archivo `.sql` se guardará en la carpeta `backups/`.
```bash
docker-compose run --rm postgres-backup
```

### Detener el Stack
Para detener todos los servicios:
```bash
docker-compose down
```

## 📄 Licencia

[!License: MIT](https://opensource.org/licenses/MIT)

Este proyecto está bajo la Licencia MIT.