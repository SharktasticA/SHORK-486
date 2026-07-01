# Notes on patching

## Failed patching

If an existing patch fails to apply clearnly (say trying a patch for an earlier kernel with a later one), use `--merge=diff3` to insert conflict markers to allow for a manual merge:

    patch -p1 --merge=diff3 < filepath.patch

The following can be run to find out what files contain conflict markers:

    grep -rn --exclude-dir=.git '^<<<<<<<\|^|||||||\|^=======\|^>>>>>>>' .
