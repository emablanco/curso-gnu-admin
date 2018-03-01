Actualización de CentOS
=======================

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

CentOS viene preconfigurado para usar una red de servidores que proveen varios repositorios:

- [base] Paquetes que forman CentOS tal como están en los ISOs. Habilitado por default.

- [updates] Paquetes actualizados para [base] lanzados luego del ISOs de CentOS. Serán de Seguridad, BugFix, o  Mejoras del software de [base]. Habilitado por default.

- [addons] - Contains packages required in order to build the main Distribution or packages produced by SRPMS built in the main Distribution, but not included in the main Redhat package tree (mysql-server in CentOS-3.x falls into this category). Packages contained in the addons repository should be considered essentially a part of the core distribution, but may not be in the upstream Package tree. It is enabled by default.

- [contrib] - Packages contributed by the CentOS Users, which do not overlap with any of the core Distribution packages. These packages have not been tested by the CentOS developers, and may not track upstream version releases very closely. It is disabled by default.

- [centosplus] - Packages contributed by CentOS Developers and the Users. These packages might replace rpm's included in the core Distribution. You should understand the implications of enabling and using packages from this repository. It is diabled by default

- [csgfs] - Packages that make up the Cluster Suite and Global File System. It is disabled by default.

- [extras] - Packages built and maintained by the CentOS developers that add functionality to the core distribution. These packages have undergone some basic testing, should track upstream release versions fairly closely and will never replace any core distribution package. It is enabled by default.

- [testing] - Packages that are being tested proir to release, you should not use this repository except for a specific reason. It is disabled by default. 

Los repositorios del sistema están almacenados con extensión ``.repo`` bajo el directorio ``/etc/yum.repos.d/``, cada uno tiene el formato de archivo de configuración, formado por secciones y luego clave-valor, donde se indica su url, si está habilitado (``enable=0``), entre otros.

Yellowdog Updater Modified (yum)
--------------------------------

``Yum`` es un administrador de paquetes por línea de comandos para distribuciones basadas en RPM como Red Hat, Centos y Fedora. Como la mayoría de administradores de paquetes cuenta con interfaces gráficas como yumex (yum Extender) o PackageKit. ``yum`` resuelve automáticamente las dependencias, descargando los paquetes
necesarios y luego instalándolos en el orden correcto. Estos paquetes se almacenan bajo el directorio
``/var/cache/yum/`` y en caso que se requiera eliminarlos se debe ejecutar ``yum clean all``.

Veamos a continuación algunos de los comandos más útiles. Para conocer el resto de las opciones
vea el manual ejecutando ``man yum``.

Instalación
'''''''''''

Se debe ingresar el nombre exacto del paquete, por ejemplo firefox:

.. code-block:: bash
    
    yum install firefox

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

Al igual que el anterior pero usando la palabra remove:

.. code-block:: bash
    
    yum remove firefox
    
Actualización
'''''''''''''

Es posible actualizar un paquete específico o bien el sistema completo. Para el primer
caso hacemos:

.. code-block:: bash
    
    yum update mysql
    
Esto actualizará el paquete mysql a la última versión estable. Para actualizar el sistema
hacemos:

.. code-block:: bash
    
    yum update

Otra opción es comprobar si existen actualizaciones disponibles de los paquetes instalados, 
para esto debemos hacer:

.. code-block:: bash
    
    yum check-update

En versiones previas había diferencia entre los comandos update y upgrade, actualmente ejecutan
las mismas acciones.

Si los paquetes cuentan con actualizaciones de seguridad, es posible solamente actualizar esos paquetes a su última versión:

.. code-block:: bash

    yum update --security
    
También es posible actualizar paquetes solamente hasta la versión que contiene actualizaciones de seguridad:

.. code-block:: bash

    yum update-minimal --security

Por ejemplo, asumamos que:

- el kernel-3.10.0-1 esta instalado en el sistema; 
- el kernel-3.10.0-2 fue lanzado como una actualización de seguridad
- el kernel-3.10.0-3 fue lanzado como una actualización de un bug

Entonces, ``yum update-minimal --security`` actualizará el paquete a kernel-3.10.0-2, y ``yum update --security`` lo hará a kernel-3.10.0-3.

Búsqueda
''''''''

Para buscar un paquete se utiliza la opción search. El algoritmo busca coincidencias
primeramente en el nombre del paquete y resumen, si no hubo aciertos continúa la búsqueda
en la descripción o en la URL.

.. code-block:: bash
    
    yum search KDE

El resultado de este comando es un listado de los paquetes que coincidieron y su resumen. 
En caso que se quiera acceder a la descripción completa del paquete se utiliza la opción
info.

.. code-block:: bash
    
    yum info firefox

Grupos de paquetes
'''''''''''

Ciertos paquetes individuales están clasificados en grupos, por lo que es posible
listar o instalar todos los paquetes que pertenecen a un mismo grupo.

Para listar los grupos disponibles se utiliza el siguiente comando:

.. code-block:: bash
    
    yum grouplist
    
Para instalarlos, se utiliza el nombre del grupo entre comillas:

.. code-block:: bash
    
    yum groupinstall "KDE" "X Window System"

Para actualizar un grupo de paquetes:

.. code-block:: bash
    
    yum groupupdate "KDE"
    
Para eliminar

.. code-block:: bash
    
    yum groupremove "KDE"
    
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

Funcionalidad utilizada para listar información sobre paquetes disponibles en los repositorio
o instalados en el sistema. A continuación veremos los más utilizados.

Para listar tanto los paquetes disponibles como los instalados:

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

RPM
---

En el apéndice A del manual oficial *Red Hat Enterprise Linux 7 System Administrator's Guide* puede encontrar
instrucciones detalladas sobre el uso del administrador de paquetes ``rpm``.

Referencias
-----------

- https://www.centos.org/docs/5/html/yum/sn-software-management-concepts.html

