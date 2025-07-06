# Guía para Restaurar un Backup de la Base de Datos de n8n

Este documento describe los pasos necesarios para restaurar la base de datos de n8n desde un archivo de backup previamente generado. Sigue estos pasos cuidadosamente para asegurar una restauración exitosa.

## Prerrequisitos

- Tener Docker y Docker Compose instalados.
- Estar en el directorio raíz del proyecto donde se encuentra tu archivo `docker-compose.yml`.
- Tener un archivo de backup válido en el volumen de backups (usualmente en una carpeta `backups/` dentro del proyecto).

---

### Paso 1: Detener el servicio de n8n

Antes de restaurar la base de datos, es crucial detener el contenedor de n8n para evitar que intente conectarse a la base de datos mientras la estamos modificando. Esto previene inconsistencias en los datos.

Ejecuta el siguiente comando en tu terminal:

```bash
docker-compose stop n8n
```

---

### Paso 2: Ejecutar el script de restauración

Este comando iniciará un contenedor temporal que te guiará en el proceso de restauración. El script realizará las siguientes acciones de forma interactiva:
1.  Listará los archivos de backup disponibles en el directorio `/backups/`.
2.  Te pedirá que ingreses el nombre del archivo que deseas restaurar.
3.  Eliminará la base de datos actual.
4.  Creará una nueva base de datos vacía con el mismo nombre.
5.  Restaurará los datos desde el archivo de backup que seleccionaste.

Copia y ejecuta el siguiente comando. Cuando se te solicite, **copia y pega el nombre completo del archivo de backup** que deseas usar y presiona Enter.

```bash
docker-compose run --rm postgres-backup sh -c "
  echo 'Listando backups disponibles:' &&
  ls -la /backups/ &&
  echo 'Ingresa el nombre del archivo de backup (ej: n8n_backup_20241201_143000.sql):' &&
  read BACKUP_FILE &&
  echo 'Eliminando base de datos existente...' &&
  dropdb -h postgres -U ${POSTGRES_USER} ${POSTGRES_DB} &&
  echo 'Creando nueva base de datos...' &&
  createdb -h postgres -U ${POSTGRES_USER} ${POSTGRES_DB} &&
  echo 'Restaurando desde backup...' &&
  psql -h postgres -U ${POSTGRES_USER} -d ${POSTGRES_DB} < /backups/\$BACKUP_FILE &&
  echo 'Restauración completada exitosamente'
"
```

---

### Paso 3: Iniciar el servicio de n8n

Una vez que la base de datos ha sido restaurada exitosamente, puedes volver a iniciar el servicio de n8n para que utilice los datos recién restaurados.

```bash
docker-compose start n8n
```

---

## Verificación

Después de iniciar el servicio, espera uno o dos minutos y luego accede a tu instancia de n8n a través del navegador. Verifica que tus flujos de trabajo (workflows), credenciales y ejecuciones (según la data del backup) estén presentes. Si todo se ve como esperabas, ¡la restauración fue un éxito!