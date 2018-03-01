====================
Arranque del sistema
====================

Cuando inicia el equipo, el *BIOS* toma el control, detecta los discos, carga el registro maestro de arranque ("*MBR*") y ejecuta el *gestor de arranque*. Éste toma el control, busca el **Kernel** en el disco, lo carga en memoria y lo ejecuta. Luego el **Kernel** se inicializa y empieza la búsqueda y montaje de la partición que contiene el sistema de archivos raíz y finalmente ejecuta el primer programa: **init** . Por lo general esta "*partición raíz*" y su **init** están ubicados en un archivo virtual del sistema que sólo existe en *RAM*, llamado "*initramfs*", antes llamado "*initrd*" por "*disco RAM de inicialización*" ("*initialization RAM disk*"). El *gestor de arranque* carga este sistema de archivos en memoria, desde un archivo en el disco rígido o desde la red. Contiene sólo lo mínimo requerido por el **Kernel** para cargar el "verdadero" sistema de archivos raíz: estos pueden ser módulos de controladores para el disco rígido u otros dispositivos sin los cuales el sistema no puede iniciar, o scripts de inicialización y módulos para ensamblar arreglos *RAID*, abrir particiones cifradas, activar volúmenes *LVM*, etc. Una vez que se monta la partición raíz, el *initramfs* entrega el control al verdadero **init** y la máquina regresa al proceso de inicio estándar.


Gestor de arranque
==================

También llamado **cargador de arranque** (o *boot loader*), es el programa encargado de levantar el *Kernel* en memoria. Existen varios cargadores de arranque, **LILO** (*LInux LOader*), **LOADLIN** (*LOAD LINux*), **GRUB** (*GRand Unified Bootloader*), entre otros.

**LILO** y **GRUB** son los cargadores de arranque más utilizados en sistemas **GNU/LINUX**. El primero es bastante más arcaico y está cayendo en desuso. El segundo es un proyecto que intenta universalizar la **gestión del arranque** de los sistemas, lo que lo ha hecho muy popular y lo ha puesto como gestor por defecto de muchas distribuciones de **GNU/Linux**.

**LILO** tiene algunas desventajas que **GRUB** mejoró. La más importante es que los gestores de arranque en disco, deben instalar parte de sus funciones en el *MBR*, y **LILO** en particular, requiere que por cada cambio de configuración que se realice (como agregar un nuevo *Kernel* a seleccionar durante el *booteo*), se ejecute el comando **lilo** para instalar esa modificación en el *MBR*. Con lo cual, si hubiera algún error de configuración, el sistema podría no iniciar. Sumado a esto, **LILO** no posee ninguna interfaz interactiva durante el *booteo*, lo que lleva a tener que buscar alternativas para arrancar el sistema en caso de información incorrecta.


GRUB
----

**GRUB** provee un método eficiente para el arranque de **GNU/Linux** así como para otros sistemas operativos. Puede administrar hasta 64 diferentes imágenes de boot en un disco. También permite elegir instalarlo en el *MBR* o en algún otro medio (un pendrive por ejemplo).

Generalmente, los sistemas **GNU/Linux** utilizan lo que se conoce como *método de carga directa*, es decir, no existe nada que se ejecute entre el *gestor de arranque* y el *Kernel*. Sin embargo, además del método de arranque directo, **GRUB** soporta la *carga encadenada*, la cual es utilizada por sistemas propietarios como *Windows*. Como consecuencia de esto, **GRUB** permite arrancar desde casi cualquier sistema operativo. En otras palabras, si un sistema propietario requiere lanzar su propio arrancador para *bootear*, lo que hace **GRUB** es conocer la existencia de ese otro sistema, y permitir la ejecución de el otro arrancador. Eso es el *encadenado*.

En el caso de *Windows* por ejemplo, al instalarlo destruye la presencia de cualquier **gestor de arranque** existente en el *MBR*, dado que lo sobrescribe completamente. Por esta razón y en caso de tener booteo dual con otro sistema, se recomienda instalar primero el sistema propietario y luego **GNU/Linux**.

.. raw:: pdf

    PageBreak

Algunas características de GRUB
+++++++++++++++++++++++++++++++

- Tiene soporte para *Kernels* que no son multiarranque: *FreeBSD*, *NetBSD*, *OpenBSD* y **GNU/Linux**.
- Admite el modo *LBA* (*Dirección de Bloque Lógico*), y si el modo está disponible, puede acceder a todo el disco.
- Soporta la carga de módulos que por defecto están comprimidos con *gzip*.
- Permite la carga de múltiples módulos del *Kernel* (característica del multiarranque).
- Trae soporte para varios sistemas de archivos: *Minix FS*, *JFS*, *BSD*, *DOS FAT16* y *FAT32*, *FFS*, *ext2fs*, *ext3fs*, *ext4fs*, *ReiserFS*, entre otros.
- Puede arrancar a través de la red utilizando el protocolo *TFTP*.
- Levanta la información de un archivo de configuración (la modificación de este archivo no requiere reinstalar **GRUB** en *MBR*).
- Posee un tiempo de espera programable para el menú de arranque.
- Desde el menú es posible acceder a una interfaz de comandos (modo edición).
- Reconoce varios formatos ejecutables.
- Es independiente de las traducciones de geometría del disco.
- Es capaz de detectar toda la *RAM* instalada.


