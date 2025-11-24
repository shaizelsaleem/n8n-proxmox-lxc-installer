# Automated News Bulletin Generator - n8n Workflow

This n8n workflow automates the creation of short news bulletins by fetching XML news feeds, parsing them, finding supporting media, generating AI scripts, creating audio, and assembling everything into a final video bulletin.

## Workflow Overview

The workflow consists of the following main stages:

1. **Scheduled Trigger** - Runs every 30 minutes (configurable)
2. **XML News Fetching** - Finds and reads recent XML news files
3. **XML Parsing** - Extracts news items from XML structure
4. **Media Discovery** - Finds supporting media files for each news item
5. **AI Script Generation** - Uses Ollama Qwen2.5 to create news scripts
6. **Audio Generation** - Converts scripts to audio using ElevenLabs
7. **Video Generation** - Creates video from images using ComfyUI
8. **Final Assembly** - Combines all assets into final news bulletin

## Prerequisites

### Required Services

1. **n8n** - Workflow automation platform
2. **Ollama** - Local AI service with Qwen2.5 model
3. **ComfyUI** - Local image/video generation service
4. **ElevenLabs API** - Text-to-speech service
5. **FFmpeg** - Media processing tool

### Directory Structure

Create the following directory structure:

```
/home/engine/project/
├── xml_news_wires/          # Place XML news files here
├── supporting_media/        # Place supporting media files here
├── generated_assets/         # Auto-generated intermediate files
├── final_bulletins/         # Final output videos
└── news-bulletin-workflow.json
```

### Environment Variables

Set these variables in n8n:

```bash
ELEVENLABS_API_KEY=your_elevenlabs_api_key
ELEVENLABS_VOICE_ID=your_preferred_voice_id
```

## Installation and Setup

### 1. Install Required Dependencies

```bash
# Install FFmpeg
sudo apt update && sudo apt install -y ffmpeg

# Install xml2js for n8n (if not already installed)
npm install -g xml2js
```

### 2. Setup Ollama

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull Qwen2.5 model
ollama pull qwen2.5

# Start Ollama service
ollama serve
```

### 3. Setup ComfyUI

```bash
# Clone and setup ComfyUI (if not already done)
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt

# Start ComfyUI server
python main.py --listen 0.0.0.0 --port 8188
```

### 4. Import Workflow

1. Open n8n web interface
2. Click "Import from file"
3. Select `news-bulletin-workflow.json`
4. Configure credentials for ElevenLabs API

## Configuration

### XML News Format

The workflow expects XML files in one of these formats:

**RSS Format:**
```xml
<rss>
  <channel>
    <item>
      <title>News Title</title>
      <description>News Description</description>
      <pubDate>2024-01-01</pubDate>
      <category>Technology</category>
    </item>
  </channel>
</rss>
```

**News Format:**
```xml
<news>
  <item>
    <title>News Title</title>
    <description>News Description</description>
    <published>2024-01-01</published>
    <category>Technology</category>
  </item>
</news>
```

### Media File Naming

Supporting media files should be named with relevant keywords. The workflow searches for files containing:
- News title keywords (first 3 words)
- News category
- Common media extensions (.jpg, .jpeg, .png, .gif, .mp4, .mov)

### Customization Options

1. **Schedule Interval**: Modify the trigger node to change execution frequency
2. **Script Style**: Adjust the Ollama prompt for different script styles
3. **Audio Voice**: Change the ElevenLabs voice ID
4. **Video Duration**: Modify ComfyUI parameters for different video lengths
5. **Output Quality**: Adjust FFmpeg parameters for different quality settings

## Usage

1. Place XML news files in the `xml_news_wires/` directory
2. Add supporting media files to the `supporting_media/` directory
3. Ensure all services are running (Ollama, ComfyUI)
4. Activate the workflow in n8n
5. Monitor execution and check `final_bulletins/` for output

## Output

The workflow generates:
- **Final News Bulletin**: MP4 video file in `final_bulletins/` directory
- **Intermediate Assets**: Audio files, video segments in `generated_assets/`
- **Execution Logs**: n8n execution history

## Troubleshooting

### Common Issues

1. **XML Parsing Errors**: Check XML file format and structure
2. **Media Not Found**: Verify media file naming and directory structure
3. **Ollama Connection**: Ensure Ollama service is running on port 11434
4. **ComfyUI Connection**: Ensure ComfyUI is running on port 8188
5. **FFmpeg Errors**: Install FFmpeg and verify installation

### Debug Mode

Enable debug output by adding log statements in the Code nodes or use n8n's built-in debugging features.

## Performance Optimization

- Limit the number of concurrent news items processed
- Optimize media file sizes for faster processing
- Cache frequently used media files
- Adjust workflow execution based on system resources

## Security Considerations

- Secure ElevenLabs API keys
- Validate XML input to prevent injection attacks
- Limit file access permissions
- Monitor resource usage

## Extension Ideas

1. **Multi-language Support**: Add translation services
2. **Social Media Integration**: Auto-post to social platforms
3. **Template System**: Multiple bulletin formats
4. **Quality Control**: Add manual approval steps
5. **Analytics**: Track bulletin performance metrics

## Support

For issues with:
- **n8n Workflow**: Check n8n documentation
- **Ollama**: Refer to Ollama documentation
- **ComfyUI**: Check ComfyUI community resources
- **ElevenLabs**: Review ElevenLabs API documentation