=============
Acceso remoto
=============

Entre las tareas que tiene un administrador de sistemas, está el poder conectarse por red y realizar la gestión de servidores en forma remota. Es esencial el poder conectarse a un equipo de forma remota. Los servidores, aislados en su propia habitación, rara vez están equipados con monitores y teclados permanentes, pero están conectados a la red. Pensar hoy a un administrador sin acceso remoto a los sistemas, es imposible.

Para este fin, se desarrollaron una serie de comandos y metodologías que contemplan acciones como:

- copia remota de archivos.
- ejecución de comandos en una terminal remota.
- autenticación por medio de usuario y contraseña en una terminal remota.

.. raw:: pdf

    Spacer 0 10

entre otros.

Si bien estos comandos se han ido reemplazando por alternativas más seguras y completas, algunos todavía permanecen, al menos por conveniencia o retro-compatibilidad.


Comandos remotos
================


**GNU/Linux** dispone de una serie de comandos transparentes a la red, independientemente de la conexión física, es posible ejecutar comandos que muevan información por la red o permitan acceso a algunos servicios que se estén ejecutando en dispositivos distantes. Los comandos suelen tener una "*r*" delante ("*r*" de "*remoto*"), por ejemplo: **rcp**, **rlogin**, **rsh**, **rexec**, etc., que permiten las funcionalidades indicadas de forma remota en la red.

Estos comandos funcionan a través del método *cliente-servidor*, lo cual requiere que en los *hosts* remotos, esté instalado y escuchando peticiones el *daemon* correspondiente.

Por ejemplo, para **rexec**: **rexecd** .

	**Concepto básico Cliente-Servidor**: Generalmente se describe a un sistema en el que varios procesos se comunican entre ellos con la metáfora "cliente/servidor". El servidor es el programa que toma y ejecuta los pedidos que provienen de un cliente. Es el cliente el que controla la operación, el servidor no tiene iniciativa propia.


Un vistazo breve a algunos comandos
-----------------------------------

rlogin
++++++

El comando **rlogin** permite conectar con otros sistemas de la red:

.. code-block:: bash

	rlogin host

*host* es el nombre del sistema remoto.

Si el sistema remoto "conoce" y se "fía" del sistema que intenta conectarse, le permitirá acceder. Sino le solicitará contraseña.


.. raw:: pdf

    PageBreak

rcp
+++

El comando **rcp** permite copiar archivos de una sistema a otro. La sintaxis es similar a la del comando *cp*. Antes de aceptar la copia de archivos desde el sistema origen, el comando se asegura de determinar si el *host* origen tiene permisos de acceso al sistema remoto.

.. code-block:: bash

	rcp host:ubicación_dato_origen ubicación_dato_destino


rsh
+++

El comando **rsh** ("*sh*" viene del término "*shell*") permite ejecutar un único comando en un sistema remoto sin realizar una conexión previa.

Para ejecutar un comando en un sistema remoto escriba:

.. code-block:: bash

	rsh host comando

De igual forma que los comandos *rlogin* y *rcp*, **rsh** se asegura primero de que el *host* origen tenga permiso de acceso al sistema.


rexec
+++++

El comando **rexec** tiene un comportamiento similar a *rsh*, permitiendo ejecutar comandos en el host remoto. La única diferencia es que generalmente requiere indicar el usuario y contraseña de conexión. *rsh* tiene otros mecanismos para validar el usuario de acceso.

.. code-block:: bash

	rexec host comando


rusers
++++++

El comando **rusers** muestra, por cada máquina de la red, quién está conectado.

.. code-block:: bash

	rusers


.rhosts y /etc/hosts.equiv
--------------------------

Son archivos especiales de configuración para algunos de los comandos remotos.

- **.rhosts**: permite que un usuario pueda especificar una serie de máquinas (y usuarios) que pueden usar su cuenta mediante comandos "*r*" (*rsh*, *rcp*, etc.) sin necesidad de introducir la contraseña de la cuenta. Esto es potencialmente peligroso, ya que una mala configuración del usuario podría permitir entrar a usuarios no deseados, o que un atacante (con acceso a la cuenta del usuario) cambiase las direcciones en **.rhosts** para poder entrar cómodamente sin ningún control.

