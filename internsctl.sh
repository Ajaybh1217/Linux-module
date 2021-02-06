#!/bin/bash

case $1 in

	--help)
		echo "--version command is to see version"
		echo "cpu getinfo command for cpu related information"
		echo "memory getinfo command for memory related information"
		echo "user create <username> command to create user"
		echo "file getinfo command to get file info"
		;;

	--version)
		echo "v0.1.0"
		;;

	cpu)
		if [[ $# -eq 2 && $2 = "getinfo" ]]; then
			lscpu;
		else
			echo "Use an option like- getinfo"
		fi
		;;

	memory)
		if [[ $# -eq 2 && $2 = "getinfo" ]]; then
			free -h;
		else
			echo "Invalid option ${2}"
			echo "Use an option like- getinfo"
		fi
		;;

	user)
		if [[ $# -eq 3 && $2 = create ]]; then
			sudo useradd -m ${3};
			echo "User ${3} created successfully."
		elif [[ $# -eq 2 && $2 = list ]]; then
			awk -F':' '{ print $1}' /etc/passwd;
		elif [[ $# -eq 3 && $2 = list && $3 = "--sudo-only" ]]; then
			grep '^sudo:.*$' /etc/group | cut -d: -f4;
		else
			echo "Invalid option ${2}"
			echo "Use an option like - create <user-name> or list or list --sudo-only"
		fi
		;;

	file)
		if [[ $# -eq 3 && $2 = "getinfo" ]]; then
			echo -ne "File:\t\t"
			echo "${3}"
			echo -ne "Access:\t\t"
			ls -l ${3} | awk -F' ' '{print $1}'
			echo -ne "Size (B):\t"
			ls -l ${3} | awk -F' ' '{print $5}'
			echo -ne "Owner:\t\t"
			ls -l ${3} | awk -F' ' '{print $3}'
			echo -ne "Modify:\t\t"
			stat ${3} | grep Modify | awk -F' ' '{print $2, $3, $4}'
			
		elif [[ $# -eq 4 && $2 = "getinfo" ]]; then
			case $3 in
				--size | -s)
					ls -lh ${4} | awk -F' ' '{print $5}';
					;;

				--permissions | -p)
					ls -l ${4} | awk -F' ' '{print $1}';
					;;

				--owner | -o)
					ls -l ${4} | awk -F' ' '{print $3}';
					;;

				--last-modified | -m)
					stat ${4} | grep Modify | awk -F' ' '{print $2, $3, $4}';
					;;
				*)
					echo "Invalid Option"	
			esac

		else
			echo "Invalid Option"
		fi
		;;

	*)
		echo "Invalid Option"
		;;
esac
	
