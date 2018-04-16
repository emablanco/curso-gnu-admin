===========================
Unidad IV - Sistema de logs
===========================

El sistema **GNU/Linux** está en todo momento haciendo algo. Tal vez actualizando una base de datos, enviando un correo, ruteando un paquete, o cualquier otra cosa. Si algo sale mal, ¿Cómo se puede tener idea de que ocurrió cuando tantas cosas están pasando? ¿Cuál proceso es responsable? ¿Podría haber una manera de conseguir mas información? Los archivos de **logs** son esa fuente de información. Estos archivos proveen información detallada del sistema. Si cualquier cosa significativa le ocurre al sistema, es casi seguro que habrá alguna referencia en los archivos de **logs**.


Logs del sistema
================

La información del sistema se almacena en una variedad de archivos de **logs**. Estos **logs** pueden ser específicos de aplicaciones o mensajes desde varias fuentes, y ser escritos a un mismo archivo de **log**. También es posible guardar en un **log**, mensajes basados en sus respectivas importancias además de su fuente. El **rsyslogd** (**syslogd** en otras distros) es el demonio (*daemon*) que es responsable de enviar al **log** la actividad del sistema.

Los archivos de logs de **GNU/Linux** son muy parecidos entre las distintas distribuciones, esto es causa de los factores de tradición y protocolo de **UniX**, **POSIX** (*Portable Operating System Interface for UniX*). La mayoría de archivos de **log** residen en el directorio */var/log/* .

Sin embargo algunos programas tienen sus propios directorios y pueden almacenar una gran cantidad de información si son configurados correctamente con este objetivo. Demonios como *httpd*, *squid* y *samba*, comúnmente mantienen archivos y directorios separados detallando los eventos específicos de las tareas que ellos desempeñan.

Algunos de los logs más utilizados
----------------------------------

- **/var/log/auth.log**: en este archivo se registra todos lo referente a usuarios que están accediendo el sistema, como el usuario de acceso y los posibles sucesos que pongan en peligro la seguridad del sistema. Por defecto todos los ingresos del usuario *root* se registran en este archivo. También suele utilizarse para enviar los mensajes de los *tcp wrappers* (o los *firewalls*), cada vez que se establece una conexión a un servicio de *inetd* o *xinetd*. En otras distros puede aparecer como */var/log/secure* . Monitorizar estos archivos es una parte importantísima de la seguridad del sistema.
- **/var/log/lastlog**: contiene el *login* de cada usuario.
- **/var/log/syslog**: es el archivo de **log** por defecto del demonio **rsyslogd**. Este archivo contiene una amplia variedad de mensajes de orígenes diversos (diferentes demonios, servicios o el mismo kernel). Dentro de este archivo se encuentra una lista larga de los eventos (en orden cronológico), con cada entrada representando un registro individual. El archivo */var/log/syslog* es el archivo central del sistema de mensajes y registros del sistema. Almacena los mensajes de kernel con todos los programas que efectúan eventos que generan un registro. La mayor parte de los errores y mensajes del sistema se encuentran aquí en este archivo.
- **/var/log/utmp**: este archivo contiene información binaria para cada usuario que está actualmente activo. Es interesante para determinar quién está dentro del sistema.
- **/var/log/wtmp**: cada vez que un usuario entra en el sistema, sale, o la máquina reinicia, se guarda una entrada en este archivo binario.

.. raw:: pdf

    PageBreak

syslog y rsyslogd
=================

**GNU/Linux** tiene varios métodos para archivar información en los archivos de **logs**. Algunos programas simplemente escriben en sus propios archivos. Sin embargo la mayoría de los programas utilizan una interfase de Programación de Aplicación (*API*) la cual es proveída por el kernel llamada **syslog**. Un *daemon* llamado **rsyslogd** acepta mensajes desde el kernel, les da formato y decide donde almacenarlos. De hecho, el kernel tiene su propio mecanismo de **logs**. El *daemon* *klogd* acepta estos mensajes desde el kernel y se los envía al **rsyslogd**.