- **/etc/hosts.equiv**: es exactamente lo mismo que los archivos **.rhosts** pero a nivel de máquina, especificando qué servicios, qué usuarios y qué grupos pueden acceder sin control de contraseña a los servicios "*r*". Además, un error como poner en una línea de ese archivo un "*+*", permite el acceso a cualquier máquina.

.. raw:: pdf

    Spacer 0 20

Normalmente, no se tendría que permitir crear estos archivos, y en términos de seguridad, habría que borrarlos completamente y deshabilitar los comandos "*r*".

.. raw:: pdf

    PageBreak

El presente
-----------

Hoy en día, los archivos "*.rhosts*" "*/etc/hosts.equiv*" no suelen existir en los sistemas, y como alternativa a los comandos remotos antes vistos, se presentan herramientas más seguras.

La alternativa es usar clientes y servidores seguros que soporten el cifrado de los mensajes y autenticación de los participantes. Hay alternativas seguras a los servicios clásicos, pero actualmente la solución más usada es la utilización del paquete **OpenSSH** (que puede combinarse también con **OpenSSL** para entornos web). **OpenSSH** ofrece soluciones basadas en los comandos **ssh**, **scp** y **sftp**, permitiendo sustituir a los antiguos clientes y servidores (se utiliza un *daemon* denominado *sshd*). El comando **ssh** permite las antiguas funcionalidades de *telnet*, *rlogin*, y *rsh* entre otros, y **scp** sería el equivalente seguro de *rcp*, y **sftp** del *ftp*.


	**sftp** es un programa interactivo similar a *ftp* . En una sola sesión **sftp** pueden transferir varios archivos y es posible manipular archivos remotos con él (eliminar, renombrar, cambiar permisos, etc.).

inetd
=====

**inetd** (llamado generalmente "*superservidor de internet*") es un servidor de servidores. Ejecuta a pedido servidores rara vez utilizados para que no tengan que ejecutarse continuamente.

Los servidores pueden funcionar de dos maneras diferentes: *standalone* (en el cual el servicio escucha en el puerto asignado y siempre se encuentra activo) o a través del **inetd**.

**inetd** es un servidor que controla y gestiona las conexiones de red de los servicios especificados en el archivo */etc/inetd.conf*, el cual enumera estos servidores y sus puertos usuales. El programa **inetd** escucha en todos estos puertos y cuando detecta una conexión a uno de ellos ejecuta el programa servidor correspondiente.

Dos archivos importantes necesitan ser configurados: */etc/services* y */etc/inetd.conf* . En el primero se asocian los servicios, los puertos y el protocolo, y en el segundo los programas servidores que responderán ante una petición a un puerto determinado.

El formato de */etc/services* es:

.. code-block:: bash

	name port/protocol aliases

donde el primer campo es nombre del servicio, el segundo el puerto donde atiende este servicio y el protocolo que utiliza, y el siguiente, un alias
del nombre. Por defecto existen una serie de servicios que ya están preconfigurados.

A continuación se muestra un ejemplo de */etc/services* .

.. code-block:: bash

	tcpmux 		1/tcp
	echo 		7/tcp
	echo 		7/udp
	discard 	9/tcp 		sink null
	discard 	9/udp 		sink null
	systat 		11/tcp 		users
	...
	ftp 		21/tcp
	ssh 		22/tcp
	ssh 		22/udp
	telnet 		23/tcp
	smtp 		25/tcp 		mail


El archivo */etc/inetd.conf* es la configuración para el servicio maestro de red (*inetd server daemon*). Cada línea significativa del archivo */etc/inetd.conf* describe un servidor con siete campos (separados con espacios):

.. code-block:: bash

	service socket_type proto flags user server_path server_args

