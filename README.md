# font-manager
Command line utility to activate and de-activate fonts on macOS.


    font-manager register /path/to/font.otf

    font-manager unregister /path/to/font.otf

    font-manager list

    font-manager list-ext

Registering a font will make it appear in the font selection panel or menu of all apps. 

The fonts do NOT need to be within the standard OS font folders. 

You can also list all installed (registered) fonts. 

You can also list all activated fonts in 'external' locations (i.e. non-standard OS font folders), with their filepaths.

This code was created by Code Copilot, under my tutelage! 

***Usage***

The bare Swift code will run from the Terminal prompt. (Don't forget to check that the executable flags are set.)
Alternatively, you can compile it with `swiftc ./file-manager.swift`, which will create a binary that you can put in `/usr/local/bin` or similar.
