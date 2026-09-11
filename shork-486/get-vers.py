######################################################
## Gets the latest version numbers of SHORK 486's   ##
## software components.                             ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



import os
import time
import requests

from dotenv import load_dotenv



COL_WIDTH = 44
FETCH_COUNT = 10
TIMEOUT = 5

BLACKLIST = [
    "-rc",
    "-beta",
    "-alpha",
    "nightly",
    "pre-rrt-big-changes",
    "verified",
    "-devel",
    "dev_"
]

REPOS = [
    "pmattes/x3270",
    "universal-ctags/ctags",
    "dosemu2/dosemu2",
    "dosfstools/dosfstools",
    "mkj/dropbear",
    "file/file",
    "git/git",
    "telmich/gpm",
    "htop-dev/htop",
    "joe-editor/joe",
    "xiph/libao",
    "libevent/libevent",
    "jmcnamara/libxlsxwriter",
    "gnome/libxml2",
    "nih-at/libzip",
    "llvm/llvm-project",
    "deepin-community/lsb-release-minimal",
    "lua/lua",
    "jqlang/jq",
    "ThomasDickey/lynx-snapshots",
    "troglobit/mg",
    "micro-editor/MICRO",
    "micropython/micropython",
    "iustin/mt-st",
    "netwide-assembler/nasm",
    "mirror/ncurses",
    "openssl/openssl",
    "NixOS/patchelf",
    "PCRE2Project/pcre2",
    "andmarti1424/sc-im",
    "strace/strace",
    "tmux/tmux",
    "tn5250/tn5250",
    "util-linux/util-linux",
    "vim/vim",
    "wfeldt/libx86emu",
    "madler/zlib",
]



# Get GITHUB_TOKEN from ght.env
load_dotenv(os.path.join(os.getcwd(), "ght.env"))
github_token = os.environ.get("GITHUB_TOKEN")
headers = {"Authorization": f"Bearer {github_token}"} if github_token else {}



print(
    "------------------------------------------------------------------------------------"
    " GitHub "
    "------------------------------------------------------------------------------------"
)

for repo in REPOS:
    name = repo.split("/")[-1]
    data = None
    versions = []

    try:
        resp = requests.get(
            f"https://api.github.com/repos/{repo}/releases?per_page={FETCH_COUNT}",
            headers=headers,
            timeout=TIMEOUT,
        )
        resp.raise_for_status()
        data = resp.json()
    except requests.RequestException:
        data = None

    if data:
        for item in data:
            tag = item.get("tag_name", "")
            val = tag.lower().strip()
            if any(term.lower() in val or term.lower() == val for term in BLACKLIST):
                continue
            updated = (item.get("updated_at"))[:10]
            versions.append(f"{tag} ({updated})")
            if len(versions) == 3:
                break

    if not versions:
        try:
            resp = requests.get(
                f"https://api.github.com/repos/{repo}/tags?per_page={FETCH_COUNT}",
                headers=headers,
                timeout=TIMEOUT,
            )
            resp.raise_for_status()
            data = resp.json()
        except requests.RequestException:
            data = None

        if data:
            for item in data:
                tname = item.get("name", "")
                val = tname.lower().strip()
                if any(term.lower() in val or term.lower() == val for term in BLACKLIST):
                    continue
                versions.append(tname)
                if len(versions) == 3:
                    break

    versions = (versions + ["", "", ""])[:3]
    v1, v2, v3 = versions

    print(
        f"{name + ':':<{COL_WIDTH}}"
        f"{v1:<{COL_WIDTH}}"
        f"{v2:<{COL_WIDTH}}"
        f"{v3:<{COL_WIDTH}}"
    )
    time.sleep(0.5)

print("Manual check needed for:")
print("https://github.com/ThomasDickey/lynx-snapshots.git")
