# Supporting Media Directory

This directory contains media files that support the news bulletin generation. The workflow automatically searches for relevant media files based on news content.

## Directory Structure

Organize your media files by category for better matching:

```
supporting_media/
├── technology/
│   ├── tech_background.jpg
│   ├── computer_screen.png
│   └── server_room.mp4
├── politics/
│   ├── government_building.jpg
│   ├── press_conference.mp4
│   └── flag_animation.png
├── sports/
│   ├── stadium.jpg
│   ├── athletes.mp4
│   └── trophy.png
├── business/
│   ├── office.jpg
│   ├── stock_chart.png
│   └── meeting_room.mp4
├── community/
│   ├── city_hall.jpg
│   ├── event_crowd.mp4
│   └── local_scene.png
└── generic/
    ├── news_background.jpg
    ├── transition.mp4
    └── logo.png
```

## File Naming Guidelines

### 1. Category-Based Naming
- `technology_innovation.jpg`
- `politics_election.mp4`
- `sports_championship.png`
- `business_market.jpg`

### 2. Keyword-Based Naming
- `ai_robot.jpg`
- `stock_market_chart.png`
- `football_stadium.mp4`
- `city_skyline.jpg`

### 3. Descriptive Naming
- `breaking_news_background.jpg`
- `weather_map_animation.mp4`
- `interview_setup.jpg`
- `crowd_celebration.mp4`

## Supported File Formats

### Images
- **JPEG/JPG**: Best for photographs
- **PNG**: Best for graphics with transparency
- **GIF**: For simple animations
- **WEBP**: Modern format with good compression

### Videos
- **MP4**: Preferred format (H.264 codec)
- **MOV**: QuickTime format
- **AVI**: Legacy format
- **WEBM**: Web-optimized format

### Audio
- **MP3**: Compressed audio
- **WAV**: Uncompressed audio
- **AAC**: High-quality compressed audio

## Media Selection Logic

The workflow uses the following priority to select media:

1. **Exact Title Match**: Files containing news title keywords
2. **Category Match**: Files in category-specific folders
3. **Keyword Match**: Files containing relevant keywords
4. **Generic Fallback**: Default news background files

## Best Practices

### Image Guidelines
- **Resolution**: Minimum 1920x1080 for HD output
- **Aspect Ratio**: 16:9 for landscape, 9:16 for vertical
- **File Size**: Keep under 5MB for faster processing
- **Quality**: High quality, no compression artifacts

### Video Guidelines
- **Duration**: 10-60 seconds for supporting clips
- **Resolution**: 1920x1080 (1080p) or 1280x720 (720p)
- **Frame Rate**: 30 FPS for smooth playback
- **Format**: MP4 with H.264 codec

### Audio Guidelines
- **Quality**: 44.1kHz sample rate
- **Bitrate**: 128-320 kbps
- **Format**: MP3 or AAC
- **Volume**: Normalized to -6dB

## Anchor Images

The first image found is used as the anchor for ComfyUI video generation. Ensure you have high-quality anchor images:

- **Technology**: `tech_anchor.jpg`, `ai_anchor.png`
- **Politics**: `government_anchor.jpg`, `debate_anchor.png`
- **Sports**: `sports_anchor.jpg`, `victory_anchor.png`
- **Business**: `business_anchor.jpg`, `market_anchor.png`

## Sample Media Files

Create sample media files for testing:

```bash
# Create test directories
mkdir -p supporting_media/{technology,politics,sports,business,community,generic}

# Download sample images (replace with actual URLs)
wget -O supporting_media/technology/tech_background.jpg "https://example.com/tech-bg.jpg"
wget -O supporting_media/politics/government_building.jpg "https://example.com/gov-building.jpg"
wget -O supporting_media/sports/stadium.jpg "https://example.com/stadium.jpg"

# Or create placeholder files
touch supporting_media/technology/anchor_tech.jpg
touch supporting_media/politics/anchor_politics.jpg
touch supporting_media/sports/anchor_sports.jpg
touch supporting_media/generic/news_background.jpg
```

## Media Optimization

### Image Optimization
```bash
# Optimize JPEG images
ffmpeg -i input.jpg -vf scale=1920:1080 -quality good -compression_level 6 output.jpg

# Optimize PNG images
pngquant --quality=65-80 --output=output.png input.png
```

### Video Optimization
```bash
# Optimize MP4 videos
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k output.mp4
```

## License and Usage

Ensure all media files have appropriate licenses for:
- **Commercial Use**: If bulletins will be distributed commercially
- **Modification**: If files will be processed/modified
- **Attribution**: If credit is required

Recommended sources:
- **Free**: Unsplash, Pexels, Pixabay
- **Premium**: Getty Images, Shutterstock, Adobe Stock
- **Custom**: Original photography/videography