System V
========

El sistema de incio **System V** (más conocido como **init** o **sysvinit**) ejecuta varios procesos siguiendo instrucciones del archivo */etc/inittab* . El primer programa que ejecuta (que se corresponde con el paso *sysinit*) es */etc/init.d/rcS* , un script que ejecuta todos los programas del directorio */etc/rcS.d/* . Entre estos encontrará sucesivamente programas a cargo de:

- configurar el teclado de la consola;
- cargar controladores: el *Kernel* carga por sí mismo la mayoría de los módulos a medida que el hardware es detectado; los controladores extras se cargan automáticamente cuando los módulos correspondientes son listados en */etc/modules* ;
- verificar la integridad de los *sistemas de archivos*;
- montar particiones locales;
- configurar la red;
- montar sistemas de archivos de red (*NFS*).

Después de esta etapa, **init** toma el control e inicia los programas activados en el *nivel de ejecución* ("*runlevel*") predeterminado (generalmente el nivel 2). Ejecuta */etc/init.d/rc2* , un script que inicia todos los servicios enumerados en */etc/rc2.d/* y aquellos cuyos nombres comiencen con la letra "*S*". Los números de dos cifras que le sigue fueron utilizados históricamente para definir el orden en el que se iniciarán los servicios, pero actualmente el sistema de inicio predeterminado utiliza *insserv* , que programa todo automáticamente basándose en las dependencias de los scripts. Cada script de inicio, declara las condiciones a cumplir para iniciar o detener el servicio (por ejemplo, si debe iniciar antes o después de otro servicio); **init** luego los ejecuta en un orden que satisfaga estas condiciones. El enumerado estático de los scripts ya no se tiene en cuenta (pero sus nombres siempre deben comenzar con «S» seguidos de dos números y el nombre real del script utilizado para dependencias). Generalmente, se inician primero los servicios de base (como los registros con *rsyslogd* o la asociación de puertos con *portmap* ) seguidos de los servicios estándar y la interfaz gráfica ( *gdm*, *kdm*, *xdm* ).

Este sistema de inicio basado en dependencias hace posible renumerar automáticamente los scripts, lo que sería tedioso de hacer manualmente y limita el riesgo de error humano ya que se realiza la programación según los parámetros indicados. Otro beneficio es que se pueden iniciar los servicios en paralelo cuando son independientes entre ellos, lo cual puede acelerar el proceso de inicio.

**init** distingue varios niveles de ejecución ("*runlevel*") y puede cambiar de uno a otro ejecutando *telinit nuevo-nivel* . Inmediatamente, **init** ejecuta nuevamente */etc/init.d/rc* con el nuevo nivel de ejecución. Luego, este script ejecutará los servicios faltantes y detendrá aquellos que ya no se desean. Para hacerlo, se refiere al contenido del archivo */etc/rcX.d* (donde X representa el nuevo nivel de ejecución). Los scripts cuyos nombres comienzan con "*S*" (por "*start*", iniciar) son los servicios a iniciar; aquellos cuyos nombres comienzan con "*K*" (por "*kill*", matar) son los servicios a detener. El script no inicia ningún servicio que ya haya estado activo en el nivel de ejecución anterior.

De forma predeterminada, el inicio de **System V** en **Debian** utiliza cuatro niveles de ejecución diferentes:

	* **Nivel 0**: sólo se lo utiliza temporalmente mientras se apaga el equipo. Por eso sólo contiene scripts "*K*".
	* **Nivel 1**: también conocido como modo de usuario único (*single-user*), corresponde al sistema en modo degradado; sólo incluye servicios básicos y está destinado a operaciones de mantenimiento donde no se desea la interacción con usuarios normales.
	* **Nivel 2**: es el nivel para operaciones normales, lo que incluye servicios de red, una interfaz gráfica, sesiones de usuario, etc.
	* **Nivel 6**: similar a nivel 0, excepto a que es utilizada durante la fase de cierre que precede a un reinicio.

.. raw:: pdf

    Spacer 0 20

Existen otros niveles, especialmente del 3 al 5. De forma predeterminada están configurados para operar de la misma forma que el nivel 2, pero el administrador puede modificarlos (agregando o eliminando scripts en los directorios */etc/rcX.d* correspondientes) para adaptarlos a necesidades particulares.

.. image:: imagenes/inicio-systemV.png
	:scale: 200


Todos los scripts en los varios directorios */etc/rcX.d* son sólo enlaces simbólicos (creados durante la instalación del paquete por el programa *update-rc.d* ) que apuntan a los scripts reales que están almacenados en */etc/init.d/* . El administrador puede ajustar los servicios disponibles en cada nivel de ejecución ejecutando *update-rc.d* nuevamente con los parámetros correctos. La página de manual *update-rc.d* describe la sintaxis en detalle. Eliminar todos los enlaces simbólicos (con el parámetro *remove* ) no es un buen método de desactivar un servicio. En lugar de hacer eso, simplemente se debería configurar para que dicho script no se ejecute en el nivel de ejecución deseado (preservando las llamadas para detenerlo en caso que el servicio se esté ejecutando en el nivel de ejecución anterior). Debido a que *update-rc.d* tiene una interfaz bastante compleja, existe el comando *rcconf*, el cual provee una interfaz mucho más amigable.

Finalmente, **init** inicia los programas de control para varias consolas virtuales ( *getty* ). Muestra un prompt esperando por un nombre de usuario y luego ejecuta login usuario para iniciar una sesión.


El Demonio init
---------------

Lo último que hace el Kernel es invocar al demonio **init**, el cual permanece activo como proceso hasta que el sistema es apagado. Es el responsable de cargar los subprocesos necesarios para la puesta en marcha del sistema. También se encarga de reiniciar ciertos procesos cuando terminan, por ejemplo: al efectuar un *logout* (*cerrar sesión*), el **init** reinicia la consola para que esté lista para el siguiente *login*. Cuando **init** termina de cargarse, vacía el subdirectorio */tmp* y lanza *getty*, que se encarga de permitir hacer *login* en el sistema a los usuarios.

