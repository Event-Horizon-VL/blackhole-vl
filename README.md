# Blackhole-vl

> [!NOTE]
> This project is **not affiliated with or endorsed by the Void Linux project** or its maintainers.
>
> Use at your own discretion.

## Overview
A collection of template files for building packages on Void Linux with `xbps-src`.

This repository provides:
- **stable templates with prebuilt binaries** (main branch)
- **fully working templates without binaries** (manual branch)
- **experimental / unverified templates** (experimental branch)

<hr>

## Branches

This repository is split into multiple branches with different guarantees:

### **main**
- Stable and tested templates
- Prebuilt binary packages are provided
- Recommended for end users

### **manual**
- Templates are expected to build successfully
- **No prebuilt binaries are provided**
- Intended for local/manual builds only  
- This branch exists due to GitHub size and storage limitations

### **experimental**
- Work-in-progress templates
- May be broken, incomplete, or untested
- **All contributions should be based on this branch**
- Templates are promoted to `manual` or `main` only after validation

<hr>

## Installation
Currently packages are tested on / crosscompiled for the following architectures:
- x86_64
- x86_64-musl
- aarch64
- aarch64-musl

<details>
<summary><b> Manually building </b></summary>

> Recommended for the `manual` and `experimental` branches

1. Clone both this repository and [void-packages](https://github.com/void-linux/void-packages):

    ```
    git clone https://github.com/Nizarjh/blackhole-vl.git
    git clone https://github.com/void-linux/void-packages.git
    ```

2. (Optional) Switch to a specific branch:
    ```
    cd blackhole-vl
    git checkout manual
    # or
    git checkout experimental
    ```

3. Copy the template files into `void-packages`:

    ```
    cp -r blackhole-vl/srcpkgs/* void-packages/srcpkgs/
    ```

4. Edit `shlibs` by removing the lines found in `shlibs_remove`
   and appending the lines from `shlibs_append`:

    ```
    cd void-packages
    nvim common/shlibs
    ```

5. Bootstrap the build system:

    ```
    ./xbps-src binary-bootstrap
    ```

6. Build the desired packages:

    ```
    ./xbps-src pkg <package1> <package2> ...
    ```

7. Install the built packages:

    ```
    sudo xbps-install --repository /hostdir/binpkgs/ <package1> <package2> ...
    ```

</details>

<details>
<summary><b> 📦 Prebuilt binaries </b></summary>

> Available **only for the `main` branch**

1. Create an entry in `/etc/xbps.d/` and add this repository  
   (replace the architecture as needed):

    ```
    echo repository=https://raw.githubusercontent.com/Nizarjh/blackhole-vl/repository-x86_64 | sudo tee /etc/xbps.d/20-repository-extra.conf
    ```

2. Refresh repositories and accept the fingerprint:

    ```
    sudo xbps-install -S
    ```

3. Search and install packages as usual:

    ```
    xbps-query -Rs hypr
    sudo xbps-install -S hyprland
    ```

</details>

<hr>

## Contributing

Contributions are **highly appreciated**.

### Contribution workflow:
- **Fork and open pull requests against the `experimental` branch**
- Do **not** target `main` or `manual` directly
- Templates will be reviewed and promoted once confirmed working

This repository follows the same general rules and guidelines as
[void-packages CONTRIBUTING.md](https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md).

<hr>

## Credits
- [Makrennel: hyprland-void](https://github.com/Makrennel/hyprland-void): Hyprland template files

### Special thanks
- Encoded14

## 💖 Support My Work
[Boosty](https://boosty.to/niarjh) • [BuyMeaCoffee](https://buymeacoffee.com/nizarjh)
