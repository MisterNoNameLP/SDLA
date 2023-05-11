SDLA (SnowrunnerDiffLockAdder) provides a little script procedurally adding a optional difflock to every truck that does not have one at all.

The script is written in [PleaL](https://github.com/MisterNoNameLP/PleaL) and should work platform indipendent. But it is only testet on linux.  

Prebuild files are included in the `output` folder.

# Installation 

Clone this repository and install the [requirements](https://github.com/MisterNoNameLP/SDLA#Requirements).

# Requirements

### Interpreter

[PleaL](https://github.com/MisterNoNameLP/PleaL) (on lua5.3)  

### Luarocks

luafilesystem  
xml2lua 1.5-1 (v1.5-2 procudes invalid xml files)

# Usage

Place extracted version of the original `initial.pak` in to the `initial` folder.  
Place the extracted files from other manually installed mods into the `mods` folder.  
Execute `addDiffs.pleal` using [PleaL](https://github.com/MisterNoNameLP/PleaL) (on lua5.3).  
The script will then put the mod files into the `output` folder.  
Done.  

# Known bugs / side effects

- The diff-lock for the ZiKZ 5368 is now unlocked per default and don't have to be found in the map anymore.  
    This is because every modded truck uses the diff-lock from the ZiKZ 5368.

- The formatting in the generated `.xml` files is completely messed up.

- Some trucks causing crashes at building. These have to be removed before. Known trucks are:
  - zikz_566a
  - step_310e