El proceso **init** gerencia todo el sistema **GNU/Linux**, y necesita un archivo de configuración para saber exactamente lo que tiene que hacer. Este archivo es */etc/inittab*, y contiene información sobre el nivel a ejecutar por defecto, previsión sobre lo que hacer ante determinadas situaciones, describe qué procesos se inician en la carga y durante la operación normal. Usa la información del archivo para manejar los diferentes niveles de ejecución. También lo utiliza para cambiar entre los diferentes runlevels.

**init** acepta un parámetro numérico que indica el nivel de ejecución a iniciar o uno de los siguientes:

- **init s**: Modo de *single-user* (también acepta *S*).
- **init q**: Lee nuevamente el archivo */etc/inittab* (también puede ser "Q").

.. raw:: pdf

    Spacer 0 10

Cambiar a un *runlevel* mas alto es razonable, pero a uno menor que el actual es peligroso, porque existen aplicaciones, utilidades y servicios ejecutándose que probablemente terminaran sin avisar. Por ejemplo, el nivel 0 es una manera imprudente de apagar ya que no avisa a los usuarios en sesión en el sistema que se va a apagar todo.


inittab
-------

El archivo */etc/inittab* contiene la descripción general del proceso de arranque del sistema. **init** sigue las instrucciones incluidas en dicho archivo para llevar al sistema a un estado usable, lanzando los procesos descritos en este archivo.

Un *runlevel* (o *nivel de ejecución*) es una configuración por software del sistema, que permite existir sólo a un grupo seleccionado de procesos. El sistema (por medio de **init**) está en cada momento en un *runlevel* concreto. El *superusuario* (*root*) puede cambiar el *runlevel* en cualquier momento ejecutando *telinit*. Si se efectúan cambios al archivo **inittab** no es necesario reiniciar para que los cambios surjan efectos, alcanza con ejecutar *init q* o *telinit q* .

Estos comandos le ordenan a a **init** que lea su archivo de configuración sin cambiar de *runlevel*. El comando *telinit* es un enlace simbólico a init en las mayoría de distros de **GNU/Linux** de hoy día. Hay ocho *runlevels*, llamados 0, 1, 2, 3, 4, 5, 6 y S. El *runlevel* 0 se usa para parar el sistema, el 6 para reiniciarlo y el *S* o el 1 para ponerlo en modo monousuario (*single-user*). Los demás niveles se utilizan para proporcionar determinado grado de servicios. Por ejemplo, es normal usar un nivel para el uso normal, otro para el arranque automático del *Servidor X*, otro para uso sin red, etc.

El */etc/inittab* se utiliza para determinar cuales comandos ejecutar en cuales niveles. Los cambios de niveles son controlados por los archivos *rc* que ejecutan los diferentes comandos de ese nivel. El archivo *rc* a ejecutar en cada nivel esta definido en el */etc/inittab*.


El archivo /etc/inittab
+++++++++++++++++++++++

Cada línea del archivo esta dividida en cuatro campos separados por dos puntos:

**Id: nivel: acción: proceso**

- **ID**: Identificador único de la línea, hasta 4 caracteres alfanuméricos.
- **Nivel**: *Runlevel* que activa este proceso.
- **Acción**: Palabra clave que indica la forma en que se va a ejecutar el proceso.
- **Proceso**: Nombre completo y parámetros del comando a ejecutar.

.. raw:: pdf

    Spacer 0 20

El campo acción indica cómo manejar el proceso, así como reiniciarlo si es detenido.

Los principales valores a tomar por el campo acción son:

- **Off**: No ejecute este comando.
- **Wait**: Ejecute este comando y espere que termine.
- **Once**: Ejecute este comando y no espere.
- **Respawn**: Ejecute este comando; y si falla, ejecútelo de nuevo.
- **Sysinit**: Ejecute el comando durante el primer **init**.
- **Boot**: Ejecute el comando al inicio del arranque y no espere.
- **Bootwait**: Idem **Boot**, pero espere que termine.
- **Ctrlaltdel**: Ejecute el comando especificado al presionar estas teclas.
- **initdefault**: Define nivel de arranque por defecto.

.. raw:: pdf

    Spacer 0 10

Al iniciarse, **init** busca la línea **initdefault** en */etc/inittab* para pasar al nivel por defecto.

A continuación lee las demás líneas del archivo. Cada línea tiene la forma:

**Id: runlevels: action: process**

