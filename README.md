# Procgen_game
The Cohesive Procedural World Generator is a project developed using the Godot Engine, aimed at creating a demo game that dynamically generates vast, natural landscapes. The project leverages GDScript, the native scripting language of Godot, and its core functionality is encapsulated within the biomeGen script. This script handles the procedural generation of biomes and terrain features, creating a unique world each time based on seed values and noise algorithms. 

The core of this generator lies in the BiomeGen class, which initializes the world by setting up a grid of dimensions defined by height and width. It uses four distinct noise functions from the bult-in FastNoiseLite library to simulate different environmental factors:

* Altitude Noise (alt_noise): Generates the vertical structure of the world, including mountains and valleys. 

* Precipitation Noise (ppt_noise): Controls the distribution of rainfall across the world, affecting biome classification. 

* Temperature Noise (tem_noise): Influences temperature variation to categorize biomes from hot deserts to cold tundras. 

* River Noise (river_points): Based on a cellular noise function, generates natural river systems by detecting water flow patterns and altitude drops.

The generator works by seeding these noise functions with a user-provided world_seed to ensure repeatability or randomness. This noise setup drives the creation of biomes, such as forests, plains, or rivers, which are determined by a combination of altitude, precipitation, and temperature thresholds

# Objective:
    • To develop a procedural world generator capable of creating dynamic and diverse biomes within a 2D game environment.

    • To utilize Godot Engine’s built-in FastNoise class for generating terrain features such as altitude, temperature, precipitation, and river systems. 

    • To design an efficient biome generation system that adapts to varying player positions and world seeds, ensuring a unique experience each time. 

    • To implement a tile-based rendering system that visualizes biomes and terrain based on procedural noise data. 

    • To optimize the generation and management of terrain chunks, allowing for seamless transitions and efficient memory usage during gameplay. 
    
    • To create a flexible framework for future expansion, enabling easy modification of biome rules and procedural parameters for further customization. 
    
    • To showcase the potential of procedural generation in game development, highlighting its use in creating large, varied, and immersive game worlds.

    
# Conclusion 
The Cohesive Procedural World Generator project showcases the capability of procedural generation using the Godot Engine and GDScript. At the core of this demo lies the biomeGen script, which drives the creation of diverse 2D biomes and terrain, providing a seamless and dynamic world-building experience. By utilizing the built-in FastNoiseLite class, this project effectively generates fractal-based noises to simulate various environmental features, such as altitude, precipitation, temperature, and river paths.

In summary, this project successfully demonstrates how procedural techniques can be applied to generate rich, cohesive worlds.This project showcases the flexibility and power of procedural techniques in game development.