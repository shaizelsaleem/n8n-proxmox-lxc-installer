# ComfyUI Workflow Configuration for News Bulletin Generator

This directory contains the ComfyUI workflow configuration and custom nodes needed for video generation in the news bulletin workflow.

## Required ComfyUI Nodes

Install the following custom nodes for ComfyUI:

### 1. Video Generation Nodes
```bash
# Clone into ComfyUI/custom_nodes directory
cd /home/engine/project/ComfyUI/custom_nodes

# Video generation suite
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# Image processing
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git

# Advanced control
git clone https://github.com/Fannovel16/comfyui_controlnet_aux
```

## Workflow Template

The following JSON represents the ComfyUI workflow used by the n8n workflow:

```json
{
  "3": {
    "inputs": {
      "seed": 42,
      "steps": 20,
      "cfg": 8,
      "sampler_name": "euler",
      "scheduler": "normal",
      "denoise": 1,
      "model": ["4", 0],
      "positive": ["6", 0],
      "negative": ["7", 0],
      "latent_image": ["8", 0]
    },
    "class_type": "KSampler"
  },
  "4": {
    "inputs": {
      "ckpt_name": "sd_xl_base_1.0.safetensors"
    },
    "class_type": "CheckpointLoaderSimple"
  },
  "6": {
    "inputs": {
      "text": "professional news broadcast, high quality, detailed, cinematic lighting",
      "clip": ["4", 1]
    },
    "class_type": "CLIPTextEncode"
  },
  "7": {
    "inputs": {
      "text": "blurry, low quality, distorted, text, watermark",
      "clip": ["4", 1]
    },
    "class_type": "CLIPTextEncode"
  },
  "8": {
    "inputs": {
      "pixels": ["9", 0],
      "vae": ["4", 2]
    },
    "class_type": "VAEEncode"
  },
  "9": {
    "inputs": {
      "image": "anchor_image.png",
      "upload": "image"
    },
    "class_type": "LoadImage"
  },
  "10": {
    "inputs": {
      "samples": ["3", 0],
      "vae": ["4", 2]
    },
    "class_type": "VAEDecode"
  },
  "11": {
    "inputs": {
      "filename_prefix": "news_frame_",
      "images": ["10", 0]
    },
    "class_type": "SaveImage"
  },
  "12": {
    "inputs": {
      "frame_rate": 30,
      "loop_count": 0,
      "images": ["11", 0],
      "duration": 30
    },
    "class_type": "ImagesToVideo"
  }
}
```

## API Integration

The n8n workflow sends requests to ComfyUI's WebSocket API. The workflow expects:

### Input Format
```json
{
  "prompt": {
    "workflow": {
      "nodes": {
        "9": {
          "inputs": {
            "image": "path/to/anchor/image.jpg"
          }
        },
        "12": {
          "inputs": {
            "duration": 30,
            "frame_rate": 30
          }
        }
      }
    }
  }
}
```

### Output Format
ComfyUI returns:
```json
{
  "prompt_id": "unique_id",
  "number": 1,
  "node_errors": {}
}
```

## Configuration Options

### Video Generation Parameters
- **Duration**: 30 seconds (configurable)
- **Frame Rate**: 30 FPS
- **Resolution**: Matches input image
- **Quality**: High (SDXL base model)

### Model Requirements
- **Base Model**: SDXL (sd_xl_base_1.0.safetensors)
- **VAE**: Included with SDXL
- **Scheduler**: Normal
- **Sampler**: Euler

## Troubleshooting

### Common Issues
1. **Missing Models**: Download required SDXL models
2. **Node Errors**: Install missing custom nodes
3. **Memory Issues**: Reduce batch size or resolution
4. **API Connection**: Ensure ComfyUI is running on port 8188

### Performance Optimization
- Use GPU acceleration if available
- Optimize image sizes before processing
- Cache frequently used models
- Adjust batch sizes based on system resources

## Customization

### Adding Effects
Modify the workflow to include:
- Motion blur
- Transitions
- Text overlays
- Background music integration

### Quality Settings
Adjust these parameters:
- Sampling steps (20-50)
- CFG scale (7-12)
- Denoising strength (0.7-1.0)
- Resolution settings

## Integration with Audio

The final video assembly uses FFmpeg to combine:
- Generated video from ComfyUI
- Audio from ElevenLabs
- Supporting media files

### FFmpeg Command Template
```bash
ffmpeg -i generated_video.mp4 -i audio.mp3 -i supporting_media.mp4 \
-filter_complex "[0:v][1:a]concat=v=1:a=1[v][a];[v][a]concat=n=1:v=1:a=1[out]" \
-map "[out]" final_bulletin.mp4
```