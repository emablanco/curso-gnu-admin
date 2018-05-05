Funcionamiento de un DNS
========================

Respuestas autoritativas y no autoritativas
-------------------------------------------

El servidor de DNS Bind
=======================

Directorios de configuración de Bind
------------------------------------
La configuración de Bind se encuentra en el archivo /etc/named.conf, y también
se suele guardar en el directorio /etc/named archivos de configuración separados
que luego son incluidos en el archivo /etc/named.conf.

La sintaxis de dicho archivo es la siguientes

.. code:: bash

  statement-1 ["statement-1-name"] [statement-1-class] {
    option-1;
    option-2;
    option-N;
  };
  statement-2 ["statement-2-name"] [statement-2-class] {
    option-1;
    option-2;
    option-N;
  };
  statement-N ["statement-N-name"] [statement-N-class] {
    option-1;
    option-2;
    option-N;
  };

ACLs
----
La sentencia ACL (Access Control List) nos permite definir grupos de hosts, a
los que luego podemos permitirle o denegarle el acceso a ciertos tipos de consulta
sobre el servidor de nombres, e incluso asociarlos con diferentes opciones.

Su sintaxis es la siguientes

.. code:: bash

  acl acl-name {
    match-element;
    ...
  };

Por ejemplo

.. code:: bash

  acl black-hats {
    10.0.2.0/24;
    192.168.0.0/24;
    1234:5678::9abc/24;
  };
  acl red-hats {
    10.0.1.0/24;
  };
  options {
    blackhole { black-hats; };
    allow-query { red-hats; };
    allow-query-cache { red-hats; };
  };

Opciones (options)
--------
Las opciones, permiten definir configuraciones globales y por defecto del
servidor. Se utilizan para definir la ubicación del directorio de trabajo,
los tipos de consultas que están permitidas y mucho más.

Su sintaxis es la siguiente

.. code:: bash

  options {
    option;
    ...
  };

Las opciones más comunes son:

* allow-query: Especifica que hosts pueden realizar consultas autoritativas.
  Si no se especifica, todos los hosts están permitidos por defecto.

* allow-query-cache: 	Especifica que host pueden realizar consultas no autoritativas,
  como lo son las consultas recursivas. Solo localhost y localnets están
  permitidas por defecto.

* blackhole: Especifica que host no tienen permitido realizar consultas
 	de ningún tipo al servidor. Esta opción debería utilizarse cuando un
  determinado host o red realiza un ataque al servidor. El valor por defecto es
  none.

* directory: Especifica el directorio de trabajo. El valor por defecto es
  /var/named/.

* dnssec-enable: Especifica si el servidor va a trabajar con las extensiones
  de seguridad (DNSSEC). Este tipo de extensiones fueron incorporadas para brindar
  mayor seguridad, dado que el protocolo DNS originalmente no fue diseñado pensando
  en la seguridad. Permiten entre otras cosas, realizar la autenticación de las
  respuestas y a su vez brindar compatibilidad hacia atrás con el mismo protocolo.
  Para mayor información consultar https://es.wikipedia.org/wiki/Domain_Name_System_Security_Extensions.
  El valor por defecto es yes.

* dnssec-validation: Especifica si se debe probar si un registro DNS es autentico
  via DNSSEC. La opción por defecto es yes.

* forwarders: Especifica una lista de IPs de servidores de nombre válidas a las
  cuales se les pueden reenviar consultas de resolución.

* forward: Especifica el comportamiento de la directiva forwarders. Acepta los
  siguientes valores:
  * first: El servidor consultara al listado de servidores de nombres antes de
    tratar de resolver el mismo dicha consulta.
  * only: Cuando no se pueda consultar al listado de servidores forwarders,
    el servidor no intentará resolver por el mismo dicha consulta.

* listen-on: Especifica el puerto y la dirección de red IPv4 en la que escuchará
  el servidor. En un DNS que actua solo como gateway, se puede usar esta opción
  para responder consultas originadas desde una única red solamente. Por defecto
  todas las Interfaces IPv4 son usadas para atender las con

* listen-on-v6: Similar a la opción anterior, pero para IPv6.

