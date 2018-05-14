#!/bin/bash
killall -9 x11vnc

mkdir -p ${HOME}/.vnc/

PWD=$(shuf -i 1-10000 -n 1)
echo $PWD > $HOME/.vnc/passwd

#x11vnc -display :7 -xkb -passwdfile /home/${USER}/.vnc/passwd -nossl -logfile ~/.x11vnc &
x11vnc -xkb -passwdfile /home/${USER}/.vnc/passwd -nossl -logfile ~/.x11vnc &
zenity --title="Asistencia remota" --info \
--text="<span font-family='Ubuntu' font='12'>La asistencia remota permite que el personal de soporte técnico se conecte a su equipo.

Datos de conexión:

<i>Equipo: <b>${HOSTNAME}</b>
Contraseña: <b>${PWD}</b></i>

Para finalizar la asistencia presione el boton \"Desconectar\".</span>" --ok-label="Desconectar" --no-wrap

killall -9 x11vnc

rm -f $HOME/.vnc/passwd
Datos de conexión:

<i>Equipo: <b>${HOSTNAME}</b>
Contraseña: <b>${PWD}</b></i>

Para finalizar la asistencia presione el boton \"Desconectar\".</span>" --ok-label="Desconectar" --no-wrap

killall -9 x11vnc

rm -f $HOME/.vnc/passwd