Donde *id* es una identificación para la línea, *runlevels* especifica los niveles en los que esta línea debe aplicarse, *action* es la acción que se va a realizar y *process* es el proceso a ejecutar.

El **init** va ejecutando los procesos especificados en las líneas que incluyan el nivel de ejecución actual. Cuando se cambia el nivel, los procesos del nivel antiguo son eliminados.

Los procesos que se ejecutan en un estado normal son los scripts de arranque primero, y las invocaciones a los programas que permiten a los usuarios usar el sistema después. Una de estas líneas podría ser como la siguiente:

**1:2345:respawn:/sbin/getty 38400 tty1**

Esta línea indica que en los niveles de ejecución 2,3,4 o 5 debe ejecutarse el programa */sbin/getty* (que es el programa que se encarga de pedir el *login* y el *password* a los usuarios) con los parámetros *38400* (que indica que espere comunicaciones a *38400* baudios), y *tty1* (que indica que escuche en la primera terminal virtual). La palabra clave *respawn* indica que este proceso debe reiniciarse cuando termine, de forma que cuando un usuario salga del sistema, se vuelva a mostrar el *prompt* de *login* para aceptar otro usuario.

Hay que manejar con cuidado el archivo *inittab*, ya que una modificación indebida del mismo puede dejar al sistema en un estado incapaz de arrancar.


Niveles de ejecución (runlevels)
--------------------------------

Un servicio es una funcionalidad proporcionada por la máquina, normalmente basada en *demonios* (o procesos en segundo plano de ejecución, que controlan peticiones de red, actividad del hardware, u otros programas que provean alguna tarea).

La activación o parada de servicios se realiza mediante la utilización de scripts. La mayoría de los servicios estándar, los cuales suelen tener su configuración en el directorio */etc*, suelen controlarse mediante los scripts presentes en */etc/init.d/* . En este directorio suelen aparecer scripts con nombres similares al servicio donde van destinados, y se suelen aceptar parámetros de activación o parada. Se realiza:

- **/etc/init.d/servicio start** : arranque del servicio.
- **/etc/init.d/servicio stop** : parada del servicio.
- **/etc/init.d/servicio restart** : parada y posterior arranque del servicio.

.. raw:: pdf

    Spacer 0 10

Un **nivel de ejecución** es básicamente una configuración de programas y servicios que se ejecutarán orientados a un determinado funcionamiento.

Los niveles típicos, aunque puede haber diferencias en el orden, en especial en los niveles 2-5, suelen ser:

- **0 (Parada)**: Finaliza servicios y programas activos, así como desmonta filesystems activos y para la *CPU*.
- **1 (Monousuario)**: Finaliza la mayoría de servicios, permitiendo sólo la entrada del administrador (*root*). Se usa para tareas de mantenimiento y corrección de errores críticos.
- **2 (Multiusuario sin red)**: No se inician servicios de red, permitiendo sólo entradas locales en el sistema.
- **3 (Multiusuario)**: Inicia todos los servicios excepto los gráficos asociados a *X Window*.
- **4 (Multiusuario)**: No suele usarse, típicamente es igual que el 3.
- **5 (Multiusuario X)**: Igual que el 3, pero con soporte *X* para la entrada de usuarios (*login* gráfico).
- **6 (Reinicio)**: Finaliza todos los programas y servicios. Reinicia el sistema.

.. raw:: pdf

    Spacer 0 20

Como se mencionó más arriba, Debian usa un modelo, en el que los niveles 2-5 son prácticamente equivalentes, realizando exactamente la misma función.

En el caso del modelo **runlevel** de *System V*, cuando el proceso *init* arranca, utiliza el archivo */etc/inittab* para decidir el modo de ejecución en el que va a entrar (haciendo uso del **runlevel** por defecto -*initdefault*-), y también activa una serie de servicios de terminal para atender la entrada del usuario.

Después, el sistema, según el **runlevel** escogido, consulta los archivos contenidos en */etc/rcX.d* , donde *X* es el número asociado al **runlevel** (nivel escogido), en el que se encuentran una lista de servicios para iniciar o detener en caso de que arranque en el **runlevel**, o se salga del mismo. Dentro del directorio se encuentran una serie de scripts o enlaces a los scripts que controlan el servicio.

.. raw:: pdf

    PageBreak

Systemd
=======

.. image:: imagenes/inicio-systemd.png
	:scale: 200

**systemd** es un sistema de inicio relativamente reciente. Aunque ya estaba disponible parcialmente en **Debian Wheezy**, se ha convertido en el *sistema de arranque* estándar en **Debian** a partir de **Jessie**. Las versiones anteriores utilizaban de forma predeterminada el sistema de inicio "**System V**", un sistema mucho más tradicional.