- **service**: El número de puerto *TCP* o *UDP* o el nombre del servicio (asociado con un número de puerto estándar con la información en el archivo */etc/services* ).
- **socket_type**: El tipo de *socket*, *stream* para una conexión *TCP*, *dgram* para datagramas *UDP* (otros valores posibles: *raw*, *rdm*, *seqpacket*).
- **proto**: El protocolo válido: *tcp* o *udp* (debe coincidir con el de */etc/services*).
- **flags**: Indica la acción a tomar cuando existe una nueva conexión sobre un servicio que se encuentra atendiendo a otra conexión. Tiene dos valores posibles, *wait* o *nowait* para indicarle a **inetd** si debe esperar o no a que el proceso ejecutado finalice antes de aceptar una nueva conexión. Para conexiones *TCP*, fáciles de gestionar simultáneamente, utilizará generalmente *nowait* . Para programas que respondan sobre *UDP* debería utilizar *nowait* sólo si el servidor es capaz de gestionar varias conexiones en paralelo. Puede agregar un punto al final de este campo, seguido de la cantidad máxima de conexiones autorizadas por minuto (el límite predeterminado es 256).
- **user**: El nombre del usuario bajo el cual será ejecutado el servidor.
- **server_path**: La ruta completa al programa del servidor a ejecutar.
- **server_args**: Los parámetros posibles, es una lista completa de los parámetros del servidor, incluyendo su propio nombre.

.. raw:: pdf

    Spacer 0 10

A continuación se muestra un ejemplo de /etc/inetd.conf .

.. code-block:: bash

	talk dgram udp wait nobody.tty /usr/sbin/in.talkd in.talkd
	finger stream tcp nowait nobody /usr/sbin/tcpd in.fingerd
	ident stream tcp nowait nobody /usr/sbin/identd identd -i


En general se utiliza el programa *tcpd* en el archivo */etc/inetd.conf* . Permite limitar las conexiones entrantes aplicando reglas de control de acceso, documentadas en la página del manual *hosts_access* , y que puede ser configurado en los archivos */etc/hosts.allow* y */etc/hosts.deny* . Una vez que se determinó que la conexión está autorizada, *tcpd* ejecuta el servidor real (en el ejemplo: *in.fingerd* ).

Si bien **Debian** instala **openbsd-inetd** de forma predeterminada, no faltan alternativas: **inetutils-inetd** , **micro-inetd** , **rlinetd** y **xinetd** .

