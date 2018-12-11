# FromScratch

FromScratch is a modpack for Minetest which provides a way to generate most resources from a single tree.

This modpack is basically a Minetest implementation of the Minecraft mod Ex Nihilo.

It also provides a [small API](https://github.com/Quent42340/FromScratch/wiki/API-Documentation) to add custom Barrels, Crucibles and more.

![](screenshot.png?raw=true)

## Mods

### fs_barrel

Compost saplings to make dirt.

Barrels can contain water and lava (except lava for Wooden Barrel).

It's possible to create some blocks by right-clicking a full barrel with a specific item:
- Dust + Water = Clay
- Water Bucket + Lava = Obsidian

### fs_core

Core items and helper functions like:
- Dust
- Silk Mesh
- Silk Worm
- Infested Leaves

You can put a Silk Worm in Leaves to create Infested Leaves.

Once a Leave is fully infested, you can dig it to get String.

**Warning:** Silk Worms will propagate to all neighbour Leaves.

### fs_crucible

Put cobblestone into the crucible and put a torch under it to melt it.

Another crucible, made of wood, can generate water from leaves.

The crucibles can hold 2 buckets of liquid and 8 items maximum.

### fs_sieve

Use a sieve to get ores from Gravel, Sand and Dust.

It's also possible to get stone pebbles and seeds by sieving Dirt;

You will need String to make a Silk Mesh.

### fs_tools

Use a hammer to smash blocks:
- Cobble -> Gravel
- Gravel -> Sand
- Sand -> Dust

Use a crook to get extra leaves drop:
- Leaves -> Silk Worms
- Infested Leaves -> String

## Dependencies

- default
- farming (for `farming:string`)
- bonemeal
- bucket
- fluid_lib

## License

Copyright (C) 2018-2019 Quentin Bazin

### Code

Licensed under the GNU LGPL version 2.1 or later. See LICENSE.txt

### Textures

Most of the textures comes from [Ex Nihilo Creatio](https://github.com/BloodyMods/ExNihiloCreatio) and are under [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).