**systemd** ejecuta varios procesos que se encargan de configurar el sistema: teclado, controladores, sistemas de archivos, redes, servicios. Hace esto a la vez que mantiene una visión global del sistema como un todo y de los requerimientos de los componentes. Cada componente se describe en un archivo unidad ("*unit file*"), a veces más de uno. La sintaxis de los mismos se deriva de la de los muy extendidos archivos "*.ini*". Es decir que utiliza pares: *clave = valor* agrupados entre cabeceras de *[ sección ]* . Los archivos *unit* se guardan en */lib/systemd/system/* y */etc/systemd/system/* . Hay varios tipos, entre ellos los servicios ("*services*") y metas ("*targets*").

Un *archivo de servicio* ("*service file*") de **systemd** describe un proceso gestionado por **systemd**. Contiene más o menos la misma información que los antiguos scripts de inicio, pero expresada de forma declarativa (y mucho más concisa). **systemd** se ocupa de la mayoría de las tareas repetitivas (arrancar y parar el proceso, comprobar su estado, registrar los errores, soltar privilegios, etc) y el archivo de servicio únicamente tiene que proporcionar los parámetros específicos de cada servicio.

Por ejemplo, se muestra el archivo de servicio para SSH (Secure Shell):

.. code-block:: bash

	[Unit]
	Description=OpenBSD Secure Shell server
	After=network.target auditd.service
	ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

	[Service]
	EnvironmentFile=-/etc/default/ssh
	ExecStart=/usr/sbin/sshd -D $SSHD_OPTS
	ExecReload=/bin/kill -HUP $MAINPID
	KillMode=process
	Restart=on-failure

	[Install]
	WantedBy=multi-user.target
	Alias=sshd.service

Como se puede comprobar, no hay apenas código, únicamente declaraciones. **systemd** se ocupa de mostrar los informes de progreso, de controlar los procesos e incluso de reiniciarlos cuando sea necesario.

Un archivo de *meta* ("*target file*") describe un estado del sistema en el cual se sabe que está operativo un conjunto de servicios. Se puede hacer una analogía a los antiguos niveles de ejecución ("*runlevels*"). Una de las *metas* es **local-fs.target** ; cuando se alcanza, el resto del sistema puede asumir que todos los sistemas de archivos locales están montados y son accesibles. Otros ejemplos de *metas* pueden ser **network-online.target** o **sound.target** . Las dependencias de una *meta* se pueden establecer directamente en su archivo de configuración o "*target file*" (en la línea *Requires=*) o bien utilizando un enlace simbólico a un archivo de servicio ("*service file*") en el directorio */lib/systemd/system/targetname.target.wants/* . 

Por ejemplo */etc/systemd/system/printer.target.wants/* contiene un enlace a */lib/systemd/system/cups.service* ; **systemd** se asegurará de que *CUPS* esté en ejecución para poder alcanzar la *meta* **printer.target** . Dado que los archivos de unidad son declarativos en lugar de scripts o programas, no se pueden ejecutar directamente; tienen que ser interpretados por **systemd**. Existen varias utilidades que permiten al administrador interactuar con **systemd** y controlar el estado del sistema y de cada componente.

La primera de estas utilidades es **systemctl** . Cuando se ejecuta sin argumentos, lista todos los archivos de unidad conocidos por **systemd** (excepto los que han sido deshabilitados), así como su estado. **systemctl status** muestra una mejor visión de los servicios y sus procesos relacionados. Si se proporciona el nombre de un servicio (como por ejemplo: **systemctl status ntp.service** ) muestra aún más detalles, así como las últimas líneas del registro relacionadas con el servicio.

Para arrancar un servicio manualmente se debe ejecutar **systemctl start nombredelservicio.service** . Como se puede suponer, para parar un servicio se hace con **systemctl stop nombredelservicio.service** ; otros subcomandos disponibles son *reload* y *restart* .

Para establecer si un servicio está activo (es decir, si se debe arrancar automáticamente al inicio o no) se utiliza el comando **systemctl enable nombredelservicio.service** (o *disable* ). *isenabled* permite saber si está activo o no.

Una característica interesante de **systemd** es que incluye un componente de registro llamado **journald** . Viene como complemento a los sistemas de registro tradicionales como *syslogd* , pero añade características interesantes como un enlace formal entre un servicio y los mensajes que genera, así como la posibilidad de capturar los mensajes de error generados por su secuencia de inicialización. Los mensajes se pueden mostrar con la ayuda del comando **journalctl** . Sin argumentos simplemente vuelca todos los mensajes que han ocurrido desde el arranque del sistema, aunque no se suele utilizar de esa forma. Normalmente se utiliza con un identificador de servicio:

.. code-block:: bash

	# journalctl -u ssh.service
	-- Logs begin at Tue 2015-03-31 10:08:49 CEST, end at Tue 2015-03-31 17:06:02 CEST. --
	Mar 31 10:08:55 mirtuel sshd[430]: Server listening on 0.0.0.0 port 22.
	Mar 31 10:08:55 mirtuel sshd[430]: Server listening on :: port 22.
	Mar 31 10:09:00 mirtuel sshd[430]: Received SIGHUP; restarting.
	Mar 31 10:09:00 mirtuel sshd[430]: Server listening on 0.0.0.0 port 22.
	Mar 31 10:09:00 mirtuel sshd[430]: Server listening on :: port 22.
	Mar 31 10:09:32 mirtuel sshd[1151]: Accepted password for roland from 192.168.1.129 port 53394 ssh2
	Mar 31 10:09:32 mirtuel sshd[1151]: pam_unix(sshd:session): session opened for user roland by (uid=0)

Otra opción útil es *-f* , que hace que **journalctl** siga mostrando los nuevos mensajes a medida que se van emitiendo (semejante a lo que ocurre con *tail -f archivo* ).

