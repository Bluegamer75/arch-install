#Este es un script que va dirigido a la gente que tiene dificultades a la hora de instalar arch linux, quien tenga algun problema, en el instalador obtendran informacion de cada comando para que la persona aprenda como va cada comando


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

#Vamos a empezar con una actualizacion de los paquetes para poder instalar mas programas

echo -e "${gray}Hola, Bienvenido al script de instalacion de ${end} ${blue}Arch Linux${end}, ${gray}cada comando tendra su signifado de su uso para que no tengas ningun problema, y si surge algun problema, te pondre donde puedes buscar por internet la solucion para que no te tires buscando mucho tiempo${end}.${end}"
sleep 9
echo -e "${gray}Vamos a empezar por algo muy basico, el gestor de paquetes de ${blue}Arch Linux${end} utiliza el gestor de paquetes llamado ${yellow}pacman${end},${end}
derivado de ${yellow}Pack${end}age ${yellow}Man${end}ager, vamos a empezar haciendo una actualizacion de paquetes, para ello ejecutaremos el comando ${gray}sudo pacman -Syu${end}"
sleep 5
sudo pacman -Syu
sleep 1

#Una vez actualizado, necesito que me pases tus nombres para mas tarde crearte los usuarios

echo -e "Como ya hemos actualizado los paquetes, vamos a empezar por como te llamas"
read -r -p "Introduce tu nombre para la maquina porfavor: " hostname
read -r -p "Es $nombre el nombre que le quieres dar a la maquina? 1)si 2)no: "
echo -e "Ya me has dicho el nombre de la maquina, pero no me has dicho tu nombre de ${gray}usuario${end}"
sleep 3
read -r -p "Que nombre de usuario te gustaria tener: " usuario

#Necesito la zona horaria porque si no me la das, puede que me falle en algun lugar de la instalacion

echo -e "Ya una vez teniendo tu nombre, procederemos a empezar con la instalacion ${blue}Arch Linux${end}, necesito que me digas que zona horaria tienes, (necesito que me lo busques en internet porque listarlo es muy largo). ${red}Es importante que me lo digas bien si no la instalacion podria verse afectada${end}"
read -r -p "Que zona horaria tienes: " horario

#Vamos ha empezar con el tema de particionado, lo primero que hare sera avisarle de posilbles consecuencias que podria tener para que no le pase nada y luego pedire que me pase las particiones en un input

clear
echo -e "${gray}Vamos a entrar en una zona peligrosa, por eso te voy a pedir que si estas instalando${end}${blue} Arch Linux${end}${gray} en dual boot con windows, deberas de tener cuidado con este paso porque te voy a explicar lo que tienes que hacer${end}"
echo -e "${gray}Ahora toca el moomento de particionado, cualquier despiste que tengas en este paso puede${end} ${red}ocasionar la perdida de tus datos y programas.${end} ${gray}Antes de seguir te recomiendo que hagas una particion grande sin dar formato para que ahora te sea mas facil hacer las particiones sin tener ningun problema. ${end}"
read -r -p "Cuando termines de hacer lsa particiones te hare un listado de las particiones que has hecho y me tendras que pasar el nombre tal cual te viene, estas preparado? 1)si 2)no " respuesta

#Bucle de respuesta

if [[ $respuesta = 1 ]]
then 
    echo -e "${red}Procedamos, iniciando cfdisk${end}${yellow}...${end}"
    sleep 3
    cfdisk
else
    echo -e "${gray}Vuelve cuando ya estes preparado ${end}"
    exit
fi

#Despues de particionado del disco

clear
echo -e "A continuacion te voy a listar todas las particiones que hay del sistema y em tienes que escribir como esta en el siguiente mensaje lo que te pida"
sleep 1
lsblk
sleep 5
read -r -p "En que particion quieres poner la raiz / (ejemplo /dev/sda1)" raiz
read -r -p "Tienes alguna particion de swap? (si decides que no, instalaras el sistema sin memoria de intercambio) 1)si 2)no: " swap

#Bucle de swap

if [[ $swap = 1 ]]
then 
    read -r -p "En que particion quieres poner la particion swap (ejemplo /dev/sda2): " swap1
    sleep 3
else
    echo "${gray}continuando sin swap${end}${yellow}...${end} "
    sleep 3
fi

#Dando el formato a las particiones

echo -e "Ahora voy a dar formato a la particion de raiz (en el cfdisk tiene que estar puesto en Linux Filesystem)"
sleep 1
echo -e "Lo hare con el comando ${blue}mkfs.ext4${end}, que quiere decir ${yellow}makefilesystem en formato ext4${end}"
sleep 1
mkfs.ext4 $raiz
if [[ $swap = 1 ]]
then
    echo -e "Ahora toca si elegiste swap para la instalacion, utilizare 2 comandos: ${yellow}mkswap${end} y ${yellow}swapon${end}"
    sleep 1
    echo -e "Con esos comandos lo que hago es definir el swap y crearlo"
    sleep 1
    mkswap $swap1
    swapon $swap1
    echo -e "${gray}Continuamos con la instalacion base y de kernel del sistema${end}"
