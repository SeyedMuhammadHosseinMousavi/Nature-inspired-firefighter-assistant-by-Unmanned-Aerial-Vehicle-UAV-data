# Nature inspired firefighter assistant by Unmanned Aerial Vehicle (UAV) data

### Link to the paper:
- https://m.growingscience.com/beta/jfs/5885-nature-inspired-firefighter-assistant-by-unmanned-aerial-vehicle-uav-data.html
- DOI: http://dx.doi.org/10.5267/j.jfs.2023.1.004
### Please cite:
- Mousavi, S., and A. Ilanloo. "Nature inspired firefighter assistant by unmanned aerial vehicle (UAV) data." Journal of Future Sustainability 3.3 (2023): 143-166.



## Overview

Wildfires are a significant threat to forests, wildlife, and human safety. This research leverages **Unmanned Aerial Vehicles (UAVs)** equipped with color, thermal, and infrared cameras, along with nature-inspired algorithms, to detect and analyze wildfires efficiently.

### Highlights:
- **Fire Detection**: Uses image segmentation and classification on color and thermal datasets.
- **Smoke Analysis**: Proposes a workflow for smoke detection using multi-color space techniques.
- **Nature-Inspired Algorithms**: Implements Chicken Swarm Algorithm (CSA), Bees Algorithm (BA), and Biogeography-Based Optimization (BBO) for enhanced accuracy.

---

## Features

### 1. **Fire Segmentation**
- **Techniques Used**:
  - **CSA Intensity Adjustment**: Enhances image contrast.
  - **DnCNN Denoising**: Removes unwanted noise for clearer segmentation.
  - **Bees Algorithm**: Performs robust and fast image segmentation.
- **Performance Metrics**:
  - FLAME Dataset: **Precision**: 95.57%
  - DeepFire Dataset: **Precision**: 91.74%

### 2. **Fire Classification**
- **Process**:
  - Uses Local Phase Quantization (LPQ) for frequency-based feature extraction.
  - Selects features via Biogeography-Based Optimization (BBO).
  - Classifies fire/no-fire images using Artificial Neural Networks (ANN) optimized with Firefly Algorithm (FA).
- **Performance Metrics**:
  - FLAME Dataset: **Accuracy**: 91.33%
  - DeepFire Dataset: **Accuracy**: 96.88%

### 3. **Smoke Detection**
- Separates and enhances RGB channels using Histogram Equalization and Median Filtering.
- Converts images into HSV, Lab, and YCbCr color spaces for multi-channel analysis.
- Identifies smoke using morphology operations on combined channels.

---

## Methodology

### Datasets
- **FLAME (2021)**: Includes color and thermal images of wildfires.
- **DeepFire (2022)**: Latest dataset for UAV-based fire detection.

### Algorithms
- **Chicken Swarm Algorithm (CSA)**:
  - Improves image contrast in dense environments.
- **Bees Algorithm (BA)**:
  - Combines global and local searches for precise segmentation.
- **DnCNN**:
  - Denoises images using a deep convolutional neural network.
- **Firefly Algorithm (FA)**:
  - Optimizes ANN for better classification accuracy.
- **Biogeography-Based Optimization (BBO)**:
  - Selects impactful features for classification.

---

## Results

| Metric          | FLAME (Color) | DeepFire (Thermal) |
|------------------|---------------|--------------------|
| Segmentation Precision | 95.57%        | 91.74%             |
| Classification Accuracy | 91.33%        | 96.88%             |


![bbo fa](https://github.com/user-attachments/assets/dddabdb8-30b7-4db1-8658-ccdf38e90417)
![class](https://github.com/user-attachments/assets/8e7b21c9-f6c9-4ef8-9137-7e119018bc4c)
![classification (2)](https://github.com/user-attachments/assets/1838fc02-8071-4b4f-92dc-0df7c7c3d7a4)
![cso bees](https://github.com/user-attachments/assets/03b987f2-3028-4e8e-8346-fad0a3ec1a75)
![fire segmentation](https://github.com/user-attachments/assets/2530ab03-0ce1-4ef2-9d9d-0f1685a6efb3)
![flowc](https://github.com/user-attachments/assets/ccc69728-dc4e-4e2f-b6ce-d2efe13f4737)
![smoke](https://github.com/user-attachments/assets/4368f2d3-9066-4486-ad2f-cf33bd6fd4fc)
![thermal he](https://github.com/user-attachments/assets/15b141de-0ea6-464c-9cfe-a221c4d5f826)
![thermal bees](https://github.com/user-attachments/assets/8f06d475-17ae-4426-bcf7-2d0a7eb71128)
![smoke gt](https://github.com/user-attachments/assets/97d8c1c1-59b6-448b-a641-6d2e28074188)
![smoke fig](https://github.com/user-attachments/assets/41eb0410-b5c9-4daf-9c75-e30a87ec94b4)
![seg](https://github.com/user-attachments/assets/9b1b777e-60ed-4d7e-9f88-36025eadc82b)
![regression](https://github.com/user-attachments/assets/2a8bb2e3-dcae-4b4b-8da6-15b4ed793cb1)
![noise](https://github.com/user-attachments/assets/264afb93-568e-4c61-b176-4a1b8c3066fe)
![he color](https://github.com/user-attachments/assets/357d47c0-dfe4-4714-8aab-9e83a919cc55)
![gtco](https://github.com/user-attachments/assets/3251e072-14fb-4f6f-9be0-a2b5b402d2c7)
![greenconf](https://github.com/user-attachments/assets/e0f9a783-5af2-43e3-8336-b1df31585a08)
![green gt](https://github.com/user-attachments/assets/f989309f-44ac-4c38-94cd-918d23f0855e)
![fig 2](https://github.com/user-attachments/assets/3771e9ed-6790-4b78-87d3-8f7254091777)
![fig 1](https://github.com/user-attachments/assets/22a08b97-c5a6-415b-bd66-f185f912a2f0)
![cso bees test](https://github.com/user-attachments/assets/1fa9377d-1aee-44cb-9fa2-d08af8c3e584)
![compare gt](https://github.com/user-attachments/assets/66961f70-b73c-453a-b3fb-1948b0150bcb)
![color spaces](https://github.com/user-attachments/assets/99de1915-db94-4d97-9b92-79a3b718bb04)
