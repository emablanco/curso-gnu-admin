=======
Back-up
=======

:Autores: Emiliano López (emiliano.lopez@gmail.com)

          Maximiliano Boscovich (maximiliano@boscovich.com.ar)

:Fecha: |date| |time|

.. |date| date:: %d/%m/%Y
.. |time| date:: %H:%M

.. header::
  Curso Administracion GNU/Linux

.. footer::
    ###Page### / ###Total###

En general, un administrador de sistemas se enfrenta a tres tareas para restaurar la funcionalidad completa de un sistema en otro equipo:

- Bootear un sistema de rescate en otro hardware
- replicar la estructura del sistema original
- restaurar archivos del sistema y de usuarios

Mientras que la mayoría de los sistemas de backups resuelven el tercer item, para resolver la primera y segunda opción se recomienda el uso de Relax-and-Recover (*ReaR*), utilidad destinada para recuperar y migrar sistemas (bare metal).

*ReaR* crea un sistema de rescate booteable que permite recuperar el sistema mediante el comando ``rear recover``. Durante este proceso, ReaR replica la estructura de particiones y del sistema de archivos, restaura archivos de sistema y de usuarios (generados por otro sistema de backup) y finalmente instala el cargador de arranque. En su ocpión por defecto, ReaR solo recupera la estructura de particiones y bootloader.

Per además, *ReaR* permite cubir los primeros dos items, con un método ya integrado o bien utilizando algún software de backup externo.

Instalación
===========

.. code:: bash

    yum install rear genisoimage syslinux

Configuración
=============

ReaR se configura en el archivo ``/etc/rear/local.conf`` donde se especifica el formato de la salida y la ubicación.

.. code:: bash

    OUTPUT=formato
    OUTPUT_URL=ubicacion

Donde formato puede ser, por ejemlo, ``ISO`` o ``USB``.

Independientemente de la ubicación de destino, se hace una copia en ``/var/lib/rear/output/``, para evitar este duplicado se deben agregar estas líneas al archivo de configuración:

.. code:: bash

    OUTPUT = ISO
    BACKUP = NETFS
    OUTPUT_URL = NULL
    BACKUP_URL = "iso:///backup"
    ISO_DIR = "ubicacion"

**Notar** que al hacer el backup localmente, se usa 3 barras luego de ``iso:``.

Backup por NFS
--------------

Es posible configurar Rear para que almacene las imágenes ISO de los backups creados en un servidor NFS remoto.
Para esto se deben configurar al menos los siguientes parámetros:

.. code:: bash

    OUTPUT = ISO
    BACKUP = NETFS
    BACKUP_URL = nfs://IP/RECURSO

Donde ``IP`` es la dirección IP del servidor y ``RECURSO`` el directorio exportado mediante NFS.

Creando sistema de rescate
==========================

.. code:: bash

    rear -v mkrescue

Automatizar con crontab
'''''''''''''''''''''''

Especificando en ``/etc/crontab`` se puede programar la generación del sistema de rescate en forma automática. Por ejemplo para que se ejecute a las 22 cada día de semana:

.. code:: bash

    0 22 * * 1-5 root /usr/sbin/rear mkrescue

Restaurando el sistema
''''''''''''''''''''''

- Grabar la imagen generado a un CD/DVD o USB
- Bootear el CD/DVD o USB, loguearse como **root** sin contraseña
- Elegir la opción ``Recover HOSTNAME``
- Ejecutar el comando ``rear recover``


Referencias
===========

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/ch-relax-and-recover_rear