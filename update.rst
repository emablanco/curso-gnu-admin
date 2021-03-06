Actualización de CentOS
=======================

:Autores: Emiliano López (emiliano.lopez@gmail.com)

          Maximiliano Boscovich (maximiliano@boscovich.com.ar)

:Fecha: |date| |time|

.. |date| date:: %d/%m/%Y
.. |time| date:: %H:%M

.. header::
  Curso Administracion GNU/Linux

.. footer::
    ###Page### / ###Total###

El software de CentOS y su documentación se proveen en archivos llamados paquetes RPM. Cada paquete es un archivo comprimido que contiene metadatos y varios archivos, íconos, documentación, scripts, etc. Estos paquetes además cuentan con una firma digital que comprueban su origen.

Nombre de los paquetes
----------------------

Un paquete puede ser referenciado para instalar, actualizar, eliminar, listar, etc. con cualquiera de
los siguientes identificadores (entre otros):

- nombre
- nombre.arquitectura
- nombre-version-release
- nombre-version-release.arch

Por ejemplo: ``yum install kernel-2.4.1-10.i686``

Sobre los repositorios
----------------------

Un repositorio es un directorio o sitio web que contiene paquetes de software y archivos índice. Aplicaciones de administración de paquetes como ``yum`` automaticamente ubican y obtienen el paquete RPM desde estos repositorios. Este método libera al usuario de tener que buscar e instalar nuevas aplicaciones o actualizarlas.

Los repositorios del sistema están almacenados con extensión ``.repo`` bajo el directorio ``/etc/yum.repos.d/``, cada uno tiene el formato de archivo de configuración, formado por secciones y luego clave-valor, donde se indica su url, si está habilitado (``enable=0``), entre otros.

CentOS viene preconfigurado para usar una red de servidores que proveen varios repositorios:

- [base] Paquetes que forman CentOS tal como están en los ISOs. Habilitado por default.

- [updates] Paquetes actualizados para [base] lanzados luego del ISOs de CentOS. Serán de Seguridad, BugFix, o  Mejoras del software de [base]. Habilitado por default.

- [addons] - Contains packages required in order to build the main Distribution or packages produced by SRPMS built in the main Distribution, but not included in the main Redhat package tree (mysql-server in CentOS-3.x falls into this category). Packages contained in the addons repository should be considered essentially a part of the core distribution, but may not be in the upstream Package tree. It is enabled by default.

- [contrib] - Packages contributed by the CentOS Users, which do not overlap with any of the core Distribution packages. These packages have not been tested by the CentOS developers, and may not track upstream version releases very closely. It is disabled by default.

- [centosplus] - Packages contributed by CentOS Developers and the Users. These packages might replace rpm's included in the core Distribution. You should understand the implications of enabling and using packages from this repository. It is diabled by default

- [csgfs] - Packages that make up the Cluster Suite and Global File System. It is disabled by default.

- [extras] - Packages built and maintained by the CentOS developers that add functionality to the core distribution. These packages have undergone some basic testing, should track upstream release versions fairly closely and will never replace any core distribution package. It is enabled by default.

- [testing] - Packages that are being tested proir to release, you should not use this repository except for a specific reason. It is disabled by default.

Repositorios externos
'''''''''''''''''''''

En algunas ocasiones nos veremos en la necesidad de agregar repositorios de terceros para instalar una versión más reciente de un programa que la disponible en los repositorios oficiales.

La manera recomendada de agregar un repositorio es incluyendo un archivo de extensión .repo, bajo ``/etc/yum.repos.d/``. Además, CentOS provee la herramienta

.. code-block:: bash

    yum-config-manager --add-repo REPO_URL

que automáticamente crea el archivo necesario y luego resta habilitarlo haciendo:

.. code-block:: bash

    yum-config-manager --enable REPO_ID

donde *REPO_ID* es la identificación del repositorio (use ``yum repolist all`` para listar las IDs de los repositorios disponibles).

Para mayor detalle sobre esto vea el capítulo *8.5.5 (pág. 90). Adding, Enabling, and Disabling a Yum Repository* de *Red Hat Enterprise Linux 7 System Administrator's Guide*.

Yellowdog Updater Modified (yum)
--------------------------------

``yum`` es un administrador de paquetes por línea de comandos para distribuciones basadas en RPM como Red Hat, Centos y Fedora. Como la mayoría de administradores de paquetes cuenta con interfaces gráficas como yumex (yum Extender) o PackageKit. ``yum`` resuelve automáticamente las dependencias, descargando los paquetes necesarios e instalándolos en el orden correcto. Estos paquetes se almacenan bajo el directorio
``/var/cache/yum/`` y en caso que se requiera eliminarlos se debe ejecutar ``yum clean all``.

Veamos a continuación algunos de los comandos más útiles. Para conocer el resto de las opciones
vea el manual ejecutando ``man yum``.

**ACTIVIDAD 1.1:**  Corrobore los repositorios del sistema en ``/etc/yum.repos.d/``. Observe el contenido del repositorio base y compare con el listado de servidores previamente mencionado. Corrobore la configuración global de yum en ``yum.conf``.

Para más información puede referirse a la ayuda haciendo man ``yum.conf`` o en el capítulo 8.5 (pág. 82) del libro *Red Hat Enterprise Linux 7 System Administrator's Guide*.

Instalación
'''''''''''

