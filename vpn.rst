Unidad 3: Redes privadas virtuales
==================================

Una red virtual privada (VPN: Virtual Private Network) es una forma de
enlazar dos redes locales diferentes a través de Internet u otra red no
confiable, utilizando para ello un túnel. Este túnel
generalmente está cifrado por confidencialidad, pero no necesariamente.

Ejemplos comunes de uso son la posibilidad de conectar dos o más sucursales de
una empresa; permitir a los Administradores la conexión
desde su casa al centro de cómputos; o a los usuarios acceder a su equipo
dentro de la empresa desde un sitio remoto.

.. figure:: ../imagenes/unidad03/image_0.png
   :alt: VPN de acceso remoto
   :align: center
   :scale: 65 %

   Fig.1 Ejemplo de conexión VPN de un usuario remoto a la red interna

Arquitecturas de conexión VPN
-----------------------------

Podemos clasificar a una conexión VPN según la arquitectura de conexión
utilizada, es decir, extremo a extremo como se realiza la conexión, sobre que
tecnologías y como son vinculados.

VPN de acceso remoto
~~~~~~~~~~~~~~~~~~~~

Es quizás el modelo más utilizado actualmente, y consiste en usuarios o
proveedores que se conectan con la empresa desde sitios remotos
(domicilios, hoteles, etc.) utilizando Internet como vínculo de acceso.
En este tipo de arquitectura, el cliente inicia la conexión, establece el
vínculo y una vez autenticado tiene un nivel de acceso muy similar al que
tienen en la red local de la empresa. En esta arquitectura, el cliente pasa a
ser un equipo más en la red.

La Fig. 1 representa este caso de uso.

VPN punto a punto
~~~~~~~~~~~~~~~~~

Este esquema se utiliza para conectar oficinas remotas con la sede
central de la organización. El servidor VPN acepta las conexiones vía Internet
provenientes de los sitios y establece el túnel VPN punto a punto, es decir
entre el servidor de la central y el de la sucursal solamente. Si existieran
diferentes sucursales, las mismas no se verían directamente entre ellas, sino a
través del servidor central, dado que en esta arquitectura, el vinculo es uno
a uno.

.. figure:: ../imagenes/unidad03/image_1.png
   :alt: VPN punto a punto
   :align: center
   :scale: 65 %

   Fig.2 Ejemplo de conexión VPN punto a punto

Tunneling
~~~~~~~~~

La técnica de tunneling consiste en encapsular un protocolo de red sobre
otro (protocolo de red encapsulador) creando un túnel dentro de una red
de computadoras. El establecimiento de dicho túnel se implementa
incluyendo una PDU (unidades de datos de protocolo) determinada dentro
de otra PDU con el objetivo de transmitirla desde un extremo al otro del
túnel sin que sea necesaria una interpretación intermedia de la PDU
encapsulada. De esta manera se encaminan los paquetes de datos sobre
nodos intermedios que son incapaces de ver en claro el contenido de
dichos paquetes. El túnel queda definido por los puntos extremos y el
protocolo de comunicación empleado, que entre otros, podría ser SSH.


.. figure:: ../imagenes/unidad03/image_2.png
   :alt: VPN Tunneling
   :align: center
   :scale: 65 %

   Fig.3 Ejemplo de encapsulado de PDU

VPN over LAN
~~~~~~~~~~~~

Es una variante del tipo "acceso remoto" pero, en vez de utilizar Internet
como medio de conexión, emplea la misma red de área local (LAN) de la empresa.
Sirve para aislar zonas y servicios de la red interna. Esta capacidad lo hace
muy conveniente para mejorar las prestaciones de seguridad de las redes
inalámbricas (WiFi).

