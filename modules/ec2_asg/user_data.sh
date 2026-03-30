#!/bin/bash
set -e

# Update system
yum update -y

# Install Nginx
yum install -y nginx

# Start Nginx service
systemctl start nginx
systemctl enable nginx

#!/bin/bash
set -e

# Update system
yum update -y

# Install Nginx
yum install -y nginx

# Start Nginx service
systemctl start nginx
systemctl enable nginx

# Wait for Nginx to be fully ready
sleep 10

# Verify Nginx is running
systemctl status nginx || (echo "Nginx failed to start" && exit 1)

# Create TechNova web page
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Web App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }
        h1 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 48px;
        }
        p {
            color: #666;
            font-size: 18px;
            margin-bottom: 20px;
        }
        .info-box {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: left;
            font-family: monospace;
        }
        .info-box p {
            margin: 10px 0;
            font-size: 14px;
        }
        .footer {
            margin-top: 30px;
            color: #999;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 TechNova Web App</h1>
        <p>Welcome to TechNova's Highly Available Cloud Infrastructure</p>
        
        <div class="info-box">
            <p><strong>Instance Information:</strong></p>
            <p>Project: ${project_name}</p>
            <p>Deployment: AWS Cloud Infrastructure</p>
            <p>Architecture: Multi-AZ with Auto Scaling</p>
            <p>Load Balancer: Application Load Balancer</p>
        </div>
        
        <p>Your application is running reliably in the cloud!</p>
        
        <div class="footer">
            <p>Powered by Terraform | AWS | Nginx</p>
        </div>
    </div>
</body>
</html>
EOF

# Set correct permissions
chown -R nginx:nginx /usr/share/nginx/html
chmod -R 755 /usr/share/nginx/html
