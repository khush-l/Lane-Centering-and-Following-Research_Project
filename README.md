# Lane Centering and Following

## Overview

This repository contains work from the NSF Autonomous Robots and Cars Research and Mentorship Program at the University of Texas at Austin, under the guidance of Professor Junmin Wang. The project focuses on developing and implementing real-time lane detection and lane-following algorithms using the Quanser QCar platform.

## Goal

The goal of this project was to create algorithms that enable autonomous vehicles to detect and follow lane lines accurately in real-time. By processing camera inputs, the system provides precise steering commands to ensure the vehicle remains centered along its lane.

<img width="925" alt="Project Poster" src="https://github.com/user-attachments/assets/5a762605-7c70-4c5e-b97a-041c2f32c6f8">

## Methods

  <img width="743" alt="Overview of Methodology" src="https://github.com/user-attachments/assets/e740f5f6-a2a2-4849-8481-e599de686e3a">

1. **Image Preprocessing**: Images from the QCar's cameras are resized, transformed to a bird’s-eye view, and converted to binary format to highlight lane lines.

   <img width="732" alt="Image Preprocessing Steps" src="https://github.com/user-attachments/assets/c06ef2fb-070b-474c-b42b-8174a037549c">

2. **Lane Detection**: Utilized DBSCAN clustering to identify lane lines from the processed images.

   <img width="495" alt="Lane Detection with DBSCAN" src="https://github.com/user-attachments/assets/0eea179f-9d99-4201-8813-3280915d817b">

3. **Lane Following**: Applied the Pure Pursuit algorithm to calculate steering angles and a PID controller to manage speed.

   <img width="336" alt="Lane Following Algorithm" src="https://github.com/user-attachments/assets/ee7ce338-f2c4-4184-a80f-97279c67adf8">

## Repository Contents

- **[Literature Review Presentations](Literature_Review_Presentations/)**: A folder with presentations on various research papers related to lane detection and autonomous driving.

- **[Final Poster](FinalPosterdoc.pdf)**: The final poster that will be presented at the Emerging National Researchers Conference in Washington D.C.

- **[Research Paper](Paper_final_draft.pdf)**: First author on conference research paper.

- **[MATLAB Functions](MATLAB_Functions/)**: Scripts and functions for image processing and lane-following algorithms.

- **[Simulink Model](final_lane_following_model.slx)**: Complete Simulink model that processes camera inputs and computes the steering angle and speed.

## Acknowledgements

This project was supported by the National Science Foundation and the Mobility Systems Lab at The University of Texas at Austin. Special thanks to Professor Wang and the mentorship team for their guidance and support.