El demonio **rsyslogd** es el responsable de recolectar los mensajes de servicio que provienen de aplicaciones y el kernel, para luego distribuirlos en archivos de logs (usualmente almacenados en el directorio */var/log/* ). Obedece a su archivo de configuración: **/etc/rsyslog.conf** .

Cada mensaje de log es asociado con un subsistema de aplicaciones (llamados "*facility*"):

- **auth y authpriv**: para autenticación.
- **cron**: proviene de los servicios de programación de tareas, *cron* y *atd*.
- **daemon**: afecta a un demonio sin clasificación especial (*DNS*, *NTP*, etc.).
- **ftp**: el servidor *FTP*.
- **kern** : mensaje que proviene del kernel.
- **lpr**: proviene del subsistema de impresión.
- **mail**: proviene del subsistema de correo electrónico.
- **news**: mensaje del subsistema *Usenet* (especialmente de un servidor *NNTP* — protocolo de transferencia de noticias en red, "*Network News Transfer Protocol*" — que administra grupos de noticias).
- **syslog**: mensajes del servidor **syslogd** en sí.
- **user**: mensajes de usuario (genéricos).
- **uucp**: mensajes del servidor *UUCP* (programa de copia Unix a Unix, "Unix to Unix Copy Program", un protocolo antiguo utilizado notablemente para distribuir correo electrónico).
- **local0 a local7** : reservados para uso local.

.. raw:: pdf

    Spacer 0 10

Cada mensaje tiene asociado también un nivel de prioridad. Aquí está la lista en orden decreciente:

- **emerg**: "¡Ayuda!" Hay una emergencia y el sistema probablemente está inutilizado.
- **alert**: apúrese, cualquier demora puede ser peligrosa, debe reaccionar inmediatamente.
- **crit**: las condiciones son críticas.
- **err**: error.
- **warn**: advertencia (error potencial).
- **notice**: las condiciones son normales pero el mensaje es importante.
- **info**: mensaje informativo.
- **debug** : mensaje de depuración.

.. raw:: pdf

    Spacer 0 20

Cada mensaje que se escribe a un **log** incluye la fecha y la referencia al subsistema de aplicaciones ("*facility*"); además del mensaje. Todo en una sola línea.

.. raw:: pdf

    PageBreak

El archivo /etc/rsyslog.conf
----------------------------

El archivo **/etc/rsyslog.conf** controla donde se escribe la información. Líneas que empiezan con un # son comentarios y son ignoradas por el **syslogd**. Las líneas en blanco, también son ignoradas.

El archivo /etc/rsyslog.conf en **Debian Jessie**:

.. code-block:: bash

	#  /etc/rsyslog.conf    Configuration file for rsyslog.
	#
	#                       For more information see
	#                       /usr/share/doc/rsyslog-doc/html/rsyslog_conf.html

	#################
	#### MODULES ####
	#################

	$ModLoad imuxsock # provides support for local system logging
	$ModLoad imklog   # provides kernel logging support
	#$ModLoad immark  # provides --MARK-- message capability

	# provides UDP syslog reception
	#$ModLoad imudp
	#$UDPServerRun 514

	# provides TCP syslog reception
	#$ModLoad imtcp
	#$InputTCPServerRun 514

	###########################
	#### GLOBAL DIRECTIVES ####
	###########################

	#
	# Use traditional timestamp format.
	# To enable high precision timestamps, comment out the following line.
	#
	$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat

	#
	# Set the default permissions for all log files.
	#
	$FileOwner root
	$FileGroup adm
	$FileCreateMode 0640
	$DirCreateMode 0755
	$Umask 0022

	#
	# Where to place spool and state files
	#
	$WorkDirectory /var/spool/rsyslog

	#
	# Include all config files in /etc/rsyslog.d/
	#
	$IncludeConfig /etc/rsyslog.d/*.conf

	###############
	#### RULES ####
	###############

	#
	# First some standard log files.  Log by facility.
	#
	auth,authpriv.*                 /var/log/auth.log
	*.*;auth,authpriv.none          -/var/log/syslog
	#cron.*                         /var/log/cron.log
	daemon.*                        -/var/log/daemon.log
	kern.*                          -/var/log/kern.log
	lpr.*                           -/var/log/lpr.log
	mail.*                          -/var/log/mail.log
	user.*                          -/var/log/user.log

	#
	# Logging for the mail system.  Split it up so that
	# it is easy to write scripts to parse these files.
	#
	mail.info                       -/var/log/mail.info
	mail.warn                       -/var/log/mail.warn
	mail.err                        /var/log/mail.err

	#
	# Logging for INN news system.
	#
	news.crit                       /var/log/news/news.crit
	news.err                        /var/log/news/news.err
	news.notice                     -/var/log/news/news.notice

	#
	# Some "catch-all" log files.
	#
	*.=debug;\
        	auth,authpriv.none;\
        	news.none;mail.none     -/var/log/debug
	*.=info;*.=notice;*.=warn;\
        	auth,authpriv.none;\
        	cron,daemon.none;\
        	mail,news.none          -/var/log/messages

	#
	# Emergencies are sent to everybody logged in.
	#
	*.emerg                         :omusrmsg:*

	#
	# I like to have messages displayed on the console, but only on a virtual
	# console I usually leave idle.
	#
	#daemon,mail.*;\
	#       news.=crit;news.=err;news.=notice;\
	#       *.=debug;*.=info;\
	#       *.=notice;*.=warn       /dev/tty8

	# The named pipe /dev/xconsole is for the `xconsole' utility.  To use it,
	# you must invoke `xconsole' with the `-file' option:
	#
	#    $ xconsole -file /dev/xconsole [...]
	#
	# NOTE: adjust the list below, or you'll go crazy if you have a reasonably
	#      busy site..
	#
	daemon.*;mail.*;\
		news.err;\
        	*.=debug;*.=info;\
        	*.=notice;*.=warn       |/dev/xconsole

La sintaxis del archivo **/etc/rsyslog.conf** está detallada en la página de manual rsyslog.conf , y en Debian también hay disponible documentación HTML en el paquete rsyslog-doc (*/usr/share/doc/rsyslog-doc/html/index.html*). El principio general es escribir pares de "*selector*" y "*acción*". El selector define los mensajes relevantes y la acción describe qué hacer con ellos.

Sintaxis del selector
+++++++++++++++++++++

El *selector* es una lista separada por punto y coma de pares: *subsistema.prioridad* (por ejemplo: auth.notice;mail.info ). Un asterisco puede representar todos los subsistemas o todas las prioridades (por ejemplo: *.alert o mail.* ). Puede agrupar varios subsistemas separándolos con una coma (por ejemplo: auth,mail.info ). La prioridad indicada también incluye los mensajes de prioridad igual o mayor; por lo tanto, auth.alert indica los mensajes del subsistema auth de prioridad alert o emerg . Si se agrega un signo de exclamación (!) como prefijo, indica lo contrario; en otras palabras, prioridades estrictamente menores. Por lo tanto, auth.!notice sólo incluye los mensajes del subsistema auth con prioridades info o debug . Si se agrega un signo igual (=) como prefijo corresponde única y exactamente con la prioridad indicada ( auth.=notice sólo incluye los mensajes del subsistema auth con prioridad notice ).

Cada elemento en la lista del *selector* reemplaza elementos anteriores. Así es posible restringir un conjunto o excluir ciertos elementos del mismo. Por ejemplo, kern.info;kern.!err significa los mensajes del núcleo con prioridades entre info y warn . La prioridad none indica el conjunto vacío (ninguna prioridad) y puede servir para excluir un subsistema de un conjunto de mensajes. Por lo tanto \*.crit;kern.none indica todos los mensajes con prioridad igual o mayor a crit que no provengan del kernel.

Sintaxis de las acciones
++++++++++++++++++++++++

Las acciones posibles son:

- agregar el mensaje a un archivo (ejemplo: */var/log/messages* ).
- enviar el mensaje a un servidor syslog remoto (ejemplo: *@log.falcot.com* ).
- enviar el mensaje a una tubería con nombre existente (ejemplo: *|/dev/xconsole* ).
- enviar el mensaje a uno o más usuarios si tienen una sesión iniciada (ejemplo: *root,rusuario* ).
- enviar el mensaje a todos los usuarios con sesiones activas (ejemplo: * ).
- escribir el mensaje en una consola de texto (ejemplo: */dev/tty8* ).

.. raw:: pdf

    Spacer 0 20

El símbolo menos (-) antes del nombre del archivo de **log** previene que el archivo sea sincronizado cada vez que se efectúan cambios. Normalmente, cuando un mensaje se escribe a un **log** este se escribe a *RAM*, y luego se agrega al archivo en el disco inmediatamente. Si se utiliza el (-) antes del nombre del **log**, el mensaje se escribe a RAM pero nunca se escribe al disco hasta que no ocurra la próxima rutina de sincronización de la *RAM* al disco.


log remoto
----------

En Debian, para aceptar mensajes de logs enviados desde otras máquinas se debe reconfigurar rsyslog. Es suficiente con activar ("*descomentar*") las líneas ya preparadas en el archivo */etc/rsyslog.conf* ( *$ModLoad imudp y $UDPServerRun 514* ).

Uno de los principales usos del log remoto, es permitir que se instale un servidor dedicado que reciba todos los logs de todo el sistema de red. Esto proporciona mayor seguridad, además de tener copia de los logs generados.


klogd
-----

**GNU/Linux** tiene una utilidad llamada **klogd**, con la única función de escuchar los mensajes producidos por el **kernel**. Los mensajes del **Kernel** son procesados dando los siguientes pasos:

	1) Una parte del **Kernel** hace una llamada para crear una entrada al registro del sistema.
	2) El **klogd daemon** recibe el mensaje desde */proc/kmsg* donde el **kernel** lo dejó disponible a los programas externos.
	3) El campo de prioridad del mensaje se convierte del formato de mensajes del **kernel** (un dígito del 0 al 7) al formato compatible con el del **syslog**.
	4) El mensaje es enviado a **syslogd**, donde es reconocido como un **log** del sistema y procesado como tal.


