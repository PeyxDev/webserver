<?php
session_start();

// Authentication
$auth_enabled = true;
$valid_username = 'admin';
$valid_password = 'admin123';

if ($auth_enabled && (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true)) {
    if (isset($_POST['username']) && isset($_POST['password'])) {
        if ($_POST['username'] === $valid_username && $_POST['password'] === $valid_password) {
            $_SESSION['logged_in'] = true;
            header('Location: index.php');
            exit;
        } else {
            $error = "Invalid credentials!";
        }
    }
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>FileMaster Pro - Login</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #0f0f12 0%, #1a1a2e 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                overflow: hidden;
            }
            .bg-animation {
                position: fixed;
                width: 100%;
                height: 100%;
                background: radial-gradient(circle at 20% 50%, rgba(99,102,241,0.15) 0%, transparent 50%);
                animation: pulse 4s ease-in-out infinite;
            }
            @keyframes pulse {
                0%, 100% { opacity: 0.5; transform: scale(1); }
                50% { opacity: 1; transform: scale(1.1); }
            }
            .login-container {
                position: relative;
                z-index: 1;
                background: rgba(26, 26, 46, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 32px;
                padding: 48px;
                width: 440px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
                border: 1px solid rgba(99, 102, 241, 0.2);
                animation: slideUp 0.5s ease;
            }
            @keyframes slideUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .logo { text-align: center; margin-bottom: 40px; }
            .logo-icon {
                width: 80px; height: 80px;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                border-radius: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                animation: float 3s ease-in-out infinite;
            }
            @keyframes float {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-10px); }
            }
            .logo-icon i { font-size: 40px; color: white; }
            .logo h1 {
                font-size: 32px; font-weight: 800;
                background: linear-gradient(135deg, #6366f1, #8b5cf6, #a855f7);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }
            .logo p { color: #94a3b8; margin-top: 8px; }
            .input-group { margin-bottom: 24px; }
            .input-group label {
                display: block; margin-bottom: 8px; color: #cbd5e1;
                font-size: 13px; font-weight: 500; letter-spacing: 0.5px;
            }
            .input-wrapper {
                position: relative;
                background: rgba(15, 15, 18, 0.8);
                border-radius: 16px;
                border: 1px solid rgba(99, 102, 241, 0.3);
                transition: all 0.3s;
            }
            .input-wrapper:focus-within {
                border-color: #6366f1;
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }
            .input-wrapper i {
                position: absolute; left: 16px; top: 50%;
                transform: translateY(-50%); color: #64748b;
            }
            .input-wrapper input {
                width: 100%; padding: 14px 16px 14px 48px;
                background: transparent; border: none;
                color: white; font-size: 14px;
            }
            .input-wrapper input:focus { outline: none; }
            .login-btn {
                width: 100%; padding: 14px;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                border: none; border-radius: 16px; color: white;
                font-size: 15px; font-weight: 600; cursor: pointer;
                transition: all 0.3s;
            }
            .login-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px -5px rgba(99,102,241,0.4);
            }
            .error-message {
                background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3);
                border-radius: 16px; padding: 12px; margin-bottom: 24px;
                color: #f87171; text-align: center; font-size: 14px;
            }
        </style>
    </head>
    <body>
        <div class="bg-animation"></div>
        <div class="login-container">
            <div class="logo">
                <div class="logo-icon"><i class="fas fa-folder-open"></i></div>
                <h1>FileMaster Pro</h1>
                <p>Enterprise File Management System</p>
            </div>
            <?php if (isset($error)): ?>
            <div class="error-message"><i class="fas fa-exclamation-triangle"></i> <?php echo $error; ?></div>
            <?php endif; ?>
            <form method="POST">
                <div class="input-group">
                    <label><i class="fas fa-user"></i> USERNAME</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user"></i>
                        <input type="text" name="username" placeholder="Enter username" required>
                    </div>
                </div>
                <div class="input-group">
                    <label><i class="fas fa-lock"></i> PASSWORD</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" placeholder="Enter password" required>
                    </div>
                </div>
                <button type="submit" class="login-btn"><i class="fas fa-arrow-right-to-bracket"></i> Access Dashboard</button>
            </form>
        </div>
    </body>
    </html>
    <?php
    exit;
}

// Logout
if (isset($_GET['logout'])) {
    session_destroy();
    header('Location: index.php');
    exit;
}

// Get requested path
$requested_path = isset($_GET['path']) ? $_GET['path'] : '';
$full_path = $requested_path ? realpath($requested_path) : realpath('/var/www');

