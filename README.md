# DetectIAPerson

Automatización de detección de personas usando YOLOv5 a través de Telegram. Este proyecto permite la identificación eficiente en videos o cámaras, enviando alertas instantáneas mediante un bot de Telegram. Ideal para aplicaciones de seguridad y monitoreo remoto.

## Descripción

Este script automatiza la grabación de video, la detección de personas utilizando YOLOv5, y el envío de notificaciones con los resultados a través de Telegram.

## Canal de Telegram con video de explicación por si hace falta.

Canal con video: https://t.me/+WLErr9YRy5EyYzM0

Para cualquier duda o sugerencia, por favor contacta conmigo en FalconAkantor en Telegram. (https://t.me/FalconAkantor)

## Requisitos

- **Python 3.x:** Necesario para ejecutar los scripts.
- **ffmpeg:** Utilizado para la grabación y procesamiento de video.
- **YOLOv5:** Modelo de detección de objetos utilizado para identificar personas.
- **curl:** Herramienta de línea de comandos para realizar solicitudes a la API de Telegram.
- **Una cuenta y un bot de Telegram:** Necesarios para enviar notificaciones.
- Cualquier camara IP que tengais por casa yo uso una Tapo C200.
- **DroidCam (Opcional):** Si deseas utilizar la cámara de tu móvil como fuente de video.

### Uso de DroidCam para la Fuente de Video

DroidCam es una aplicación que te permite usar la cámara de tu móvil como una cámara web en tu ordenador. Es compatible con dispositivos Android e iOS y puede ser una opción conveniente si no tienes una cámara web dedicada.

#### Pasos para configurar DroidCam:

1. **Instalar DroidCam en tu móvil:**
   - Descarga e instala la aplicación DroidCam desde la [Google Play Store](https://play.google.com/store/apps/details?id=com.dev47apps.droidcam) o la [Apple App Store](https://apps.apple.com/us/app/droidcam-wireless-webcam/id1510258102).

2. **Instalar el cliente DroidCam en tu ordenador:**
   - Visita el [sitio web de DroidCam](https://www.dev47apps.com/droidcam/) y descarga el cliente para tu sistema operativo (Windows/Linux).

3. **Conectar el móvil al ordenador:**
   - Abre la aplicación DroidCam en tu móvil.
   - En la aplicación del móvil, verás una IP y un puerto (e.g., `192.168.1.100:4747`). Estos serán necesarios para el siguiente paso.

4. **Configurar el script para usar DroidCam:**
   - Una vez que tu móvil esté transmitiendo video, puedes configurar el script `analisis.sh` para usar la transmisión de DroidCam como fuente de video.
   - Reemplaza `VIDEO_URL` en el script con la URL de DroidCam. Normalmente, esta URL tendrá el siguiente formato:
     ```bash
     VIDEO_URL="http://192.168.1.100:4747/video?640x480"
     ```
     Donde ?640x480 es la relación de calidad se puede poner hasta la que permita tu camara, pero con la que he puesto es más
     que suficiente, si no quereis que ocupe mucho el video.
     
   - Asegúrate de reemplazar `192.168.1.100:4747` con la IP y el puerto que se muestran en la aplicación DroidCam de tu móvil.

5. **Probar la conexión:**
   - Puedes probar si la conexión funciona abriendo la URL en un navegador de tu ordenador o mediante `ffmpeg` para ver si se está transmitiendo video correctamente.

#### Ventajas de Usar DroidCam:

- **Portabilidad:** Puedes colocar tu móvil en cualquier lugar que desees monitorear sin necesidad de cables adicionales.
- **Calidad:** Las cámaras de los móviles suelen ofrecer mejor calidad que muchas cámaras web convencionales.
- **Configuración rápida:** No requiere hardware adicional y es fácil de configurar.


## Instalación

1. **Clonar el repositorio:**

    ```bash
    git clone https://github.com/FalconAkantor/DetectIAPerson.git
    cd DetectIAPerson
    ```

2. **Instalar los paquetes necesarios con el script de instalación:**
    ```bash
    chmod 777 install.sh
    ./install.sh
    ```
  
3. **Instalar las dependencias necesarias:**

  ```bash
    pip install -r requirements.txt
   ```

Comprobamos con el comando de abajo que el funcionamiento es el correcto.

 ```bash
 python3 detect.py --source data/images/zidane.jpg --weights yolov5s.pt --conf-thres 0.4 --save-txt --save-crop --project results --name detection_output
 ```

## Configuración

Antes de ejecutar el script, asegúrate de configurar los siguientes valores en el archivo `analisis.sh`:

- `TOKEN`: El token de tu bot de Telegram.
- `CHAT_ID`: El ID del chat donde se enviarán las notificaciones.
- `VIDEO_URL`: La URL del stream de video que deseas monitorear.
- `OUTPUT_DIR="/ruta/de/salida"` a la ruta absoluta donde se encuentra la carpeta `DetectIAPerson`: ejemplo `OUTPUT_DIR="/home/usuario/DetectIAPerson"`
- `default_duration_minutes=300` Aquí por defecto puse 5 horas por necesidades mias con ponerlo en una tarea de cron pero podeis cambiarlo al gusto.

## Uso

Ejecuta el script desde la línea de comandos:

```bash
./analisis.sh
```

## SCRIPT DETECCIÓN

```bash
#!/bin/bash

# Configuración de Telegram
TOKEN=""
CHAT_ID=""
URL="https://api.telegram.org/bot$TOKEN/sendVideo"
MESSAGE_URL="https://api.telegram.org/bot$TOKEN/sendMessage"
PHOTO_URL="https://api.telegram.org/bot$TOKEN/sendPhoto"
DOCUMENT_URL="https://api.telegram.org/bot$TOKEN/sendDocument"

# Ruta de salida
OUTPUT_DIR="/ruta/de/salida"

# URL del video de origen para grabar (modifica según tu fuente de video)
VIDEO_URL="rtsp://usuario:contraseña@IP:PUERTO/stream1"

# Duración predeterminada de grabación en minutos si no se especifica
default_duration_minutes=300

# Número de fotogramas por segundo
FPS=0.5  # Esto significa 1 fotograma cada 2 segundos

# Bitrate objetivo para la compresión
BITRATE="500k"

# Nombre del archivo de salida con marca de tiempo
VIDEO_TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
OUTPUT_FILE="$OUTPUT_DIR/video_$VIDEO_TIMESTAMP.mp4"
LOG_FILE="$OUTPUT_DIR/detection.log"

# Función para enviar mensaje a Telegram
send_message() {
    local message=$1
    curl -s -F chat_id="$CHAT_ID" -F text="$message" "$MESSAGE_URL"
}

# Función para enviar mensaje de error a Telegram
send_error_message() {
    local message=$1
    echo "$message" | tee -a "$LOG_FILE" 2>&1
    curl -s -F chat_id="$CHAT_ID" -F text="$message" "$MESSAGE_URL"
}

# Limpiar el archivo de log al inicio del script
> "$LOG_FILE"

# Redirigir toda la salida y errores al log
exec > >(tee -a "$LOG_FILE") 2>&1

# Verificar y eliminar directorios exp2 a exp9 si existe exp9
runs_dir="$OUTPUT_DIR/runs/detect"
if [ -d "$runs_dir/exp9" ]; then
    echo "Directorio exp9 encontrado. Eliminando exp2 a exp9..."
    for i in {2..9}; do
        if [ -d "$runs_dir/exp$i" ]; then
            rm -r "$runs_dir/exp$i"
            echo "Eliminado $runs_dir/exp$i"
        fi
    done
else
    echo "exp9 no existe. No se eliminarán directorios."
fi

# Grabar video durante la duración especificada en minutos y comprimir
echo "Grabando y comprimiendo video durante $default_duration_minutes minutos..."
ffmpeg -nostdin -hide_banner -loglevel error -i "$VIDEO_URL" -t "$((default_duration_minutes * 60))" \
-vf "fps=$FPS,scale=640:-1" -c:v libx264 -preset veryslow -b:v $BITRATE -c:a aac -b:a 128k "$OUTPUT_FILE"

# Verificar si se grabó el video correctamente
if [ ! -f "$OUTPUT_FILE" ]; then
    send_error_message "Error: No se pudo grabar el video correctamente."
    exit 1
fi

# Enviar mensaje con la fecha del video
video_date=$(date +'%d de %B')
send_message "Video grabado el $video_date."

# Procesar el video usando detect.py
echo "Procesando video con detect.py..."
python3 "$OUTPUT_DIR/detect.py" --source "$OUTPUT_FILE" --conf-thres 0.35 --class 0

# Directorio donde se guardan los resultados de detect.py
results_directory=$(find "$OUTPUT_DIR/runs/detect" -type d -name "exp*" | sort | tail -n 1)

# Verificar si se encontraron archivos de resultados
if [ -z "$results_directory" ]; then
    send_error_message "No se encontraron resultados de detección en $results_directory"
    exit 1
fi

# Obtener el nombre del archivo de video procesado más reciente
processed_video=$(ls -t "$results_directory"/*.mp4 | head -n 1)

# Verificar si se encontró algún video procesado
if [ -z "$processed_video" ]; then
    send_error_message "No se encontraron videos procesados en $results_directory"
    exit 1
fi

# Enviar mensaje con el total de fotogramas con personas detectadas
echo "Analizando detección de personas..."
detections=0
detection_frames=()

# Procesar el archivo de log
while IFS= read -r line; do
    if [[ "$line" == *"person"* ]]; then
        frame=$(echo "$line" | grep -oP '\(\K[0-9]+(?=/)')
        detection_frames+=("$frame")
        detections=$((detections + 1))
    fi
done < "$LOG_FILE"

# Enviar resumen con el total de fotogramas con personas detectadas
if [ $detections -eq 0 ]; then
    send_message "No se detectó a ninguna persona en el video."
else
    send_message "Se detectaron un total de $detections fotogramas con personas en el video."
    echo "Extrayendo fotogramas del video procesado donde se detectó a una persona..."
    for frame in "${detection_frames[@]}"; do
        # Guardar los fotogramas dentro del directorio de la ejecución actual (runs/expX)
        frame_file="$results_directory/frame_$frame.png"
        ffmpeg -nostdin -hide_banner -loglevel error -i "$processed_video" -vf "select=eq(n\,$frame)" -vsync vfr "$frame_file"
        curl -s -F chat_id="$CHAT_ID" -F photo=@"$frame_file" "$PHOTO_URL"
        if [ $? -ne 0 ]; then
            send_error_message "Error: No se pudo enviar el fotograma $frame por Telegram."
        fi
    done
fi

# Enviar el video procesado con título
video_title="Video Procesado - $video_date"
echo "Enviando video procesado por Telegram..."
curl -s -F chat_id="$CHAT_ID" -F caption="$video_title" -F video=@"$processed_video" "$URL"
if [ $? -ne 0 ]; then
    send_error_message "Error: No se pudo enviar el video procesado por Telegram."
    exit 1
fi
echo "Video procesado enviado por Telegram."

# Enviar el archivo de log por Telegram
echo "Enviando archivo de log por Telegram..."
curl -s -F chat_id="$CHAT_ID" -F document=@"$LOG_FILE" "$DOCUMENT_URL"
if [ $? -ne 0 ]; then
    send_error_message "Error: No se pudo enviar el archivo de log por Telegram."
    exit 1
fi
echo "Archivo de log enviado por Telegram."

echo "Proceso completado."

```

El script grabará video, lo procesará con YOLOv5 para detectar personas, y enviará notificaciones a través de Telegram con los fotogramas y videos donde se detectaron personas.

Resultados
Videos: Se almacenarán en la ruta especificada con marca de tiempo.
Fotogramas: Enviados a Telegram cada vez que se detecta una persona.
Logs: Guardados en el archivo de log especificado para análisis posterior.

Contribuciones
Las contribuciones son bienvenidas. Si tienes ideas o mejoras, no dudes en hacer un fork del proyecto y enviar un pull request.