Si parece que un servicio no está funcionando como debiera, el primer paso para resolver el problema es comprobar si el servicio se está ejecutando realmente mediante **systemctl status** . Si no es así, y los mensajes que se muestran no son suficientes para diagnosticar el problema,
se pueden comprobar los registros que ha recolectado **journald** relacionados con el servicio. Por ejemplo, suponiendo que el servidor *SSH* no funciona:

.. code-block:: bash

	# systemctl status ssh.service
	● ssh.service - OpenBSD Secure Shell server
	Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
	Active: failed (Result: start-limit) since Tue 2015-03-31 17:30:36 CEST; 1s ago
	Process: 1023 ExecReload=/bin/kill -HUP $MAINPID (code=exited, status=0/SUCCESS)
	Process: 1188 ExecStart=/usr/sbin/sshd -D $SSHD_OPTS (code=exited, status=255)
	Main PID: 1188 (code=exited, status=255)
	Mar 31 17:30:36 mirtuel systemd[1]: ssh.service: main process exited, code=exited, status=255/n/a
	Mar 31 17:30:36 mirtuel systemd[1]: Unit ssh.service entered failed state.
	Mar 31 17:30:36 mirtuel systemd[1]: ssh.service start request repeated too quickly, refusing to start.
	Mar 31 17:30:36 mirtuel systemd[1]: Failed to start OpenBSD Secure Shell server.
	Mar 31 17:30:36 mirtuel systemd[1]: Unit ssh.service entered failed state.
	# journalctl -u ssh.service
	-- Logs begin at Tue 2015-03-31 17:29:27 CEST, end at Tue 2015-03-31 17:30:36 CEST. --
	Mar 31 17:29:27 mirtuel sshd[424]: Server listening on 0.0.0.0 port 22.
	Mar 31 17:29:27 mirtuel sshd[424]: Server listening on :: port 22.
	Mar 31 17:29:29 mirtuel sshd[424]: Received SIGHUP; restarting.
	Mar 31 17:29:29 mirtuel sshd[424]: Server listening on 0.0.0.0 port 22.
	Mar 31 17:29:29 mirtuel sshd[424]: Server listening on :: port 22.
	Mar 31 17:30:10 mirtuel sshd[1147]: Accepted password for roland from 192.168.1.129 port 38742 ssh2
	Mar 31 17:30:10 mirtuel sshd[1147]: pam_unix(sshd:session): session opened for user roland by (uid=0)
	Mar 31 17:30:35 mirtuel sshd[1180]: /etc/ssh/sshd_config line 28: unsupported option "yess".
	Mar 31 17:30:35 mirtuel systemd[1]: ssh.service: main process exited, code=exited, status=255/n/a
	Mar 31 17:30:35 mirtuel systemd[1]: Unit ssh.service entered failed state.
	Mar 31 17:30:35 mirtuel sshd[1182]: /etc/ssh/sshd_config line 28: unsupported option "yess".
	Mar 31 17:30:35 mirtuel systemd[1]: ssh.service: main process exited, code=exited, status=255/n/a
	Mar 31 17:30:35 mirtuel systemd[1]: Unit ssh.service entered failed state.
	Mar 31 17:30:35 mirtuel sshd[1184]: /etc/ssh/sshd_config line 28: unsupported option "yess".
	Mar 31 17:30:35 mirtuel systemd[1]: ssh.service: main process exited, code=exited, status=255/n/a
	Mar 31 17:30:35 mirtuel systemd[1]: Unit ssh.service entered failed state.
	Mar 31 17:30:36 mirtuel sshd[1186]: /etc/ssh/sshd_config line 28: unsupported option "yess".
	Mar 31 17:30:36 mirtuel systemd[1]: ssh.service: main process exited, code=exited, status=255/n/a
	Mar 31 17:30:36 mirtuel systemd[1]: Unit ssh.service entered failed state.
	Mar 31 17:30:36 mirtuel sshd[1188]: /etc/ssh/sshd_config line 28: unsupported option "yess".
	Mar 31 17:30:36 mirtuel systemd[1]: ssh.service: main process exited, code=exited, status=255/n/a
	Mar 31 17:30:36 mirtuel systemd[1]: Unit ssh.service entered failed state.
	Mar 31 17:30:36 mirtuel systemd[1]: ssh.service start request repeated too quickly, refusing to start.
	Mar 31 17:30:36 mirtuel systemd[1]: Failed to start OpenBSD Secure Shell server.
	Mar 31 17:30:36 mirtuel systemd[1]: Unit ssh.service entered failed state.
	# vi /etc/ssh/sshd_config
	# systemctl start ssh.service
	# systemctl status ssh.service
	● ssh.service - OpenBSD Secure Shell server
	Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
	Active: active (running) since Tue 2015-03-31 17:31:09 CEST; 2s ago
	Process: 1023 ExecReload=/bin/kill -HUP $MAINPID (code=exited, status=0/SUCCESS)
	Main PID: 1222 (sshd)
	CGroup: /system.slice/ssh.service
	└─1222 /usr/sbin/sshd -D
	#

Después de comprobar el estado del servicio (fallido), se comprueban los registros: indican un error en el archivo de configuración. Después de editar el archivo de configuración y corregir el error, se reinicia el servicio y se comprueba que efectivamente está funcionando.


Algunas otras características de systemd
----------------------------------------

