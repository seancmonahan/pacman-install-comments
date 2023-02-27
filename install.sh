prepare() {
    if [[ "${EUID}" -ne 0 ]]; then
        echo "[!] Error: you cannot run this script unless you are root"
        exit 1
    fi
    echo "[*] Installing dependencies..."
    pacman -Syu --needed --noconfirm bash sed coreutils diffutils grep
    HOOK_PATH="/etc/pacman.d/hooks/"
    SCRIPT_PATH="/etc/pacman.d/scripts/"
    
    return 0
    
    # remaining aren't needed if we do "cp --parents"
    if [[ ! -d "${HOOK_PATH}" ]]; then
        echo "[*] Hook path ${HOOK_PATH} does not exist, creating..."
        mkdir -p "${HOOK_PATH}"
    fi
    if [[ ! -d "${SCRIPT_PATH}" ]]; then
        echo "[*] Script path ${SCRIPT_PATH} does not exist, creating..."
        mkdir -p "${SCRIPT_PATH}"
    fi
    return 0
}

install() {
    HOOK_FILE="99-install-comments.hook"
    echo "[*] Copying ${HOOK_FILE} to directory ${HOOK_PATH}, creating it if needed..."
    mkdir -v -p "${HOOK_PATH}" && cp "${HOOK_FILE}" $_
    
    # what? not sure why this is setting +x on the directory
    # maybe should be on the HOOK_FILE
    chmod +x "${HOOK_PATH}"
    
    SCRIPT_FILE="install-comments-hook"
    echo "[*] Copying ${SCRIPT_FILE} to directory ${SCRIPT_PATH}, creating it if needed..."
    cp --parents "${SCRIPT_FILE}" "${SCRIPT_PATH}"
    echo "[+] Done!"
}

prepare
install