Un ejemplo clásico es un servidor con información sensible, como el que
aloja el sistema de sueldos, ubicado detrás de un equipo VPN, el cual
provee autenticación adicional más el agregado del cifrado, haciendo
posible que solamente el personal de recursos humanos habilitado pueda
acceder a la información. Otro ejemplo es la conexión a redes Wi-Fi
haciendo uso de túneles cifrados IPSec o SSL que además de pasar por los
métodos de autenticación tradicionales (WEP, WPA, direcciones MAC, etc.)
agregan las credenciales de seguridad del túnel VPN creado en la LAN
interna o externa.

.. figure:: ../imagenes/unidad03/image_3.png
   :alt: VPN over LAN
   :align: center
   :scale: 45 %

   Fig.3 Ejemplo de VPN over LAN

VPNs según el tipo de conexión
------------------------------

Otra forma de clasificar las VPNs, es según la forman en la que se realiza
la conexión entre los extremos. En este caso también podemos clasificarlas
en 4 grupos:

Conexión de acceso remoto
~~~~~~~~~~~~~~~~~~~~~~~~~

Una conexión de acceso remoto es realizada por un cliente o un usuario de una
computadora que se conecta a una red privada. Los paquetes enviados a través
de la conexión VPN son originados en el cliente de acceso remoto, el que se
autentica contra el servidor de acceso remoto, y este a su vez se autentica ante
el cliente, realizando una autenticación cruzada entre un nodo y el servidor de
VPN.

.. figure:: ../imagenes/unidad03/image_4.png
   :alt: Conexión de acceso remoto
   :align: center
   :scale: 60 %

   Fig.4 Ejemplo de Conexión de acceso remoto

Conexión VPN router a router
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Una conexión VPN router a router consiste en la unión de dos router por medio de
una VPN, uniendo de este modo ambas redes LAN.

En este tipo de conexión, los paquetes enviados desde cualquier router no se
originan en los routers, sino que en equipos pertenecientes a sus LANs. De este
modo se unen ambas redes de forma totalmente transparente para los usuarios de
las mismas.

.. figure:: ../imagenes/unidad03/image_5.png
   :alt: VPN router a router
   :align: center
   :scale: 55 %

   Fig.4 Ejemplo de VPN router a router

Conexión VPN firewall a firewall
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Una conexión VPN firewall es similar al caso anterior, con el agregado de una
capa extra de seguridad que permite aplicar reglas especificas a la conexión VPN.

.. figure:: ../imagenes/unidad03/image_6.png
   :alt: VPN firewall a firewall
   :align: center
   :scale: 55 %

   Fig.5 Ejemplo de VPN firewall a firewall

VPN en entornos móviles
~~~~~~~~~~~~~~~~~~~~~~~

La VPN móvil se establece cuando el punto de terminación de la VPN no está fijo a
una única dirección IP, sino que se mueve entre varias redes como pueden ser las
redes de datos de operadores móviles o distintos puntos de acceso de una red Wifi.
Las VPNs móviles se utilizan mucho en seguridad pública, dando acceso a las
fuerzas de orden público a aplicaciones críticas tales como bases de datos para
identificación de criminales. Mientras uno de los puntos de la conexión se mueve
entre distintas subredes de una red móvil, siempre se mantiene el vínculo con el
otro extremo.

.. figure:: ../imagenes/unidad03/image_7.png
   :alt: VPN en entornos móviles
   :align: center
   :scale: 65 %

   Fig.6 Ejemplo de VPN en entornos móviles

Ventajas del uso de VPNs
------------------------

- Integridad, confidencialidad y no repudio: al poder realizar un tunel
  encriptado de extremo a extremo, podemos tener la certeza (o casi) de que nadie
  puede ver los datos enviados (confidencialidad), e incluso tampoco alterarlos
  (integridad). A su vez, como los extremos se autentican, como veremos mas adelante,
  también podemos estar seguro de cual es el origen de los mismos (no repudio).

- Las VPN reducen los costos y son sencillas de usar: Principalmente porque no necesitamos
  de costosos enlaces punto a punto para unir diferentes LANs, sino que podemos hacer
  uso de internet.

