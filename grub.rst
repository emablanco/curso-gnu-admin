GRUB
====

GRUB 2(GNU GRand Unified Bootloader) permite al usuario seleccionar el sistema operativo o el kernel a ser cargado al momento del inicio.

El archivo de configuración de GRUB 2, ``grub.cfg`` es generado:

- durante la instalación del S.O.
- al invocar ``/usr/bin/grub2-mkconfig``
- por ``grubby`` cada vez que se instala un kernel

Al utilizar ``grub2-mkconfig`` el archivo es generado de acuerdo a la plantilla ubicada en ``/etc/grub.d/`` y a la configuración almacenada en el archivo ``/etc/default/grub``.

Por este motivo no se debe modificar el archivo ``grub.cfg`` ya que los cambios se perderán cada vez que se ejecute ``grub2-mkconfig``. 

Las operaciones sobre ``grub.cfg`` que normalemente se realizan ante la eliminación o instalación de un nuevo kernel se deben hacer mediante ``grubby``.

Cambios temporales
------------------

Cambios permanentes con grubby
------------------------------

Personalizando la configuración
-------------------------------



Referencias
-----------
- Red Hat Enterprise Linux 7 System Administrator's Guide, cap. 25 (pág. 539).
