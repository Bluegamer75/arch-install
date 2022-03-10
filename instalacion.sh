#Script creado con la intencion para la gente que no sabe instalar arch linux, todos los comandos iran guiados con una explicacion para que en el momento de la instalacion el usuario comprenda todo lo que hay en la instalacion

#Colores de letras en bash
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
cyan="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

clear
echo -e "${red}Hola, bienvendido al script de instalacion de${end} ${blue}Arch Linux,${end} ${red}todos los comandos estaran explicados uno a uno para que se entienda como funciona la instalacion${end}"
loadkeys es
sleep 5
echo Primero nos pondremos a actualizar los paquetes antes de empezar
sleep 1
echo Utilizaremos sudo pacman -Syu
sudo pacman -Syu
sleep 1 
echo -e "Ahora en caso de que tengas portatil, tienes que decirme como se llama el adaptador de red para activartelo (voy a usar ip link)"
sleep 0.5
ip link
sleep 0.5
echo -e "¿Como se llama tu ${red}adaptador de red ${end}? Escribe el nombre exactamente como lo ves"
read adaptador
echo -e "Ahora voy a activar el wifi con el $adaptador que me has puesto (ip link set $adaptador up)"
ip link set $adaptador up
sleep 0.5
echo -e "A continuacion, necesito saber tu zona horaria para ponersela al sistema, de lo contrario puede que la isntalacion falle y no se instalen bien algunos datos del sistema (te recomiendo que lo busques por internet porque la lista a mostrar tiene mas de 1000 posibilidades)"
read region
echo -e "Estas es tu zona horaria? verificala bien $region (si o no)"
echo -e "Te pondre la zona horaria que has pasado anteriormente al sistema con el comando timedatectl set-timezone $region"
timedatectl set-timezone $region 
sleep 0.5
clear
echo -e "Vamos a comenzar con el ${red}particionado del disco, cuidado con este paso!!!${end}, si lo haces mal, puedes borrar particiones importantes de otros sistemas operativos que tengas instalados, te recomiendo encarecidamente que hagas una copia de antemano o que ya hayas hecho espacio para que tengas ya preparado todo: (utilizaremos cfdisk para el particionado) Al ser instalacion BIOS, ${blue} utiliza la tabla de particiones de DOS${end}"
sleep 5
echo -e "Despues de que hagas las particiones, te voy a listar las particiones y me vas a tener que decir cual es la particion uefi, la root, y la swap por si decidiste usar swap"
sleep 3
cfdisk
sleep 1
lsblk
echo -e "donde tienes la particion de root (esta particion contendra el grub para menos lio)? a este es recomendable darle todo lo que puedas para instalar los programas que desees"
read root
echo -e "tienes alguna particion swap? si tienes, es recomendable que el espacio del swpas sea la mitas de la Memoria RAM."
read swap

if [[ swap = si ]]
then
    echo -e "En que particion tienes la memoria swap?"
    read swap1
else
    echo -e "pues continuemos"
fi

echo -e "Bien, comenzare con el formato de las particiones (primero el swap, con mkswap $swap1 y swapon $swap1)"
mkswap $swap1
swapon $swap1
echo -e "Vale, ahora le dare formato a la particio root ($root), para esto utilizare mkfs.ext4 (para que sea mas facil de entender makefilesystem.ext4)"
mkfs.ext4
echo -e "A continuacion, voy a montar la particion raiz, (mount $root /mnt)"
mount $root /mnt
clear
echo -e "Vale, ahora llega el momento de instalar lo que seria ${blue} Arch Linux${end}, para ello le pasaremos que lo instale donde esta /mnt, para la instalacion utilizaremos pacstrap /mnt base linux linux-firmware nano networkmanager"
echo -e "${red}base${end}, es lo que seria el sistema base de ${blue} Arch Linux${end}"
echo -e "${red}linux y linux-firmware${end}, son el kernel de ${blue} Arch Linux${end}"
echo -e "${red}nano${end}, es un editor de texto en terminal que puede que necesitemos mas adelante en la instalacion"
echo -e "${red}networkmanager${end}, todo lo que sea la placa de internet, si es que estas en un portatil, se encargara este programa"
sleep 6
pacstrap /mnt base linux linux-firmware nano networkmanager
sleep 1
echo -e "Ahora tendremos que generar la tabla de particiones de arch, ${blue}fstab${end}, genfstab -pU /mnt >> /mnt/etc/fstab"
genfstab -pU /mnt >> /mnt/etc/fstab
echo -e "Que nombre te gustaria ponerle a la maquina?"
read nombre
echo -e "Vale, ahora se lo pongo"
echo $nombre > /etc/hostname
echo -e "Verifica que el nombre ha puesto "
nano /etc/hostname


echo -e "Creditos del script a Mikel Asurmendi, persona empezando con la programacion que quiere llegar a algo mas en este mundo dejando su huella"