- Facilita la comunicación entre dos usuarios en lugares distantes: Al poder unir
  diferentes redes, permite que los usuarios se puedan comunicar y acceder a
  sistemas y equipos tal y como si estuvieran dentro de la misma red interna,
  por lo que no se tienen que agregar mecanismos extras de autenticación, o
  reglas de redirección de puertos para que un usuario externo pueda hacer uso
  de los mismos.


OpenVPN
-------

La herramienta más utilizadas para armar VPNs en GNU/Linux es OpenVPN,
dado que es una solución eficiente, fácil de desplegar y mantener, basada en SSL/TLS.

Su configuración involucra crear interfaces de red virtuales en el
servidor VPN y en los clientes; es compatible con interfaces
**tun** (para túneles a nivel de IP) y **tap** (para túneles a nivel
Ethernet). En la práctica, usualmente se utilizan interfaces *tun* excepto
cuando los clientes VPN deban integrarse a la red local del servidor a
través de un puente Ethernet.

OpenVPN se basa en OpenSSL para toda la criptografía SSL/TLS y
funcionalidades asociadas (confidencialidad, autenticación, integridad,
no repudio). Se puede configurar con una llave privada compartida o
con un certificado X.509 basado en la infraestructura de llave pública.
Se prefiere fuertemente esta última configuración ya que permite más
flexibilidad cuando se enfrenta a un número creciente de usuarios
itinerantes que acceden a la VPN.

Infraestructura de llave pública: easy-rsa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El algoritmo RSA es ampliamente utilizado en criptografía de llave
pública. Involucra un «par de llaves», compuestas de una llave privada y
una llave pública. Las dos llaves están fuertemente relacionadas entre
ellas y sus propiedades matemáticas son tales que un mensaje cifrado con
la llave pública sólo puede ser descifrado por alguien que conozca la
llave privada, lo que asegura confidencialidad. En la dirección opuesta,
un mensaje cifrado con la clave privada puede ser descifrado por
cualquiera que conozca la llave pública, lo que permite autenticar el
origen del mensaje ya que sólo pudo haber sido generado por alguien con
acceso a la llave privada. Cuando se asocia una función de hash digital
(MD5, SHA1 o una variante más reciente), esto lleva a un mecanismo de
firma que puede aplicarse a cualquier mensaje, y garantizar que el mismo
no ha sido alterado durante su traslado a lo largo de la red. Sin
embargo, cualquiera puede crear un par de llaves, almacenar cualquier
identidad en ella y pretender ser la identidad que elijan. Una solución
involucra el concepto de una Autoridad Certificante (CA:
«Certification Authority») formalizado por el estándar X.509. Este
término se refiere a una entidad que posee un par de llaves confiable
conocido como certificado raíz. Sólo se utiliza este certificado para
firmar otros certificados (pares de llaves), luego que se siguieron
suficientes pasos para revisar la identidad almacenada en el par de
llaves. Las aplicaciones que utilizan X.509 luego pueden verificar los
certificados que se les presente si conocen los certificados raíz
confiables. OpenVPN sigue esta regla.

Dado que los CA públicos sólo expiden certificados a cambio de un pago
(importante), también es posible crear una autoridad de certificación privada
dentro de la empresa. El paquete easy-rsa proporciona herramientas que dan soporte a
la infraestructura de certificados X.509, implementados como un conjunto
de scripts haciendo uso del comando openssl, y que precisamente nos
permiten eso, crear una autoridad de certificación privada. Veremos más
adelante como utilizar esta herramienta para crear nuestra propia CA y
emitir certificados para nuestros clientes de VPN.

Ejemplo práctico
----------------

Veremos un ejemplo de uso de VPN para teletrabajo. Para ello
utilizaremos el tipo más común de todos "VPN de acceso remoto". Contamos
con empleados que trabajan fuera de la empresa, y necesitan acceder
a equipos en la red interna de la misma de forma que lo hacen cuando están
en la misma.