Esta última encarnación de superservidor ofrece posibilidades muy interesantes, como dividir su configuración en varios archivos (almacenados en el directorio */etc/xinetd.d/* ), lo que puede hacer más sencilla la vida del administrador.

También es posible emular el comportamiento de **inetd** con el mecanismo de activación de *sockets* de *systemd* .

.. raw:: pdf

    PageBreak

Telnet
======

**telnet** es un comando (cliente) utilizado para comunicarse interactivamente con otro *host* que ejecuta el *daemon* **telnetd**. El comando **telnet** se puede ejecutar como **telnet host** o interactivamente como **telnet**, el cual pondrá el prompt "*telnet>*" y luego, por ejemplo: *open host*. Una vez establecida la comunicación, generalmente se deberá introducir el usuario y el *password* bajo el cual se desea conectar al sistema remoto. Se dispone de diversos comandos (en modo interactivo) tal como *open*, *logout*, *mode* (definir las características de visualización), *close*, *encrypt*, *quit*, *set*, *unset*, o puede ejecutar comandos externos con "*!*". Se puede utilizar el archivo */etc/telnetrc* para definiciones por defecto, o *.telnetrc* para definiciones de un usuario particular (deberá estar en el directorio *home* del usuario).

El *daemon* **telnetd** es el servidor de protocolo **telnet** para la conexión interactiva. **telnetd** es puesto en marcha generalmente por el *daemon inetd* y se recomienda incluir un wrapper tcpd (que utiliza las reglas de acceso en host.allow y en host.deny) en la llamada al **telnetd** dentro del archivo */etc/inetd.conf* (por ejemplo, incluir una línea como:

.. code-block:: bash

	telnet stream tcp nowait telnetd.telenetd /usr/sbin/tcpd /usr/bin/in.telnetd)

Si bien el par **telnet-telnetd** pueden funcionar en modo *encrypt* (transferencia de datos encriptados) en las últimas versiones (solamente si fueron compilados con la opción correspondiente o si vienen soportados por los paquetes precompilados), es un comando que ha quedado en el olvido por su falta de seguridad aunque puede ser utilizado en redes seguras o situaciones controladas.

Muchos dispositivos aún soportan **telnet**, como switchs o routers, entre otros.

En **Debian**, si no está instalado se puede utilizar **apt-get install telnetd** (si se desea instalar el servidor **telnet**) y después verificar que se ha dado de alta o bien en */etc/inetd.conf* o en */etc/xinetd.conf* (o en el directorio que estén definido los archivos por ejemplo */etc/xinetd.d* según se indique en el archivo anterior con la sentencia *include /etc/xinetd.d*). O bien en el *xinetd.conf* o en el archivo */etc/xinetd.d/telentd* deberá incluir una sección como: 


.. code-block:: bash

	service telnet
	{
	disable = no
	flags = REUSE
	socket_type = stream
	wait = no
	user = root
	server = /usr/sbin/in.telnetd
	log_on_failure += USERID
	}


Cualquier modificación en *xinetd.conf* o *inetd.conf* requiere que se reinicie el servicio.

En lugar de utilizar **telnetd** se recomienda utilizar **SSL telnet(d)** el cual reemplaza al **telnetd** utilizando encriptación y autenticación por *SSL*, o bien utilizar *SSH*. El **SSL Telnet(d)** puede funcionar con el **telnet(d)** normal en ambas direcciones, ya que al inicio de la comunicación verifica si del otro lado soporta *SSL*, y si no continúa con el protocolo **telnet** normal. Las ventajas con respecto al **telnet(d)** son que sus *passwords* y datos no circularán por la red en modo texto plano. También **SSLtelnet(d)** se puede utilizar para conectarse por ejemplo a un servidor web seguro (por ejemplo *https://servidor.web.org* ) simplemente haciendo: **telnet servidor.web.org 443** .

.. raw:: pdf

    PageBreak

SSH
===

Un cambio aconsejable hoy en día es utilizar **ssh** (interprete de órdenes seguro: "**Secure SHell**") en lugar de *telnet*, *rlogin* o *rsh*. Estos comandos son inseguros (excepto *SSLTelnet*) por varias razones: la más importante es que todo lo que se transmite por la red, incluido usuarios y contraseñas, es en texto plano (aunque existen versiones de *telnet-telnetd* encriptados, deben coincidir en que ambos lo sean en cada extremo de la conexión), cualquiera que tenga acceso a esa red o a algún segmento de la misma puede obtener toda esta información y luego suplantar la identidad del usuario. La segunda es que estos puertos (*telnet*, *rsh*, etc.) es al primer lugar donde un *cracker* intentará conectarse. El protocolo **ssh** (en su versión **OpenSSH**) provee de un conexión encriptada y comprimida mucho más segura que, por ejemplo, *telnet* (es recomendable utilizar la versión 2 del protocolo). Todas las distribuciones actuales incorporan el cliente **ssh** por defecto.

El protocolo **SSH** fue diseñado pensando en la seguridad y la confiabilidad. Las conexiones que utilizan **SSH** son seguras: la otra parte es autenticada y se cifran todos los datos intercambiados.


	**Autenticación**: Permite asegurar la identidad del cliente conectado. Generalmente mediante una contraseña que debe mantenerse en secreto.

	**Cifrado**: Es una forma de codificación que permite a dos sistemas intercambiar información confidencial en un canal público al mismo 	tiempo que la protege de que otros la puedan leer.


**SSH** también ofrece servicios de transferencia de archivos. **scp** es una herramienta para la terminal que puede utilizarse como *cp* excepto que cualquier ruta a otro equipo utilizará un prefijo con el nombre de la máquina seguido de dos puntos ("*:*").

.. code-block:: bash

	scp archivo equipo:/tmp/

**Debian** utiliza **OpenSSH**, una versión libre de **SSH** mantenida por el proyecto **OpenBSD** (un sistema operativo libre basado en el núcleo **BSD** enfocado en seguridad) que es una bifurcación ("*fork*") del software **SSH** original desarrollado por la empresa *SSH Communications Security Corp* de Finlandia. Esta empresa inicialmente desarrolló **SSH** como software libre pero eventualmente decidió continuar su desarrollo bajo una licencia privativa. El proyecto **OpenBSD** luego creó **OpenSSH** para mantener una versión libre de **SSH**.

**OpenSSH** está dividido en dos paquetes: la parte del cliente se encuentra en el paquete **openssh-client** y el servidor en el paquete **openssh-server**. El metapaquete **ssh** depende de ambas partes y facilita la instalación conjunta ( *apt install ssh* ).

Se puede ejecutar como:

.. code-block:: bash

	ssh -l user host
	ssh user@host

Si se omite el parámetro *-l*, el usuario se conectará al *host* remoto con el mismo usuario local, y en ambos casos el servidor solicitará el *password* para validar la identidad del usuario. La comunicación será siempre encriptada, por lo que nunca será accesible a otros usuarios que puedan escuchar sobre la red.

**SSH** soporta diferentes modos de autenticación basados en el algoritmo *RSA* y clave pública.

Para ejecutar un comando remoto se puede hacer:

.. code-block:: bash

	ssh -l user host comando

.. raw:: pdf

    PageBreak

Utilización de aplicaciones X11 remotas
---------------------------------------

El protocolo **SSH** permite redirigir datos gráficos (sesión "*X11*" por el nombre del sistema gráfico más utilizado); el servidor luego mantiene un canal dedicado para estos datos. Específicamente, el programa gráfico ejecutado remotamente puede mostrarse en el servidor *X.org* de la pantalla local y toda la sesión (datos ingresados y lo que sea mostrado) será segura. De forma predeterminada, esta funcionalidad está desactivada porque permite que aplicaciones remotas interfieran con el sistema local. Puede activarla especificando *X11Forwarding yes* en el archivo de configuración del servidor ( */etc/ssh/sshd_config* ). Finalmente, el usuario también debe solicitarlo agregando la opción *-X* al ejecutar **ssh** .

A través de **SSH** se puede encapsular también cualquier otra conexión *TCP/IP*.


Autenticación basada en llaves
------------------------------

Cada vez que alguien inicia sesión a través de **SSH**, el servidor remoto pide una contraseña para autenticar al usuario. Esto puede ser problemático si desea automatizar la conexión o si utiliza una herramienta que necesita conexiones frecuentes sobre **SSH**. Es por esto que **SSH** ofrece un sistema de autenticación basada en llaves.

El usuario genera un par de llaves en la máquina cliente con **ssh-keygen -t rsa** ; la llave pública se almacena en *~/.ssh/id_rsa.pub* mientras que la llave privada correspondiente estará almacenada en *~/.ssh/id_rsa* . Luego, el usuario utiliza **ssh-copy-id servidor** para agregar su llave pública al archivo *~/.ssh/authorized_keys* en el servidor. Este archivo podrá contener tantas claves públicas como sitios desde donde se quiera conectar a esta máquina en forma remota. La sintaxis es de una clave por línea y su funcionamiento es equivalente al archivo *.rhosts* (aunque las líneas tendrán un tamaño considerable). Si no se protegió la llave privada con una "*frase de contraseña*" al momento de crearla, todos los inicios de sesión siguientes al servidor funcionarán sin contraseña. De lo contrario, debe descifrar la llave privada cada vez, ingresando la *frase de contraseña*. Afortunadamente, **ssh-agent** permite mantener llaves privadas en memoria para no tener que ingresar la frase de contraseña regularmente. Para ello, simplemente utilizaría **ssh-add** (una vez por sesión de trabajo) siempre que la sesión ya esté asociada con una instancia funcional de **ssh-agent** . De forma predeterminada, **Debian** activa este comportamiento en sesiones gráficas pero lo puede desactivar cambiando el archivo */etc/X11/Xsession.options* . Para una sesión en consola, puede iniciarlo manualmente con **eval $(ssh-agent)** .


sshd
----

El **sshd** es el servidor (*daemon*) para el **ssh**. Juntos reemplazan al *rlogin*, *telnet*, *rsh* y proveen una comunicación segura y encriptada entre dos *hosts* inseguros en la red.

Se arranca generalmente a través de los archivos de inicialización, y espera conexiones de los clientes. El **sshd** de la mayoría de las distribuciones actuales soporta las versiones 1 y 2 del protocolo **SSH**. Cuando se instala el paquete, crea una clave *RSA* específica del *host*, y cuando el *daemon* se inicia, crea otra, la *RSA* para la sesión, que no se almacena en el disco y la cambia cada hora. Cuando un cliente inicia la comunicación, el cliente genera un número aleatorio de *256 bits* que es encriptado con las dos claves del servidor y enviado. Este número se utilizará durante la comunicación como clave de sesión para encriptar la comunicación que se realizará a través de un algoritmo de encriptación estándar. El usuario puede seleccionar cualquiera de los disponibles ofrecidos por el servidor. Existen algunas diferencias (mayor seguridad) cuando se utiliza la versión 2 del protocolo. A partir de ese momento, se inician algunos de los métodos de autenticación de usuario descritos en el cliente o se le solicita el *password*, pero siempre con la comunicación encriptada.

.. raw:: pdf

    PageBreak

Túnel sobre SSH
===============

Muchas veces tenemos un acceso a un servidor **sshd**, pero por cuestiones de seguridad no a otros servicios que no son encriptados (por ejemplo un servicio de consulta de mail *POP3* o un servidor de ventanas *X11*) o simplemente se quiere conectar a un servicio a los cuales sólo se tiene acceso desde el entorno de la empresa. Para ello es posible establecer un **túnel encriptado** entre la máquina cliente (por ejemplo con *Windows*, y un cliente **ssh** llamado **putty** de **software libre**) y el servidor con **sshd**. En este caso, al vincular el **túnel** con el servicio, el servicio verá la petición como si viniera de la misma máquina. Por ejemplo, si queremos establecer una conexión para *POP3* sobre el puerto *110* de la máquina remota (y que también tiene un servidor **sshd**) hacemos:

.. code-block:: bash

	ssh -C -L 1100:localhost:110 usuario-id@host

Este comando pedirá el *password* para el *usuario-id* sobre *host*, y una vez conectado se habrá creado el **túnel**. Cada paquete que se envíe a la máquina local sobre el puerto *1100* será enviado a la máquina remota *localhost* sobre el puerto *110*, que es donde escucha el servicio *POP3* (la opción *-C* comprime el tráfico por el **túnel**).

Hacer **túneles** sobre otros puertos es muy fácil. Por ejemplo, supongamos que sólo tengamos acceso a un *remote proxy server* (*servidor proxy remoto*) desde una máquina remota (*remote login*) –no desde la máquina local–, se puede hacer un **túnel** para conectar el navegador a través del **túnel** en la máquina local. Consideremos que tenemos *login* sobre una maquina *gateway* (*puerta de enlace*), la cual puede acceder a la máquina llamada *proxy* , que ejecuta el *Squid proxy server* sobre el puerto *3128*. Ejecutamos:

.. code-block:: bash

	ssh -C -L 8080:proxy:3128 user@gateway

Después de conectarnos tendremos un **túnel** escuchando sobre el puerto local *8080*, que reconducirá el tráfico desde *gateway* hacia *proxy* al *3128*. Para navegar en forma segura, solo se deberá hacer *http://localhost:8080/* .



Las opciones *-R* y *-L* le permiten a **ssh** crear **túneles** cifrados entre dos equipos, redirigiendo de forma segura un puerto *TCP* local a un equipo remoto o viceversa.


.. image:: imagenes/tunel-ssh-local.png
	:scale: 200

.. code-block:: bash

	ssh -L 8000:servidor:25 intermediario

establece una sesión **SSH** con el equipo *intermediario* y escucha en el puerto *local* *8000*. Para cualquier conexión en este puerto, **ssh** iniciará una conexión desde el equipo *intermediario* al puerto *25* de servidor y unirá ambas conexiones.

.. image:: imagenes/tunel-ssh-remoto.png
	:scale: 200

.. code-block:: bash

	ssh -R 8000:servidor:25 intermediario

también establece una sesión **SSH** al equipo *intermediario*, pero es en este equipo que **ssh** escuchará en el puerto *8000*. Cualquier conexión establecida en este puerto causará que **ssh** abra una conexión desde el equipo *local* al puerto *25* del servidor y unirá ambas conexiones.

En ambos casos, se realizan las conexiones en el puerto *25* del equipo servidor, que pasarán a través del **túnel SSH** establecido entre la máquina *local* y la máquina *intermediario*. En el primer caso, la entrada al **túnel** es el puerto *local 8000* y los datos se mueven hacia la máquina *intermediario* antes de dirigirse a servidor en la red "*pública*". En el segundo caso, la entrada y la salida del **túnel** son invertidos; la entrada es en el puerto *8000* de la máquina *intermediario*, la salida es en el equipo *local* y los datos son dirigidos a servidor. En la práctica, el servidor generalmente está en la máquina *local* o el *intermediario*. De esa forma **SSH** asegura la conexión de un extremo a otro.


VNC
===

**VNC** (computación en redes virtuales: "*Virtual Network Computing*") permite el acceso remoto a escritorios gráficos.

Esta herramienta se utiliza más que nada para asistencia técnica; el administrador puede ver los errores con los que se enfrenta el usuario y mostrarle el curso de acción correcto sin tener que estar a su lado.

Primero, el usuario debe autorizar compartir su sesión. El *entorno gráfico* de escritorio *GNOME* en **Jessie** incluye esa opción en su panel de configuración (al contrario que en versiones anteriores de **Debian**, donde el usuario tenía que instalar y ejecutar la orden **vino** ). *KDE* aún requiere utilizar **krfb** para permitir compartir una sesión existente sobre **VNC**. Para otros *entornos gráficos* de escritorio, el programa **x11vnc** (en el paquete **Debian** del mismo nombre) cumple el mismo propósito; puede ponerlo a disposición del usuario con un icono explícito.

Cuando la sesión gráfica está disponible a través de **VNC**, el administrador debe conectarse a ella con un cliente **VNC**. Para ello *GNOME* posee **vinagre** y **remmina** , mientras que *KDE* incluye **krdc** (en el menú *K → Internet → Cliente de Escritorio Remoto* ). Existen otros clientes **VNC** para utilizar en una terminal como **xvnc4viewer** (en el paquete **Debian** del mismo nombre). Una vez conectado, el administrador puede ver lo que sucede, trabajar en el equipo remotamente y mostrarle al usuario cómo proceder.

**VNC** también funciona para usuarios móviles o ejecutivos de empresas que ocasionalmente necesitan iniciar sesión desde sus casas para acceder a un escritorio remoto similar al que utilizan en la oficina. La configuración de tal servicio es más complicada: primero debe instalar el paquete **vnc4server**, modificar la configuración del *gestor de pantalla* para aceptar pedidos *XDMCP Query* (en *gdm3* puede hacerlo agregando *Enable=true* en la sección "*xdmcp*" del archivo */etc/gdm3/daemon.conf* ). Finalmente, inicie el servidor **VNC** con *inetd* para que se inicie una sesión automáticamente cuando el usuario intente hacerlo.

.. raw:: pdf

    PageBreak

Por ejemplo, puede agregar la siguiente línea al archivo */etc/inetd.conf* :

.. code-block:: bash

	5950 stream tcp nowait nobody.tty /usr/bin/Xvnc Xvnc -inetd -query localhost
	 -once -geometry 1024x768 -depth 16 securitytypes=none

Redireccionar las conexiones entrantes al *gestor de pantallas* soluciona el problema de la autenticación ya que sólo los usuarios con cuentas locales pasarán la pantalla de inicio de sesión de *gdm3* (o su equivalente *kdm* , *xdm* , etc.). Como esta operación permite múltiples sesiones simultáneamente sin problemas (siempre que el servidor sea suficientemente poderoso), incluso puede ser utilizada para proveer escritorios completos para usuarios móviles (o sistemas de escritorios menos potentes configurados como clientes ligeros). Los usuarios simplemente iniciarán sesión en la pantalla del servidor con **vncviewer servidor:50** ya que utiliza el puerto *5950*.




.. raw:: pdf

    PageBreak

Bibliografía
============

The Debian Administrator's Handbook, Raphaël Hertzog and Roland Mas, ( `https://debian-handbook.info/ <https://debian-handbook.info/>`_ )

Administración Avanzada del Sistema GNU/Linux ( `<http://openaccess.uoc.edu/webapps/o2/handle/10609/226>`_ )

