#! /bin/bash

show_rename()
{ 
	# analiza si se encontro un directorio conflictivo y lo renombra.
	dir=$1
	new_dir=$dir
	if [ -d $dir ]; then 
		temp=$(echo $dir | sed 'y:[ñáéíóúÑÁÉÍÓÚ ]:[naeiouNAEIOU_]:') 
		if [ "$dir" != "$temp" ]; then
			new_dir=$temp
			mv "$dir" "$new_dir" > /dev/null
		fi
	fi
	
	# llama recursivamente a los subdirectorios, si encuentra un archivo
	# conflictivo lo renombra
	
		# sino se declara local i el valor de i al ser recursiva la funcion
		# se comparte en cada llamado de la funcion	
	local i
	for i in $new_dir/*
	do	
			# renombra archivos conflictivos
			if [ -f $i ]; then
				file=$i
				new_file=$(echo $file | sed 'y:[ñáéíóúÑÁÉÍÓÚ ]:[naeiouNAEIOU_]:') 
				if [ "$file" != "$new_file" ]; then
					mv "$file" "$new_file" > /dev/null
				fi
				
     		fi
     		# llama recursivamente para ingresar a los subdirectorios
     		if [ -d $i ]; then
        		show_rename $i	
     		fi
   
	done	
}

#................................... MAIN .....................................#
# verifica la cantidad de argumentos ingresados
msj="Ingrese al menos una ruta y/o N (N=1 mostrar lista, N=2 renombrar)"

if [ "$#" -gt "2" ]; then 
	echo "La cantidad de argumentos ingresados ingresado excede lo permitido"
	echo "$msj"
	return 0
fi

# Ingresa directorio (n=1)
if [ "$#" -eq "1" ]; then
	# verifica si el primer argumento es un directorio
	if [ -d $1 ]; then 
		dir=$1
		find $dir | grep "[áéíóúñÁÉÍÓÚÑ ]"	
	else
		echo "$msj"
		return 0
	fi
fi

# Directorio actual (n=1)
if [ "$#" -eq "0" ]; then
	dir=$(pwd)
	find | grep "[áéíóúñÁÉÍÓÚÑ ]"
fi

# Ingresa directorio y n
if [ "$#" -eq "2" ]; then
	dir=$1
	n=$2
	if [ "$n" -eq "1" ]; then
		find $dir | grep "[áéíóúñÁÉÍÓÚÑ ]"
	elif [ "$n" -eq "2" ]; then
		show_rename $dir 
	else
		echo "Ingrese un valor correcto para n"
	fi
fi
