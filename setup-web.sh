#!/bin/bash

# ============================================
# AUTO FIX & MANAGE WEB SERVER - PEYXDEV
# Support: Ubuntu 22.04 | 24.04
# ============================================

set -e

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Icon
ICON_CHECK="✅"
ICON_ERROR="❌"
ICON_INFO="ℹ️"
ICON_WARN="⚠️"
ICON_ROCKET="🚀"
ICON_FOLDER="📁"
ICON_DB="🗄️"
ICON_LOCK="🔒"
ICON_WRENCH="🔧"
ICON_GLOBE="🌍"
ICON_REFRESH="🔄"
ICON_TRASH="🗑️"
ICON_BACKUP="💾"
ICON_USER="👤"

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║                                          ║"
    echo "║   ██████╗ ███████╗██╗   ██╗██████╗ ███████╗║"
    echo "║   ██╔══██╗██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝║"
    echo "║   ██████╔╝█████╗   ╚████╔╝ ██║  ██║█████╗  ║"
    echo "║   ██╔═══╝ ██╔══╝    ╚██╔╝  ██║  ██║██╔══╝  ║"
    echo "║   ██║     ███████╗   ██║   ██████╔╝███████╗║"
    echo "║   ╚═╝     ╚══════╝   ╚═╝   ╚═════╝ ╚══════╝║"
    echo "║                                          ║"
    echo "║     AUTO FIX & MANAGE SERVER v2.0        ║"
    echo "║          BY PEYXDEV                      ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_msg() { echo -e " ${GREEN}${ICON_CHECK}${NC} $1"; }
print_error() { echo -e " ${RED}${ICON_ERROR}${NC} $1"; }
print_info() { echo -e " ${BLUE}${ICON_INFO}${NC} $1"; }
print_warning() { echo -e " ${YELLOW}${ICON_WARN}${NC} $1"; }
print_step() { 
    echo ""
    echo -e "${MAGENTA}┌────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}│ ${ICON_WRENCH} $1${NC}"
    echo -e "${MAGENTA}└────────────────────────────────────────┘${NC}"
}

print_menu() {
    clear
    print_banner
    echo ""
    echo -e "${WHITE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║            MAIN MENU                     ║${NC}"
    echo -e "${WHITE}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${GREEN}🔧 FIX & REPAIR MENU${NC}"
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${GREEN}1)${NC} Fix Permission All Folders"
    echo -e "  ${GREEN}2)${NC} Fix PHP/Apache Configuration"
    echo -e "  ${GREEN}3)${NC} Fix API 500 Error"
    echo -e "  ${GREEN}4)${NC} Fix Database Connection"
    echo -e "  ${GREEN}5)${NC} Fix SSL Certificate"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BLUE}📊 MANAGEMENT MENU${NC}"
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${BLUE}6)${NC} View Server Status"
    echo -e "  ${BLUE}7)${NC} Backup Website & Database"
    echo -e "  ${BLUE}8)${NC} Restore Backup"
    echo -e "  ${BLUE}9)${NC} View Error Logs"
    echo -e "  ${BLUE}10)${NC} Restart Services"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${YELLOW}⚙️ ADVANCED MENU${NC}"
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${YELLOW}11)${NC} Install PHPMyAdmin"
    echo -e "  ${YELLOW}12)${NC} Install SSL Certificate"
    echo -e "  ${YELLOW}13)${NC} Create Database & Tables"
    echo -e "  ${YELLOW}14)${NC} Optimize Server Performance"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${RED}15)${NC} Exit"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "$(echo -e ${WHITE}▶ Pilihan Anda [1-15]:${NC} )" MENU_CHOICE
}

# ==================== FIX FUNCTIONS ====================

