#!/bin/bash

# ============================================
# AUTO FIX ALL - PEYXDEV
# Fix: Permission, API 500, Database, Chat API
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_msg() { echo -e "${GREEN}✅${NC} $1"; }
print_error() { echo -e "${RED}❌${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ️${NC} $1"; }
print_step() { echo -e "${CYAN}▶ $1${NC}"; }

clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║     AUTO FIX ALL - PEYXDEV               ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ==================== INPUT DOMAIN ====================
read -p "Masukkan domain (contoh: pxstore.web.id): " DOMAIN
DOC_ROOT="/var/www/$DOMAIN"
API_PATH="$DOC_ROOT/api-php"

if [ ! -d "$DOC_ROOT" ]; then
    print_error "Folder $DOC_ROOT tidak ditemukan!"
    exit 1
fi

# ==================== FIX PERMISSION ====================
print_step "1. FIX PERMISSION"
chown -R www-data:www-data $DOC_ROOT
find $DOC_ROOT -type d -exec chmod 755 {} \;
find $DOC_ROOT -type f -exec chmod 644 {} \;
chmod 755 $API_PATH 2>/dev/null
print_msg "Permission fixed"

# ==================== FIX .HTACCESS ====================
print_step "2. FIX .HTACCESS"
rm -f $API_PATH/.htaccess
rm -f $DOC_ROOT/.htaccess
print_msg ".htaccess removed"

# ==================== FIX PHP CONFIG ====================
print_step "3. FIX PHP CONFIG"
a2enmod php8.2 2>/dev/null
a2enmod rewrite headers 2>/dev/null
systemctl restart apache2
print_msg "PHP modules enabled"

# ==================== FIX CHAT API ====================
print_step "4. FIX CHAT API"

# Backup old file
mv $API_PATH/chat_api.php $API_PATH/chat_api.php.bak 2>/dev/null

# Create new chat API
cat > $API_PATH/chat_api.php << 'EOF'
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

error_reporting(0);
ini_set('display_errors', 0);

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database configuration
$host = "localhost";
$username = "root";
$password = "PeyxDev2024";
$database = "if0_40214202_pxstore";

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "error" => "Database connection failed"]);
    exit();
}

// Create tables if not exists
$conn->query("CREATE TABLE IF NOT EXISTS chat_conversations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) DEFAULT 'Pengguna',
    user_email VARCHAR(255),
    status ENUM('active', 'closed') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user (user_id)
)");

$conn->query("CREATE TABLE IF NOT EXISTS chat_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT,
    user_id VARCHAR(255) NOT NULL,
    message TEXT,
    message_type ENUM('text', 'image', 'file') DEFAULT 'text',
    file_name VARCHAR(255),
    file_path VARCHAR(500),
    file_size INT,
    is_bot TINYINT(1) DEFAULT 0,
    is_admin TINYINT(1) DEFAULT 0,
    admin_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)");

function getUserId() {
    if (isset($_COOKIE['px_user_id'])) {
        return $_COOKIE['px_user_id'];
    }
    $userId = 'user_' . uniqid() . '_' . time();
    setcookie('px_user_id', $userId, time() + (365 * 24 * 60 * 60), '/');
    return $userId;
}

function getOrCreateConversation($conn, $userId, $userEmail = null, $userName = null) {
    $stmt = $conn->prepare("SELECT id FROM chat_conversations WHERE user_id = ?");
    $stmt->bind_param("s", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        return $row['id'];
    } else {
        $stmt = $conn->prepare("INSERT INTO chat_conversations (user_id, user_name, user_email) VALUES (?, ?, ?)");
        $userName = $userName ?: 'Pengguna';
        $stmt->bind_param("sss", $userId, $userName, $userEmail);
        if ($stmt->execute()) {
            return $stmt->insert_id;
        }
        return false;
    }
}

function getBotResponse($message) {
    $lowerMsg = strtolower(trim($message));
    
    $responses = [
        'topup' => '💰 Cara Top Up Saldo:\n\n1. Klik tombol "Top Up"\n2. Pilih nominal\n3. Pilih metode pembayaran\n4. Transfer sesuai nominal\n5. Upload bukti pembayaran\n\nSaldo akan masuk setelah bukti terverifikasi.',
        'game' => '🎮 Layanan Top Up Game:\n\n• Mobile Legends\n• Free Fire\n• PUBG Mobile\n• Valorant\n\nSilakan pilih produk di menu utama.',
        'vpn' => '🔒 Layanan VPN:\n\n• SSH Account\n• VMess Account\n• VLess Account\n• Trojan Account\n\nSilakan chat untuk request config.',
        'cs' => '👋 Ada yang bisa kami bantu?\n\nKetik:\n- "topup" untuk info top up\n- "game" untuk top up game\n- "vpn" untuk layanan VPN',
    ];
    
    foreach ($responses as $key => $response) {
        if (strpos($lowerMsg, $key) !== false) {
            return $response;
        }
    }
    
    return "Terima kasih atas pesan Anda! 🙏 Admin kami akan segera membalas. Silakan tunggu sebentar ya.";
}

