#!/bin/bash

#region colours
green=$(tput setaf 2; tput bold)
red=$(tput setaf 1; tput bold)
yellow=$(tput setaf 3; tput bold)
cyan=$(tput setaf 6; tput bold)
end=$(tput sgr0)
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
    echo -e "${green}Usage:${end} $0 [options]"
    echo -e "${green}Options:${end}"
    echo -e "  ${green}-u${end} ${cyan}USERNAME${end} ${yellow}Map process own by username${end}"
    echo -e "  ${green}-h${end} ${yellow}Display this help panel${end}"
    exit 0
}
#endregion

#region args
# Check if any argument has been passed
declare -i args_counter=0
username="" # Variable to store the username

while [ $# -gt 0 ]; do
    case "$1" in # Check if the argument is an option
        -u|--user)
            if [ -z "$2" ]; then
                echo "Error: Missing argument for $1"
                exit 1
            fi
            username="$2"
            args_counter+=1
            shift 2
            ;;
        -h|--help)
            helpPanel
            ;;
        *)
            helpPanel
            ;;
    esac
done

if [ $args_counter -eq 0 ]; then
    helpPanel
fi
#endregion

#region helpers
# Check if the user exists
if ! id -u "$username" &>/dev/null; then
  echo -e "${red}[-]${end} User '$username' not found"
  exit 1
fi
#endregion

#region main
function main() {
	# Headers
	echo -e "${yellow}$(printf "%-10s %-7s %-7s %s\n" "USERNAME" "PID" "PPID" "COMMAND")${end}"
	echo -e "${cyan}---------- ------- ------- ------------------------------${end}"
  	local old_procs
  	old_procs=$(ps -u "$username" -eo user:10,pid:7,ppid:7,command:30 --no-headers 2>/dev/null | awk '$1 == "'"$username"'"')
  	while true; do
    	local new_procs
    	new_procs=$(ps -u "$username" -eo user:10,pid:7,ppid:7,command:30 --no-headers 2>/dev/null | awk '$1 == "'"$username"'"')
    
		# Compare processes
		diff --suppress-common-lines <(echo "$old_procs") <(echo "$new_procs") | 
		grep -v -E "procmon|command" | 
		awk -v green="$green" -v red="$red" -v end="$end" '
		/^</ {
		# Remove diff characters (<, >, -)
			gsub(/^[<> ]*/, "");
			# Process removed
			printf "%s", red
			print "- ",$1,  "   "$2, "  "$3, "     "substr($0, index($0,$4)), end
		}
		/^>/ {
		# Remove diff characters (<, >, -)
			gsub(/^[<> ]*/, "");
			# New process
			printf "%s", green
			print "+ ",$1,  "   "$2, "  "$3, "     "substr($0, index($0,$4)), end
		}
		' | column -t -s $'\t'
		
		old_procs="$new_procs"
  	done
}

main
#endregion