Para llevar adelante nuestro cometido, empezaremos por implementar una
Autoridad Certificante (CA), la que emitirá certificados para el personal
externo (clientes VPN) de una empresa ficticia denominada "Mambo-tango".
Estos certificados serán las credenciales que validarán y permitirán la
conexión de los mismos.

Creando nuestra propia CA
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

    root@servidor:~# apt-get install openvpn
    root@servidor:~# make-cadir pki-mambotango

Esto generará un directorio pki-mambotango con el conjunto de scripts
necesarios para generar los certificados de los usuarios de nuestra CA.
Además podremos definir ciertos datos propios de la empresa, los que
formarán parte de los certificados que se emitan    .

A continuación debemos entrar en el directorio pki-mambotango y editar
el archivo "vars". En el podremos definir los siguientes atributos, con
información propia de la organización

.. code:: bash

    export KEY_COUNTRY="AR"
    export KEY_PROVINCE="SF"
    export KEY_CITY="SantaFe"
    export KEY_ORG="Mambo-Tango"
    export KEY_EMAIL="admin@mambo-tango.org.ar"

luego debemos generar el par de claves propios de la CA, para eso antes
debemos cargar las variables modificadas, hacer una limpieza y
luego si generarlas

.. code:: bash

    root@servidor:~# . ./vars
    root@servidor:~# ./clean-all
    root@servidor:~# ./build-ca

Durante este paso se almacenarán las dos partes del par de llaves en
**keys/ca.crt** y **keys/ca.key (clave privada)**

Ahora podemos crear el certificado para el servidor VPN, así como también
los parámetros Diffie-Hellman necesarios en el servidor para la conexión
SSL/TLS. Se identifica el servidor VPN por su nombre DNS
vpn.mambo-tango.org.ar; se reutiliza este nombre para los archivos de
llaves generados (keys/vpn.mambo-tango.org.ar.crt para el certificado
público, keys/vpn.mambo-tango.org.ar.key para la llave privada):

.. code:: bash

    root@servidor:~# ./build-key-server vpn.mambo-tango.org.ar
    root@servidor:~# ./build-dh

El siguiente paso crea los certificados para los clientes VPN; debemos
generar un certificado para cada equipo o persona autorizada para utilizar
la VPN:

.. code:: bash

    root@servidor:~# ./build-key cliente1

Esto generará dentro de la carpeta *keys* los archivos *cliente1.crt (certificado)*
y *cliente1.key (clave privada)*. Estos archivos son los que deberá utilizar
el cliente de VPN para conectarse, como veremos luego.

Configuración de servidor de VPN
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El script de inicialización de OpenVPN intenta, de forma predeterminada, iniciar
todas las redes privadas virtuales definidas en /etc/openvpn/\*.conf. Para
configurar un servidor VPN debemos almacenar el archivo de configuración
correspondiente en este directorio.

Con muy pocos parámetros podemos tener un servidor OpenVPN sencillo. A continuación
mostramos un archivo de configuración de ejemplo, que guardaremos como
/etc/openvpn/server.conf. En caso de requerir más parámetros, puede tomar el
archivo de ejemplo que viene con el paquete openvpn
/usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz.

.. code:: bash

    port 1194
    proto udp
    dev tun
    ca /etc/ssl/certs/ca.crt
    cert /etc/ssl/certs/vpn.mambo-tango.org.ar.crt
    key /etc/ssl/private/vpn.mambo-tango.org.ar.key
    dh /etc/ssl/certs/dh2048.pem
    server 10.8.0.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    push "route 192.168.10.0 255.255.255.0"
    push "dhcp-option DNS 192.168.10.2"
    push "dhcp-option DNS 192.168.10.3"
    keepalive 10 120
    comp-lzo
    persist-key
    persist-tun
    status openvpn-status.log
    verb 3

Los primeros 3 parámetros sirven para especificar el puerto donde escuchará
el servidor de VPNs, bajo que protocolo y el tipo de
interfaz a utilizar.

