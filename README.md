# FromScratch

FromScratch is a modpack for Minetest which provides a way to generate most resources from a single tree.

This modpack is heavily inspirated by the Ex Nihilo mod for Minecraft.

![](screenshot.png?raw=true)

## Mods

### fs_barrel

Compost saplings to make dirt.

_Will also be able to contain fluids._ (TODO)

Fluid/item interaction is also planned, for example:
- _Dust + Water = Clay_ (TODO)
- _Water + Lava = Obsidian_ (TODO)

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

_Another crucible, made of wood, will be able to make water from saplings._ (TODO)

The crucibles can hold 2 buckets of liquid and 8 items maximum.

### fs_sieve

Use a sieve to get ores from Gravel.

You will need String to make a Silk Mesh.

_Will support Dirt, Sand and Dust too._ (TODO)

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
- moreblocks (optional)

## License

Copyright (C) 2018-2019 Quentin Bazin

Code: Licensed under the GNU LGPL version 2.1 or later. See LICENSE.txt

