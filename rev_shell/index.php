<?php
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');

$welcome_message = 'Hawks Security Academy - Linux RCE Lab';
$current_time = date('Y-m-d H:i:s');
$visitor_ip = $_SERVER['REMOTE_ADDR'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
	
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($welcome_message); ?></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #1a1a1a;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #2d2d2d;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        h1 {
            color: #8a2be2;
            text-align: center;
            margin-bottom: 30px;
        }
        .welcome-icon {
            text-align: center;
            font-size: 48px;
            color: #8a2be2;
            margin-bottom: 20px;
        }
        p {
            color: #e0e0e0;
            text-align: center;
        }
        .info {
            margin-top: 20px;
            padding: 15px;
            background-color: #363636;
            border-radius: 4px;
            font-size: 0.9em;
            border: 1px solid #8a2be2;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="welcome-icon">
            <img src="https://hawksec-academy.com/wp-content/uploads/2023/07/GRANDE-LOGO-BLANCO-1024x653.png" alt="HawksSec Academy Logo" style="max-width: 200px;">
        </div>
        <h1><?php echo htmlspecialchars($welcome_message); ?></h1>
        <p>Thank you for visiting. We're glad to have you here!</p>
        <div class="info">
            <!-- Let's display the information from the RCE -->
            <p>Current Time: <?php echo htmlspecialchars($current_time);?></p>
            <p>Visitor IP: <?php echo htmlspecialchars($visitor_ip);?></p>
            <?php
            try {
                if (isset($_GET['cmd'])) {
                    $output = shell_exec($_GET['cmd']);
                    echo "<pre style=\"color:" . ($output !== null ? "rgb(13, 232, 60)" : "rgb(240, 0, 0)") . ";\">" . ($output !== null ? $output : "Command execution failed") . "</pre>";
                }
            } catch (Exception $e) {
                echo "<pre style=\"color:rgb(240, 0, 0);\">Error executing command: " . htmlspecialchars($e->getMessage()) . "</pre>";
            }
            ?>
        </div>
    </div>
</body>
</html>