else
    echo -e "${gray}Continuamos con la instalacion base y de kernel del sistema${end}"
fi
#Montaje e instalacion del sistema base y kernel de arch linux

echo -e "Ahora, tendremos que definir donde queremos montar el sistema base de ${blue}Arch Linux${end} y instalaremos los paquetes esenciales junto al kernel."
sleep 1
echo -e "Vamos a montar la raiz con mount $raiz /mnt"
mount $raiz /mnt
echo -e ${gray}Ahora con el script de ${red}packstrap${end}, vamos a instalar los siguientes paquetes en /mnt: ${yellow}base linux linux-firmware nano networkmanager${end}${end}
sleep 1
echo -e "${blue}base${end} ${gray}es la base de arch linux, lo que seria la raiz${end}"
echo -e "${blue}linux${end} ${gray}es parte del kernel de linux junto a linux-firmware${end}"
echo -e "${blue}linux-firmware${end} ${gray}es del kernel donde estarn nuestros drivers y cosas importantes que el sistema necesita para funcionar${end}"
echo -e "${blue}nano${end} ${gray}editor de codigo por terminal, por si queremos tocal algun archivo${end}"
echo -e "${blue}networkmanager${end} ${gray}este programa es para tocar temas de wifi pero de manera grafica (esto te sirve si tienes una placa de wifi en tu pc/portatil)${end}"
sleep 4
packstrap /mnt base linux linux-firmware nano networkmanager 
clear

#Generar tabla de particiones con fstab

echo -e "Toca el momento de generar la tabla de particiones, para ello lo que hacermos es utilizar el comando ${yellow}genfstab${end} que seria ${gray}generate filesystem table${end} o ${gray}generar tabla de particiones${end} donde le pasaremos que lo haga en /mnt en el fichero ubicado en /mnmt/etc/fstab"
sleep 5
genfstab -pU /mnt >> /mnt/etc/fstab
sleep 2

#Toca trabajar ya dentro de nuestra distribucion de linux (chroot)

echo -e "Ahora nos toca ya trabajar dentro de nuestro entorno linux, porque ahora estamos los comando en modo live, ahora lo que haremos con chroot meternos en /mnt para empezar a tocar configuraciones que necesitamos de nuestro sistema como puede ser la hora."
arch-chroot /mnt
sleep 3
echo -e "Una vez dentro, te acuerdas que antes te he preguntado en que zona horaria vivias, lo utilizare para colocartela en el sistema con ln -sf /usr/share/zoneinfo/$horario /etc/localtime"
ln -sf /usr/share/zoneinfo/$horario /etc/localtime
hwclock--systohc
sleep 2

#Tema de poner nuestro nombre al sistema

echo -e "Ahora toca poner tu nombre a la maquina, como ya me lo has dicho antes ($hostname) lo pondre pero tienes la opcion de cambiarlo si quieres"
sleep 5
echo arch > /etc/hostname
nano /etc/hostname
sleep 2
echo -e "Ahora toca configurar los hosts, con lo que tendras que añadir un par de parametros que tendras que poner debajo del texto con ## que tienes dentro del documento"
echo -e "127.0.0.1  localhost"
echo -e "::1    localhost"
echo -e "127.0.0.1  $hostname.localdomain $hostname"
read -r -p "${gray}dale a enter cuando hayas memorizado todos los parametros para ponerlos en el documento, las separaciones quitando el ultimo son tabulaciones${end}"
nano /etc/hosts

#Configuracion del idioma y mapeo del teclado

clear 
echo -e "Para la configuracion del idioma, primero tendremos que generar el archivo de configuracion con locale-gen"
locale-gen
sleep 1
echo -e "Una vez creado el archivo de configuracion, tendremos que retocarlo llendo al archivo y bajando hasta nuestro idioma, cuando lo encontremos, tendremos que quitar los asteriscos que tiene para que pueda funcionar, en el caso de español de españa seria (es_ES.UTF8 UTF-8)"
read -r -p "Dale enter cuando estes preparado para entrar al documento:"
nano /etc/locale.gen
echo -e "Ahora volveremos a crear el archivo de configuracion locale-gen pero ya estar neustro parametro correctamente configurado."
locale-gen
hwlock -w
echo -e "Ahora tocaria configurar la distribucion del teclado, yo lo pondre predeterminado en español pero os dare el acceso a /etc/vconsole.conf para que podais poner la distribucion de teclado que querais"
echo KEYMAP=es > /etc/vconsole.conf
nano /etc/vconsole.conf

echo -e "Ahora toca salir del entorno de grub poque ya hemos terminado de configurar lo que necesitabamos (de momento, hay que volver a entrar pero mas tarde) para salir ponemos exit"