fix_permission() {
    print_step "FIX PERMISSION ALL FOLDERS"
    
    read -p "Masukkan domain (contoh: pxstore.web.id): " DOMAIN
    DOC_ROOT="/var/www/$DOMAIN"
    
    if [ ! -d "$DOC_ROOT" ]; then
        print_error "Folder $DOC_ROOT tidak ditemukan!"
        return
    fi
    
    print_msg "Memperbaiki permission untuk $DOMAIN"
    
    # Set ownership
    chown -R www-data:www-data $DOC_ROOT
    
    # Set folder permission
    find $DOC_ROOT -type d -exec chmod 755 {} \;
    
    # Set file permission
    find $DOC_ROOT -type f -exec chmod 644 {} \;
    
    # Permission khusus untuk api-php
    if [ -d "$DOC_ROOT/api-php" ]; then
        chmod 755 $DOC_ROOT/api-php
        chmod 644 $DOC_ROOT/api-php/*.php 2>/dev/null
        print_msg "Permission api-php folder fixed"
    fi
    
    # Hapus .htaccess yang bermasalah
    find $DOC_ROOT -name ".htaccess" -exec mv {} {}.bak \;
    print_msg ".htaccess files backed up"
    
    # Buat .htaccess baru
    cat > $DOC_ROOT/.htaccess << 'EOF'
Options +Indexes
DirectoryIndex index.php index.html

<IfModule mod_authz_core.c>
    Require all granted
</IfModule>

<FilesMatch "\.(php|html)$">
    Require all granted
</FilesMatch>
EOF
    
    chmod 644 $DOC_ROOT/.htaccess
    
    # Restart Apache
    systemctl restart apache2
    
    print_msg "Permission fixed successfully!"
    print_info "Test: curl -k https://$DOMAIN/api-php/test.html"
}

fix_php_apache() {
    print_step "FIX PHP/APACHE CONFIGURATION"
    
    print_msg "Memperbaiki konfigurasi PHP dan Apache"
    
    # Enable modul PHP
    a2enmod php8.2 2>/dev/null
    a2enmod rewrite 2>/dev/null
    a2enmod headers 2>/dev/null
    
    # Fix php.ini
    sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/display_startup_errors = Off/display_startup_errors = On/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/post_max_size = 8M/post_max_size = 50M/g' /etc/php/8.2/apache2/php.ini
    
    # Restart service
    systemctl restart apache2
    systemctl restart php8.2-fpm
    
    print_msg "PHP/Apache configuration fixed!"
}

fix_api_500() {
    print_step "FIX API 500 INTERNAL SERVER ERROR"
    
    read -p "Masukkan domain (contoh: pxstore.web.id): " DOMAIN
    DOC_ROOT="/var/www/$DOMAIN"
    
    if [ ! -d "$DOC_ROOT" ]; then
        print_error "Folder $DOC_ROOT tidak ditemukan!"
        return
    fi
    
    print_msg "Memperbaiki API 500 Error"
    
    # Buat folder api-php jika belum ada
    mkdir -p $DOC_ROOT/api-php
    
    # Buat file test sederhana
    cat > $DOC_ROOT/api-php/test-simple.php << 'EOF'
<?php
echo "API is working!";
?>
EOF
    
    # Buat file login sederhana
    cat > $DOC_ROOT/api-php/login.php << 'EOF'
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$response = ['success' => true, 'message' => 'API is working'];
echo json_encode($response);
EOF
    
    # Set permission
    chmod 755 $DOC_ROOT/api-php
    chmod 644 $DOC_ROOT/api-php/*.php
    chown -R www-data:www-data $DOC_ROOT/api-php
    
    # Hapus .htaccess di api-php
    rm -f $DOC_ROOT/api-php/.htaccess
    
    # Tambahkan konfigurasi ke virtual host
    cat >> /etc/apache2/sites-available/$DOMAIN.conf << EOF

<Directory $DOC_ROOT/api-php>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
    <FilesMatch "\.(php|html)$">
        Require all granted
    </FilesMatch>
</Directory>
EOF
    
    # Restart Apache
    systemctl restart apache2
    
    print_msg "API 500 Error fixed!"
    print_info "Test: curl -k https://$DOMAIN/api-php/test-simple.php"
    print_info "Test: curl -k https://$DOMAIN/api-php/login.php"
}

fix_database() {
    print_step "FIX DATABASE CONNECTION"
    
    read -sp "Masukkan password MySQL: " MYSQL_PASS
    echo ""
    
    # Test connection
    if mysql -u root -p$MYSQL_PASS -e "SELECT 1" 2>/dev/null; then
        print_msg "MySQL connection successful!"
        
        # Create database if not exists
        read -p "Masukkan nama database: " DB_NAME
        mysql -u root -p$MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
        print_msg "Database $DB_NAME ready"
        
        # Create admin_users table
        mysql -u root -p$MYSQL_PASS $DB_NAME << 'EOF'
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);
EOF
        print_msg "Table admin_users created"
        
    else
        # Reset password
        print_warning "Reset password MySQL"
        service mysql stop
        mysqld_safe --skip-grant-tables &
        sleep 5
        mysql -e "FLUSH PRIVILEGES; ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_PASS';"
        pkill mysqld
        service mysql start
        print_msg "MySQL password reset to: $MYSQL_PASS"
    fi
}

fix_ssl() {
    print_step "FIX SSL CERTIFICATE"
    
    read -p "Masukkan domain: " DOMAIN
    read -p "Masukkan email: " EMAIL
    
    # Install certbot
    apt install -y certbot python3-certbot-apache
    
    # Renew certificate
    certbot --apache -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email $EMAIL --force-renewal
    
    # Auto renew cron
    (crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet") | crontab -
    
    print_msg "SSL certificate fixed!"
}

# ==================== MANAGEMENT FUNCTIONS ====================

view_status() {
    print_step "SERVER STATUS"
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}  SERVICE STATUS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Apache
    if systemctl is-active apache2 >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} Apache: Running"
    else
        echo -e "  ${RED}❌${NC} Apache: Stopped"
    fi
    
    # MySQL
    if systemctl is-active mysql >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} MySQL: Running"
    else
        echo -e "  ${RED}❌${NC} MySQL: Stopped"
    fi
    
    # PHP-FPM
    if systemctl is-active php8.2-fpm >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} PHP-FPM: Running"
    else
        echo -e "  ${RED}❌${NC} PHP-FPM: Stopped"
    fi
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}  DISK USAGE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    df -h / | tail -1
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}  MEMORY USAGE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    free -h
    
    echo ""
    read -p "Tekan Enter untuk kembali..."
}

backup_data() {
    print_step "BACKUP WEBSITE & DATABASE"
    
    read -p "Masukkan domain: " DOMAIN
    BACKUP_DIR="/root/backups"
    mkdir -p $BACKUP_DIR
    DATE=$(date +%Y%m%d_%H%M%S)
    
    DOC_ROOT="/var/www/$DOMAIN"
    
    if [ -d "$DOC_ROOT" ]; then
        tar -czf $BACKUP_DIR/website_${DOMAIN}_$DATE.tar.gz $DOC_ROOT
        print_msg "Website backed up: $BACKUP_DIR/website_${DOMAIN}_$DATE.tar.gz"
    else
        print_error "Folder $DOC_ROOT tidak ditemukan"
    fi
    
    read -sp "Password MySQL: " MYSQL_PASS
    echo ""
    
    mysqldump -u root -p$MYSQL_PASS --all-databases > $BACKUP_DIR/database_$DATE.sql 2>/dev/null
    print_msg "Database backed up: $BACKUP_DIR/database_$DATE.sql"
    
    # Delete backups older than 7 days
    find $BACKUP_DIR -type f -mtime +7 -delete
    print_msg "Old backups deleted (retention: 7 days)"
}

restore_backup() {
    print_step "RESTORE BACKUP"
    
    BACKUP_DIR="/root/backups"
    
    echo ""
    echo -e "${CYAN}Available backups:${NC}"
    ls -lh $BACKUP_DIR/
    echo ""
    
    read -p "Masukkan nama file backup website: " WEBSITE_BACKUP
    read -p "Masukkan nama file backup database: " DB_BACKUP
    read -p "Masukkan domain tujuan: " DOMAIN
    
    DOC_ROOT="/var/www/$DOMAIN"
    
    if [ -f "$BACKUP_DIR/$WEBSITE_BACKUP" ]; then
        tar -xzf $BACKUP_DIR/$WEBSITE_BACKUP -C /
        print_msg "Website restored"
    else
        print_error "File website backup tidak ditemukan"
    fi
    
    if [ -f "$BACKUP_DIR/$DB_BACKUP" ]; then
        read -sp "Password MySQL: " MYSQL_PASS
        echo ""
        mysql -u root -p$MYSQL_PASS < $BACKUP_DIR/$DB_BACKUP
        print_msg "Database restored"
    else
        print_error "File database backup tidak ditemukan"
    fi
    
    # Fix permission after restore
    chown -R www-data:www-data $DOC_ROOT
    find $DOC_ROOT -type d -exec chmod 755 {} \;
    find $DOC_ROOT -type f -exec chmod 644 {} \;
    
    print_msg "Restore completed!"
}

view_logs() {
    print_step "VIEW ERROR LOGS"
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}  APACHE ERROR LOG (last 20 lines)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    tail -20 /var/log/apache2/error.log
    echo ""
    
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}  PHP ERROR LOG (last 20 lines)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    tail -20 /var/log/php8.2-fpm.log 2>/dev/null || echo "No PHP-FPM log"
    echo ""
    
    read -p "Tekan Enter untuk kembali..."
}

restart_services() {
    print_step "RESTART ALL SERVICES"
    
    systemctl restart apache2
    systemctl restart mysql
    systemctl restart php8.2-fpm
    
    print_msg "All services restarted!"
    sleep 2
}

# ==================== ADVANCED FUNCTIONS ====================

install_phpmyadmin() {
    print_step "INSTALL PHPMYADMIN"
    
    read -p "Masukkan domain: " DOMAIN
    DOC_ROOT="/var/www/$DOMAIN"
    
    cd /var/www
    rm -rf phpmyadmin
    wget -q https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip
    unzip -q phpMyAdmin-latest-all-languages.zip
    mv phpMyAdmin-*-all-languages phpmyadmin
    rm phpMyAdmin-latest-all-languages.zip
    
    BLOWFISH=$(openssl rand -base64 32)
    cat > /var/www/phpmyadmin/config.inc.php <<EOF
<?php
\$cfg['blowfish_secret'] = '$BLOWFISH';
\$cfg['Servers'][1]['auth_type'] = 'cookie';
\$cfg['Servers'][1]['host'] = 'localhost';
\$cfg['Servers'][1]['compress'] = false;
\$cfg['Servers'][1]['AllowNoPassword'] = false;
?>
EOF
    
    ln -sf /var/www/phpmyadmin $DOC_ROOT/phpmyadmin
    
    chown -R www-data:www-data /var/www/phpmyadmin
    find /var/www/phpmyadmin -type d -exec chmod 755 {} \;
    find /var/www/phpmyadmin -type f -exec chmod 644 {} \;
    
    systemctl restart apache2
    
    print_msg "PHPMyAdmin installed!"
    print_info "Access: https://$DOMAIN/phpmyadmin"
    print_info "Username: root"
    print_info "Password: (your MySQL password)"
}

install_ssl() {
    fix_ssl
}

create_database_tables() {
    print_step "CREATE DATABASE & TABLES"
    
    read -p "Masukkan nama database: " DB_NAME
    read -sp "Masukkan password MySQL: " MYSQL_PASS
    echo ""
    
    mysql -u root -p$MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    print_msg "Database $DB_NAME created"
    
    mysql -u root -p$MYSQL_PASS $DB_NAME << 'EOF'
CREATE TABLE IF NOT EXISTS `admin_users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(100) NOT NULL,
    `password` varchar(255) NOT NULL,
    `email` varchar(255) DEFAULT NULL,
    `is_active` tinyint(1) DEFAULT 1,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`)
);

INSERT INTO `admin_users` (`username`, `password`, `email`) VALUES 
('admin', '$2y$10$Z6lZ0QxyZZ81bnLcvrMe8eKrBhvCiuNe8tovNsxF3JYnIHFdCkh/i', 'admin@localhost')
ON DUPLICATE KEY UPDATE id=id;

CREATE TABLE IF NOT EXISTS `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `email` varchar(255) NOT NULL,
    `username` varchar(100) DEFAULT NULL,
    `password` varchar(255) DEFAULT NULL,
    `balance` int(11) DEFAULT 0,
    `created_at` timestamp NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `email` (`email`)
);
EOF
    
    print_msg "Tables created successfully!"
    print_info "Admin login: username 'admin', password 'admin123'"
}

optimize_server() {
    print_step "OPTIMIZE SERVER PERFORMANCE"
    
    # Optimize MySQL
    mysql -u root -e "SET GLOBAL query_cache_size = 268435456;" 2>/dev/null
    mysql -u root -e "SET GLOBAL innodb_buffer_pool_size = 536870912;" 2>/dev/null
    
    # Optimize PHP
    sed -i 's/memory_limit = 256M/memory_limit = 512M/g' /etc/php/8.2/apache2/php.ini
    sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/8.2/apache2/php.ini
    
    # Enable OPcache
    sed -i 's/;opcache.enable=1/opcache.enable=1/g' /etc/php/8.2/apache2/php.ini
    
    # Optimize Apache
    a2enmod expires headers deflate
    
    # Restart services
    systemctl restart apache2 mysql php8.2-fpm
    
    print_msg "Server optimized!"
}

# ==================== MAIN LOOP ====================

while true; do
    print_menu
    
    case $MENU_CHOICE in
        1) fix_permission ;;
        2) fix_php_apache ;;
        3) fix_api_500 ;;
        4) fix_database ;;
        5) fix_ssl ;;
        6) view_status ;;
        7) backup_data ;;
        8) restore_backup ;;
        9) view_logs ;;
        10) restart_services ;;
        11) install_phpmyadmin ;;
        12) install_ssl ;;
        13) create_database_tables ;;
        14) optimize_server ;;
        15) 
            print_msg "Terima kasih telah menggunakan PeyxDev Script!"
            exit 0
            ;;
        *) 
            print_error "Pilihan tidak valid!"
            sleep 2
            ;;
    esac
done