.. raw:: pdf

    PageBreak

Comandos relacionados
=====================

dmesg
-----

Los mensajes del arranque del sistema del *kernel* son registrados en el archivo */var/log/dmesg*. Este archivo contiene la información del subsistema del *kernel* y de las cargas de los modules durante el tiempo de encendido. En general, los *drivers* despliegan información de diagnostico de cada dispositivo y de su modulo. Si un *driver* no se puede cargar por una mala configuración o problema del hardware, esa información se escribirá en el archivo. Este archivo puede ser accedido directamente con un editor de texto o a través del comando **dmesg**.

lastlog
-------

Invocar el comando **lastlog**, dará como resultado una lista de los usuarios del sistema y la información de la ultima vez que ingresaron al mismo, incluyendo de qué máquina y a través de qué puerto y la fecha. Si el usuario nunca ingresó al sistema también será indicado. El comando **lastlog** recibe su información desde el archivo de log */var/log/lastlog* , el cual es un archivo binario. No legible desde un editor de texto.

Si no se le pasan opciones, **lastlog** muestra las entradas ordenadas por *UID* . Si se utiliza la opción *-t* , **lastlog** desplegará todos los ingresos durante un tiempo especificado de días. Con la opción *-u* , **lastlog** desplegará el último ingreso del usuario especificado.


last
----

El comando **last** muestra todos los ingresos (*login*) al sistema, listados en el archivo de log binario */var/log/wtmp* . En este archivo se menciona qué usuarios entraron o salieron, cuándo y dónde se originó la conexión. Es posible que **last** liste a un mismo usuario más de una vez.

También existe una variación del comando llamada **lastb**, que lista los intentos de *login* que no pudieron validarse correctamente. Utiliza el archivo */var/log/btmp* (si no existe puede ser necesario crearlo). Estos mismos fallos de autenticación también suelen enviarse al **log** *auth.log* .

who , w y finger
----------------

Los comandos **who** y **w** son usados para determinar quién está actualmente dentro del sistema (*logged in*). El comando **w** también muestra el tiempo que el usuario permaneció dentro del sistema. Estos comandos utilizan el archivo binario */var/log/utmp* .

El comando **finger** muestra la información contenida en el campo de comentarios del archivo */etc/passwd*, de los usuarios que están actualmente dentro del sistema. **finger** también utiliza el archivo binario */var/log/utmp* .

logger
------

El programa **logger** es una simple herramienta que permite colocar mensajes con la fecha actual en el archivo */var/log/messages* .

Utilizar **logger** es sencillo:

.. code-block:: bash

	$ logger Prueba de mensaje desde la xterm de gnome.


El registro se escribirá en el log en forma similar a:

.. code-block:: bash

	Jul. 27 14:22:45 gnome3 gnome: Prueba de mensaje desde la xterm de gnome.

.. raw:: pdf

    PageBreak

logrotate
=========

Los **logs** siempre están recolectando información. El archivo */var/log/syslog* es donde la mayoría de los mensajes del sistema se registran. Este archivo puede crecer rápidamente. Si se dejase solo, continuaría creciendo de tamaño hasta llegar a ser imposible de manejar. Muchos archivos de **logs** tienden a volverse excesivamente grandes (especialmente si se tratan de los **logs** de algún servicio especial, como un servidor web o un servidor de correo electrónico), lo que hace necesario que sean administrados.

El esquema más común es el del archivado rotativo: el archivo de **log** es almacenado regularmente y sólo se mantienen los últimos *N* archivos.

Esta tarea puede realizarse de forma manual. Periódicamente habría que revisar y limpiar los archivos de **logs**. Hacer esto, lleva a tener que decidir si se quiere salvar la información vieja o no (lo que se conoce como rotar los **logs**). Una manera sería copiar o mover periódicamente cada archivo de **log** que se desea conservar a otro sitio. Luego hay dos opciones, o recrear el archivo de **log** (si el original fue movido) o vaciar el **log** original (si se copió a otro directorio). Además en muchos casos, sería necesario reiniciar el servicio que hace uso del **log**.

De esta forma sería posible conservar los **logs** más viejos mientras también se mejora el funcionamiento del sistema. Sin embargo, a medida que el número de **logs** viejos se incrementa, será necesario decidir si se desea archivarlos, o sólo eliminar los **logs** más viejos. Esto dependerá de la importancia de conservar esos registros en el tiempo. Si es una simple estación de trabajo, no suele ser necesario mantener **logs** viejos.

Para simplificar este proceso, se puede hacer uso del comando **logrotate** . El cual tiene la capacidad de rotar los archivos de **logs**, comprimirlos o remover los **logs** viejos. Esta actividad puede ser basada en el tiempo (por ejemplo diariamente) o en el tamaño del **log**.

**Debian**, al igual que muchas distribuciones, utiliza **logrotate** para la rotación general de los archivos de **logs** del sistema.

La sintaxis de **logrotate** es:

**logrotate [opciones] archivo_de_configuración**