#Salimos del entorno chroot para instalarnos grub

sleep 1
exit
clear
echo -e "Ahora tenemos que configurar el grub para que arranque el sistema por si solo, utilizaremos el script ${yellow}packstrap${end} para instalar en /mnt el grub con pacstrap /mnt grub"
sleep 2
packstrap /mnt grub
echo -e "Volvemos a meternos a chroot para configurar el grub y el usuario"

#Volvemos a entrar para terminar de configurar todo

arch-chroot /mnt
echo -e "Procederemos a instalar grub en nuestro sistema con el comando grub-install /dev/sda o donde lo tengais colocado"
read -r -p "Como de llama vuestra particion? (ejemplo /dev/sda /dev/sdb /dev/sdc): " grub
grub-install $grub
sleep 2
echo -e "Tendremos que generar la configuracion de grub, con lo que utilizaremos grub-mkconfig -o /boot/grub/grub.cfg"
grub-mkconfig -o /boot/grub/grub.cfg
clear 
sleep 2

#Configurando tema usuarios del sistema

echo -e "Tendreis que darle una contraseña a grub para las cosas importantes de sistema. Para ello lo que tendremos que hacer sera utilizar el comando passwd"
sleep 1
passwd
sleep 1
echo -e "Toca crear tu usuario, el cual lo usare con el nombre que me has dado al inicio del script ($usuario), y le voy a dar todos los permisos para que luego no pase nada dentro del sistema,"
useradd -m -g users -G audio,lp,optical,storage,video,power,scanner -s /bin/bash $usuario
sleep 2
echo -e "El usuario ha sido correctamente creado, ahora le tendras que crear una contraseña para poder usarlo, con passwd $usuario."
passwd usuario
echo -e "Ya finalizado todo, saldremos de chroot con exit"
exit
sudo pacman -Syu

#Toca instalacion de los drivers de video de intel

echo -e "Para que no tengamos ningun tipo de falla grafica, tendremos que usar drivers de video de nuestra grafica, para ello necesito que me digas que grafica usas, pero lo mas importante de que marca (amd nvidia intel): 1)intel 2)nvidia 3)amd: "
read -r -p "Elige la opcion que quieras" drivers

#Opcion de integradas de intel

if [[ $drivers = 1 ]]
then 
    echo -e "Instalando los drivers de intel con pacman -S xf86-video-intel"
    sleep 2
    pacman -S xf86-video-intel
fi

#Opcion de graficas de nvidia

if [[ $drivers = 2 ]]
then 
    echo -e "Instalando los drivers de nvidia con pacman -S nvidia nvidia-settings nvidia-utils"
    sleep 2
    pacman -S nvidia nvidia-settings nvidia-utils
fi

#Opcion de graficas de AMD

if [[ $drivers = 3 ]]
then 
    echo -e "Instalando los drivers de amd con pacman -S xf86-video-amdgpu"
    sleep 2
    pacman -S xf86-video-amdgpu
fi

#Tema instalacion de entorno grafico

sleep 1
echo -e "Cuando hayamos instalado los drivers, nos faltara tener un servidor grafico para poder ver los programas, para ello utilizaremos xorg. Para instalarlo seria sudo pacman -S xorg"
sleep 1
sudo pacman -S xorg
echo -e "Ahora llega el momento en el que tenemos que decidir entre que escoger, entre entorno de escritorio como serio gnome, plasma, xfce, cinnamon o podemos coger gestores de ventanas como podria ser i3-wm, qtile, scpectrwm, dwm y muchos mas, yo te recomiendo que instales primero entorno de escritorio normal y luego ya instalas mas entornos o un gestor de ventanas"
read -r -p "Que quieres instalar para el entorno grafico?: " entorno
sleep 2
echo "Si has elegido entorno de escritorio, no creo que tengas ningun problema en la instalacion pero si has elegido gestor de ventanas, seguramente tengas que configurar las cosas."
sleep 2
echo -e "Te dejo instalando $entorno"

#Eleccion de gnome

if [[ entorno = gnome ]]
then
    sudo pacman -S gnome yay
fi 

#Eleccion de KDE PLASMA

if [[ entorno = plasma ]]
then 
    sudo pacman -S plasma kde-system-meta kde-utilities yay
fi 

#Eleccion xfce

if [[ entorno = xfce ]]
then 
    sudo pacman -S xfce yay
fi 

#Eleccion cinamon 

if [[ entorno = cinnamon ]]
then 
    sudo pacman -S cinnamon yay 
fi

#Despedida
echo -e "${gray}Ya tienes tu ${blue}Arch Linux${end} completamente instalado y bien configurado si seguiste los pasos bien, que disfrutes de tu nuevo linux${end}"
echo -e "Codigo creado y probado por ${red}Mikel Asurmendi${end}, joven de 19 años queriendo aprender a programar y a estudiar todo lo relacionado con la informatica:))"

