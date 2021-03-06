# update.py
# Simon Hulse
# simon.hulse@chem.ox.ac.uk
# Last Edited: Mon 21 Feb 2022 17:19:12 GMT

from dataclasses import dataclass
import pathlib
import subprocess


@dataclass
class FromTo:
    src: pathlib.Path
    dst: pathlib.Path


# Find pygments directory
# Parse shebang to determine python executable used
def get_pygments_styles_dir():
    pygmentise_exe = (
        subprocess.run(["which", "pygmentize"], capture_output=True)
        .stdout.decode("utf-8")
        .rstrip()
    )
    print(pygmentise_exe)
    if pygmentise_exe:
        with open(pygmentise_exe, "r") as fh:
            python_exe = fh.readline().replace("#!", "").rstrip()
        pygments_dir = (
            pathlib.Path(
                next(
                    filter(
                        lambda x: "USER_SITE" in x,
                        subprocess.run(
                            [python_exe, "-m", "site"],
                            capture_output=True,
                        )
                        .stdout.decode("utf-8")
                        .split("\n"),
                    )
                )
                .replace("USER_SITE: '", "")
                .replace("' (exists)", "")
            )
            / "pygments/styles"
        )
        return pygments_dir
    else:
        return None


configdir = pathlib.Path(__file__).resolve().parent
homedir = pathlib.Path().home()

files = [
    FromTo(configdir / ".bashrc", homedir / ".bashrc"),
    FromTo(configdir / ".profile", homedir / ".profile"),
    FromTo(configdir / ".vimrc", homedir / ".vimrc"),
    FromTo(configdir / ".vim/ftplugin", homedir / ".vim/ftplugin"),
    FromTo(configdir / ".vim/UltiSnips", homedir / ".vim/UltiSnips"),
    FromTo(configdir / ".fonts/ebgaramond", homedir / ".fonts/ebgaramond"),
    FromTo(configdir / ".fonts/juliamono", homedir / ".fonts/juliamono"),
    FromTo(
        configdir / ".fonts/Garamond-Math.otf", homedir / ".fonts/Garamond-Math.otf"
    ),
    FromTo(configdir / ".config/matplotlib", homedir / ".config/matplotlib"),
    FromTo(configdir / ".config/zathura", homedir / ".config/zathura"),
    FromTo(configdir / ".config/flake8", homedir / ".config/flake8"),
    FromTo(
        configdir / "pygments/gruvboxdark.py",
        get_pygments_styles_dir() / "gruvboxdark.py",
    ),
]

pygmentspath = get_pygments_styles_dir()
if pygmentspath is not None:
    files.append(FromTo(configdir / "pygments/gruvboxlight.py",
                        pygmentspath / "gruvboxlight"))


for f in files:
    counter = 0
    while True:
        if f.dst.parents[counter].is_dir():
            break
        else:
            counter += 1
    parents = f.dst.parents
    for i in reversed(range(counter)):
        subprocess.run(["mkdir", parents[i]])

    subprocess.run(["cp", "-r", f.src, f.dst])