Los siguiente 4 definen todo lo relacionado con los certificados
X509. En particular definimos cual es el certificado de la CA en la que vamos
a confiar (en este caso, nuestra propia CA), cual es el certificado que
identifica a nuestro servidor, y su clave privada.

La opción server especifica la red a la que pertenecerán los clientes de VPN,
es decir, a cada uno de los clientes que se conecten, se les dará una IP fija
en esta subred (10.8.0.0/24). La información respecto de que IP fue asignada a
que cliente vpn, es logueada en en el archivo ipp.txt definido en la opción
ifconfig-pool-persist.

Los siguientes 3 parámetros son información que se envía a los clientes luego
de establecer la conexión. En este caso se envía una ruta, para que los mismos
puedan llegar a la subred interna (192.168.10.0/24 en este caso) utilizando como
gateway al servidor de VPN (el que tendrá la ip 10.8.0.1). Además se envía información
respecto de los servidores de DNS internos, para que estos puedan resolver los nombres
tal y como si estuvieran dentro de la propia red interna.

Los restantes parámetros no son tan relevantes, simplemente diremos que definen
el tiempo para determinar si un cliente perdió la conexión, definen que los paquetes
irán comprimidos con el algoritmo lza y algunas opciones de log.


Antes de reiniciar el servidor para que tome la configuración, debemos copiar
los certificados a su ubicación definida

.. code:: bash

    root@servidor:~# cp pki-mambotango/keys/ca.crt /etc/ssl/certs/
    root@servidor:~# cp pki-mambotango/keys/vpn.mambo-tango.org.ar.crt /etc/ssl/certs/
    root@servidor:~# cp pki-mambotango/keys/dh2048.pem /etc/ssl/certs/
    root@servidor:~# cp pki-mambotango/keys/ca.key /etc/ssl/private/
    root@servidor:~# cp pki-mambotango/keys/vpn.mambo-tango.org.ar.key /etc/ssl/private/

luego si reiniciamos el servidor y chequeamos que este activo

.. code:: bash

    root@servidor:~# service openvpn restart
    root@servidor:~# netstat -lntpu|grep 1194
    udp        0      0 0.0.0.0:1194            0.0.0.0:*                           893/openvpn


Configuración de los clientes de VPN
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada cliente para poder conectarse al servidor, debe contar con
openvpn instalado (apt-get install openvpn), su certificado emitido
por la CA en la que confía el servidor de VPN (nuestra CA en este caso),
su clave privada, el certificado de la CA y una configuración mínima como la siguiente
, la que guardaremos en el archivo /etc/openvpn/cliente.conf:

.. code:: bash

    dev tun
    proto udp
    ca /etc/ssl/certs/ca.crt
    cert /etc/ssl/certs/client.crt
    key /etc/ssl/private/client.key
    client
    remote vpn.mambo-tango.org.ar 1194
    resolv-retry infinite
    nobind
    persist-key
    persist-tun
    ns-cert-type server
    comp-lzo
    verb 3

Como verán los parámetros son muy parecidos a los utilizados para el servidor
con la salvedad que aquí especificamos que es un cliente (opción client),
en que dirección y puerto escucha el servidor (parámetro remote) entre otras.
Cabe aclarar que el archivo ca.crt, debe ser el mismo que se utiliza en el
servidor de VPN, dado que ambos equipos deben confiar en los certificados emitidos
por dicha CA.

Otra aclaración importante, es que la dirección especificada en remote, debe
ser la IP publica del servidor de VPN. En nuestro ejemplo, el mismo se encuentra detrás
del firewall, por lo que será la IP pública del firewall, y luego en este deberemos
aplicar una redirección de puerto para redirigir y permitir el tráfico con destino al
puerto 1194, protocolo UDP.
Puede encontrar mas parámetros de configuración en el archivo
/usr/share/doc/openvpn/examples/sample-config-files/client.conf

Por último debemos editar el archivo /etc/default/openvpn y configurar el siguiente
parámetro para que la VPN levante automáticamente cada vez que inicia el sistema.

.. code:: bash

    AUTOSTART="all"

