#!/data/data/com.termux/files/usr/bin/bash

# Function to display the menu and get user choices
display_menu() {
    echo "Select utilities to install (separate choices with spaces):"
    echo "1. Ollama"
    echo "2. Open WebUI"
    echo "3. Oobabooga"
    echo "4. Big-AGI"
    echo "5. Exit"
}

# Display the menu
clear
display_menu

# Get user choices
read -p "Enter your choices: " choices

# Track if UI setup is done
ui_setup_done=false

# Process each choice
for choice in $choices; do
    apt update && apt install proot-distro -y
    case $choice in
        1)
            echo "Installing Ollama..."
            pd install --override-alias ollama ubuntu
            pd login ollama -- bash -c "apt update && apt upgrade -y && wget https://ollama.com/install.sh && bash /root/install.sh"
            ;;
        2)
            if [ "$ui_setup_done" = false ]; then
                echo "Setting up UI environment..."
                pd install --override-alias ui ubuntu
                ui_setup_done=true
            fi
            echo "Setting up Open WebUI..."
            pd login ui -- bash -c "apt update && apt upgrade -y && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh && bash /root/Miniconda3-latest-Linux-aarch64.sh -b -p /root/miniconda3" 
	    pd login ui -- bash -c "/root/miniconda3/bin/conda create -n webui python=3.11 -y && /root/miniconda3/envs/webui/bin/pip install open-webui && apt install libsndfile1 libsndfile1-dev -y"

            ;;
        3)
            if [ "$ui_setup_done" = false ]; then
                echo "Setting up UI environment..."
                pd install --override-alias ui ubuntu
                ui_setup_done=true
            fi
            echo "Installing Oobabooga..."
            pd login ui -- bash -c "apt update && apt upgrade -y && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh && bash /root/Miniconda3-latest-Linux-aarch64.sh -b -p /root/miniconda3" 
	    pd login ui -- bash -c "/root/miniconda3/bin/conda create -n textgen python=3.11 -y && /root/miniconda3/envs/textgen/bin/pip3 install torch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 --index-url https://download.pytorch.org/whl/cpu && apt install git -y && git clone https://github.com/oobabooga/text-generation-webui && cd text-generation-webui && /root/miniconda3/envs/textgen/bin/pip3 install -r requirements_cpu_only_noavx2.txt"
            ;;
        4)
            if [ "$ui_setup_done" = false ]; then
                echo "Setting up UI environment..."
                pd install --override-alias ui ubuntu
                ui_setup_done=true
            fi
            echo "Installing Big-AGI..."
            pd login ui -- bash -c "apt install -y ca-certificates curl gnupg git && mkdir -p /etc/apt/keyrings && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && echo 'deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main' | tee /etc/apt/sources.list.d/nodesource.list && apt update && apt install nodejs -y"
            pd login ui -- bash -c "git clone --branch v2-dev https://github.com/enricoros/big-AGI.git && cd big-AGI && npm install -g npm@11.0.0 && npm install && npm run build"
            ;;
        5)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice: $choice"
            ;;
    esac
done

echo "Installation completed."