Se debe ingresar el nombre exacto del paquete, por ejemplo nmap y python34:

.. code-block:: bash

    yum install nmap python34

Al instalar un paquete del modo previo nos solicitará confirmación del siguiente modo:

``Is this ok [y/d/N]:``

- ``y``: confirmamos descarga e instalación
- ``d``: solamente descarga, sin instalación
- ``N``: abortamos acción (en mayúsculas al ser la opción por defecto)

Con este comando también es posible instalar un paquete manualmente, es decir, a partir de un
archivo .rpm.

.. code-block:: bash

    yum install paquete.rpm

Como toda distribución que provee un sistema de instalación a través de repositorios, siempre
es recomendable hacer toda instalación o actualización a través del repositorio.

Eliminación
'''''''''''

Al igual que el anterior pero usando la palabra ``remove``:

.. code-block:: bash

    yum remove nmap

Actualización
'''''''''''''

Para comprobar si existen actualizaciones disponibles de los paquetes instalados debemos hacer:

.. code-block:: bash

    yum check-update

En versiones previas de CentOS había diferencia entre los comandos ``update`` y ``upgrade``, actualmente ejecutan
las mismas acciones.

Es posible actualizar un paquete específico o bien el sistema completo. Para el primer caso hacemos:

.. code-block:: bash

    yum update mysql

Esto actualizará el paquete ``mysql`` a la última versión estable. Para actualizar el sistema
hacemos:

.. code-block:: bash

    yum update

Si los paquetes cuentan con actualizaciones de seguridad, es posible **solamente** actualizar esos paquetes a su última versión:

.. code-block:: bash

    yum update --security

También es posible actualizar paquetes solamente hasta la versión que contiene actualizaciones de seguridad:

.. code-block:: bash

    yum update-minimal --security

Por ejemplo, asumamos que:

- el kernel-3.10.0-1 esta instalado en el sistema;
- el kernel-3.10.0-2 fue lanzado como una actualización de **seguridad**
- el kernel-3.10.0-3 fue lanzado como una actualización de un **bug**

Entonces, ``yum update-minimal --security`` actualizará el paquete a kernel-3.10.0-2, y ``yum update --security`` lo hará a kernel-3.10.0-3.

**ACTIVIDAD 1.2:**

- Corrobore si hay actualizaciones disponibles en su sistema y en caso afirmativo realícela.
- Instale el paquete ``vim``, observe y explique las sugerencias que recibe del sistema

Búsqueda
''''''''

Para buscar un paquete se utiliza la opción ``search``. El algoritmo busca coincidencias
primeramente en el nombre del paquete y resumen, si no hubo aciertos continúa la búsqueda
en la descripción o en la URL.

.. code-block:: bash

    yum search KDE

El resultado de este comando es un listado de los paquetes que coincidieron y su resumen.
En caso que se quiera acceder a la descripción completa del paquete se utiliza la opción
info.

.. code-block:: bash

    yum info firefox

**ACTIVIDAD 1.2:** Busque el paquete ``htop``. Corrobore la información disponible (versión, repositorio, descripción, etc) y luego realice la instalación.

**ACTIVIDAD 1.3:** 

- Investigue la opción de búsqueda ``yum search all`` para encontrar un paquete en cuya descripción contiene las palabras *Japanese enhancement screens*. Instale aquel paquete que en el que coinciden todas las palabras. ¿Para qué sirve, analice y aprenda su uso básico?
- Corrobore en qué paquete se encuentra la herramienta ``ifconfig``. Instale dicho paquete.


Grupos de paquetes
''''''''''''''''''

Ciertos paquetes individuales están clasificados en grupos, por lo que es posible
listar o instalar todos los paquetes que pertenecen a un mismo grupo.

Para listar los grupos disponibles se utiliza el siguiente comando:

.. code-block:: bash

    yum grouplist

Para instalarlos, se utiliza el nombre del grupo entre comillas:

.. code-block:: bash

    yum groupinstall "GNOME Desktop"

Para actualizar un grupo de paquetes:

.. code-block:: bash

    yum groupupdate "GNOME Desktop"

Para eliminar

.. code-block:: bash

    yum groupremove "GNOME Desktop"

**ACTIVIDAD 1.4:**

- Instale el entorno de escritorio GNOME. Corrobore que inicie correctamente con el comando ``startx``. Investigue cómo cambiar la configuración de CentOS para que se inicie el entorno gráfico por defecto (vea ``systemctl set-default ...`` en modos de inicio del apunte introductorio).
- Descargue e instale manualmente el paquete rpm ``https://code.visualstudio.com/docs/?dv=linux64_rpm``

Repositorios disponibles
''''''''''''''''''''''''

Para listar los repositorio yum habilitados:

.. code-block:: bash

    yum repolist

Para listar también los deshabilitados se agrega el parámetro ``all``.
En caso de pretender instalar un paquete de un repositorio específico se debe
agregar el parámetro ``--enablerepo=NOMBRE_REPO`` al comando de instalación de
paquetes.

Listados
''''''''

Funcionalidad utilizada para listar información sobre paquetes disponibles en los repositorios
o aquellos instalados en el sistema. A continuación veremos los más utilizados.

Para listar tanto los paquetes **disponibles** como los **instalados**:

.. code-block:: bash

    yum list all

Para listar solamente los paquetes disponibles en los repositorios:

.. code-block:: bash

    yum list available

Para listar todos los paquetes instalados en el sistema:

.. code-block:: bash

    yum list installed

Para listar los paquetes instalados en el sistema pero que no están disponibles en ningún repositorio

.. code-block:: bash

    yum list extras

**ACTIVIDAD 1.5:**

- Corrobore si se encuentra instalado el paquete ``wget`` y ``links`` mediante el uso de ``yum list``. ¿Qué diferencias encuentra con ``yum search`` y ``yum info``?
- Corrobore los paquetes que fueron instalados por fuera de los respositorios

Downgrade de paquetes
---------------------

Ante una actualización de paquetes es posible que no obtengamos el comportamiento deseado, y sea necesario volver a una versión
previa. Esto es posible salvo para paquetes críticos como ``selinux``, ``selinux-policy-*``, `kernel`` y ``glibc`` que no está soportado.

**ACTIVIDAD 1.6:** busque en el manual de yum para qué es la opción ``downgrade`` y comente para qué casos lo utilizaría.

Cabe preguntarse, ¿qué sucede en la próxima actualización? ¿es posible fijar un paquete a una determinada versión?

Ver el paquete ``yum-plugin-versionlock`` en el siguiente enlace_.

Básicamente se agrega la versión del paquete a fijar en 
``/etc/yum/pluginconf.d/versionlock.list``

.. _enlace: https://access.redhat.com/solutions/98873

RPM
---

En el apéndice A del manual oficial *Red Hat Enterprise Linux 7 System Administrator's Guide* puede encontrar
instrucciones detalladas sobre el uso del administrador de paquetes ``rpm``.

Repositorio local
-----------------

En una infraestrura de varios equipos una alternativa interesante para acelerar las descargas de paquetes es implementar
un repositorio local. De este modo, los equipos descargaran por la red LAN los paquetes para instalaciones economizando
el uso del enlace a internet.

Si bien no entraremos en detalle sobre el modo de implementarlo, veremos unas pautas generales sobre la manera de llevarlo
a cabo:

- Copiar todos los paquetes ``.rpm`` (desde un DVD o la web oficial) a un directorio local (DIRLOCAL) que a su vez debe ser servido mediante ftp o http.

- Crear un archivo ``.repo`` bajo ``/etc/yum.repos.d/`` con el contenido

.. code-block:: bash

    [localrepo]
    name=Unixmen Repository
    baseurl=file://DIRLOCAL
    gpgcheck=0
    enabled=1


- Crear el repositorio usando el comando ``createrepo -v DIRLOCAL``

- Deshabilitar el resto de los repositorios

- Configurar en los clientes creando el archivo ``/etc/yum.repos.d/localrepo.repo`` con el siguiente contenido

.. code-block:: bash

    [localrepo]
    name=Unixmen Repository
    baseurl=http://IP/DIRLOCAL
    gpgcheck=0
    enabled=1


- Restará desahilitar el resto de los repositorios

Una guía detallada sobre este proceso puede encontrarse en https://access.redhat.com/solutions/9892

Referencias
-----------

- https://www.centos.org/docs/5/html/yum/sn-software-management-concepts.html
- Red Hat Enterprise Linux 7 System Administrator's Guide
- https://access.redhat.com/solutions/29617
- https://www.if-not-true-then-false.com/2010/yum-downgrade-packages-on-fedora-centos-red-hat-rhel/
