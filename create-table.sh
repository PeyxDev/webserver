#!/bin/bash

# ============================================
# CREATE TABLES FROM SQL - PEYXDEV
# Membuat semua tabel tanpa data
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_msg() { echo -e "${GREEN}✅${NC} $1"; }
print_error() { echo -e "${RED}❌${NC} $1"; }
print_step() { echo -e "${CYAN}▶ $1${NC}"; }

clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║     CREATE TABLES - PEYXDEV              ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# Input password MySQL
read -sp "🔐 Password MySQL: " MYSQL_PASS
echo ""

# Input nama database
read -p "📁 Nama database: " DB_NAME
DB_NAME=${DB_NAME:-if0_40214202_pxstore}

print_step "Membuat database $DB_NAME"
mysql -u root -p$MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
print_msg "Database $DB_NAME siap"

print_step "Membuat semua tabel..."

mysql -u root -p$MYSQL_PASS $DB_NAME <<'EOF'
-- Table 1: admin_users
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);

-- Table 2: bot_settings
CREATE TABLE IF NOT EXISTS `bot_settings` (
  `id` int(11) NOT NULL DEFAULT 1,
  `bot_token` varchar(255) DEFAULT NULL,
  `chat_id` varchar(100) DEFAULT NULL,
  `notifications_enabled` tinyint(1) DEFAULT 1,
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);

-- Table 3: chat_conversations
CREATE TABLE IF NOT EXISTS `chat_conversations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `user_email` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `status` enum('active','closed') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user` (`user_id`)
);

-- Table 4: chat_messages
CREATE TABLE IF NOT EXISTS `chat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` int(11) DEFAULT NULL,
  `user_id` varchar(255) NOT NULL,
  `message` text DEFAULT NULL,
  `message_type` enum('text','image','file') DEFAULT 'text',
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  `is_bot` tinyint(1) DEFAULT 0,
  `is_admin` tinyint(1) DEFAULT 0,
  `admin_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `conversation_id` (`conversation_id`)
);

-- Table 5: pxstore_resellers
CREATE TABLE IF NOT EXISTS `pxstore_resellers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reseller_id` varchar(255) NOT NULL,
  `reseller_name` varchar(255) DEFAULT NULL,
  `reseller_data` longtext DEFAULT NULL,
  `total_sales` int(11) DEFAULT 0,
  `total_income` decimal(15,2) DEFAULT 0.00,
  `commission_rate` decimal(5,2) DEFAULT 15.00,
  `active_customers` int(11) DEFAULT 0,
  `reseller_history` longtext DEFAULT NULL,
  `join_date` datetime DEFAULT NULL,
  `last_active` datetime DEFAULT NULL,
  `logout_time` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'active',
  `last_ip` varchar(50) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- Table 6: pxstore_users
CREATE TABLE IF NOT EXISTS `pxstore_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `user_data` longtext DEFAULT NULL,
  `balance` int(11) DEFAULT 0,
  `topup_history` longtext DEFAULT NULL,
  `exchange_history` longtext DEFAULT NULL,
  `total_exchanges` int(11) DEFAULT 0,
  `join_date` datetime DEFAULT NULL,
  `login_time` datetime DEFAULT NULL,
  `logout_time` datetime DEFAULT NULL,
  `last_ip` varchar(50) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- Table 7: telegram_messages
CREATE TABLE IF NOT EXISTS `telegram_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` varchar(100) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `sent_to_telegram` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);

-- Table 8: telegram_replies
CREATE TABLE IF NOT EXISTS `telegram_replies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `processed` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);

-- Table 9: topup_transactions
CREATE TABLE IF NOT EXISTS `topup_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `type` enum('utama','qris') DEFAULT 'utama',
  `tx_id` varchar(100) NOT NULL,
  `method` varchar(50) DEFAULT 'qris',
  `status` enum('pending','completed','rejected') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_status` (`status`),
  KEY `idx_tx_id` (`tx_id`)
);

-- Table 10: transactions
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `transaction_type` varchar(50) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'success',
  `payment_method` varchar(100) DEFAULT NULL,
  `transaction_code` varchar(100) NOT NULL,
  `is_topup` tinyint(1) DEFAULT 0,
  `is_qris` tinyint(1) DEFAULT 0,
  `timestamp` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_transaction` (`user_id`,`transaction_code`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_transaction_code` (`transaction_code`),
  KEY `idx_timestamp` (`timestamp`)
);

-- Table 11: transaction_users
CREATE TABLE IF NOT EXISTS `transaction_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `balance` decimal(15,2) DEFAULT 0.00,
  `last_sync` datetime DEFAULT NULL,
  `total_transactions` int(11) DEFAULT 0,
  `total_amount` decimal(15,2) DEFAULT 0.00,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
);

-- Table 12: users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `saldo_utama` int(11) DEFAULT 0,
  `saldo_qris` int(11) DEFAULT 0,
  `points` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  `referral_code` varchar(20) DEFAULT NULL,
  `user_type` enum('member','reseller') DEFAULT 'member',
  `commission_balance` int(11) DEFAULT 0,
  `referrer_email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `referral_code` (`referral_code`)
);

-- Table 13: user_sessions
CREATE TABLE IF NOT EXISTS `user_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `last_activity` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `idx_user_id` (`user_id`)
);

-- Insert contoh data (1 baris saja)
INSERT INTO `admin_users` (`username`, `password`, `email`, `is_active`) VALUES 
('admin', '$2y$10$Z6lZ0QxyZZ81bnLcvrMe8eKrBhvCiuNe8tovNsxF3JYnIHFdCkh/i', 'admin@example.com', 1)
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO `users` (`email`, `saldo_utama`, `user_type`) VALUES 
('admin@example.com', 0, 'member')
ON DUPLICATE KEY UPDATE id=id;
EOF

print_msg "13 Tabel berhasil dibuat:"
echo ""
echo "  📋 Daftar Tabel:"
echo "  ───────────────────────────────────────────"
echo "  1. admin_users"
echo "  2. bot_settings"
echo "  3. chat_conversations"
echo "  4. chat_messages"
echo "  5. pxstore_resellers"
echo "  6. pxstore_users"
echo "  7. telegram_messages"
echo "  8. telegram_replies"
echo "  9. topup_transactions"
echo "  10. transactions"
echo "  11. transaction_users"
echo "  12. users"
echo "  13. user_sessions"
echo ""
echo -e "${GREEN}✅ Semua tabel berhasil dibuat di database: $DB_NAME${NC}"