// Security: Allowed directories
$allowed_dirs = ['/var/www', '/home', '/opt', '/etc', '/backup'];

$is_allowed = false;
foreach ($allowed_dirs as $allowed) {
    $allowed_real = realpath($allowed);
    if ($allowed_real && strpos($full_path, $allowed_real) === 0) {
        $is_allowed = true;
        break;
    }
}

if (!$full_path || !$is_allowed || !is_dir($full_path)) {
    $full_path = '/var/www';
    $requested_path = '/var/www';
}

// Handle actions
$action = isset($_GET['action']) ? $_GET['action'] : '';

if ($action === 'get_files') {
    header('Content-Type: application/json');
    $items = scandir($full_path);
    $result = ['dirs' => [], 'files' => []];
    
    foreach ($items as $item) {
        if ($item == '.' || $item == '..') continue;
        $item_path = $full_path . '/' . $item;
        
        if (is_dir($item_path)) {
            $result['dirs'][] = [
                'name' => $item, 'path' => $item_path, 'type' => 'dir',
                'permission' => substr(sprintf('%o', fileperms($item_path)), -4),
                'modified' => date('Y-m-d H:i:s', filemtime($item_path))
            ];
        } else {
            $result['files'][] = [
                'name' => $item, 'path' => $item_path, 'type' => 'file',
                'size' => filesize($item_path),
                'size_formatted' => formatSize(filesize($item_path)),
                'ext' => pathinfo($item, PATHINFO_EXTENSION),
                'permission' => substr(sprintf('%o', fileperms($item_path)), -4),
                'modified' => date('Y-m-d H:i:s', filemtime($item_path))
            ];
        }
    }
    
    // Sort directories first, then files
    usort($result['dirs'], function($a, $b) { return strcmp($a['name'], $b['name']); });
    usort($result['files'], function($a, $b) { return strcmp($a['name'], $b['name']); });
    
    echo json_encode($result);
    exit;
}

if ($action === 'get_content' && isset($_GET['file'])) {
    header('Content-Type: application/json');
    $file_path = realpath($_GET['file']);
    $is_allowed = false;
    foreach ($allowed_dirs as $allowed) {
        $allowed_real = realpath($allowed);
        if ($allowed_real && strpos($file_path, $allowed_real) === 0) { $is_allowed = true; break; }
    }
    if ($file_path && is_file($file_path) && $is_allowed) {
        $content = file_get_contents($file_path);
        echo json_encode(['success' => true, 'content' => $content, 'filename' => basename($file_path)]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Cannot read file']);
    }
    exit;
}

if ($action === 'save_content' && isset($_POST['file']) && isset($_POST['content'])) {
    header('Content-Type: application/json');
    $file_path = realpath($_POST['file']);
    $is_allowed = false;
    foreach ($allowed_dirs as $allowed) {
        $allowed_real = realpath($allowed);
        if ($allowed_real && strpos($file_path, $allowed_real) === 0) { $is_allowed = true; break; }
    }
    if ($file_path && is_file($file_path) && $is_allowed && is_writable($file_path)) {
        file_put_contents($file_path, $_POST['content']);
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false]);
    }
    exit;
}

if ($action === 'delete' && isset($_GET['item'])) {
    header('Content-Type: application/json');
    $item_path = realpath($_GET['item']);
    $is_allowed = false;
    foreach ($allowed_dirs as $allowed) {
        $allowed_real = realpath($allowed);
        if ($allowed_real && strpos($item_path, $allowed_real) === 0) { $is_allowed = true; break; }
    }
    if ($item_path && $is_allowed) {
        if (is_file($item_path)) {
            unlink($item_path);
        } elseif (is_dir($item_path)) {
            rmdir($item_path);
        }
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false]);
    }
    exit;
}

if ($action === 'create_folder' && isset($_POST['folder_name'])) {
    header('Content-Type: application/json');
    $folder_name = preg_replace('/[^a-zA-Z0-9_\-]/', '', $_POST['folder_name']);
    $new_folder = $full_path . '/' . $folder_name;
    
    if (!empty($folder_name) && !file_exists($new_folder)) {
        if (mkdir($new_folder, 0755, true)) {
            echo json_encode(['success' => true, 'message' => 'Folder created successfully']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to create folder - permission denied']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid folder name or already exists']);
    }
    exit;
}

