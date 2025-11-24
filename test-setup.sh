#!/bin/bash

# Test Script for News Bulletin Generator
# This script tests all components of the news bulletin workflow

set -e

echo "🧪 Testing News Bulletin Generator Components..."

# Test 1: Directory Structure
echo "📁 Test 1: Checking directory structure..."
directories=(
    "xml_news_wires"
    "supporting_media"
    "generated_assets"
    "final_bulletins"
)

for dir in "${directories[@]}"; do
    if [ -d "/home/engine/project/$dir" ]; then
        echo "✅ $dir directory exists"
    else
        echo "❌ $dir directory missing"
        exit 1
    fi
done

# Test 2: Sample XML file
echo "📄 Test 2: Checking sample XML file..."
if [ -f "/home/engine/project/xml_news_wires/sample_news.xml" ]; then
    echo "✅ Sample XML file exists"
    # Validate XML structure
    if xmllint --noout "/home/engine/project/xml_news_wires/sample_news.xml" 2>/dev/null; then
        echo "✅ XML file is well-formed"
    else
        echo "❌ XML file is not well-formed"
    fi
else
    echo "❌ Sample XML file missing"
fi

# Test 3: FFmpeg installation
echo "🎥 Test 3: Checking FFmpeg..."
if command -v ffmpeg &> /dev/null; then
    echo "✅ FFmpeg is installed"
    echo "   Version: $(ffmpeg -version | head -1)"
else
    echo "❌ FFmpeg not found"
    echo "   Install with: sudo apt install ffmpeg"
    exit 1
fi

# Test 4: Ollama installation and model
echo "🤖 Test 4: Checking Ollama..."
if command -v ollama &> /dev/null; then
    echo "✅ Ollama is installed"
    
    # Check if Ollama service is running
    if curl -s http://localhost:11434/api/version > /dev/null 2>&1; then
        echo "✅ Ollama service is running"
        
        # Check if Qwen2.5 model is available
        if ollama list | grep -q "qwen2.5"; then
            echo "✅ Qwen2.5 model is available"
        else
            echo "❌ Qwen2.5 model not found"
            echo "   Install with: ollama pull qwen2.5"
        fi
    else
        echo "❌ Ollama service is not running"
        echo "   Start with: ollama serve"
    fi
else
    echo "❌ Ollama not found"
    echo "   Install with: curl -fsSL https://ollama.ai/install.sh | sh"
fi

# Test 5: ComfyUI installation
echo "🎨 Test 5: Checking ComfyUI..."
if [ -d "/home/engine/project/ComfyUI" ]; then
    echo "✅ ComfyUI directory exists"
    
    # Check if ComfyUI service is running
    if curl -s http://localhost:8188 > /dev/null 2>&1; then
        echo "✅ ComfyUI service is running"
    else
        echo "❌ ComfyUI service is not running"
        echo "   Start with: cd ComfyUI && python main.py --listen 0.0.0.0 --port 8188"
    fi
else
    echo "❌ ComfyUI directory not found"
    echo "   Install with: git clone https://github.com/comfyanonymous/ComfyUI.git"
fi

# Test 6: Node.js dependencies
echo "📦 Test 6: Checking Node.js dependencies..."
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    echo "✅ Node.js and npm are installed"
    
    # Check if xml2js is available globally
    if npm list -g xml2js &> /dev/null; then
        echo "✅ xml2js is installed globally"
    else
        echo "❌ xml2js not found globally"
        echo "   Install with: npm install -g xml2js"
    fi
else
    echo "❌ Node.js/npm not found"
    echo "   Install with: sudo apt install nodejs npm"
fi

# Test 7: Environment configuration
echo "⚙️ Test 7: Checking environment configuration..."
if [ -f "/home/engine/project/.env" ]; then
    echo "✅ .env file exists"
    
    # Check for required variables
    required_vars=("ELEVENLABS_API_KEY" "ELEVENLABS_VOICE_ID")
    for var in "${required_vars[@]}"; do
        if grep -q "^$var=" /home/engine/project/.env; then
            value=$(grep "^$var=" /home/engine/project/.env | cut -d'=' -f2)
            if [ "$value" != "your_elevenlabs_api_key_here" ] && [ "$value" != "your_preferred_voice_id_here" ]; then
                echo "✅ $var is configured"
            else
                echo "❌ $var needs to be configured"
            fi
        else
            echo "❌ $var not found in .env"
        fi
    done
else
    echo "❌ .env file not found"
    echo "   Copy .env.template to .env and configure"
fi

# Test 8: Workflow file
echo "🔄 Test 8: Checking workflow file..."
if [ -f "/home/engine/project/news-bulletin-workflow.json" ]; then
    echo "✅ n8n workflow file exists"
    
    # Validate JSON structure
    if python3 -m json.tool "/home/engine/project/news-bulletin-workflow.json" > /dev/null 2>&1; then
        echo "✅ Workflow JSON is valid"
    else
        echo "❌ Workflow JSON is invalid"
    fi
else
    echo "❌ n8n workflow file not found"
fi

# Test 9: Permissions
echo "🔐 Test 9: Checking file permissions..."
scripts=("setup.sh" "start-services.sh" "test-setup.sh")
for script in "${scripts[@]}"; do
    if [ -f "/home/engine/project/$script" ]; then
        if [ -x "/home/engine/project/$script" ]; then
            echo "✅ $script is executable"
        else
            echo "❌ $script is not executable"
            echo "   Fix with: chmod +x $script"
        fi
    fi
done

# Test 10: System resources
echo "💾 Test 10: Checking system resources..."
echo "   Available disk space: $(df -h /home/engine/project | tail -1 | awk '{print $4}')"
echo "   Memory usage: $(free -h | grep Mem | awk '{print $3"/"$2}')"
echo "   CPU cores: $(nproc)"

# Performance test
echo "⚡ Test 11: Performance test..."
if command -v ollama &> /dev/null && curl -s http://localhost:11434/api/version > /dev/null 2>&1; then
    echo "   Testing Ollama response time..."
    start_time=$(date +%s.%N)
    response=$(curl -s http://localhost:11434/api/generate -X POST -d '{"model":"qwen2.5","prompt":"Test","stream":false}' 2>/dev/null)
    end_time=$(date +%s.%N)
    elapsed=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "N/A")
    echo "   Response time: ${elapsed}s"
    
    if [ -n "$response" ]; then
        echo "✅ Ollama API responding correctly"
    else
        echo "❌ Ollama API not responding correctly"
    fi
fi

echo ""
echo "🧪 Test Summary:"
echo "   Run this script after setup to verify all components"
echo "   Fix any failed tests before using the workflow"
echo ""
echo "🎬 Ready for news bulletin generation!"