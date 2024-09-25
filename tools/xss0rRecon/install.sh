#!/bin/bash

# Define color codes for output formatting
BOLD_WHITE='\033[1;37m'
BOLD_CYAN='\033[1;36m'
NC='\033[0m'  # No Color

# Set Go version and download URL
GO_VERSION="1.23.1"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://golang.org/dl/${GO_TAR}"

# Remove old Go installation if it exists
if [ -d "/usr/local/go" ]; then
    echo "Removing old Go installation..."
    sudo rm -rf /usr/local/go
fi

# Download the specified version of Go
echo "Downloading Go version ${GO_VERSION}..."
wget ${GO_URL}

# Extract the downloaded tarball
echo "Extracting Go ${GO_VERSION}..."
sudo tar -C /usr/local -xzf ${GO_TAR}

# Add Go to the PATH
echo "Updating PATH..."
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
source ~/.bashrc

# Clean up by removing the downloaded tarball
echo "Cleaning up..."
rm ${GO_TAR}

# Verify installation
echo "Go version installed:"
go version

echo "Installation completed!"

# List of tools to install
declare -A tools
tools=(
    ["Waybackurls"]="github.com/tomnomnom/waybackurls@latest"
    ["Gau"]="github.com/lc/gau@latest"
    ["Uro"]="https://github.com/s0md3v/uro"
    ["Katana"]="github.com/projectdiscovery/katana/cmd/katana@latest"
    ["Hakrawler"]="github.com/hakluke/hakrawler@latest"
    ["GoSpider"]="github.com/jaeles-project/gospider@latest"
    ["Arjun"]="https://github.com/s0md3v/Arjun.git"
    ["Dnsbruter"]="https://github.com/RevoltSecurities/Dnsbruter.git"
    ["SubProber"]="https://github.com/sanjai-AK47/SubProber.git"
    ["Subdominator"]="https://github.com/RevoltSecurities/Subdominator"
)

# Associative array to keep track of installation status
declare -A installation_status

# Function to install a tool based on its name and URL
install_tool() {
    local tool_name="$1"
    local tool_url="$2"

    echo -e "${BOLD_WHITE}Installing ${tool_name}...${NC}"

    case $tool_name in
        "Uro")
            pip3 install uro && installation_status["$tool_name"]="installed" || installation_status["$tool_name"]="failed"
            ;;
        "Arjun")
            git clone "$tool_url" && cd Arjun && python3 setup.py install && installation_status["$tool_name"]="installed" || installation_status["$tool_name"]="failed"
            cd .. && rm -rf Arjun
            ;;
        "Dnsbruter")
            git clone "$tool_url" && cd Dnsbruter || { echo "Failed to enter Dnsbruter directory"; return; }
            if ! command -v python3 &> /dev/null; then
                echo "Python 3 is not installed. Please install Python 3 and try again."
                cd .. && rm -rf Dnsbruter
                return
            fi
            pip3 install -r requirements.txt && {
                echo "$tool_name installed successfully."
                installation_status["$tool_name"]="installed"
            } || {
                echo "Installing dependencies for $tool_name failed."
                installation_status["$tool_name"]="failed"
            }
            cd .. && rm -rf Dnsbruter
            ;;
        "SubProber")
            git clone "$tool_url" && cd SubProber
            pip3 install . && {
                echo "$tool_name installed successfully."
                installation_status["$tool_name"]="installed"
            } || {
                echo "Installing $tool_name failed."
                installation_status["$tool_name"]="failed"
            }
            subprober -h # Display help for SubProber
            cd .. && rm -rf SubProber
            ;;
        "Subdominator")
            sudo pip3 install aiofiles
            sudo pip3 install git+https://github.com/RevoltSecurities/Subdominator && {
                echo "$tool_name installed successfully."
                installation_status["$tool_name"]="installed"
            } || {
                echo "Installing $tool_name failed."
                installation_status["$tool_name"]="failed"
            }
            ;;
        "Katana")
            go install "$tool_url" && installation_status["$tool_name"]="installed" || installation_status["$tool_name"]="failed"
            ;;
        *)
            go install "$tool_url" && installation_status["$tool_name"]="installed" || installation_status["$tool_name"]="failed"
            ;;
    esac
}

# Function to print summary of installation results
print_summary() {
    echo -e "\n${BOLD_CYAN}Installation Summary:${NC}"
    for tool in "${!installation_status[@]}"; do
        echo -e "${BOLD_WHITE}$tool:${NC} ${installation_status[$tool]}"
    done
}

# Main function
main() {
    for tool_name in "${!tools[@]}"; do
        if ! command -v "${tool_name,,}" &> /dev/null; then
            install_tool "$tool_name" "${tools[$tool_name]}"
        else
            echo -e "${BOLD_WHITE}$tool_name:${NC} is already installed."
            installation_status["$tool_name"]="installed"
        fi
    done

    echo -e "\n${BOLD_CYAN}If you encounter any issues or are unable to run any of the tools,${NC}"
    echo -e "${BOLD_WHITE}please refer to the following links for manual installation:${NC}"
    echo -e "${BOLD_WHITE}Waybackurls:${NC} https://github.com/tomnomnom/waybackurls"
    echo -e "${BOLD_WHITE}Gau:${NC} https://github.com/lc/gau"
    echo -e "${BOLD_WHITE}Uro:${NC} https://github.com/s0md3v/uro"
    echo -e "${BOLD_WHITE}Katana:${NC} https://github.com/projectdiscovery/katana"
    echo -e "${BOLD_WHITE}Hakrawler:${NC} https://github.com/hakluke/hakrawler"
    echo -e "${BOLD_WHITE}GoSpider:${NC} https://github.com/jaeles-project/gospider"
    echo -e "${BOLD_WHITE}Arjun:${NC} https://github.com/s0md3v/Arjun"
    echo -e "${BOLD_WHITE}Dnsbruter:${NC} https://github.com/RevoltSecurities/Dnsbruter"
    echo -e "${BOLD_WHITE}SubProber:${NC} https://github.com/sanjai-AK47/SubProber"
    echo -e "${BOLD_WHITE}Subdominator:${NC} https://github.com/RevoltSecurities/Subdominator"

    print_summary
}

# Run the main function
main