if ($action === 'rename' && isset($_POST['old_name']) && isset($_POST['new_name'])) {
    header('Content-Type: application/json');
    $old_path = realpath($_POST['old_name']);
    $new_name = preg_replace('/[^a-zA-Z0-9_\-\.]/', '', $_POST['new_name']);
    
    if ($old_path && $new_name) {
        $new_path = dirname($old_path) . '/' . $new_name;
        if (!file_exists($new_path)) {
            if (rename($old_path, $new_path)) {
                echo json_encode(['success' => true, 'message' => 'Renamed successfully']);
            } else {
                echo json_encode(['success' => false, 'message' => 'Failed to rename']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'File already exists']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid name']);
    }
    exit;
}

// FIXED: Upload action - improved with better error handling
if ($action === 'upload') {
    if (isset($_FILES['file']) && $_FILES['file']['error'] === UPLOAD_ERR_OK) {
        $target = $full_path . '/' . basename($_FILES['file']['name']);
        
        // Check if directory is writable
        if (!is_writable($full_path)) {
            $error_msg = urlencode('Upload failed: Directory is not writable. Please check permissions.');
            header('Location: index.php?path=' . urlencode($requested_path) . '&error=' . $error_msg);
            exit;
        }
        
        if (move_uploaded_file($_FILES['file']['tmp_name'], $target)) {
            header('Location: index.php?path=' . urlencode($requested_path) . '&success=1');
            exit;
        } else {
            $error_msg = urlencode('Upload failed: Could not move file. Check disk space and permissions.');
            header('Location: index.php?path=' . urlencode($requested_path) . '&error=' . $error_msg);
            exit;
        }
    } else {
        $error_msg = urlencode('Upload failed: No file selected or upload error.');
        header('Location: index.php?path=' . urlencode($requested_path) . '&error=' . $error_msg);
        exit;
    }
}

function formatSize($bytes) {
    if ($bytes < 1024) return $bytes . ' B';
    if ($bytes < 1048576) return round($bytes/1024, 1) . ' KB';
    if ($bytes < 1073741824) return round($bytes/1048576, 1) . ' MB';
    return round($bytes/1073741824, 1) . ' GB';
}

$parent_path = dirname($full_path);
$can_go_up = false;
foreach ($allowed_dirs as $allowed) {
    $allowed_real = realpath($allowed);
    if ($allowed_real && strpos($parent_path, $allowed_real) === 0 && $parent_path !== $allowed_real) {
        $can_go_up = true;
        break;
    }
}

$is_writable = is_writable($full_path);
$success_msg = isset($_GET['success']) ? 'File uploaded successfully!' : '';
$error_msg = isset($_GET['error']) ? urldecode($_GET['error']) : '';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FileMaster Pro - Enterprise File Manager</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/dracula.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/material-darker.min.css">
    <style>
        :root {
            --bg-primary: #0a0a0f;
            --bg-secondary: #0f0f14;
            --bg-tertiary: #1a1a24;
            --bg-hover: #2a2a35;
            --border: #2a2a35;
            --text-primary: #ffffff;
            --text-secondary: #a0a0b0;
            --text-muted: #6b6b7a;
            --accent: #6366f1;
            --accent-dark: #4f46e5;
            --accent-light: #818cf8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --gradient: linear-gradient(135deg, #6366f1, #8b5cf6, #a855f7);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            overflow: hidden;
        }

        /* App Container */
        .app {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar - VS Code Style */
        .sidebar {
            width: 280px;
            background: var(--bg-secondary);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        /* Custom Scrollbar */
        .sidebar::-webkit-scrollbar, .file-table-container::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        .sidebar::-webkit-scrollbar-track, .file-table-container::-webkit-scrollbar-track {
            background: var(--bg-primary);
        }
        .sidebar::-webkit-scrollbar-thumb, .file-table-container::-webkit-scrollbar-thumb {
            background: var(--border);
            border-radius: 3px;
        }
        .sidebar::-webkit-scrollbar-thumb:hover, .file-table-container::-webkit-scrollbar-thumb:hover {
            background: var(--accent);
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(180deg, var(--bg-secondary) 0%, var(--bg-primary) 100%);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
        }

        .logo-icon {
            width: 44px;
            height: 44px;
            background: var(--gradient);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        .logo-icon i {
            font-size: 24px;
            color: white;
        }

        .logo-text h2 {
            font-size: 18px;
            font-weight: 700;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .logo-text p {
            font-size: 11px;
            color: var(--text-muted);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            background: rgba(99, 102, 241, 0.1);
            border-radius: 12px;
            border: 1px solid rgba(99, 102, 241, 0.2);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: var(--gradient);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .user-details {
            flex: 1;
        }

        .user-details .name {
            font-size: 14px;
            font-weight: 600;
        }

        .user-details .role {
            font-size: 11px;
            color: var(--text-muted);
        }

        .logout-btn {
            color: var(--text-muted);
            text-decoration: none;
            padding: 6px;
            border-radius: 8px;
            transition: all 0.2s;
        }

        .logout-btn:hover {
            background: var(--bg-hover);
            color: var(--danger);
        }

        .nav-menu {
            flex: 1;
            padding: 20px;
        }

        .section-title {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            padding: 16px 12px 8px;
            font-weight: 700;
        }

        .nav-item {
            padding: 10px 12px;
            margin-bottom: 4px;
            border-radius: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.2s;
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 500;
        }

        .nav-item:hover {
            background: var(--bg-hover);
            color: var(--text-primary);
        }

        .nav-item.active {
            background: var(--gradient);
            color: white;
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .nav-item i {
            width: 20px;
            font-size: 14px;
        }

        .quick-access-item {
            padding: 8px 12px;
            margin-bottom: 2px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            transition: all 0.2s;
            color: var(--text-secondary);
        }

        .quick-access-item:hover {
            background: var(--bg-hover);
            color: var(--text-primary);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background: var(--bg-primary);
        }

        /* Top Bar */
        .top-bar {
            background: var(--bg-secondary);
            border-bottom: 1px solid var(--border);
            padding: 12px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .location-bar {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 12px;
            background: var(--bg-primary);
            padding: 8px 16px;
            border-radius: 12px;
            border: 1px solid var(--border);
        }

        .location-bar i {
            color: var(--accent);
        }

        .location-bar input {
            flex: 1;
            background: none;
            border: none;
            color: var(--text-primary);
            font-size: 13px;
            font-family: 'Monaco', 'Menlo', monospace;
        }

        .location-bar input:focus {
            outline: none;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-primary {
            background: var(--gradient);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
        }

        .btn-secondary {
            background: var(--bg-tertiary);
            color: var(--text-primary);
            border: 1px solid var(--border);
        }

        .btn-secondary:hover {
            background: var(--bg-hover);
        }

        /* Stats Bar */
        .stats-bar {
            background: var(--bg-secondary);
            padding: 12px 24px;
            display: flex;
            gap: 32px;
            border-bottom: 1px solid var(--border);
            font-size: 13px;
        }

        .stat {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-muted);
        }

        .stat i {
            color: var(--accent);
            font-size: 14px;
        }

        .stat-value {
            color: var(--text-primary);
            font-weight: 600;
        }

        /* Permission Warning */
        .permission-warning {
            background: rgba(239, 68, 68, 0.1);
            border-left: 3px solid var(--danger);
            padding: 12px 24px;
            margin: 12px 24px;
            border-radius: 10px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* File Table */
        .file-table-container {
            flex: 1;
            overflow: auto;
        }

        .file-table {
            width: 100%;
            border-collapse: collapse;
        }

        .file-table th {
            text-align: left;
            padding: 14px 20px;
            background: var(--bg-tertiary);
            color: var(--text-muted);
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .file-table td {
            padding: 12px 20px;
            border-bottom: 1px solid var(--border);
            font-size: 13px;
        }

        .file-table tr {
            cursor: pointer;
            transition: background 0.2s;
        }

        .file-table tr:hover {
            background: var(--bg-tertiary);
        }

        .file-name {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .file-icon {
            width: 32px;
            font-size: 18px;
            text-align: center;
        }

        .file-actions {
            display: flex;
            gap: 6px;
        }

        .action-icon {
            padding: 6px 8px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            color: var(--text-muted);
            background: none;
            border: none;
        }

        .action-icon:hover {
            background: var(--bg-hover);
        }

        .action-icon.edit:hover { color: var(--warning); }
        .action-icon.delete:hover { color: var(--danger); }
        .action-icon.download:hover { color: var(--success); }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(8px);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background: var(--bg-secondary);
            border-radius: 20px;
            width: 90%;
            max-width: 500px;
            border: 1px solid var(--border);
            animation: modalSlideIn 0.3s ease;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        @keyframes modalSlideIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-editor {
            max-width: 1000px;
            width: 90%;
            height: 85vh;
        }

        .modal-editor .modal-content {
            max-width: 1000px;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .close-modal {
            background: none;
            border: none;
            color: var(--text-muted);
            font-size: 24px;
            cursor: pointer;
            transition: color 0.2s;
        }

        .close-modal:hover {
            color: var(--danger);
        }

        .modal-body {
            padding: 24px;
        }

        .modal-body input {
            width: 100%;
            padding: 12px 16px;
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 14px;
        }

        .modal-body input:focus {
            outline: none;
            border-color: var(--accent);
        }

        .upload-area {
            border: 2px dashed var(--border);
            padding: 48px;
            text-align: center;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s;
            background: var(--bg-primary);
        }

        .upload-area:hover {
            border-color: var(--accent);
            background: rgba(99, 102, 241, 0.05);
        }

        .upload-area i {
            font-size: 56px;
            color: var(--accent);
            margin-bottom: 16px;
        }

        .upload-area p {
            margin-bottom: 8px;
        }

        .editor-container {
            flex: 1;
            overflow: hidden;
        }

        .editor-actions {
            padding: 16px 24px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        /* Toast Notification */
        .toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: var(--bg-secondary);
            padding: 14px 24px;
            border-radius: 12px;
            border-left: 3px solid var(--success);
            transform: translateX(400px);
            transition: transform 0.3s ease;
            z-index: 1100;
            font-size: 14px;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        .toast.show {
            transform: translateX(0);
        }

        .toast.error {
            border-left-color: var(--danger);
        }

        /* Loading */
        .loading-state {
            text-align: center;
            padding: 60px;
            color: var(--text-muted);
        }

        .loading-state i {
            font-size: 40px;
            margin-bottom: 16px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
            }
            .sidebar .logo-text,
            .sidebar .user-details,
            .sidebar .section-title,
            .sidebar .nav-item span,
            .sidebar .quick-access-item span {
                display: none;
            }
            .sidebar .nav-item {
                justify-content: center;
            }
            .sidebar .quick-access-item {
                justify-content: center;
            }
            .stats-bar {
                flex-wrap: wrap;
                gap: 16px;
            }
            .file-table th:nth-child(3),
            .file-table td:nth-child(3),
            .file-table th:nth-child(4),
            .file-table td:nth-child(4) {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="app">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-folder-open"></i>
                    </div>
                    <div class="logo-text">
                        <h2>FileMaster Pro</h2>
                        <p>Enterprise Edition</p>
                    </div>
                </div>
                <div class="user-info">
                    <div class="user-avatar">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div class="user-details">
                        <div class="name"><?php echo htmlspecialchars($valid_username); ?></div>
                        <div class="role">Administrator</div>
                    </div>
                    <a href="?logout=1" class="logout-btn" title="Logout">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
            
            <div class="nav-menu">
                <div class="section-title">EXPLORER</div>
                <div class="nav-item active" onclick="refreshFiles()">
                    <i class="fas fa-folder-open"></i> <span>File Browser</span>
                </div>
                <div class="nav-item" onclick="showUpload()">
                    <i class="fas fa-cloud-upload-alt"></i> <span>Upload File</span>
                </div>
                <div class="nav-item" onclick="showCreateFolder()">
                    <i class="fas fa-folder-plus"></i> <span>New Folder</span>
                </div>
                
                <div class="section-title">QUICK ACCESS</div>
                <div class="quick-access-item" onclick="navigateTo('/var/www')">
                    <i class="fas fa-globe"></i> <span>/var/www</span>
                </div>
                <div class="quick-access-item" onclick="navigateTo('/home')">
                    <i class="fas fa-home"></i> <span>/home</span>
                </div>
                <div class="quick-access-item" onclick="navigateTo('/opt')">
                    <i class="fas fa-cube"></i> <span>/opt</span>
                </div>
                <div class="quick-access-item" onclick="navigateTo('/etc')">
                    <i class="fas fa-cog"></i> <span>/etc</span>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="top-bar">
                <div class="location-bar">
                    <i class="fas fa-map-marker-alt"></i>
                    <input type="text" id="currentPath" value="<?php echo htmlspecialchars($full_path); ?>" readonly>
                    <?php if ($can_go_up): ?>
                    <button class="btn btn-secondary" onclick="navigateTo('<?php echo dirname($full_path); ?>')">
                        <i class="fas fa-level-up-alt"></i> Up
                    </button>
                    <?php endif; ?>
                </div>
                <button class="btn btn-primary" onclick="refreshFiles()">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
            </div>
            
            <div class="stats-bar">
                <div class="stat"><i class="fas fa-folder"></i> Folders: <span class="stat-value" id="statFolders">0</span></div>
                <div class="stat"><i class="fas fa-file"></i> Files: <span class="stat-value" id="statFiles">0</span></div>
                <div class="stat"><i class="fas fa-lock"></i> Permission: <span class="stat-value" id="statPermission"><?php echo $is_writable ? 'Writable' : 'Read Only'; ?></span></div>
            </div>
            
            <?php if ($success_msg): ?>
            <div class="toast show" style="transform: translateX(0); border-left-color: var(--success);"><?php echo $success_msg; ?></div>
            <script>setTimeout(() => document.querySelector('.toast').classList.remove('show'), 3000);</script>
            <?php endif; ?>
            
            <?php if ($error_msg): ?>
            <div class="toast show error" style="transform: translateX(0); border-left-color: var(--danger);"><?php echo $error_msg; ?></div>
            <script>setTimeout(() => document.querySelector('.toast').classList.remove('show'), 3000);</script>
            <?php endif; ?>
            
            <?php if (!$is_writable): ?>
            <div class="permission-warning">
                <i class="fas fa-exclamation-triangle"></i>
                Warning: Current directory is not writable. Upload and create folder may not work. Run: sudo chmod 755 <?php echo $full_path; ?>
            </div>
            <?php endif; ?>
            
            <div class="file-table-container">
                <table class="file-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Size</th>
                            <th>Modified</th>
                            <th>Permissions</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="fileList">
                        <tr><td colspan="5" class="loading-state"><i class="fas fa-spinner fa-spin"></i><br>Loading files...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Upload Modal -->
    <div id="uploadModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-cloud-upload-alt"></i> Upload File</h3>
                <button class="close-modal" onclick="closeModal('uploadModal')">&times;</button>
            </div>
            <div class="modal-body">
                <form action="index.php?action=upload&path=<?php echo urlencode($requested_path); ?>" method="POST" enctype="multipart/form-data" id="uploadForm">
                    <div class="upload-area" onclick="document.getElementById('uploadFile').click()">
                        <i class="fas fa-cloud-upload-alt"></i>
                        <p><strong>Click or drag file to upload</strong></p>
                        <small style="color: var(--text-muted);">Maximum file size: 50MB</small>
                        <input type="file" name="file" id="uploadFile" style="display:none" onchange="document.getElementById('uploadForm').submit()">
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Create Folder Modal -->
    <div id="folderModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-folder-plus"></i> Create New Folder</h3>
                <button class="close-modal" onclick="closeModal('folderModal')">&times;</button>
            </div>
            <div class="modal-body">
                <form id="createFolderForm">
                    <input type="text" id="folderName" placeholder="Enter folder name" required>
                    <div style="margin-top: 20px; display: flex; gap: 12px;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Create Folder</button>
                        <button type="button" class="btn btn-secondary" onclick="closeModal('folderModal')">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Rename Modal -->
    <div id="renameModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Rename Item</h3>
                <button class="close-modal" onclick="closeModal('renameModal')">&times;</button>
            </div>
            <div class="modal-body">
                <form id="renameForm">
                    <input type="text" id="renameName" placeholder="New name" required>
                    <input type="hidden" id="renameOldPath">
                    <div style="margin-top: 20px; display: flex; gap: 12px;">
                        <button type="submit" class="btn btn-primary" style="flex: 1;">Rename</button>
                        <button type="button" class="btn btn-secondary" onclick="closeModal('renameModal')">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Modal -->
    <div id="editModal" class="modal modal-editor">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-code"></i> Edit File: <span id="editFileName"></span></h3>
                <button class="close-modal" onclick="closeEditModal()">&times;</button>
            </div>
            <div class="editor-container">
                <textarea id="editor" style="width:100%; height:100%; font-family: monospace;"></textarea>
            </div>
            <div class="editor-actions">
                <button class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
                <button class="btn btn-primary" onclick="saveFile()"><i class="fas fa-save"></i> Save Changes (Ctrl+S)</button>
            </div>
        </div>
    </div>
    
    <div id="toast" class="toast"></div>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/htmlmixed/htmlmixed.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/javascript/javascript.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/css/css.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/php/php.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/python/python.min.js"></script>
    <script>
    let currentPath = '<?php echo $full_path; ?>';
    let editor = null;
    let currentEditFile = null;
    
    document.addEventListener('DOMContentLoaded', () => {
        loadFiles();
        
        document.getElementById('createFolderForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const folderName = document.getElementById('folderName').value.trim();
            
            if (!folderName) {
                showToast('Please enter folder name', 'error');
                return;
            }
            
            const formData = new FormData();
            formData.append('folder_name', folderName);
            
            try {
                const response = await fetch(`index.php?action=create_folder&path=${encodeURIComponent(currentPath)}`, {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                if (result.success) {
                    closeModal('folderModal');
                    loadFiles();
                    showToast(result.message || 'Folder created successfully');
                    document.getElementById('folderName').value = '';
                } else {
                    showToast(result.message || 'Failed to create folder', 'error');
                }
            } catch (error) {
                showToast('Error creating folder', 'error');
            }
        });
        
        document.getElementById('renameForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const newName = document.getElementById('renameName').value.trim();
            const oldPath = document.getElementById('renameOldPath').value;
            
            if (!newName) {
                showToast('Please enter new name', 'error');
                return;
            }
            
            const formData = new FormData();
            formData.append('old_name', oldPath);
            formData.append('new_name', newName);
            
            try {
                const response = await fetch('index.php?action=rename', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                if (result.success) {
                    closeModal('renameModal');
                    loadFiles();
                    showToast(result.message || 'Renamed successfully');
                } else {
                    showToast(result.message || 'Failed to rename', 'error');
                }
            } catch (error) {
                showToast('Error renaming', 'error');
            }
        });
        
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                e.preventDefault();
                if (currentEditFile) saveFile();
            }
        });
    });
    
    async function loadFiles() {
        try {
            const response = await fetch(`index.php?action=get_files&path=${encodeURIComponent(currentPath)}`);
            const data = await response.json();
            
            document.getElementById('currentPath').value = currentPath;
            document.getElementById('statFolders').textContent = data.dirs.length;
            document.getElementById('statFiles').textContent = data.files.length;
            
            const fileList = document.getElementById('fileList');
            
            if (data.dirs.length === 0 && data.files.length === 0) {
                fileList.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 60px; color: var(--text-muted);"><i class="fas fa-folder-open"></i><br>Empty directory</td></tr>';
                return;
            }
            
            let html = '';
            
            data.dirs.forEach(dir => {
                html += `
                    <tr ondblclick="navigateTo('${escapeHtml(dir.path)}')">
                        <td><div class="file-name"><div class="file-icon"><i class="fas fa-folder" style="color: var(--accent);"></i></div><span>${escapeHtml(dir.name)}</span></div></td>
                        <td style="color: var(--text-muted);">Folder</td>
                        <td style="color: var(--text-muted); font-size: 12px;">${escapeHtml(dir.modified)}</td>
                        <td style="color: var(--text-muted); font-family: monospace; font-size: 11px;">${dir.permission}</td>
                        <td><div class="file-actions">
                            <button class="action-icon edit" onclick="event.stopPropagation(); showRename('${escapeHtml(dir.path)}', '${escapeHtml(dir.name)}')" title="Rename"><i class="fas fa-edit"></i></button>
                            <button class="action-icon delete" onclick="event.stopPropagation(); deleteItem('${escapeHtml(dir.path)}')" title="Delete"><i class="fas fa-trash"></i></button>
                        </div></td>
                    </tr>
                `;
            });
            
            data.files.forEach(file => {
                const icon = getFileIcon(file.ext);
                html += `
                    <tr ondblclick="editFile('${escapeHtml(file.path)}')">
                        <td><div class="file-name"><div class="file-icon">${icon}</div><span>${escapeHtml(file.name)}</span></div></td>
                        <td style="color: var(--text-muted);">${file.size_formatted}</td>
                        <td style="color: var(--text-muted); font-size: 12px;">${escapeHtml(file.modified)}</td>
                        <td style="color: var(--text-muted); font-family: monospace; font-size: 11px;">${file.permission}</td>
                        <td><div class="file-actions">
                            ${isEditable(file.ext) ? `<button class="action-icon edit" onclick="event.stopPropagation(); editFile('${escapeHtml(file.path)}')" title="Edit"><i class="fas fa-code"></i></button>` : ''}
                            <button class="action-icon" onclick="event.stopPropagation(); showRename('${escapeHtml(file.path)}', '${escapeHtml(file.name)}')" title="Rename"><i class="fas fa-edit"></i></button>
                            <button class="action-icon download" onclick="event.stopPropagation(); downloadFile('${escapeHtml(file.path)}')" title="Download"><i class="fas fa-download"></i></button>
                            <button class="action-icon delete" onclick="event.stopPropagation(); deleteItem('${escapeHtml(file.path)}')" title="Delete"><i class="fas fa-trash"></i></button>
                        </div></td>
                    </tr>
                `;
            });
            
            fileList.innerHTML = html;
        } catch (error) {
            showToast('Error loading files', 'error');
        }
    }
    
    function navigateTo(path) {
        currentPath = path;
        window.history.pushState({}, '', `index.php?path=${encodeURIComponent(path)}`);
        loadFiles();
    }
    
    function refreshFiles() {
        loadFiles();
        showToast('Refreshed');
    }
    
    async function editFile(filePath) {
        currentEditFile = filePath;
        try {
            const response = await fetch(`index.php?action=get_content&file=${encodeURIComponent(filePath)}`);
            const data = await response.json();
            
            if (data.success) {
                document.getElementById('editFileName').innerText = data.filename;
                document.getElementById('editModal').style.display = 'flex';
                
                setTimeout(() => {
                    if (!editor) {
                        editor = CodeMirror.fromTextArea(document.getElementById('editor'), {
                            lineNumbers: true,
                            theme: 'material-darker',
                            mode: 'text/plain',
                            autoCloseBrackets: true,
                            matchBrackets: true,
                            styleActiveLine: true,
                            tabSize: 4,
                            lineWrapping: true,
                            indentUnit: 4,
                            gutters: ["CodeMirror-linenumbers"]
                        });
                    }
                    editor.setValue(data.content);
                    editor.focus();
                }, 100);
            } else {
                showToast('Cannot read file', 'error');
            }
        } catch (error) {
            showToast('Error loading file', 'error');
        }
    }
    
    async function saveFile() {
        if (!currentEditFile || !editor) return;
        
        const formData = new FormData();
        formData.append('file', currentEditFile);
        formData.append('content', editor.getValue());
        
        try {
            const response = await fetch('index.php?action=save_content', {
                method: 'POST',
                body: formData
            });
            
            const result = await response.json();
            if (result.success) {
                showToast('File saved successfully');
                closeEditModal();
            } else {
                showToast('Failed to save file', 'error');
            }
        } catch (error) {
            showToast('Error saving file', 'error');
        }
    }
    
    async function deleteItem(itemPath) {
        if (confirm('Are you sure you want to delete this item? This action cannot be undone.')) {
            try {
                const response = await fetch(`index.php?action=delete&item=${encodeURIComponent(itemPath)}`);
                const result = await response.json();
                
                if (result.success) {
                    loadFiles();
                    showToast('Deleted successfully');
                } else {
                    showToast('Failed to delete', 'error');
                }
            } catch (error) {
                showToast('Error deleting item', 'error');
            }
        }
    }
    
    function showRename(itemPath, currentName) {
        document.getElementById('renameOldPath').value = itemPath;
        document.getElementById('renameName').value = currentName;
        document.getElementById('renameModal').style.display = 'flex';
    }
    
    function downloadFile(filePath) {
        window.open(filePath, '_blank');
    }
    
    function showUpload() {
        document.getElementById('uploadModal').style.display = 'flex';
    }
    
    function showCreateFolder() {
        document.getElementById('folderModal').style.display = 'flex';
    }
    
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }
    
    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
        currentEditFile = null;
    }
    
    function showToast(message, type = 'success') {
        const toast = document.getElementById('toast');
        toast.textContent = message;
        toast.className = 'toast';
        if (type === 'error') toast.classList.add('error');
        toast.classList.add('show');
        
        setTimeout(() => {
            toast.classList.remove('show');
        }, 3000);
    }
    
    function getFileIcon(ext) {
        const icons = {
            'jpg': '<i class="fas fa-image" style="color: #f59e0b;"></i>',
            'jpeg': '<i class="fas fa-image" style="color: #f59e0b;"></i>',
            'png': '<i class="fas fa-image" style="color: #f59e0b;"></i>',
            'gif': '<i class="fas fa-image" style="color: #f59e0b;"></i>',
            'pdf': '<i class="fas fa-file-pdf" style="color: #ef4444;"></i>',
            'php': '<i class="fab fa-php" style="color: #6366f1;"></i>',
            'html': '<i class="fab fa-html5" style="color: #f97316;"></i>',
            'css': '<i class="fab fa-css3-alt" style="color: #3b82f6;"></i>',
            'js': '<i class="fab fa-js" style="color: #eab308;"></i>',
            'json': '<i class="fas fa-brackets-curly" style="color: #10b981;"></i>',
            'txt': '<i class="fas fa-file-alt" style="color: #64748b;"></i>',
            'zip': '<i class="fas fa-file-archive" style="color: #8b5cf6;"></i>',
            'md': '<i class="fas fa-markdown" style="color: #06b6d4;"></i>',
            'py': '<i class="fab fa-python" style="color: #3b82f6;"></i>',
            'sql': '<i class="fas fa-database" style="color: #f59e0b;"></i>'
        };
        return icons[ext] || '<i class="fas fa-file" style="color: #64748b;"></i>';
    }
    
    function isEditable(ext) {
        const editable = ['txt', 'php', 'html', 'css', 'js', 'json', 'md', 'xml', 'sql', 'py', 'sh'];
        return editable.includes(ext);
    }
    
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    window.onclick = function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    }
    </script>
</body>
</html>