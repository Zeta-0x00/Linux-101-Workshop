.ONESHELL:  # Forces all recipe commands to execute in a single shell
.SILENT:
.SHELL := /usr/bin/bash  # Ensures the use of Bash
# Default target (first target or explicit)
default: serve
.PHONY: default serve stop
# region colours
GREEN := $(shell tput setaf 2 2>/dev/null)
RED := $(shell tput setaf 1 2>/dev/null)
YELLOW := $(shell tput setaf 3 2>/dev/null)
CYAN := $(shell tput setaf 6 2>/dev/null)
GRAY := $(shell tput setaf 7 2>/dev/null)
PURPLE := $(shell tput setaf 5 2>/dev/null)
BOLD := $(shell tput bold 2>/dev/null)
END := $(shell tput sgr0 2>/dev/null)
# endregion

serve:
	@echo "$(GREEN)$(BOLD)"
	@echo "           _     <-. (\`-')_            (\`-')                        "
	@echo "   <-.    (_)       \( OO) )     .->   (OO )_.->                    "
	@echo " ,--. )   ,-(\`-'),--./ ,--/ ,--.(,--.  (_| \_)--..--.  .----.  .--. "
	@echo " |  (\`-') | ( OO)|   \ |  | |  | |(\`-')\  \`.'  //_  | /  ..  \/_  | "
	@echo " |  |OO ) |  |  )|  . '|  |)|  | |(OO ) \    .') |  ||  /  \  .|  | "
	@echo "(|  '__ |(|  |_/ |  |\    | |  | | |  \ .'    \  |  |'  \  /  '|  | "
	@echo " |     |' |  |'->|  | \   | \  '-'(_ .'/  .'.  \ |  | \  \`'  / |  | "
	@echo " \`-----'  \`--'   \`--'  \`--'  \`-----'  \`--'   '--'\`--'  \`---''  \`--' $(END)"
	@echo ""
	@echo "$(PURPLE)$(BOLD)╔═════════════════════════════════════════════╗$(END)"
	@echo "$(PURPLE)$(BOLD)║$(END) $(GREEN)Linux 101 for hackers - Reverse Shell Lab$(END)   $(PURPLE)$(BOLD)║$(END)"
	@echo "$(PURPLE)$(BOLD)║$(END) $(GRAY)Version: $(YELLOW)1.0$(END)                                $(PURPLE)$(BOLD)║$(END)"
	@echo "$(PURPLE)$(BOLD)║$(END) $(GRAY)Copyright © 2025 Hawks Security Academy$(END)     $(PURPLE)$(BOLD)║$(END)"
	@echo "$(PURPLE)$(BOLD)║$(END) $(GRAY)for more info: $(CYAN)https://hawksec-academy.com/$(END) $(PURPLE)$(BOLD)║$(END)"
	@echo "$(PURPLE)$(BOLD)╚═════════════════════════════════════════════╝$(END)"
	@echo ""
	@which php > /dev/null 2>&1 || { echo "$(RED)$(BOLD)[!]$(END) $(GRAY)Error: PHP is not installed in the system. Please install PHP to continue.$(END)"; exit 1; }
	@echo "$(CYAN)$(BOLD)[$(GREEN)+$(CYAN)$(BOLD)]$(END) $(GRAY)Initializing web server...$(END)"
	@echo "$(CYAN)$(BOLD)[$(GREEN)+$(CYAN)$(BOLD)]$(END) $(GRAY)Listening on port: $(CYAN)8880$(END)"
	@echo ""
	@{ \
		trap 'echo -e "\n$(RED)$(BOLD)[!]$(END) $(GRAY)Server stopped by user$(END)"; kill $$SERVER_PID 2>/dev/null; exit 0' INT; \
		php -S 0.0.0.0:8880 & SERVER_PID=$$!; \
		wait $$SERVER_PID || exit 0; \
	} 2>/dev/null

stop:
	@echo "$(CYAN)$(BOLD)[$(YELLOW)!$(CYAN)$(BOLD)]$(END) Stopping PHP server..."
	@kill $$(lsof -t -i:8880) 2>/dev/null || true
