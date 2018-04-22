GRUB
====


Como es el proceso de arranque
------------------------------

1. El sistema carga y ejecuta el gestor de arranque. Las especificaciones de este
proceso dependen de la arquitectura del sistema. Por ejemplo:

* BIOS:
  en sistemas basados en x86 ejecutan una primera etapa del gestor de arranque
  desde el MBR del disco duro primario, el cual, a su vez, carga un gestor de
  arranque adicional, GRUB.
* UEFI en sistemas basados en x86 montan una partición de sistema EFI que
  contiene una versión del gestor de arranque de GRUB. El gestor de arranque EFI
  carga y ejecuta GRUB como una aplicación de EFI.

2. El gestor de arranque carga el kernel en memoria, la cual a su vez carga los
módulos necesarios y monta la partición root para sólo-lectura.

3. El kernel transfiere el control del proceso de arranque al programa /sbin/init.

4. El programa /sbin/init carga todos los servicios y herramientas de espacio del
usuario y monta todas las particiones listadas en /etc/fstab.

5. Se le presenta al usuario una pantalla de inicio de conexión para el sistema
Linux recién iniciado.

GRUB 2
------

GRUB 2(GNU GRand Unified Bootloader) permite al usuario seleccionar el sistema operativo o el kernel a ser cargado al momento del inicio.

El archivo de configuración de GRUB 2, ``/boot/grub2/grub.cfg`` es generado:

- Durante la instalación del S.O.
- Al invocar ``/usr/bin/grub2-mkconfig``
- por ``grubby`` cada vez que se instala un kernel

Al utilizar ``grub2-mkconfig`` el archivo es generado de acuerdo a la plantilla
ubicada en ``/etc/grub.d/`` y a la configuración almacenada en el archivo ``/etc/default/grub``.

Por este motivo no se debe modificar el archivo ``grub.cfg`` ya que los cambios
se perderán cada vez que se ejecute ``grub2-mkconfig``.

Las operaciones sobre ``grub.cfg`` que normalemente se realizan ante la
eliminación o instalación de un nuevo kernel se deben hacer mediante ``grubby``.

Cambios temporales
..................

Al momento de inicio, cuando se presenta el menu de grub2, podemos presionar
la tecla "e" y de ese modo ingresar al menu de edición de grub. Todos los
cambios que relalicemos durarán hasta que reiniciemos el equipo.

Cambios permanentes con grubby
..............................

La herramienta grubby puede utilizar para leer la información de grub2, y
generar el nuevo archivo /boot/grub2/grub.cfg, quedando de este modo de manera
persistente los mismos.

* Para visulalizar todos los kernels disponibles, ejecutamos

.. code:: bash

  [root@localhost ~]# grubby --info=ALL
  index=0
  kernel=/boot/vmlinuz-3.10.0-693.21.1.el7.x86_64
  args="ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet LANG=es_AR.UTF-8"
  root=/dev/mapper/centos-root
  initrd=/boot/initramfs-3.10.0-693.21.1.el7.x86_64.img
  title=CentOS Linux (3.10.0-693.21.1.el7.x86_64) 7 (Core)
  index=1
  kernel=/boot/vmlinuz-3.10.0-693.el7.x86_64
  args="ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb LANG=es_AR.UTF-8 quiet"
  root=/dev/mapper/centos-root
  initrd=/boot/initramfs-3.10.0-693.el7.x86_64.img
  title=CentOS Linux (3.10.0-693.el7.x86_64) 7 (Core)
  index=2
  kernel=/boot/vmlinuz-0-rescue-8f345dae63df40e39b2469ca7e7d8be9
  args="ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet"
  root=/dev/mapper/centos-root
  initrd=/boot/initramfs-0-rescue-8f345dae63df40e39b2469ca7e7d8be9.img
  title=CentOS Linux (0-rescue-8f345dae63df40e39b2469ca7e7d8be9) 7 (Core)
  index=3
  non linux entry

Si queremos ver las opciones de una entrada en particular, le pasamos el kernel
en cuestion

.. code:: bash

  [root@localhost ~]# grubby --info=/boot/vmlinuz-3.10.0-693.21.1.el7.x86_64
  index=0
  kernel=/boot/vmlinuz-3.10.0-693.21.1.el7.x86_64
  args="ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet LANG=es_AR.UTF-8"
  root=/dev/mapper/centos-root
  initrd=/boot/initramfs-3.10.0-693.21.1.el7.x86_64.img
  title=CentOS Linux (3.10.0-693.21.1.el7.x86_64) 7 (Core)

Si queremos ver cual es el kernel que bootea por defecto

.. code:: bash

  [root@localhost ~]# grubby --default-index
  0

Si queremos ver que kernel es

.. code:: bash

  [root@localhost ~]# grubby --default-kernel
  /boot/vmlinuz-3.10.0-693.21.1.el7.x86_64

Si queremos cambiar los argumentos de booteo

.. code:: bash

  [root@localhost ~]# grubby --remove-args "quiet" --update-kernel /boot/vmlinuz-3.10.0-693.el7.x86_64

Si queremos agregar un argumento de booteo

.. code:: bash

  [root@localhost ~]# grubby --args "quiet" --update-kernel /boot/vmlinuz-3.10.0-693.el7.x86_64

Si queremos actualizar todos los kernels, agregando o sacando argumentos

.. code:: bash

  [root@localhost ~]# grubby --update-kernel=ALL --args=console=ttyS0,115200 --remove-args="quiet"

si queremos cambiar la entrada de booteo por defecto

.. code:: bash

  [root@localhost ~]# grubby --set-default-index=0


Personalizando la configuración
...............................



Referencias
-----------
- Red Hat Enterprise Linux 7 System Administrator's Guide, cap. 25 (pág. 539).
- Red Hat Enterprise Linux 6 Guía de instalación, Apéndice F.