- **activación de sockets**: se puede usar un *archivo de unidad de socket* ("*socket unit file*") para describir un *socket de red* gestionado por **systemd**. Esto significa que **systemd** creará este *socket* y que se ejecutará el servicio correspondiente cuando exista un intento de conexión al mismo. Con esto se duplica aproximadamente la funcionalidad de *inetd* .
- **temporizadores**: un *archivo de unidad de temporizador* ("*timer unit file*") describe eventos que se ejecutan periódicamente o en determinados instantes. Cuando un servicio está enlazado con un temporizador la tarea correspondiente se ejecuta cada vez que se dispare el temporizador. Eso permite replicar parte de la funcionalidad de *cron* .
- **red**: un *archivo de unidad de red* ("*network unit file*") describe una interfaz de red y permite configurarla, así como expresar que un servicio depende de que una interfaz de red determinada esté levantada.


Otros sistemas de inicio
========================

**System V** y **systemd** no son los únicos sistemas de inicio que existen.

**file-rc** es un sistema de inicio con un proceso muy simple. Mantiene el principio de niveles de ejecución pero reemplaza los directorios y enlaces simbólicos con un archivo de configuración que le indica a **init** los procesos a iniciar y el orden en el que hacerlo.

El sistema **upstart** todavía no ha sido probado perfectamente en **Debian**. Está basado en eventos: los scripts de inicio no se ejecutan en un orden secuencial sino en respuesta a eventos como la finalización de otro script del que depende. Este sistema, creado por **Ubuntu**, está presente en **Debian Jessie** pero no es el predeterminado; sólo viene como reemplazo para **sysvinit** (**System V**). Una de las tareas ejecutadas por **upstart** es ejecutar los scripts escritos para sistemas tradicionales, especialmente aquellos del paquete **sysv-rc** .

También existen otros sistemas y otros modos de operación, como por ejemplo **runit** o **minit** pero estos son bastante especializados y están poco difundidos.


Kernel: /proc y /sys
====================

En el arranque del sistema **GNU/Linux**, se produce todo un volcado de información interesante; cuando el sistema arranca, suelen aparecer los datos de detección de las características de la máquina, detección de dispositivos, arranque de servicios de sistema, etc., y se mencionan los problemas aparecidos.

En la mayoría de las distribuciones esto puede verse en la consola del sistema directamente durante el proceso de arranque. Sin embargo, o la velocidad de los mensajes o algunas modernas distribuciones que los ocultan tras carátulas gráficas pueden impedir seguir los mensajes correctamente, con lo cual existen una serie de herramientas posibles para acceder a esa información.

.. raw:: pdf

    PageBreak

- **Comando dmesg**: da los mensajes del último arranque del kernel.
- **Archivo /var/log/messages**: log general del sistema, que contiene los mensajes generados por el **Kernel** y otros *demonios* (*daemons*), puede haber multitud de archivos diferentes de log, normalmente en */var/log*, y dependiendo de la configuración del servicio *syslog*.
- **Comando uptime**: indica cuánto tiempo hace que el sistema está activo.
- **Sistema /proc**: pseudo sistema de archivos (**procfs**) que utiliza el **Kernel** para almacenar la información de procesos y de sistema.
- **Sistema /sys**: pseudo sistema de archivos (**sysfs**) que apareció con la rama 2.6.x del **Kernel**, con objetivo de proporcionar una forma más coherente de acceder a la información de los dispositivos y sus controladores (*drivers*).


Kernel: /proc
-------------

El **Kernel** durante su arranque, pone en funcionamiento un *pseudo-filesystem* llamado **/proc**, donde vuelca la información que recopila de la máquina, así como muchos de sus datos internos, durante la ejecución. El directorio **/proc** está implementado sobre memoria y no se guarda en disco. Los datos contenidos son tanto de naturaleza estática como dinámica (varían durante la ejecución).

Hay que tener en cuenta que al ser **/proc** fuertemente dependiente del **Kernel**, su estructura depende del **Kernel** del cual se dispone en el sistema, y la estructura y los archivos incluidos pueden cambiar.

Una de las características interesantes, es que en el directorio **/proc** se encuentran las imágenes de los procesos en ejecución, junto con la información que el **Kernel** maneja acerca de ellos. Cada proceso del sistema se puede encontrar en el directorio */proc/<pidproceso>*, donde hay un directorio con archivos que representan su estado. Esta información es básica para programas de depuración, o bien para los propios comandos del sistema como *ps* o *top*, que pueden utilizarla para ver el estado de los procesos. En general muchas de las utilidades del sistema consultan la información dinámica del sistema desde **/proc** (en especial algunas utilidades proporcionadas en el paquete *procps*).

Por otra parte, en **/proc** podemos encontrar otros archivos de estado global del sistema, como ser:

