#!/bin/bash

# ============================================
# FileMaster Pro - Auto Install Script
# Version: 3.0
# Description: Install File Manager from GitHub
# ============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
GITHUB_REPO="https://raw.githubusercontent.com/peyxdev/webserver/main"
INSTALL_DIR="/var/www/filemanager"
DOMAIN=""
ADMIN_USER=""
ADMIN_PASS=""

# Print banner
print_banner() {
    clear
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                 FILEMASTER PRO INSTALLER                     ║"
    echo "║                   Auto Install from GitHub                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Get domain input
get_domain() {
    echo ""
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                    DOMAIN SETUP                         │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Enter your domain (e.g., filemanager.yourdomain.com): " DOMAIN
    
    if [[ -z "$DOMAIN" ]]; then
        echo -e "${RED}Domain cannot be empty!${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Domain set to: $DOMAIN${NC}"
}

# Get admin credentials
get_credentials() {
    echo ""
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│                  ADMIN CREDENTIALS                      │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    while [[ -z "$ADMIN_USER" ]]; do
        read -p "Enter admin username (min 3 chars): " ADMIN_USER
        if [[ ${#ADMIN_USER} -lt 3 ]]; then
            echo -e "${RED}Username must be at least 3 characters!${NC}"
            ADMIN_USER=""
        fi
    done
    
    while [[ -z "$ADMIN_PASS" ]]; do
        read -s -p "Enter admin password (min 6 chars): " ADMIN_PASS
        echo ""
        if [[ ${#ADMIN_PASS} -lt 6 ]]; then
            echo -e "${RED}Password must be at least 6 characters!${NC}"
            ADMIN_PASS=""
        else
            read -s -p "Confirm password: " ADMIN_PASS_CONFIRM
            echo ""
            if [[ "$ADMIN_PASS" != "$ADMIN_PASS_CONFIRM" ]]; then
                echo -e "${RED}Passwords do not match!${NC}"
                ADMIN_PASS=""
            fi
        fi
    done
    
    echo -e "${GREEN}✓ Credentials saved${NC}"
}

# Check root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Please run as root! Use: sudo bash $0${NC}"
        exit 1
    fi
}

# Detect OS
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$ID
        echo -e "${GREEN}✓ Detected OS: $OS${NC}"
    else
        echo -e "${RED}Cannot detect OS${NC}"
        exit 1
    fi
}

# Install packages
install_packages() {
    echo -e "${BLUE}[i] Installing required packages...${NC}"
    
    if [[ $OS == "ubuntu" ]] || [[ $OS == "debian" ]]; then
        apt update
        apt install -y apache2 php php-cli php-common php-json php-mbstring php-zip php-gd php-curl php-xml curl wget git unzip
    elif [[ $OS == "centos" ]] || [[ $OS == "rhel" ]] || [[ $OS == "fedora" ]]; then
        yum install -y httpd php php-cli php-common php-json php-mbstring php-zip php-gd php-curl php-xml curl wget git unzip
    fi
    
    echo -e "${GREEN}✓ Packages installed${NC}"
}

# Create directory
create_directory() {
    echo -e "${BLUE}[i] Creating directory...${NC}"
    
    if [[ -d $INSTALL_DIR ]]; then
        echo -e "${YELLOW}[!] Directory exists, backing up...${NC}"
        mv $INSTALL_DIR $INSTALL_DIR.bak.$(date +%Y%m%d_%H%M%S)
    fi
    
    mkdir -p $INSTALL_DIR
    chown -R www-data:www-data $INSTALL_DIR
    chmod -R 755 $INSTALL_DIR
    
    echo -e "${GREEN}✓ Directory created: $INSTALL_DIR${NC}"
}

# Download index.php from GitHub
download_index() {
    echo -e "${BLUE}[i] Downloading index.php from GitHub...${NC}"
    
    # Download file
    curl -s -o $INSTALL_DIR/index.php "$GITHUB_REPO/index.php"
    
    if [[ -f $INSTALL_DIR/index.php ]]; then
        echo -e "${GREEN}✓ index.php downloaded successfully${NC}"
    else
        echo -e "${RED}Failed to download index.php${NC}"
        exit 1
    fi
    
    # Replace default credentials with custom ones
    sed -i "s/\$valid_username = 'admin';/\$valid_username = '$ADMIN_USER';/" $INSTALL_DIR/index.php
    sed -i "s/\$valid_password = 'admin123';/\$valid_password = '$ADMIN_PASS';/" $INSTALL_DIR/index.php
    
    echo -e "${GREEN}✓ Credentials updated in index.php${NC}"
}

# Configure Apache virtual host
configure_apache() {
    echo -e "${BLUE}[i] Configuring Apache...${NC}"
    
    cat > /etc/apache2/sites-available/filemanager.conf << EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    DocumentRoot $INSTALL_DIR
    
    <Directory $INSTALL_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/filemanager_error.log
    CustomLog \${APACHE_LOG_DIR}/filemanager_access.log combined
</VirtualHost>
EOF

    a2ensite filemanager.conf
    a2dissite 000-default.conf
    systemctl reload apache2
    
    echo -e "${GREEN}✓ Apache configured${NC}"
}

# Configure Nginx (optional)
configure_nginx() {
    echo -e "${BLUE}[i] Configuring Nginx...${NC}"
    
    cat > /etc/nginx/sites-available/filemanager << EOF
server {
    listen 80;
    server_name $DOMAIN;
    root $INSTALL_DIR;
    index index.php;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }
}
EOF

    ln -sf /etc/nginx/sites-available/filemanager /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    systemctl reload nginx
    
    echo -e "${GREEN}✓ Nginx configured${NC}"
}

# Configure firewall
configure_firewall() {
    echo -e "${BLUE}[i] Configuring firewall...${NC}"
    
    if command -v ufw &> /dev/null; then
        ufw allow 80/tcp
        ufw allow 443/tcp
        echo -e "${GREEN}✓ UFW configured${NC}"
    elif command -v firewall-cmd &> /dev/null; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
        echo -e "${GREEN}✓ FirewallD configured${NC}"
    else
        echo -e "${YELLOW}[!] No firewall detected, skipping${NC}"
    fi
}

# Set proper permissions
set_permissions() {
    echo -e "${BLUE}[i] Setting permissions...${NC}"
    
    chown -R www-data:www-data $INSTALL_DIR
    chmod -R 755 $INSTALL_DIR
    chmod 644 $INSTALL_DIR/index.php
    
    echo -e "${GREEN}✓ Permissions set${NC}"
}

# Test installation
test_installation() {
    echo -e "${BLUE}[i] Testing installation...${NC}"
    
    if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200\|301\|302"; then
        echo -e "${GREEN}✓ Web server is running${NC}"
    else
        echo -e "${YELLOW}[!] Web server may not be running correctly${NC}"
    fi
    
    if php -v &> /dev/null; then
        echo -e "${GREEN}✓ PHP is working${NC}"
    else
        echo -e "${RED}PHP is not working${NC}"
    fi
}

# Show completion message with DNS record instruction
show_completion() {
    clear
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                         INSTALLATION COMPLETE!                               ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${GREEN}✓ FileMaster Pro has been installed successfully!${NC}"
    echo ""
    
    echo -e "${CYAN}┌───────────────────── DNS RECORD CONFIGURATION ─────────────────────┐${NC}"
    echo -e "${YELLOW}"
    echo "  Please add the following DNS record at your domain registrar:"
    echo ""
    echo "  ┌─────────────────────────────────────────────────┐"
    echo "  │  TYPE:  A                                       │"
    echo "  │  NAME:  ${DOMAIN%.*} (or @ for root)            │"
    echo "  │  VALUE: $(curl -s ifconfig.me)                  │"
    echo "  │  TTL:   3600 (or default)                       │"
    echo "  └─────────────────────────────────────────────────┘"
    echo -e "${NC}"
    echo -e "${CYAN}┌──────────────────────── LOGIN INFORMATION ────────────────────────┐${NC}"
    echo -e "${GREEN}"
    echo "  URL:      http://$DOMAIN"
    echo "  Username: $ADMIN_USER"
    echo "  Password: $ADMIN_PASS"
    echo -e "${NC}"
    echo -e "${CYAN}┌──────────────────────── INSTALLATION PATH ────────────────────────┐${NC}"
    echo -e "${GREEN}"
    echo "  Files:    $INSTALL_DIR"
    echo "  Config:   /etc/apache2/sites-available/filemanager.conf"
    echo -e "${NC}"
    echo -e "${CYAN}┌──────────────────────── HELPFUL COMMANDS ─────────────────────────┐${NC}"
    echo -e "${YELLOW}"
    echo "  Restart Apache:  sudo systemctl restart apache2"
    echo "  Check logs:      sudo tail -f /var/log/apache2/error.log"
    echo "  Update file:     sudo nano $INSTALL_DIR/index.php"
    echo -e "${NC}"
    echo -e "${CYAN}┌──────────────────────── NEXT STEPS ───────────────────────────────┐${NC}"
    echo -e "${WHITE}"
    echo "  1. Add DNS record as shown above"
    echo "  2. Wait 5-30 minutes for DNS propagation"
    echo "  3. Access: http://$DOMAIN"
    echo "  4. Login with your credentials"
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════════${NC}"
}

# Main execution
main() {
    print_banner
    get_domain
    get_credentials
    check_root
    detect_os
    install_packages
    create_directory
    download_index
    set_permissions
    
    # Configure based on web server
    if command -v apache2 &> /dev/null; then
        configure_apache
    elif command -v nginx &> /dev/null; then
        configure_nginx
    else
        echo -e "${RED}No web server found! Installing Apache...${NC}"
        install_packages
        configure_apache
    fi
    
    configure_firewall
    test_installation
    show_completion
}

# Run main function
main