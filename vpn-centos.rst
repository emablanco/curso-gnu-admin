OpenVPN
=======

There are three major families of VPN implementations in wide usage today: SSL, IPSec, and PPTP. OpenVPN is an SSL VPN and as such is not compatible with IPSec, L2TP, or PPTP.

The IPSec protocol is designed to be implemented as a modification to the IP stack in kernel space, and therefore each operating system requires its own independent implementation of IPSec.

By contrast, OpenVPN's user-space implementation allows portability across operating systems and processor architectures, firewall and NAT-friendly operation, dynamic address support, and multiple protocol support including protocol bridging.

There are advantages and disadvantages to both approaches. The principal advantages of OpenVPN's approach are portability, ease of configuration, and compatibility with NAT and dynamic addresses. The learning curve for installing and using OpenVPN is on par with that of other security-related daemon software such as ssh.

Historically, one of IPSec's advantages has been multi-vendor support, though that is beginning to change as OpenVPN support is beginning to appear on dedicated hardware devices.

While the PPTP protocol has the advantage of a pre-installed client base on Windows platforms, analysis by cryptography experts has revealed ​security vulnerabilities. 

Instalación
-----------

Instalamos el repositorio EPEL (Extra Packages for Enterprise Linux). Esto es porque OpenVPN no esta disponible en los repositorios por defecto de CentOS. EPEL es un repositorio adicional gestionado por el proyecto Fedora.

Luego instalamos el cliente-servidor ``openvpn`` y, ``easy-rsa`` un conjunto de scripts para administrar claves y certificados.

.. code-block:: bash

    yum install epel-release
    yum install openvpn easy-rsa
    
Vemos que la versión instalada es la 2.4.4.

Generación de certificados y claves
-----------------------------------

Copiamos los scripts de easy-rsa al directorio de openvpn:

.. code-block:: bash

    cp -rf /usr/share/easy-rsa/VERSION/* /etc/openvpn/easy-rsa

Descargamos el archivo ``vars.example`` de https://github.com/OpenVPN/easy-rsa/blob/v3.0.5/easyrsa3/vars.example 
realizamos una copia denominada ``vars`` que vamos a modificar. 

Una infraestructura de clave pública (PKI) se basa en la noción de confiar en una autoridad particular en autenticar un par remoto. 

Para crear e inicializar una nueva PKI, usamos el comando:

.. code-block:: bash

    ./easyrsa init-pki

Se creará una nueva estructura PKI en blanco lista para ser usada para crear una nueva CA (Autoridad de Certificación) y generar claves. 

Estructura de directorios del PKI
'''''''''''''''''''''''''''''''''

    - private/ - claves privadas generadas para el host
    - reqs/ - dir with locally generated certificate requests (for a CA imported requests are stored here)

In a clean PKI no files will exist until, just the bare directories. Commands called later will create the necessary files depending on the operation.

When building a CA, a number of new files are created by a combination of Easy-RSA and (indirectly) openssl. The important CA files are:

    - ca.crt - This is the CA (Certificate Authority) certificate
    - index.txt - This is the "master database" of all issued certs
    - serial - Stores the next serial number (serial numbers increment)
    - private/ca.key - This is the CA private key (security-critical)
    - certs_by_serial/ - dir with all CA-signed certs by serial number
    - issued/ - dir with issued certs by commonName

Once you have created a PKI, the next useful step will be to either create a CA, or generate keypairs for a system that needs them. Continue with the relevant section below.

Creando la CA
''''''''''''''

In order to sign requests to produce certificates, you need a CA. To create a new CA in a PKI you have created, run:

.. code-block:: bash

    ./easyrsa build-ca

Be sure to use a strong passphrase to protect the CA private key. Note that you must supply this passphrase in the future when performing signing operations with your CA, so be sure to remember it.

During the creation process, you will also select a name for the CA called the Common Name (CN.) This name is purely for display purposes and can be set as you like.

Una vez creada la CA debemos generar el certificado del servidor y de los clientes para ser firmados con la CA. 

Certificado del servidor
'''''''''''''''''''''''''

Creamos el certificado:

.. code-block:: bash

    ./easyrsa gen-req servidor-openvpn-epe nopass

Una vez generado debemos firmarlo:

.. code-block:: bash
    
    ./easyrsa sign-req server servidor-openvpn-epe

Nos solicitará la passphrase para continuar con la firma y una serie de confirmaciones 
y ya hemos creado el .crt que utilizaremos posteriormente en la configuración de OpenVPN.

Certificados de clientes
''''''''''''''''''''''''
Genero y firmo:

.. code-block:: bash

    ./easyrsa gen-req cliente1-openvpn-epe nopass
    ./easyrsa sign-req client cliente1-openvpn-epe
    
Parámetros Diffie-Hellmann y la clave tls-auth
''''''''''''''''''''''''''''''''''''''''''''''

.. code-block:: bash

    ./easyrsa gen-dh
    openvpn --genkey --secret ta.key
    

Organizar los .crt y .key del servidor y clientes
'''''''''''''''''''''''''''''''''''''''''''''''''

Crear un directorio para los archivos del servidor y otro por cada cliente.

Para el servidor:

- ca.crt
- dh.pem
- servidor-openvpn-epe.crt
- servidor-openvpn-epe.key
- ta.key

Para el cliente1:

- ca.crt
- cliente1-openvpn-epe.crt
- cliente1-openvpn-epe.key
- ta.key

Configuración del servidor
--------------------------

Copiamos el archivo de configuración de ejemplo:

.. code-block:: bash
    
    cp /usr/share/doc/openvpn-VERSION/sample/sample-config-files/server.conf /etc/openvpn

Para ver los protocolos de cifrado soportados podemos ejecutar ``openvpn --show-ciphers``.

Configuración del cliente
-------------------------

Debemos tener instalado el paquete openvpn y para su configuración nos basamos en el archivo de configuración de ejemplo:

.. code-block:: bash
    
    cp /usr/share/doc/openvpn-VERSION/sample/sample-config-files/client.conf /etc/openvpn/cliente1-openvpn-epe.conf

Ahí configuramos la ip o nombre del servidor, los certificados, claves, etc. 

Debemos transferir desde el servidor los 4 archivos necesarios: ca.crt y ta.key son los mismos del servidor, mientras que cliente1-openvpn-epe.crt y cliente1-openvpn-epe.key son exclusivos del cliente.

Next we need to run and enable OpenVPN on startup.

.. code-block:: bash
    
    #systemctl start openvpn-client@cliente1-openvpn-epe
    #systemctl -f enable openvpn@server.service
    
Si sale el error debido a la imposibilidad de escribir en el openvpn-status.log se debe ejecutar:

.. code-block:: bash

    ausearch -c 'openvpn' --raw | audit2allow -M my-openvpn
    semodule -i my-openvpn.pp
    


Referencias
-----------

* https://github.com/OpenVPN/easy-rsa
* https://community.openvpn.net/openvpn/wiki/FAQ
* https://www.redeszone.net/redes/openvpn/

