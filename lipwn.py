import os
import sys
import subprocess
import time
from time import sleep
from colorama import Fore, Style, init
from rich import print as rich_print
from rich.panel import Panel

init(autoreset=True)

class Color:
    BLUE = '\033[94m'
    GREEN = '\033[1;92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    RESET = '\033[0m'
    ORANGE = '\033[38;5;208m'
    BOLD = '\033[1m'
    UNBOLD = '\033[22m'
    ITALIC = '\033[3m'
    UNITALIC = '\033[23m'

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def loading_animation(text):
    for c in text:
        sys.stdout.write(c)
        sys.stdout.flush()
        sleep(0.01)
    print()

def display_menu():
    title = """
            ██╗     ██╗██████╗ ██╗    ██╗███╗   ██╗
            ██║     ██║██╔══██╗██║    ██║████╗  ██║
            ██║     ██║██████╔╝██║ █╗ ██║██╔██╗ ██║
            ██║     ██║██╔═══╝ ██║███╗██║██║╚██╗██║
            ███████╗██║██║     ╚███╔███╔╝██║ ╚████║
            ╚══════╝╚═╝╚═╝      ╚══╝╚══╝ ╚═╝  ╚═══╝
    """
    # Print each line with a delay
    for line in title.splitlines():
        for char in line:
            sys.stdout.write(Color.ORANGE + Style.BRIGHT + char)
            sys.stdout.flush()
            sleep(0.0040)
        print()
    
    print(Fore.WHITE + Style.BRIGHT + "─" * 65)
    border_color = Color.CYAN + Style.BRIGHT
    option_color = Fore.WHITE + Style.BRIGHT  
    
    print(border_color + "┌" + "─" * 63 + "┐")
    
    options = [
        "1]  Xss0rRecon",
        "2]  Lostsec Scanner",
        "4]  Exit"
    ]
    
    for option in options:
        # Adjust the length to fit emojis
        print(border_color + "│ " + option_color + option.ljust(60) + border_color + "│")
    
    print(border_color + "└" + "─" * 63 + "┘")
    authors = "Created by 0xlipon"
    instructions = "Select an option by entering the corresponding number:"
    
    print(Fore.WHITE + Style.BRIGHT + "─" * 65)
    print(Fore.WHITE + Style.BRIGHT + authors.center(65))
    print(Fore.WHITE + Style.BRIGHT + "─" * 65)
    print(Fore.WHITE + Style.BRIGHT + instructions.center(65))
    print(Fore.WHITE + Style.BRIGHT + "─" * 65)

def print_exit_menu():
    clear_screen()

    panel = Panel(
        """
  (        (                   
  )\ )     )\ )                
 (()/( (  (()/( (  (           
  /(_)))\  /(_)))\))(    (     
 (_)) ((_)(_)) ((_)()\   )\ )  
 | |   (_)| _ \_(()((_) _(_/(  
 | |__ | ||  _/\ V  V /| ' \)) 
 |____||_||_|   \_/\_/ |_||_| 
 
        Credit - 0xlipon 
        """,
        style="bold green",
        border_style="blue",
        expand=False
    )
    rich_print(panel)
    print(Color.RED + "\n\nSession Off ...\n")
    exit()

# Selection Strat Here...
def handle_selection(selection):
    if selection == '1':
        print(Color.GREEN + "[+] Launching Xss0rRecon...")
        # Save the current directory
        original_dir = os.getcwd()

        # Change to the directory where 'xss0rRecon.sh' is located
        os.chdir("/tools/xss0rRecon")

        # Execute the script
        xss0rRecon = "./xss0rRecon.sh"
        try:
            subprocess.run(xss0rRecon, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(Color.RED + f"[-] Error occurred: {e}")
    
        # After the script finishes, return to the original directory
        os.chdir(original_dir)
        
    elif selection == '2':
        clear_screen()
        print(Color.GREEN + "[+] Launching Lostsec Scanner...")

        # Save the current directory
        original_dir = os.getcwd()

        # Change to the directory where 'lostsec.py' is located
        os.chdir("/tools/lostools")

        # Execute the script
        Lostsec = "python3 lostsec.py"
        try:
            subprocess.run(Lostsec, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(Color.RED + f"[-] Error occurred: {e}")
    
        # After the script finishes, return to the original directory
        os.chdir(original_dir)
            
    elif selection == '3':
        clear_screen()
        print(Color.GREEN + "[+] Launching ComingSoon...")
        ComingSoon = "python3 /tools/lostools/new.py"
        subprocess.run(ComingSoon, shell=True)

    elif selection == '4':
        clear_screen()
        print_exit_menu()
        
    else:
        print(Color.RED + "[!] Invalid selection, try again...")

# Main Function Here...
def main():
    clear_screen()
    sleep(1)
    clear_screen()

    while True:
        display_menu()
        choice = input(f"\n{Fore.CYAN}[?] Select an option (0-4): {Style.RESET_ALL}").strip()
        handle_selection(choice)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print_exit_menu()
        sys.exit(0)
