# Multi-Agent Shuttle System

This project develops an optimized shuttle system for Queen’s University students using **multi-agent systems** and **Lloyd's Algorithm**. It addresses transportation inefficiencies caused by harsh winters, long walking distances, and insufficient public transit, offering a safer, more efficient, and environmentally friendly solution.


## Report

For a detailed explanation of the project, its methodology, and results, check out the full report:  
**[Multi-Agent Shuttle System Report](https://github.com/michaelkokorudz/multi-agent_shuttle_system/blob/main/Multi-Agent.Shuttle.System.Report.pdf)**


## Running the Simulation

### **Setup**
1. Ensure MATLAB R2021b or later is installed.
2. Clone the repository:
   ```bash
   git clone https://github.com/michaelkokorudz/multi-agent_shuttle_system.git
3. Open the file `run_lloyds.m` in MATLAB to adjust simulation parameters:
   - **Number of agents**: This parameter defines the total number of shuttles in the system. Adjust this value in the script to suit your simulation requirements.
   - **Density hotspots**: Modify the locations and intensities of high-population regions in the `density_map.m` file. These areas represent high demand for shuttle services.
4. Run the `run_lloyds.m` file in MATLAB to start the simulation:
   ```matlab
   run_lloyds
This initializes the agents, sets up the environment, and begins the simulation based on the defined parameters.


## Problem Statement

Queen’s University students face significant challenges commuting during winter:
- Harsh weather conditions make walking long distances unsafe.
- Public transit systems are often unreliable and inefficient.
- Increased reliance on private vehicles leads to traffic congestion and environmental harm.

### **Goals**
- Provide safe and efficient transportation.
- Reduce environmental impact by limiting private vehicle use.
- Enhance accessibility for all students.


## Features

### **1. Multi-Agent Simulation**
- Models shuttles as agents with:
  - **Observation range**: Determines areas the agent can monitor.
  - **Communication range**: Governs interaction with other agents.
- Agents iteratively adjust positions to optimize coverage.

### **2. Density-Based Movement**
- Population hotspots are modeled using Gaussian density maps.
- Shuttles are attracted to high-density regions for maximum efficiency.

### **3. Real-Time Adjustments**
- Agents dynamically adapt to changes in density and communication networks.

### **4. Visualization**
- Animates shuttle movements, communication links, and population densities.
- Provides insights into system behavior over time.