* max-cache-size: Especifica el máximo de memoria cache que se utilizará para
  guardar las respuestas de las consultas realizadas. La opción por defecto es 32M.

* notify: Especifica a cuales de sus servidores secundarios se debe notificar
  cuando una de sus zonas es actualizada. Las opciones que acepta son las siguientes:
  * yes: Se notificará a todos los secundarios.
  * no : No se notificará a nadie.
  * master-only: El servidor notificará solo a los primarios.
  * explicit: El servidor notificará solo a los servidores secundarios especificados
    en la clausula also-notify de dicha zona.

  * recursion: especifica si el servidor debe trabajar de manera recursiva. El
    valor por defecto es yes.

Ejemplo de una archivo de configuración
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

  options {
    allow-query       { localhost; };
    listen-on port    53 { 127.0.0.1; };
    listen-on-v6 port 53 { ::1; };
    max-cache-size    256M;
    directory         "/var/named";

    recursion         yes;
    dnssec-enable     yes;
    dnssec-validation yes;
  };

Zone (zonas)
------------

La sentencia zone permite definir características de una zona particular, como
es la ubicación de su archivo de configuración u opciones especificas de la misma,
y pueden ser utilizadas para sobre-escribir las opciones globales.
Su sintaxis es la siguiente

.. code:: bash

  zone zone-name [zone-class] {
    option;
    ...
  };

La variable zone-name especifica el nombre de la zona y opcionalmente zone-class
el tipo de clase correspondiente a la misma. La clave option especifica las
opciones particulares dentro de dicha zona, entre las que podemos destacar

* allow-query: similar a la opción global, pero solo aplicable para esta zona.

* allow-transfer: Especifica que servidores secundarios pueden solicitar la
  transferencia de esta zona. Por defecto todas las peticiones de transferencia
  estan permitidas.

*  allow-update: Especifica que hosts tienen permitido actualizar dinámicamente
 	 la información en esta zona. Por defecto esta en deny all.
   Se debe ser cuidadoso al permitir quien puede actualizar estas.

* file: Especifica el nombre del archivo que contiene la especificación de la zona.

* masters: Especifica desde que direcciones IP se pueden realizar consultas
  autoritativas. Esta opción es utilizada unicamente si la zona esta definida
  como esclava.

* notify: Similar a la opción global, pero aplicable solo para esta zona.

* type: Especifica el tipo de zona. Esta opción acepta los siguientes valores:
  * delegation-only: Fuerza la delegación de zonas de infrastructuras como COM,
    NET, ó ORG. Cualquier respuesta qu es recibida sin una delegación explicita
    o implicita, son tratadas como NXDOMAIN. Esta opción es solo aplicable en
    las zonas raiz o TLDs (Top-Level Domains)
  * forward: Reenvia todas las consultas de esta zona a otros servidores de nombre.
  * hint: Un tipo especial de zona utilizada para apuntar a servidores raíz
    para que resuelvan consultas cuando una zona no es conocida.
  * master: Define quienes son los servidores de nombre autoritativos para esta
    zona. La zona debería definirse como master, si la configuración de la misma
    reside en el sistema solamente.
    slave: Especifica los servidores esclavos para esta zona.

Ejemplo configuración de zona en un servidor primario
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

  zone "example.com" IN {
    type master;
    file "example.com.zone";
    allow-transfer { 192.168.0.2; };
  };

En este caso le decimos que la zona que se denomina "example.com" esta definida
como master en este servidor, que su archivo con la definición de los host que
pertenecen a la misma se encuentra en "example.com.zone" y que se le permite
la transferencia de la misma al equipo 192.168.0.2 (el que debería ser otro
servidor dns definido como esclavo de esta zona)

Ejemplo configuración de zona en un servidor secundario
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

  zone "example.com" {
    type slave;
    file "slaves/example.com.zone";
    masters { 192.168.0.1; };
  };

Como verán la diferencia es muy mínima, solo cambia el tipo y bueno, en este
caso le decimos quien es el master de dicha zona para que acepte las actualizaciones
cuando se realizan cambios en la misma.


Referencias
===========

https://www.digitalocean.com/community/tutorials/an-introduction-to-dns-terminology-components-and-concepts

investigar
https://calomel.org/unbound_dns.html

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s1-bind
