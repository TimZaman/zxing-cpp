#/bin/sh
# Easy Compile Script 
# (c) Tim Zaman, Pixelprisma 2014

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BUILDDIR="${DIR}/_build"

execname="pixelink"

#Loop over the arguments
for var in "$@"
do
	#echo "$var"
	case $var in
		"help") 
			echo -e "\033[33;33mCommand\tFunction\x1B[0m"
			echo -e "  rm\tRemoves compiled result"
			echo -e "  make\tMakes/Compiles the program"
			echo -e "  run\tRuns program"
			echo -e "  install\tinstalls"
			echo -e ""
			exit
		;;	

		"rm")
			echo -e "\033[33;33m|| Refreshing compile folder..\x1B[0m"
			if [ -d "${BUILDDIR}" ]; then #If the folder exists..
				rm -rf "${BUILDDIR}" #Remove it
			fi
		;;

		"make") 
			echo -e "\033[33;33m|| Running Make..\x1B[0m"

			if ! [ -d "${BUILDDIR}" ]; then #If the folder does not exist yet
				mkdir "${BUILDDIR}" #Make the folder
			fi

			if [[ "$OSTYPE" == "darwin"* ]]; then
				generator="XCode"
				ARGS_CMAKE=" "
				cmake -H${DIR} -B${BUILDDIR} -GXcode ${ARGS_CMAKE} | awk ' /succeeded/ {print "\033[32m" $0 "\033[39m"} /error/ {print "\033[31m" $0 "\033[39m"}'
			else
				echo ${DIR}
				generator="Unix Makefiles"
				ARGS_CMAKE=" "
				cmake -H${DIR} -B${BUILDDIR} -G "$generator" ${ARGS_CMAKE} | awk ' /succeeded/ {print "\033[32m" $0 "\033[39m"} /error/ {print "\033[31m" $0 "\033[39m"}'
			fi

			if [ ${PIPESTATUS[0]} -eq 0 ] ; then
				echo -e "\033[33;32m CMake succeeded.\x1B[0m"
			else
				echo -e "\033[33;31m CMake failed.\x1B[0m"
				exit 1
			fi

			#Then run make

			echo -e "\033[33;33m|| Running Make --build ..\x1B[0m"


			#if [[ "$OSTYPE" == "darwin"* ]] ; then
			#	cmake --build ${BUILDDIR} | awk ' /succeeded/ {print "\033[32m" $0 "\033[39m"} /error/ {print "\033[31m" $0 "\033[39m"}'
			#else
				cmake --build ${BUILDDIR} | awk ' /succeeded/ {print "\033[32m" $0 "\033[39m"} /error/ {print "\033[31m" $0 "\033[39m"}'
			#fi


			if [ ${PIPESTATUS[0]} -eq 0 ]; then
				echo -e "\033[33;32m Make succeeded.\x1B[0m"
			else
				echo -e "\033[33;31m Make failed.\x1B[0m"
				exit 1
			fi


			if [[ "$OSTYPE" == "darwin"* ]]; then
				echo -e "\033[33;33m|| Copying executable to _build directory.\x1B[0m"
				cp ${BUILDDIR}/Debug/* ${BUILDDIR}/
			fi

		;;

		"install") 
			echo -e "\033[33;33m|| Installing Program..\x1B[0m"
			sudo cmake --build ${BUILDDIR} --target install
			if [[ "$OSTYPE" == "darwin"* ]]; then
				sudo install_name_tool -id /opt/pixelink/lib/libpixelink.dylib /opt/pixelink/lib/libpixelink.dylib
			fi
		;;
   
	esac
done


echo -e "\033[33;35m|| END SRC\x1B[0m"

#echo -e "\033[33;31m Color Text" - red
#echo -e "\033[33;32m Color Text" - green
#echo -e "\033[33;33m Color Text" - yellow
#echo -e "\033[33;34m Color Text" - blue
#echo -e "\033[33;35m Color Text" - Magenta
#echo -e "\033[33;30m Color Text" - Gray
#echo -e "\033[33;36m Color Text" - Cyan

exit 0
