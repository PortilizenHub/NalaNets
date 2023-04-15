# Table of Contents
- [Main Menu - Options](#main-menu---options)
- [Nala - Settings](#nala---settings)
- [Nala - Assets](#nala---assets)
- [Stages - Layers](#stages---layers)
- [Stages - Sizes and Positions](#stages---sizes-and-positions)
  - [Sizes](#sizes)
  - [Positions](#positions)
- [Stages - Animated](#stages---animated)

# Main Menu - Options
There was MEANT to be some mod support for this but there is this thing called `scope-creep`.

# Nala - Settings
In the `assets/data` folder, there is a file called `nalaSettings`, this is where you can modify the cat (or whatever you want your player to try and catch) settings, the size, start position, and the min and max speed.

# Nala - Assets
This is like, something important, as of right now a jumping nala is unused, but it was planned, so there are 2 frames of animation, idle and jump, the idle is used. The Jump isn't.

# Stages - Layers
As of right now the way stages work is by reading the `assets/images/stage` folder based on last modified so for examples you made a floor, wall, and tv, the layers would be in that order!

# Stages - Sizes and Positions
The way to change both of these values is in the `assets/data` folder where there is the files `size.txt` and `stage.txt`.

These are the files you modify, `stage.txt` is of course the positions because `size.txt` is the sizes.

## Sizes
The Sizes are simple because its 1 value you can add, by default i suggest using 0 unless this stage sprite is the last sprite in the list.

## Positions
The positions are a TINY bit more difficult because they add an extra value.

Example position
```
340
73
```

the `340` is the X, the `73` is the Y.
if your sprite has only one of the values then the position will probably default to

```
0
0
```

# Stages - Animated
Sadly there is NO WAY to have your sprite be animated as of now, but I will see what I can do.