# DetectIAPerson

Automatización de detección de personas usando YOLOv5 a través de Telegram. Este proyecto permite la identificación eficiente en videos o cámaras en vivo, enviando alertas instantáneas mediante un bot de Telegram. Ideal para aplicaciones de seguridad y monitoreo remoto.

## Descripción

Este script automatiza la grabación de video, la detección de personas utilizando YOLOv5, y el envío de notificaciones con los resultados a través de Telegram. Es ideal para aplicaciones de monitoreo en tiempo real y sistemas de seguridad que requieren alertas instantáneas cuando se detecta una persona en la escena.

## Requisitos

- Python 3.x
- ffmpeg
- YOLOv5 (para la detección de objetos)
- curl (para enviar solicitudes a la API de Telegram)
- Una cuenta y un bot de Telegram

## Instalación

1. **Clonar el repositorio:**

    ```bash
    git clone https://github.com/FalconAkantor/DetectIAPerson.git
    cd DetectIAPerson
    ```

2. **Instalar las dependencias necesarias:**

    ```bash
    pip install -r requirements.txt
    ```

3. **Instalar los paquetes necesarios con el script de instalación:**

    ```bash
    ./instalacion.sh
    ```

4. **Configurar ffmpeg:**

    Asegúrate de que `ffmpeg` esté instalado y accesible en tu sistema. Puedes instalarlo utilizando el administrador de paquetes de tu sistema operativo.

## Configuración

Antes de ejecutar el script, asegúrate de configurar los siguientes valores en el archivo `analisis.sh`:

- `TOKEN`: El token de tu bot de Telegram.
- `CHAT_ID`: El ID del chat donde se enviarán las notificaciones.
- `VIDEO_URL`: La URL del stream de video que deseas monitorear.
- `OUTPUT_FILE`: La ruta donde se guardarán los videos grabados.
- `LOG_FILE`: La ruta donde se guardarán los logs de ejecución.
- `runs_dir`: Directorio donde se almacenarán los resultados de las detecciones.

## Uso

Ejecuta el script desde la línea de comandos:

```bash
./analisis.sh