- **/proc/bus**: Directorio con información de los buses *PCI* y *USB*.
- **/proc/cmdline**: Línea de arranque del **Kernel**.
- **/proc/cpuinfo**: Información de la *CPU*.
- **/proc/devices**: Listado de dispositivos del sistema de caracteres o bloques.
- **/proc/drive**: Información de algunos módulos del **Kernel** de hardware.
- **/proc/filesystems**: Sistemas de archivos habilitados en el **Kernel**.
- **/proc/ide**: Directorio de información del bus *IDE*, características de discos.
- **/proc/interrups**: Mapa de interrupciones hardware (*IRQ*) utilizadas.
- **/proc/ioports**: Puertos de *E/S* utilizados.
- **/proc/meminfo**: Datos del uso de la memoria.
- **/proc/modules**: Módulos del **Kernel**.
- **/proc/mounts**: Sistemas de archivos montados actualmente.
- **/proc/net**: Directorio con toda la información de red.
- **/proc/scsi**: Directorio de dispositivos *SCSI*, o *IDE* emulados por *SCSI*.
- **/proc/sys**: Acceso a parámetros del kernel configurables dinámicamente.
- **/proc/version**: Versión y fecha del **Kernel**.

A partir de la rama 2.6 del **Kernel**, se ha iniciado una transición progresiva de **procfs** (**/proc**) a **sysfs** (**/sys**) con objetivo de mover toda aquella información que no esté relacionada con procesos, en especial dispositivos y sus controladores (módulos del **Kernel**) hacia el sistema **/sys**.


Kernel: /sys
------------

El sistema **sys** se encarga de hacer disponible la información de dispositivos y controladores (información de la cual dispone el **Kernel**) al espacio de usuario, de manera que otras *API* o aplicaciones puedan acceder de una forma flexible a la información de los dispositivos (o sus controladores). Suele ser utilizada por capas como *HAL* y el servicio *udev* para la monitorización y configuración dinámica de los dispositivos.

Dentro del concepto de **sys** existe una estructura de datos en árbol de los dispositivos y controladores (digamos el modelo conceptual fijo), y cómo después se accede a él a través del sistema de archivos **sysfs** (estructura que puede cambiar entre versiones).

En cuanto se detecta o aparece en el sistema un objeto añadido, en el árbol del modelo de controladores (controladores, dispositivos -incluyendo sus diferentes clases-) se crea un directorio en **sysfs**. La relación padre/hijo se refleja con subdirectorios bajo */sys/devices/* (reflejando la capa física y sus identificadores). En el subdirectorio */sys/bus* se colocan enlaces simbólicos, reflejando el modo en el que los dispositivos pertenecen a los diferentes buses físicos del sistema. Y en */sys/class* se muestran los dispositivos agrupados de acuerdo a su clase, como por ejemplo *net* (red), mientras que */sys/block/* contiene los dispositivos de bloques.

Alguna de la información proporcionada por **/sys** puede encontrarse también en **/proc**, pero se consideró que éste estaba mezclando diferentes cosas (dispositivos, procesos, datos hardware, parámetros **Kernel**) de forma no coherente, y ésta fue una de las decisiones para crear **/sys**. Se espera que progresivamente se migre información de **/proc** a **/sys** para centralizar la información de los dispositivos.


Memoria
=======

El sistema dispone de la **memoria física** de la propia máquina, y de la **memoria virtual**, que puede ser direccionada por los procesos. Normalmente (a no ser que estemos tratando con servidores empresariales), no dispondremos de cantidades demasiado grandes, de modo que la **memoria física** será menor que el tamaño de la **memoria virtual** necesaria (*4GB* en sistemas de *32bits*). Esto obligará a utilizar una *zona de intercambio* (**swap**) sobre disco, para implementar los procesos asociados a **memoria virtual**.

Esta *zona de intercambio* (**swap**) puede implementarse como un archivo en el sistema de archivos, pero es más habitual encontrarla como una partición de *intercambio* (llamada **swap**), creada durante la instalación del sistema. En el momento de particionar el disco, se declara como de tipo **Linux Swap**.

Para examinar la información sobre la **memoria** tenemos varios métodos y comandos útiles:

- **Archivo /etc/fstab**: aparece la partición **swap** (si existiese). Con el comando *fdisk* se puede averiguar su tamaño (o consultar a */proc/swaps*).
- **Comando ps**: permite conocer qué procesos tenemos, y con las opciones de porcentaje y **memoria** usada.
- **Comando top**: es una versión *ps* dinámica actualizable por periodos de tiempo. Puede clasificar los procesos según la memoria que usan o el tiempo de *CPU*.
- **Comando free**: informa sobre el estado global de la **memoria**. Da también el tamaño de la **memoria virtual**.
- **Comando vmstat**: informa sobre el estado de la **memoria virtual**, y el uso que se le da.
- Algunos paquetes, como **dstat**, permiten recoger datos de los diferentes parámetros (**memoria**, **swap**, y otros) a intervalos de tiempo (de forma parecida a *top*).


Bibliografía
============

The Debian Administrator's Handbook, Raphaël Hertzog and Roland Mas, ( `https://debian-handbook.info/ <https://debian-handbook.info/>`_ )

Administración Avanzada del Sistema GNU/Linux ( `<http://openaccess.uoc.edu/webapps/o2/handle/10609/226>`_ )

Administración de Sistemas GNU/Linux, Guía de Estudio hacia una capacitación segura, Antonio Perpiñan, Fundación Código Libre Dominicano ( `http://www.codigolibre.org <http://www.codigolibre.org>`_ )

Básicamente GNU/Linux, Antonio Perpiñan, Fundación Código Libre Dominicano ( `http://www.codigolibre.org <http://www.codigolibre.org>`_ )