Por defecto, **logrotate** almacena información sobre su estado en el sistema en el archivo */var/lib/logrotate/status* , pero este comportamiento puede ser sobrescrito usando la opción *-s* y el nombre de otro archivo. Se le puede pasar más de un archivo de configuración al comando **logrotate** pero las instrucciones contenidas en el último archivo pueden sobrescribir las de los anteriores.

**logrotate** responde a las directivas presentes en el archivo */etc/logrotate.conf*, y a todos los archivos en el directorio */etc/logrotate.d/* . El administrador puede modificar estos archivos si desea adaptar la política por defecto de rotación de **logs** definida en **Debian**. Entre las opciones posibles, se podría desear aumentar la cantidad de archivos mantenidos en la rotación, o mover los archivos de **logs** a un directorio específico dedicado a su archivado, en lugar de eliminarlos. También puede enviar los **logs** por *email* para archivarlos en otro lado. La página del manual de **logrotate** describe todas las opciones disponibles en estos archivos de configuración. El programa **logrotate** es ejecutado diariamente por la aplicación *cron*.

.. raw:: pdf

    PageBreak

El archivo */etc/logrotate.conf* en **Debian Jessie**:

.. code-block:: bash

	# see "man logrotate" for details
	# rotate log files weekly
	weekly

	# keep 4 weeks worth of backlogs
	rotate 4

	# create new (empty) log files after rotating old ones
	create

	# uncomment this if you want your log files compressed
	#compress

	# packages drop log rotation information into this directory
	include /etc/logrotate.d

	# no packages own wtmp, or btmp -- we'll rotate them here
	/var/log/wtmp {
	    missingok
	    monthly
	    create 0664 root utmp
	    rotate 1
	}

	/var/log/btmp {
	    missingok
	    monthly
	    create 0660 root utmp
	    rotate 1
	}

	# system-specific logs may be configured here


