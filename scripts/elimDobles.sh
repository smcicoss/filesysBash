#! /bin/bash
# -*- ENCODING: UTF-8 -*-
# ·

# original de: David Arroyo Menéndez
# http://www.davidam.com/
# En: https://github.com/davidam/bash-examples


# Simón Martínez Álvarez [simon@cicoss.net]

# Con arboles de directorios grandes la cantidad de memoria 
# utilizada es enorme ya que hace una lectura previa de todos
# los nombres de fichero antes de empezar a comparar y el tiempo
# empleado en esa lectura tambien se vuelve inasumible, así como
# el tiempo empleado por md5sum en ficheros grandes.
# Por otro lado no permite elegir cual borrar.
# Otro problema, grave, que presenta este script es que si dentro
# del arbol tenemos un enlace simbolico a otra parte del mismo
# arbol borrará todos los ficheros que existan en esa rama.

################################################################

echo "¡¡¡ATENCIÖN!!!"
echo "Este script borra todos los ficheros que tengan el mismo contenido"
echo "Llamense igual o no."
echo "No distingue si se accecede a el directamente o a través de un link"
echo -e "\tpor lo que si un fichero está apuntado por un link desde la"
echo -e "\tla misma rama será tomado por un fichero distinto pero"
echo -e "\tcon el mismo contenido y lo eliminará eliminado así el"
echo -e "\túnico fichero existente."
echo -n "¿Quieres continuar?(s/n):"
read respuesta

if ! [ ${respuesta^^} == "S" ]; then
  echo ${respuesta^^}
  exit 1
fi

declare -A arr
shopt -s globstar

for fichero in **; do
  echo -n "."
  [[ -f "$fichero" ]] || continue

  read cksm _ < <(md5sum "$fichero")
  if ((arr["$cksm"]++)); then
    echo -e "\nrm $fichero"
    rm -v "$fichero"
  fi
done

echo ""
