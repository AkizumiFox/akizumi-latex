#!/usr/bin/env python3
"""Install akizumi-latex on macOS, Linux or Windows.

  python3 install.py          (Windows: py install.py)

1. Makes the templates visible to TeX: TEXMFHOME/tex/latex/akizumi-latex
   points at this folder (a symlink; on Windows a directory junction, which
   needs no administrator rights). Edits here take effect immediately.
2. Puts `ax` on the command line: a link in ~/bin (macOS) or ~/.local/bin
   (Linux); on Windows this repo's bin folder, which holds ax.cmd, is added to
   the user PATH.
3. macOS only: links bin/biber when TeX Live's own biber fails to start.
"""

import os
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
WINDOWS = os.name == "nt"
MACOS = sys.platform == "darwin"


def die(msg):
    print(f"install: {msg}", file=sys.stderr)
    sys.exit(1)


def kpse_var(name):
    try:
        out = subprocess.run(["kpsewhich", f"-var-value={name}"],
                             capture_output=True, text=True).stdout.strip()
    except OSError:
        die("kpsewhich not found; install TeX Live first (https://tug.org/texlive/)")
    if not out:
        die(f"TeX Live did not report {name}")
    return Path(out)


def is_junction(path):
    try:
        return os.path.isjunction(path)  # Python 3.12+
    except AttributeError:
        try:
            os.readlink(path)
            return True
        except (OSError, ValueError):
            return False


def is_link(path):
    return path.is_symlink() or (WINDOWS and is_junction(path))


def points_here(path):
    return Path(os.path.realpath(path)) == HERE


def remove_link(path):
    if WINDOWS and is_junction(path):
        os.rmdir(path)  # removes the junction only, never the target
    else:
        path.unlink()


def link_dir(link, target):
    if is_link(link):
        remove_link(link)
    elif link.exists():
        die(f"{link} exists and is not a link; refusing to overwrite")
    link.parent.mkdir(parents=True, exist_ok=True)
    if WINDOWS:
        r = subprocess.run(["cmd", "/c", "mklink", "/J", str(link), str(target)],
                           capture_output=True, text=True)
        if r.returncode:
            die(f"could not create junction {link}: {r.stdout}{r.stderr}")
    else:
        link.symlink_to(target, target_is_directory=True)
    print(f"linked {link} -> {target}")


def link_file(link, target):
    if is_link(link):
        link.unlink()
    elif link.exists():
        print(f"skipped {link}: a file that is not ours is in the way")
        return
    link.symlink_to(target)
    print(f"linked {link}")


def add_to_user_path(folder):
    """Windows: append folder to the user PATH in the registry."""
    import ctypes
    import winreg
    folder = str(folder)
    with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment", 0,
                        winreg.KEY_READ | winreg.KEY_WRITE) as key:
        try:
            value, kind = winreg.QueryValueEx(key, "Path")
        except FileNotFoundError:
            value, kind = "", winreg.REG_EXPAND_SZ
        parts = [p for p in value.split(";") if p]
        norm = lambda p: os.path.normcase(os.path.normpath(os.path.expandvars(p)))
        if any(norm(p) == norm(folder) for p in parts):
            print(f"{folder} is already on PATH")
            return
        parts.append(folder)
        if kind not in (winreg.REG_SZ, winreg.REG_EXPAND_SZ):
            kind = winreg.REG_EXPAND_SZ
        winreg.SetValueEx(key, "Path", 0, kind, ";".join(parts))
    # tell running programs so new terminals see the change
    result = ctypes.c_ulong()
    ctypes.windll.user32.SendMessageTimeoutW(0xFFFF, 0x1A, 0, "Environment", 0x2, 5000,
                                             ctypes.byref(result))
    print(f"added {folder} to PATH; open a new terminal")


def install_tools():
    if WINDOWS:
        add_to_user_path(HERE / "bin")
        return
    bindir = Path.home() / ("bin" if MACOS else ".local/bin")
    bindir.mkdir(parents=True, exist_ok=True)
    for tool in ("ax", "akizumi-both"):
        link_file(bindir / tool, HERE / "bin" / tool)
    old = bindir / "aaron-both"  # name before v0.6
    if old.is_symlink():
        old.unlink()
        print(f"removed {old}")
    if MACOS:
        # TeX Live's own biber (MacTeX or a plain TeX Live), not one already on PATH
        texbiber = kpse_var("SELFAUTOLOC") / "biber"
        if texbiber.exists() and subprocess.run([str(texbiber), "--version"],
                                                capture_output=True).returncode:
            link_file(bindir / "biber", HERE / "bin" / "biber")
            print("  (TeX Live's biber does not start here; using bin/biber)")
    path = os.environ.get("PATH", "").split(os.pathsep)
    if str(bindir) not in path:
        shell = "~/.zshrc" if MACOS else "~/.bashrc"
        print(f"note: add {bindir} to PATH, e.g. "
              f"echo 'export PATH=\"{bindir}:$PATH\"' >> {shell}")


def main():
    texmf = kpse_var("TEXMFHOME") / "tex" / "latex"
    link_dir(texmf / "akizumi-latex", HERE)
    old = texmf / "aaron-latex"  # name before v0.6
    if is_link(old) and points_here(old):
        remove_link(old)
        print(f"removed {old}")
    install_tools()
    found = shutil.which("kpsewhich") and subprocess.run(
        ["kpsewhich", "akizumi-core.sty"], capture_output=True, text=True).stdout.strip()
    print(f"TeX finds the templates: {found or 'NOT YET, check the link above'}")


if __name__ == "__main__":
    main()