// Handle GET requests
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $action = $_GET['action'] ?? '';
    
    if ($action === 'get_chat_history') {
        $userId = getUserId();
        $conversationId = getOrCreateConversation($conn, $userId);
        
        $stmt = $conn->prepare("SELECT * FROM chat_messages WHERE conversation_id = ? ORDER BY created_at ASC");
        $stmt->bind_param("i", $conversationId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $messages = [];
        while ($row = $result->fetch_assoc()) {
            $messages[] = $row;
        }
        
        echo json_encode([
            "success" => true,
            "messages" => $messages,
            "user_id" => $userId,
            "conversation_id" => $conversationId
        ]);
        exit();
    }
    
    if ($action === 'get_all_conversations') {
        $result = $conn->query("SELECT * FROM chat_conversations ORDER BY updated_at DESC");
        $conversations = [];
        while ($row = $result->fetch_assoc()) {
            $conversations[] = $row;
        }
        echo json_encode(["success" => true, "conversations" => $conversations]);
        exit();
    }
    
    echo json_encode(["success" => true, "message" => "API is running"]);
    exit();
}

// Handle POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) {
        $input = $_POST;
    }
    
    $action = $input['action'] ?? '';
    
    if ($action === 'send_user_message') {
        $userId = getUserId();
        $message = trim($input['message'] ?? '');
        $userName = $input['user_name'] ?? null;
        
        if (empty($message)) {
            echo json_encode(["success" => false, "error" => "Pesan tidak boleh kosong"]);
            exit();
        }
        
        $conversationId = getOrCreateConversation($conn, $userId, null, $userName);
        
        // Save user message
        $stmt = $conn->prepare("INSERT INTO chat_messages (conversation_id, user_id, message) VALUES (?, ?, ?)");
        $stmt->bind_param("iss", $conversationId, $userId, $message);
        $stmt->execute();
        
        // Get bot response
        $botResponse = getBotResponse($message);
        
        // Save bot response
        $stmt = $conn->prepare("INSERT INTO chat_messages (conversation_id, user_id, message, is_bot) VALUES (?, ?, ?, 1)");
        $stmt->bind_param("iss", $conversationId, $userId, $botResponse);
        $stmt->execute();
        
        echo json_encode([
            "success" => true,
            "bot_message" => $botResponse,
            "user_id" => $userId,
            "conversation_id" => $conversationId
        ]);
        exit();
    }
    
    if ($action === 'send_admin_message') {
        $conversationId = intval($input['conversation_id'] ?? 0);
        $message = trim($input['message'] ?? '');
        $adminId = intval($input['admin_id'] ?? 1);
        
        if ($conversationId <= 0 || empty($message)) {
            echo json_encode(["success" => false, "error" => "Invalid parameters"]);
            exit();
        }
        
        $adminUserId = 'admin_' . $adminId;
        
        $stmt = $conn->prepare("INSERT INTO chat_messages (conversation_id, user_id, message, is_admin, admin_id) VALUES (?, ?, ?, 1, ?)");
        $stmt->bind_param("issi", $conversationId, $adminUserId, $message, $adminId);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Pesan terkirim"]);
        } else {
            echo json_encode(["success" => false, "error" => "Gagal mengirim pesan"]);
        }
        exit();
    }
    
    echo json_encode(["success" => false, "error" => "Unknown action"]);
    exit();
}

echo json_encode(["success" => false, "error" => "Invalid request"]);
$conn->close();
EOF

chmod 644 $API_PATH/chat_api.php
print_msg "Chat API fixed"

# ==================== FIX VIRTUAL HOST ====================
print_step "5. FIX VIRTUAL HOST"

cat > /etc/apache2/sites-available/$DOMAIN.conf << EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DOC_ROOT
    
    <Directory $DOC_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/${DOMAIN}_error.log
    CustomLog \${APACHE_LOG_DIR}/${DOMAIN}_access.log combined
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DOC_ROOT
    
    <Directory $DOC_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    <Directory $API_PATH>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
    
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/$DOMAIN/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/$DOMAIN/privkey.pem
    
    ErrorLog \${APACHE_LOG_DIR}/${DOMAIN}_ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/${DOMAIN}_ssl_access.log combined
</VirtualHost>
EOF

a2ensite $DOMAIN.conf 2>/dev/null
a2dissite 000-default.conf 2>/dev/null

# ==================== RESTART SERVICES ====================
print_step "6. RESTART SERVICES"
systemctl restart apache2
systemctl restart php8.2-fpm
print_msg "Services restarted"

# ==================== TEST ====================
print_step "7. TESTING"

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  TEST RESULTS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Test 1: PHP info
if curl -k -s https://$DOMAIN/info.php | grep -q "PHP Version"; then
    print_msg "PHP Info: OK"
else
    print_error "PHP Info: FAILED"
fi

# Test 2: Chat API
RESPONSE=$(curl -k -s "https://$DOMAIN/api-php/chat_api.php?action=get_chat_history")
if echo "$RESPONSE" | grep -q "success"; then
    print_msg "Chat API: OK"
else
    print_error "Chat API: FAILED"
fi

# Test 3: Send message
RESPONSE=$(curl -k -s -X POST https://$DOMAIN/api-php/chat_api.php \
    -H "Content-Type: application/json" \
    -d '{"action":"send_user_message","message":"test"}')
if echo "$RESPONSE" | grep -q "bot_message"; then
    print_msg "Send Message: OK"
else
    print_error "Send Message: FAILED"
fi

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}       FIX COMPLETED! ✅${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo -e "  ${CYAN}🌍 Akses Website:${NC}"
echo -e "  https://$DOMAIN"
echo ""
echo -e "  ${CYAN}💬 Akses Chat:${NC}"
echo -e "  https://$DOMAIN/api-php/chat_api.php?action=get_chat_history"
echo ""
echo -e "  ${CYAN}📝 Test dengan Curl:${NC}"
echo -e "  curl -k https://$DOMAIN/api-php/chat_api.php?action=get_chat_history"
echo ""
echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${MAGENTA}  PeyxDev - Auto Fix Complete${NC}"
echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"