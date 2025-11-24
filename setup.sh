#!/bin/bash

# Automated News Bulletin Generator - Setup Script
# This script sets up the environment and dependencies for the news bulletin workflow

set -e

echo "🎬 Setting up Automated News Bulletin Generator..."

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p /home/engine/project/{xml_news_wires,supporting_media,generated_assets,final_bulletins}

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y ffmpeg curl wget git python3 python3-pip nodejs npm

# Install Node.js dependencies for n8n
echo "📦 Installing Node.js dependencies..."
npm install -g xml2js

# Setup Ollama
echo "🤖 Setting up Ollama..."
if ! command -v ollama &> /dev/null; then
    echo "Installing Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
else
    echo "Ollama already installed"
fi

# Pull Qwen2.5 model
echo "🧠 Pulling Qwen2.5 model..."
if command -v ollama &> /dev/null; then
    ollama pull qwen2.5 || echo "Failed to pull Qwen2.5 model. Please ensure Ollama is running."
else
    echo "Ollama not found. Please install Ollama first."
fi

# Setup ComfyUI
echo "🎨 Setting up ComfyUI..."
if [ ! -d "/home/engine/project/ComfyUI" ]; then
    echo "Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git /home/engine/project/ComfyUI
    cd /home/engine/project/ComfyUI
    pip3 install -r requirements.txt
    echo "ComfyUI installed successfully"
else
    echo "ComfyUI already exists"
fi

# Create sample configuration files
echo "📝 Creating sample configuration files..."

# Create environment variables template
cat > /home/engine/project/.env.template << 'EOF'
# ElevenLabs Configuration
ELEVENLABS_API_KEY=your_elevenlabs_api_key_here
ELEVENLABS_VOICE_ID=your_preferred_voice_id_here

# Service URLs
OLLAMA_URL=http://localhost:11434
COMFYUI_URL=http://localhost:8188

# Directory Paths
XML_NEWS_WIRES_PATH=/home/engine/project/xml_news_wires
SUPPORTING_MEDIA_PATH=/home/engine/project/supporting_media
GENERATED_ASSETS_PATH=/home/engine/project/generated_assets
FINAL_BULLETINS_PATH=/home/engine/project/final_bulletins
EOF

# Create sample XML news file
cat > /home/engine/project/xml_news_wires/sample_news.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>Sample News Feed</title>
    <description>Sample news for testing</description>
    <item>
      <title>Breaking: Technology Advances in AI</title>
      <description>Latest developments in artificial intelligence show promising results for automation and machine learning applications.</description>
      <pubDate>2024-11-24T10:00:00Z</pubDate>
      <category>Technology</category>
    </item>
    <item>
      <title>Local Community Event Successful</title>
      <description>The annual community festival brought together thousands of residents for a celebration of local culture and achievements.</description>
      <pubDate>2024-11-24T09:30:00Z</pubDate>
      <category>Community</category>
    </item>
  </channel>
</rss>
EOF

# Create systemd service files for automatic startup
echo "🔧 Creating systemd service files..."

# Ollama service
cat > /tmp/ollama.service << 'EOF'
[Unit]
Description=Ollama Service
After=network.target

[Service]
Type=simple
User=engine
ExecStart=/usr/local/bin/ollama serve
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# ComfyUI service
cat > /tmp/comfyui.service << 'EOF'
[Unit]
Description=ComfyUI Service
After=network.target

[Service]
Type=simple
User=engine
WorkingDirectory=/home/engine/project/ComfyUI
ExecStart=/usr/bin/python3 main.py --listen 0.0.0.0 --port 8188
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Move service files
sudo mv /tmp/ollama.service /etc/systemd/system/
sudo mv /tmp/comfyui.service /etc/systemd/system/

# Create startup script
cat > /home/engine/project/start-services.sh << 'EOF'
#!/bin/bash

echo "🚀 Starting News Bulletin Generator Services..."

# Start Ollama
echo "🤖 Starting Ollama..."
sudo systemctl start ollama
sudo systemctl enable ollama

# Start ComfyUI
echo "🎨 Starting ComfyUI..."
sudo systemctl start comfyui
sudo systemctl enable comfyui

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if services are running
if curl -s http://localhost:11434/api/version > /dev/null; then
    echo "✅ Ollama is running"
else
    echo "❌ Ollama failed to start"
fi

if curl -s http://localhost:8188 > /dev/null; then
    echo "✅ ComfyUI is running"
else
    echo "❌ ComfyUI failed to start"
fi

echo "🎬 Services startup complete!"
echo "You can now import the workflow into n8n and start generating news bulletins."
EOF

chmod +x /home/engine/project/start-services.sh

# Create test script
cat > /home/engine/project/test-setup.sh << 'EOF'
#!/bin/bash

echo "🧪 Testing News Bulletin Generator Setup..."

# Test directories
echo "📁 Testing directories..."
[ -d "/home/engine/project/xml_news_wires" ] && echo "✅ xml_news_wires directory exists" || echo "❌ xml_news_wires directory missing"
[ -d "/home/engine/project/supporting_media" ] && echo "✅ supporting_media directory exists" || echo "❌ supporting_media directory missing"
[ -d "/home/engine/project/generated_assets" ] && echo "✅ generated_assets directory exists" || echo "❌ generated_assets directory missing"
[ -d "/home/engine/project/final_bulletins" ] && echo "✅ final_bulletins directory exists" || echo "❌ final_bulletins directory missing"

# Test FFmpeg
echo "🎥 Testing FFmpeg..."
if command -v ffmpeg &> /dev/null; then
    echo "✅ FFmpeg is installed"
    ffmpeg -version | head -1
else
    echo "❌ FFmpeg not found"
fi

# Test Ollama
echo "🤖 Testing Ollama..."
if command -v ollama &> /dev/null; then
    echo "✅ Ollama is installed"
    if ollama list | grep -q qwen2.5; then
        echo "✅ Qwen2.5 model is available"
    else
        echo "❌ Qwen2.5 model not found. Run: ollama pull qwen2.5"
    fi
else
    echo "❌ Ollama not found"
fi

# Test ComfyUI
echo "🎨 Testing ComfyUI..."
if [ -d "/home/engine/project/ComfyUI" ]; then
    echo "✅ ComfyUI directory exists"
else
    echo "❌ ComfyUI directory not found"
fi

echo "🧪 Setup test complete!"
EOF

chmod +x /home/engine/project/test-setup.sh

echo "✅ Setup completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Copy .env.template to .env and configure your API keys"
echo "2. Run: ./start-services.sh to start the services"
echo "3. Run: ./test-setup.sh to verify the setup"
echo "4. Import news-bulletin-workflow.json into n8n"
echo "5. Place your XML news files in xml_news_wires/"
echo "6. Add supporting media files to supporting_media/"
echo ""
echo "🎬 Your automated news bulletin generator is ready!"