Las primeras entradas en */etc/logrotate.conf* son definiciones de variables globales. Todos los **logs** las utilizarán, salvo que se especifique lo contrario en una entrada separada (en **Debian** generalmente en un archivo dentro de */etc/logrotate.d/*). Las entradas referidas a */var/log/wtmp* y a */var/log/btmp* son específicas.

Algunas de las opciones posibles de utilizar en una configuración de **logrotate** son:

- **compress**: Usa *gzip* para comprimir los **logs** viejos.
- **copytruncate**: Copia los **logs** y trunca el **log** viejo.
- **create**: Aplica los permisos señalados al nuevo **log**. Si no se especificaron permisos, se usan los permisos del **log** viejo.
- **daily**: Rotación diaria del **log**.
- **delaycompress**: Comprime en la próxima rotación.
- **ifempty**: Rota el **log** vacío.
- **include** *nombre_de_archivo_o_directorio*: Lee el archivo indicado, o los archivos dentro del directorio especificado.
- **mail** *email*: Envía el **log** a la dirección especificada, cuando es eliminado.
- **monthly**: Rota los **logs** mensualmente.
- **nocompress**: No comprime.
- **nocopytruncate**: No copia ni trunca el **log**.
- **nocreate**: No usa permisos especificados al crear.
- **nodelaycompress**: Comprime ahora.
- **noolddir**: No se mueve a otro directorio.
- **notifempty**: No comprime el **log** vacío.
- **olddir** *directorio*: Mueve **logs** viejos al directorio especificado.
- **postrotate**: Ejecuta un script después de rotar el **log**.
- **prerotate**: Ejecuta un script antes de rotar el **log**.
- **rotate** *n*: Específica el número de **logs** viejos a conservar.
- **size** *n*: Rota cuando el **log** llegue a *n bytes* (se agrega una *k* para especificar *kilobytes* o *M* para especificar *megabytes*).

.. raw:: pdf

    Spacer 0 20

dmesg
=====

Uno de los mayores usos de los archivos de **logs** es diagnosticar y resolver problemas del sistema.

Una forma de diagnosticar problemas del sistema detectados durante la etapa de arranque, es utilizar el comando **dmesg** para desplegar el mensaje del sistema desde el *kernel ring buffer*.

La sintaxis del **dmesg** es:

.. code-block:: bash

	dmesg [opciones]

Por defecto, el comando **dmesg** (ejecutado sin parámetros) mostrará toda la información registrada. Sin embargo tiene muchas opciones posibles que facilitan su lectura.

Pueden verse las opciones con el comando:

.. code-block:: bash

	dmesg --help

.. raw:: pdf

    Spacer 0 20

Bibliografía
============

The Debian Administrator's Handbook, Raphaël Hertzog and Roland Mas, ( `https://debian-handbook.info/ <https://debian-handbook.info/>`_ )

Administración Avanzada del Sistema GNU/Linux ( `<http://openaccess.uoc.edu/webapps/o2/handle/10609/226>`_ )

Básicamente GNU/Linux, Antonio Perpiñan, Fundación Código Libre Dominicano ( `http://www.codigolibre.org <http://www.codigolibre.org>`_ )

Administración de Sistemas GNU/Linux, Guía de Estudio hacia una capacitación segura, Antonio Perpiñan, Fundación Código Libre Dominicano ( `http://www.codigolibre.org <http://www.codigolibre.org>`_ )

===========================================================
UNIDAD VI - Programación de tareas sincrónicas y asíncronas
===========================================================

La idea detrás del uso de computadoras es, entre otras cosas, automatizar tareas que toman mucho tiempo o son tediosas para los humanos. Una gran parte de las funciones de un administrador de sistemas involucra la ejecución de tareas repetitivas. La capacidad de poder programar estas tareas se convierte en un gran aliado. Una forma, es a través de los shell scripts, los cuales combinan una serie de comandos y lo convierten en un solo comando. Otra manera de automatizar tareas de administración del sistema es programar la computadora para que ejecute comandos automáticamente en tiempos específicos. En las tareas de administración, suele ser necesaria la ejecución a intervalos de ciertas tareas, ya sea por programar las tareas para realizarlas en horarios de menor uso de la máquina, o bien por la propia naturaleza periódica de las tareas que se quieran desarrollar.

Los mecanismos que provee **GNU/Linux** para lograr esto son los sistemas **cron**, **anacron** y **at**, los cuales pueden ser utilizados para ejecutar un simple comando o una serie de comandos dentro de un *shell script*. Es posible programar una tarea que nos recuerde algún evento o ejecutar un programa automáticamente. Puede ser un evento que ocurre una sola vez o que se repite en intervalos regulares. **GNU/Linux** tiene la capacidad de hacer ambos automáticamente.

**cron** es el demonio responsable de ejecutar tareas programadas y recurrentes (todos los días, todas las semanas, etc.); **atd** está encargado de los programas a ejecutarse una sola vez, pero en un momento específico en el futuro.

En un sistema **Unix**, muchas tareas están programadas para ejecutarse regularmente:

	- Rotar los archivos de logs.
	- Actualizar la base de datos del programa locate.
	- Realizar backups.
	- Ejecutar scripts de mantenimiento (como limpiar los archivos temporales).

.. raw:: pdf

    Spacer 0 20

at
==

La orden **at** ejecuta un programa en un momento específico en el futuro. Estas tareas funcionan solamente una vez, no sobre una base que se repite. Obtiene la fecha y hora deseada como parámetros y el programa a ejecutar en su entrada estándar. Ejecutará el programa como si hubiese sido ingresado en la consola actual, incluso se encarga de mantener el entorno para poder reproducir las mismas condiciones al ejecutar el programa, incluyendo el *pwd* y directorio, por eso si lo que se programa es un *script*, es recomendable utilizar la ruta completa para prevenir posibles errores en la ejecución.

La sintaxis del comando **at** es:

.. code-block:: bash

	at [opciones] fecha


Por ejemplo, para ejecutar un trabajo a las *4pm*, tres días a partir de ahora, el comando es:

.. code-block:: bash

	at 4pm + 3 days

Para ejecutar un trabajo a las *10am del 16 de Agosto*:

.. code-block:: bash

	at 10am Agosto 16

Para lanzar un trabajo a la *1am de mañana*:

.. code-block:: bash

	at 1am tomorrow


Algunas de las opciones que pueden ser usadas con el comando **at** son:

	- **b**: Ejecuta trabajos cuando la carga del sistema es baja (alias de **batch**).
	- **d**: Elimina trabajos (*job*). Igual al comando **atrm**.
	- **f archivo**: Lee los trabajos (*job*) desde el archivo especificado.
	- **l**: Lista todos los *jobs* del usuario. Igual al comando **atq**.
	- **m**: Envía un correo al usuario cuando el trabajo se completó.

.. raw:: pdf

    Spacer 0 10

Usar el comando **at** es muy simple y consiste en tres pasos muy fáciles:

	1. Escribir **at** con cualquier opción y la fecha de ejecución.
	2. Escribir el comando que se pretende ejecutar.
	3. Utilizar *Ctrl+D* para guardar el trabajo.

.. raw:: pdf

    Spacer 0 10

Después que **at** ejecuta un trabajo, puede enviar un correo con los mensajes de errores o para notificar que el trabajo se completó. El comando **at** puede ejecutar un trabajo sólo una vez, y después de haberlo ejecutado, se elimina de la cola de trabajos (*queue*).


Es posible utilizar el comando **at** como recordatorio de algún evento:

.. code-block:: bash

	$ at 07:39
	warning: commands will be executed using /bin/sh
	at> echo "Buenos días!"
	at> <EOT>
	job 11 at 2017-09-06 07:39


También es posible ejecutar más de un comando:

.. code-block:: bash

	$ at 08:01
	warning: commands will be executed using /bin/sh
	at> echo "Buenos días!"
	at> echo "Buenos días lista!" | mail listadmin@debian.org
	at> <EOT>
	job 12 at 2017-09-06 08:01

En este caso los comando serán ejecutados en orden secuencial.


**Nota**: La advertencia de utilizar */bin/sh*, puede ser significativa si (por ejemplo) se usa por defecto el *tcsh* en vez del *bash* porque los dos tienen una sintaxis un poco diferente.


Si la intención es volver a ejecutar ciertos comandos varias veces, se pueden escribir los mismos en un archivo y utilizar la opción *-f* de **at**.

.. code-block:: bash

	at 11:10 -f archivo.txt


Parámetros indicadores de tiempo
--------------------------------

**at** soporta muchas combinaciones para indicar los parámetros de tiempo, pero es posible clasificarlas en tres grupos:

	1. Por hora, formato *HH:MM*
	2. Por día de la semana con número o por nombre.
	3. Por palabras:  *midnight* (medianoche), *noon* (tarde), *teatime* (4 p.m.), *today* (hoy), *tomorrow* (mañana), y *now* (ahora).

.. raw:: pdf

    Spacer 0 10

**at** es muy flexible en aceptar formatos de fecha y hora. Es posible especificar el tiempo en formato de *hh:mm* o simplemente la hora. Cuando se especifica una hora, se asume que se está usando el reloj de 24 horas, así que las *4p.m*. es expresada como las *16:00*. También se puede programar tareas relativas al momento presente, como es el número de minutos, horas, días, semanas, o años midiendo desde ahora. Usar *now* como el tiempo también va a requerir un incremento de la fecha. El incremento es seguido por minuto(s), hora(s), día(s), o semana(s).

.. code-block:: bash

	#Algunos ejemplos

	at 23:15 -f hacer-backup.sh
	at + 3 hours -f actualizar-db.bash
	at now sat reboot


También es posible especificar la fecha en varios formatos europeos u occidentales, incluyendo *DD.MM.AA* (*27.07.17* representaría el 27 de Julio de 2017), *AAAA-MM-DD* (la misma fecha se representaría como *2017-07-27*), *MM/DD/[CC]AA* (es decir: *12/25/17* o *12/25/2017* representan, ambas, el 25 de Diciembre de 2017) o simplemente *MMDDCCAA* (de forma que *122517* o *12252017* también representaría el 25 de Diciembre de 2017). Sin fecha, ejecutará el programa tan pronto como el reloj indique la hora especificada (el mismo día o el siguiente si ya pasó dicha hora ese día).

.. code-block:: bash

	# Algunos ejemplos más

	$ at now + 3 hour
	$ at 6:10pm + 1 days
	$ at 5:30 tomorrow
	$ at 2am
	$ at 8pm 12/23/2017
	$ at 9:35 Jul 26
	$ at 6 Saturday


Algunos comandos
----------------

Para ver los trabajos que han sido programados, se puede usar el comando **atq**, o **at -l**.

.. code-block:: bash

	# at -l
	1 2017-07-26 20:00 a root
	2 2017-07-26 20:00 a root
	3 2017-07-27 08:00 a root
	5 2017-07-27 08:00 a root
	6 2017-07-26 09:00 a root
	7 2017-07-26 09:00 a root

.. code-block:: bash

	# atq
	1 2017-07-26 20:00 a root
	2 2017-07-26 20:00 a root
	3 2017-07-27 08:00 a root
	5 2017-07-27 08:00 a root
	6 2017-07-26 09:00 a root
	7 2017-07-26 09:00 a root

Ambos comandos hacen la misma cosa, sólo cambia la sintaxis. Si se ejecuta como *root*, se listaran los trabajos enumerados de todos los usuarios, pero es posible listar sólo los trabajos de un usuario en particular. La mayoría de las versiones de **at** no permiten que usuarios normales listen los trabajos de otros usuarios.

Para ver exactamente qué comandos en particular ejecutara un trabajo, se utiliza **at -c**. Listará todos los comandos que serán ejecutados. Adicionalmente podrá mostrar muchas definiciones de variable de entorno y de cambios de directorio porque **at** ejecuta los trabajos en el mismo ambiente que fueron creados.

El comando **atrm** o **at -d**, permite remover o quitar trabajos en cola. Sólo precisa que se le indique el *número de trabajo*.

.. code-block:: bash

	$ atrm 13
	$ at -d 13

Para determinar el *número de un trabajo*, se puede usar **at -l** o **atq**.


at.allow y at.deny
------------------

Ejecutar trabajos **at** utiliza recursos del sistema. Si muchos usuarios ejecutan trabajos largos y complejos al mismo tiempo, esto puede resultar en un efecto adverso al buen funcionamiento del mismo. Hay dos archivos que controlan la capacidad del usuario de poder ejecutar trabajos **at**, el */etc/at.allow* y el */etc/at.deny*. Cuando un usuario trata de ejecutar un trabajo **at**, el sistema primero revisa si existe el archivo */etc/at.allow* y si contiene el nombre del usuario. Si el nombre del usuario está ahí, el acceso al uso del comando **at** y de programar trabajos es permitido. Si el archivo */etc/at.allow* no existe, se revisa el archivo */etc/at.deny*. Para prohibir a un usuario programar trabajos **at**, es suficiente con agregarlo al archivo */etc/at.deny*. Cualquier usuario que no es mencionado en el archivo */etc/at.deny* podrá hacer uso del comando **at**. Si ambos archivos existen, **at** primero revisa el archivo */etc/at.allow*. Si el usuario que está requiriendo programar un trabajo con **at** está listado en el archivo */etc/at.allow*, entonces tendrá acceso, y **at** no revisará el archivo */etc/at.deny*. Si se pretende prevenir que todos los usuarios puedan programar tareas con **at**, simplemente se debe borrar el archivo */etc/at.deny*. Si el archivo */etc/at.deny* existe pero esta vacío, todos los usuarios podrán ejecutar trabajos **at**. Si ninguno de los dos archivos existe, solamente el usuario *root* podrá utilizar el comando **at**.

Si los usuarios de un sistema tienen permitido programar tareas usando el comando **at**, será necesario revisar periódicamente la carga a la cual se somete el sistema.

.. raw:: pdf

    PageBreak

Batch
=====

El comando **batch** es idéntico a ejecutar **at -b** y programar un trabajo para ejecutarse una sola vez.

Su sintaxis es:

.. code-block:: bash

	batch [opciones] [tiempo]

Soporta las mismas opciones que se usan con **at**. Si no se especifica ningún tiempo con **batch**, el trabajo se ejecutará en el momento en que la carga del sistema este baja. Si se especifica un tiempo, el trabajo se ejecutará cuando la carga del sistema baje después del tiempo especificado. El comando **batch** examina el archivo */proc/loadavg* para revisar la carga del sistema. Se ejecuta cuando el promedio (*average*) de la carga del sistema cae por de bajo de *1.5*.

Los comandos que se ejecutan desde **batch** o **at -b** se ejecutan con una prioridad inferior que si se ejecutasen en *background* (segundo plano). No como los trabajos que se ejecutan en el *background*, los cuales son terminados (*killed*) cuando se sale del sistema (*log off*), los comandos **batch** continúan hasta que se apague el sistema. Además, **batch** envía un mensaje de correo al momento que el trabajo se completa o si ocurre algún error.

Los trabajos sometidos vía los comandos **at** y **batch** son manejados por el *daemon* **atd**. Este programa mantiene una cola de los trabajos y de los tiempos en que los mismos serán ejecutados. El *daemon* **atd** no necesita comprobar para saber si hay trabajos nuevos, solo espera hasta que sea hora de comenzar un trabajo ya en cola o cuando el comando **at** le dice que agregue algo a la misma. La opción *-1* de **atd**, permite especificar el promedio de carga máxima por debajo de la cual se permite la ejecución de los trabajos.


cron
====

Es un sistema para programar procesos que van a ser ejecutados con regularidad. Alguno de sus usos más comunes son para arrancar un backup, para rotar archivos de logs y para inicializar scripts del sistema. El sistema cron consiste de un daemon y un archivo de configuraciones por usuario. Cada archivo de configuración es denominado crontab. Cada entrada del archivo crontab se llama evento o trabajo.

El demonio cron
---------------

Como en la mayoría de los servicios del sistema, la funcionalidad de cron es provista por un sistema *daemon* **cron** o **crond** dependiendo de la distribución utilizada. El **Cron** lee el archivo de configuración para determinar cuales comandos debe ejecutar y cuando. Cada un minuto **cron** lee todos los archivos **crontab** para ver qué comando debe ejecutar. Si encuentra una entrada que coincida con la hora actual, ejecuta el
comando correspondiente con el *UID* del dueño del archivo **crontab**. **Cron** puede ser configurado para permitir o denegar a usuarios específicos la habilidad para programar eventos. Los archivos para especificar quien puede utilizar **cron** son */etc/cron.allow* y */etc/cron.deny*. Si el archivo *cron.allow* existe, sólo los usuarios listados en el pueden utilizar **cron**, si el archivo no existe, sólo los usuarios que no aparecen en el archivo *cron.deny* podrán ejecutar tareas. Un archivo *cron.deny* vacío significa que todos los usuarios pueden utilizar **cron**.

Si los archivos no existen el programa puede permitir, o a todos los usuarios, o sólo a *root* (esto es dependiente de la configuración y la distribución en uso). El **cron** mantiene un directorio en *spool* para almacenar los archivos **crontab**. Casi siempre este directorio se encuentra en */var/spool/cron* y contiene un archivo **crontab** para cada usuario que tiene un trabajo programado. Normalmente la salida del trabajo ejecutado por **cron** es enviada por correo al usuario. Esto puede ser cambiado y redireccionar la salida a un archivo o especificar un usuario diferente para enviar el correo.

De forma predeterminada, todos los usuarios pueden programar tareas para ejecutar. Cada usuario tiene su propio **crontab** en el que pueden almacenarlas. Pueden editarlo ejecutando **crontab -e** (el contenido del mismo es almacenado en el archivo */var/spool/cron/crontabs/usuario*).

El usuario *root* tiene su propio **crontab**, pero también puede utilizar el archivo */etc/crontab* o escribir archivos **crontab** adicionales en el directorio */etc/cron.d* . Estas dos últimas soluciones tienen la ventaja de poder especificar el usuario bajo el que se ejecutará el programa.

De forma predeterminada, el paquete **cron** incluye algunas tareas programadas que ejecutan:

	- Programas en el directorio */etc/cron.hourly/* una vez por hora.
	- Programas en el directorio */etc/cron.daily/* una vez por día.
	- Programas en el directorio */etc/cron.weekly/* una vez por semana.
	- Programas en el directorio */etc/cron.monthly/* una vez por mes.

.. raw:: pdf

    Spacer 0 10

Muchos paquetes **Debian** dependen de este servicio: agregan sus *scripts* de mantenimiento en estos directorios, los cuales garantizan un funcionamiento óptimo de sus servicios.


El archivo crontab
------------------

El archivo **crontab** le dice al *daemon* **cron** qué programas debe ejecutar y cuando. Cada usuario tiene un archivo **crontab** y también existe un archivo **crontab** en el directorio */etc*. El programa utilizado para administrar los archivos **crontab** también se llama **crontab**.

Existen dos tipos de entrada: *definición de variables de entorno* y *eventos*. Una *variable de entorno* define un comportamiento o información a utilizar por **cron** para todos los eventos. Una *variable de entorno* se asigna mediante un símbolo de "*=*" y un valor asociado. Por ejemplo, la variable *SHELL=/bin/sh*, define el *shell* a utilizar por **cron** para la ejecución de los eventos indicados en el archivo. Hay una variable de entorno especial denominada *MAILTO* que especifica dónde se debe de enviar la salida. Si se deja en blanco (*MAILTO=""*), toda la salida es ignorada. Por defecto la salida es enviada al correo del dueño del archivo **crontab**.

La mayor parte de las entradas en el archivo **crontab** son eventos, un evento tiene dos partes: el tiempo en que el evento se ejecuta, y qué hacer cuando llegue el momento de ejecutarlo. Cinco campos en la entrada del evento representan tiempos. En este orden, ellas son: minuto, hora, día del mes, mes y día de la semana. Los campos son separados por espacios o tab. Las horas se representan en 24 horas. En el campo del día de la semana es posible utilizar: o cero o siete para domingo, y los otros días en orden numérico.

Un evento se ejecuta cuando el tiempo del campo coincide con el tiempo actual. El **cron** revisa una vez por minuto para encontrar entradas que deben ser iniciadas. Para que un evento sea iniciado, cada campo de tiempo debe coincidir con el tiempo actual, excepto para el día de la semana y para el día del mes, entre estos dos campos, solo uno necesita coincidir.

Detalle de los campos
+++++++++++++++++++++

	- **minuto**: número de 0 a 59.
	- **hora**: número de 0 a 23.
	- **día**: número del día del mes, de 1 a 31 (o a 30, o a 28, o a 29, según el mes).
	- **mes**: número de 1 a 12.
	- **semana**: número de 0 a 7, donde 1 es el lunes y el domingo es tanto el 0 como el 7. También es posible utilizar las tres primeras letras del nombre del día en inglés, como Sun, Mon, etc.).
	- **usuario**: el nombre de usuario bajo el que se ejecutará el programa (en el archivo */etc/crontab* y en los fragmentos ubicados en */etc/cron.d/* , pero no en los archivos de cada usuario).
	- **comando**: el programa a ejecutar (cuando se cumpla la condición definida por los primeros cinco campos).

.. raw:: pdf

    Spacer 0 10

Todos estos detalles están documentados en el manual de **crontab**.

En los primeros cinco campos, cada valor puede expresarse como una lista de valores posibles (separados por coma). La sintaxis *a-b* describe el intervalo de todos los valores entre *a* y *b*. La sintaxis *a-b/c* describe el intervalo con un incremento de *c* (por ejemplo: 0-10/2 es lo mismo que *0,2,4,6,8,10* . Un asterisco "*" es un comodín y representa todos los valores posibles.

Los siguiente es un ejemplo del archivo crontab.

.. code-block:: bash

	MAILTO = root
	0   *   *    *   *    echo "Ejecuta cada hora."
	0   1.2 *    *	 *    echo "Ejecuta a la 1 AM y 2 AM."
	13  2   1    *	 *    echo "Ejecuta a las 2:13AM el primer día de cada mes."
	9   17  *    *	 1-5  echo "Ejecuta a las 5:09PM todos los días de semana."
	0   0   1    1	 *    echo "Feliz año Nuevo!"
	0   6   */2  *	 *    echo "Ejecuta a las 6AM los días de fecha par."


Se debe tener especial cuidado de que todos los campos de tiempo estén correctos. Ya que no se recibirá ningún mensaje de aviso ante un error de sintaxis, y seguramente, el evento no se ejecutara como se espera.

Otro ejemplo:

.. code-block:: bash

	#Formato
	#min hora día mes dds programa

	# Descargar los datos todas las noches a las 19:25
	25	19	*	*	*	$HOME/bin/descargar.pl

	# 08:00 en días de semana (Lunes a Viernes)
	00	08	*	*	1-5	$HOME/bin/haceralgo

	# Reiniciar el proxy luego de cada reinicio
	@reboot /usr/bin/proxy

.. raw:: pdf

    PageBreak

Atajos de texto para cron
+++++++++++++++++++++++++

**cron** reconoce algunas abreviaciones que reemplazan los primeros cinco campos de un elemento de **crontab**. Corresponden a las opciones de programación más comunes:

	- **@yearly**: una vez por año (1 de Enero a las 00:00).
	- **@monthly**: una vez por mes (el primer día del mes a las 00:00).
	- **@weekly**: una vez por semana (Domingo a las 00:00).
	- **@daily**: una vez por día (a las 00:00).
	- **@hourly**: una vez por hora (al principio de cada hora).
	- **@reboot**: una vez, al inicio del sistema.
	- **@annually**: igual que **@yearly**.
	- **@midnight**: igual que **@daily**.

.. raw:: pdf

    Spacer 0 10

Algunas opciones del comando crontab
------------------------------------

Los archivos de **crontab** no deben editarse directamente en el directorio */var/spool/cron*. Debe utilizarse siempre el comando:

.. code-block:: bash

	crontab -e

Este comando utilizara el editor por defecto definido en las variables de entorno *VISUAL* o *EDITOR*. Si ninguna está definida, utilizara el *vi*, que suele ser el editor por defecto en la mayoría de las distribuciones de **GNU/Linux**.

Para mostrar los eventos o tareas del **crontab**:

.. code-block:: bash

	crontab -l

Para remover todo el contenido del **crontab**:

.. code-block:: bash

	crontab -r

Se le puede indicar a **crontab** que lea los eventos desde un archivo en particular:

.. code-block:: bash

	crontab /home/usuario/mi_crontab


La opción *-u*, permite indicarle a crontab el usuario asociado al archivo que se requiere utilizar:

.. code-block:: bash

	crontab -u miusuario /home/miusuario/archivo_crontab

Si se ejecuta como *root*:

.. code-block:: bash

	crontab	-u usuario

es posible listar los eventos de ese usuario en particular.

.. raw:: pdf

    PageBreak

anacron
=======

**anacron** es el demonio que completa **cron** en equipos que no están encendidos todo el tiempo. Dado que generalmente las tareas recurrentes están programadas para la mitad de la noche, no se ejecutarán nunca si la máquina está apagada en esos momentos. El propósito de **anacron** es ejecutarlas teniendo en cuenta los períodos de tiempo en los que el equipo no estuvo funcionando. **anacron** frecuentemente ejecutará dichos programas unos minutos después de iniciar la máquina, lo que utilizará poder de procesamiento del equipo. Es por esto que se ejecutan las tareas en el archivo */etc/anacrontab* con el programa *nice* que reduce su prioridad de ejecución, limitando así su impacto en el resto del sistema.

El formato del archivo de **anacron** no es el mismo que el de */etc/crontab*.

Ejemplo:

.. code-block:: bash

	# /etc/anacrontab: configuration file for anacron

	# See anacron(8) and anacrontab(5) for details.
	SHELL=/bin/sh
	PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
	HOME=/root
	LOGNAME=root

	# These replace cron's entries
	# periodo  #retraso  #identificador de tarea  #comando
	1 	   5 	     cron.daily 	      run-parts --report /etc/cron.daily
	7 	   10 	     cron.weekly 	      run-parts --report /etc/cron.weekly
	@monthly   15 	     cron.monthly 	      run-parts --report /etc/cron.monthly


El archivo tiene, al igual que en el caso de */etc/crontab*, las definiciones de las variables de entorno. Luego tiene tres líneas de eventos con las siguientes columnas:

	- **periodo**: Es un número que indica cada cuántos días debe ejecutarse el comando (al igual que en cron, se pueden utilizar atajos: @daily, @weekly, @monthly o @yearly).
	- **retraso**: Es un número que indica cuántos minutos debe esperar **anacron** a partir de que el demonio se haya iniciado, para ejecutar el comando.
	- **identificador de tarea**: Indica si la tarea es diaria, semanal, o mensual.
	- **comando**: Es el comando a ejecutar.

.. raw:: pdf

    Spacer 0 10

En el ejemplo anterior, **anacron** ejecuta los scripts que están dentro de los directorios */etc/cron.daily*, */etc/cron.weekly* y */etc/cron.monthly*.

.. raw:: pdf

    Spacer 0 10

Algunas opciones del comando anacron
------------------------------------

Para que anacron ejecute las tareas programadas de forma secuencial:

.. code-block:: bash

	anacron -s

Para que anacron ejecute las tareas sin tener en cuenta ni la fecha ni la hora:

.. code-block:: bash

	anacron -f

Para que anacron ejecute las tareas sin tener en cuenta el tiempo de retraso configurado:

.. code-block:: bash

	anacron -n


Instalar el paquete **anacron** desactiva la ejecución vía **cron** de los scripts en los directorios */etc/cron.hourly/* , */etc/cron.daily/* , */etc/cron.weekly/* y */etc/cron.monthly/* . Esto evita que sean ejecutados más de una vez (tanto por **anacron** como por **cron**). El programa **cron** continuará activo y seguirá administrando otras tareas programadas (especialmente aquellas programadas por los usuarios mediante **crontab**).

.. raw:: pdf

    Spacer 0 20

cron versus anacron
===================

Se presenta una pequeña tabla comparativa.

.. raw:: pdf

    Spacer 0 10

+---------------------------------------------+---------------------------------------------+
|		Cron			      |			Anacron			    |
+=============================================+=============================================+
|Ideal para servidores			      | Ideal para notebooks y PC de escritorios.   |
+---------------------------------------------+---------------------------------------------+
|Cron espera que el sistema esté corriendo 24 |Anacron no espera que el sistema esté activo |
|horas. Si hay una tarea programada, y el     |las 24 horas. Si una tarea programada y el   |
|sistema se detiene antes de ese horario, la  |sistema se detiene durante ese tiempo, la    |
|tarea no será ejecutada.                     |tarea será ejecutada cuando el sistema esté  |
|					      |operativo nuevamente.			    |
+---------------------------------------------+---------------------------------------------+
|La menor granularidad de tiempo es el minuto |La menor granularidad de tiempo es el día.   |
|(por ejemplo, una tarea puede ejecutarse cada| 					    |
|minuto).				      |						    |
+---------------------------------------------+---------------------------------------------+
|Las tareas pueden ejecutarlas los usuarios   |Sólo puede ser utilizado por el usuario root |
|normales (mientras el usuario root no haya   |(aunque existen maneras de que un usuario    |
|restringido esta posibilidad).       	      |normal pueda ejecutar tareas también).       |
+---------------------------------------------+---------------------------------------------+
|Cron debe utilizarse cuando una tarea        |Anacron debe utilizarse cuando una tarea     |
|requiera ser ejecutada a una hora particular.|requiera ser ejecutada independientemente de |
|					      |la hora.					    |
+---------------------------------------------+---------------------------------------------+

