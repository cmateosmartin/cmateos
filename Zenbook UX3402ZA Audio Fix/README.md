### La intención de este documento es dejar constancia del procedimiento seguido para hacer funcionar los altavoces internos del Zenbook UX3402ZA en linux.

##### Este procedimiento NO es oficial y las consecuancias de su uso serán de quien lo ejecute y bajo ninguna circunstancia mía o de los autores citados.



Mi configuración:
- OS: Ubuntu 22.04.2 LTS x86_64
- Host: Zenbook UX3402ZA
- Kernel: 6.2.10-060210-generic
- CPU: 12th Gen Intel i5-1240P (16) @ 4.400GHz
- GPU: Intel Alder Lake-P
- BIOS version: 310



Prerrequisitos:
1. Tener instalado la versión del kernel 6.0 o superior (https://linux.how2shout.com/linux-kernel-6-2-features-in-ubuntu-22-04-20-04/)

    1.1 Comprobar la versión actual del kernel:
    ```
    uname -r
    ```
    1.2 En caso de que la versión sea inferior a la version 6.x ejecutar los siguientes comandos:
    ```
    sudo apt-get update
    sudo apt-get upgrade
    mkdir kernel && cd kernel
    ```
    ```
    wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
    ```
    [sudo mv ubuntu-mainline-kernel.sh /usr/local/bin/] #Para usarlo fácilmente en el futuro, ya que el directorio se encuentra en el $PATH
    ```
    chmod +x ubuntu-mainline-kernel.sh
    ```
    ```
    sudo ./ubuntu-mainline-kernel.sh -i
    ```
    ```
    sudo reboot
    ```
2. Actualizar la version de la BIOS a la última disponible (https://www.asus.com/us/laptops/for-home/zenbook/zenbook-14-oled-ux3402/helpdesk_bios/?model2Name=zenbook-14-oled-ux3402)



Documentación:
- https://gist.github.com/lamperez/862763881c0e1c812392b5574727f6ff
- https://gist.github.com/lamperez/d5b385bc0c0c04928211e297a69f32d7
- https://wiki.archlinux.org/title/DSDT
- https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1045690
- https://itsfoss.com/update-grub/

Procedimiento:
1. Instalar las herramientas que nos van a permitir ensamblar y desensamblar las tablas ACPI:
```
sudo apt install acpica-tools
```
2. Crear una carpeta temporal (por comodidad)
```
mkdir acpi && cd acpi
```
3.  Extraer las tablas
```
sudo acpidump -b
```
4. Desensamblar las tablas
```
iasl -d dsdt.dat
```
5. Modificar las tablas añadiendo los objetos indicados en https://gist.github.com/lamperez/862763881c0e1c812392b5574727f6ff 
   Utilizar la 
```
vim dsdt.dsl
```
```
+++ dsdt.dsl	2023-03-26 12:00:45.643851841 +0200
@@ -18,7 +18,7 @@
  *     Compiler ID      "INTL"
  *     Compiler Version 0x20200717 (538969879)
  */
-DefinitionBlock ("", "DSDT", 2, "_ASUS_", "Notebook", 0x01072009)
+DefinitionBlock ("", "DSDT", 2, "_ASUS_", "Notebook", 0x0107200A)
 {
     /*
      * iASL Warning: There were 233 external control methods found during
@@ -90642,7 +90642,43 @@
             Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
             {
             }
+
+            Name (_DSD, Package ()   // _DSD: Device-Specific Data
+            {
+                ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"), 
+                Package ()
+                {
+                    Package () { "cirrus,dev-index", Package () { Zero, One }},
+                    Package () { "reset-gpios", Package () {
+                       SPK1, One, Zero, Zero,
+                       SPK1, One, Zero, Zero,
+                    } },
+                    Package () { "spk-id-gpios", Package () {
+                       SPK1, 0x02, Zero, Zero,
+                       SPK1, 0x02, Zero, Zero,
+                    } },
+                    Package () { "cirrus,speaker-position",     Package () { Zero, One } },
+                    // gpioX-func: 0 not used, 1 VPSK_SWITCH, 2: INTERRUPT, 3: SYNC
+                    Package () { "cirrus,gpio1-func",           Package () { One, One } },
+                    Package () { "cirrus,gpio2-func",           Package () { 0x02, 0x02 } },
+                    // boost-type: 0 internal, 1 external
+                    Package () { "cirrus,boost-type",           Package () { One, One } },
+                },
+            })
         }
+
+        Name (_DSD, Package ()
+        {
+            ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"), 
+            Package ()
+            {
+                Package () { "cs-gpios", Package () { 
+                    Zero,                    // Native CS
+                    SPK1, Zero, Zero, Zero   // GPIO CS
+                } }
+            }
+        })
+
     }
```

6. Ensamblar las tablas ACPI 
```
iasl -sa dsdt.dsl
```
7. Copiar la tabla ensamblada a la carpeta de arranque
```
cp -p dsdt.aml /boot/dsdt.aml
```
8. Crear el script /etc/grub.d/01_acpi con instrucciones para que coja las tablas ACPI creadas en los pasos anteriores
```
vim /etc/grub.d/01_acpi
```
```
#! /bin/sh -e

# Uncomment to load custom ACPI table
GRUB_CUSTOM_ACPI="/boot/dsdt.aml"

# DON'T MODIFY ANYTHING BELOW THIS LINE!

prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib

. ${libdir}/grub/grub-mkconfig_lib

# Load custom ACPI table
if [ x${GRUB_CUSTOM_ACPI} != x ] && [ -f ${GRUB_CUSTOM_ACPI} ] \
        && is_path_readable_by_grub ${GRUB_CUSTOM_ACPI}; then
    echo "Found custom ACPI table: ${GRUB_CUSTOM_ACPI}" >&2
    prepare_grub_to_access_device `${grub_probe} --target=device ${GRUB_CUSTOM_ACPI}` | sed -e "s/^/ /"
    cat << EOF
acpi (\$root)`make_system_path_relative_to_its_root ${GRUB_CUSTOM_ACPI}`
EOF
fi
```

9. Dar permisos de ejecución al script anterior
```
chmod +x /etc/grub.d/01_acpi
```
10. Actualizar grub2
```
sudo update-grub
```
