# Processes

## Adding new bundled software

### `build.sh`

1. Create `PROG_SRC` and `PROG_VER` variables under the "Target software/feature versions" section.
    * If intending to clone a Git repository, `PROG_SRC` should be its web URL.
    * If intended to download a tarball, `PROG_SRC` should be its web URL but excluding the file name itself.
2. Create an `INCLUDE_PROG` variable under the "Build parameters/arguments" section. Its default value should almost always be `false`.
3. Create an if statement that will trigger the program's source download and compilation if `INCLUDE_PROG` is `true` under the "Compile bunlded programs" section.
4. Try calling `get_prog_git()` or `get_prog_tar()` to handle downloading and compiling the program for you.
    * If you need to patch the source code before compiling, you may supply a patch file as a function parameter. If you must, you may modify `get_prog_[git/tar]()` by adding new code under "Apply any desired patches" inside them to make small `sed` patches and customisation.
    * If your program does not follow the typical GNU-style compilation process, you may create a dedicated `get_prog()` function under the "Bundled software building" section instead.
5. If the program installs files that you deem non-essential, you may add to `trim_fat()` to move/remove them.
6. Add an entry to `copy_licences()` to copy the program's licence file and include it in `manifest.csv`.
7. Add an entry to `get_installed_progs_feats()` so that the program shows up in the after-build report.
8. Add an entry to `get-vers.sh` so that script can let us know what the latest version of the software is.

### `config.sh`

* Create an `INCLUDE_PROG` variable near the top with the others. It must be `false`.
* Add an entry to `save_env()` so that the variable can be saved into the result `.env` file.
* Add an entry to `set_mini_vars()` that sets `INCLUDE_PROG` to `false`.
* Add an entry to any other relevant `set_*_vars()` functions you wish to create build type defaults for. Otherwise, it will become a custom-only option.
* Add an entry to the `BUNDLED_ITEMS` list so that the program will appear as an option when configuring a custom build. If the program is to be included in a default build, please indicate this via adding a `*` (asterisk) in front of the program description. If the program tangibly increases system memory usage compared to a default build (16MiB RAM + 8MiB swap), also indicate this with adding a leading `†` (dagger) too.
* Add an entry to the series of if statements that handle `BUNDLED`'s result so that the user's choice will be saved in `.env`.
