<h1 align="center">Blackhole-vl</h1>

<p align="center">
  A collection of <a href="https://github.com/void-linux/void-packages/blob/master/Manual.md">template files</a> for building packages for Void Linux with <code>xbps-src</code>, alongside a community <a href="#binary-repository">binary repository</a>.
</p>

<p align="center">
  Use <a href="https://github.com/Event-Horizon-VL/blackhole-vl/tree/main"><code>main</code></a> for prebuilt packages. The <a href="https://github.com/Event-Horizon-VL/blackhole-vl/tree/manual"><code>manual</code></a> branch contains additional templates for local builds.
</p>

<p align="center">
  <a href="https://black-hole.dev/packages">Browse packages</a> ·
  <a href="#quick-start">Quick start</a> ·
  <a href="#package-requests">Package requests</a> ·
  <a href="https://github.com/Event-Horizon-VL/blackhole-vl/discussions">Discussions</a>
</p>


<p align="center">
    <sub>This project is not affiliated with or endorsed by the Void Linux project or its maintainers.</sub>
</p>

---

## Table of Contents

- [Quick start](#quick-start)
- [Binary repository](#binary-repository)
  - [Mirrors](#mirrors)
  - [Using the repository](#using-the-repository)
  - [Finding packages](#finding-packages)
  - [Removing the repository](#removing-the-repository)
- [Manual building](#manual-building)
  - [Building from templates](#building-from-templates)
  - [Editing shlibs](#editing-shlibs)
- [Branches](#branches)
- [Package requests](#package-requests)
- [Troubleshooting](#troubleshooting)
  - [Migrating from old GitHub repositories](#migrating-from-old-github-repositories)
  - [`unresolvable shlib libhyprutils.so.10`](#unresolvable-shlib-libhyprutilsso10)
  - [`ERROR: package: the RSA signature is not valid!`](#error-package-the-rsa-signature-is-not-valid)
  - [Package not found](#package-not-found)
- [Contributing](#contributing)
- [Credits](#credits)
- [Support](#support)
- [License](#license)

---

## Quick start

Run the following commands to add the Blackhole repository mirror and refresh package metadata:

```sh
sudo cp /usr/share/xbps.d/00-repository-main.conf /etc/xbps.d/
sudo sed -i "1i repository=https://mirror.black-hole.dev/$(xbps-uhelper arch)" /etc/xbps.d/00-repository-main.conf
sudo xbps-install -S
```

See [Mirrors](#mirrors) for more mirrors and [Using the repository](#using-the-repository) for package management.

Some packages are **not available as prebuilt binaries in the repository** and can be built manually, see [Manual Building](#manual-building).

## Binary repository

Prebuilt packages are available for `x86_64`, `x86_64-musl`, `aarch64` and `aarch64-musl`.

### Mirrors

| Architecture | URL |
| --- | --- |
| `x86_64` | <https://mirror.black-hole.dev/x86_64/> |
| `x86_64-musl` | <https://mirror.black-hole.dev/x86_64-musl/> |
| `aarch64` | <https://mirror.black-hole.dev/aarch64/> |
| `aarch64-musl` | <https://mirror.black-hole.dev/aarch64-musl/> |

A ru-mirror with the same layout is available at <https://ru.mirror.black-hole.dev/>. It is recommended for users whose network cannot reliably reach the main host.

### Using the repository

The [Quick start](#quick-start) section covers enabling the mirror, refreshing metadata and accepting the repository fingerprint. Once enabled, the [Blackhole mirror](#mirrors) is listed first in the repository configuration, and repositories higher in the list take priority.

After syncing, you can verify that the mirror is active with:

```sh
xbps-query -L
```

### Finding packages

After enabling the repository, search for and install packages as usual:

```sh
xbps-query -Rs <pattern>
sudo xbps-install -S <package>
```

You can also browse the package list on [our website](https://black-hole.dev/packages).

### Removing the repository

To use only the official repositories again, remove the Blackhole mirror entry from `/etc/xbps.d/00-repository-main.conf`. The official repository entry will remain:

```sh
sudo sed -i '/mirror\.black-hole\.dev/d' /etc/xbps.d/00-repository-main.conf
sudo xbps-install -S
```


## Manual building

Templates that are too large or too expensive to distribute as binaries live on the `manual` branch and are intended to be built locally.

### Building from templates

1. Clone this repository and [void-packages](https://github.com/void-linux/void-packages):

    ```sh
    git clone https://github.com/Event-Horizon-VL/blackhole-vl.git
    git clone https://github.com/void-linux/void-packages.git
    ```

2. *(Optional)* Switch to a specific branch:

    ```sh
    git -C blackhole-vl checkout manual
    ```

3. Copy the template files into `void-packages`:

    ```sh
    cp -r blackhole-vl/srcpkgs/* void-packages/srcpkgs/
    ```

4. Apply the `shlibs` changes (see [Editing shlibs](#editing-shlibs)):

    ```sh
    grep -vFxf blackhole-vl/shlibs_remove void-packages/common/shlibs > temp
    mv temp void-packages/common/shlibs
    cat blackhole-vl/shlibs_append >> void-packages/common/shlibs
    ```

5. Bootstrap the build system:

    ```sh
    cd void-packages
    ./xbps-src binary-bootstrap
    ```

6. Build the desired packages:

    ```sh
    ./xbps-src pkg <package1> <package2> ...
    ```

7. Install the built packages:

    ```sh
    sudo xbps-install --repository hostdir/binpkgs/ <package1> <package2> ...
    ```

### Editing shlibs

`void-packages` tracks shared library sonames in `common/shlibs`, so each package that ships a new or renamed library needs its soname registered there. This repository keeps the changes in two files:

- `shlibs_remove` — lines to delete from `void-packages/common/shlibs`
- `shlibs_append` — lines to add

Both CI and the manual steps above apply these files. If your template ships a library, add the soname to `shlibs_append`; if it replaces an existing library, add the old line to `shlibs_remove`. See `.github/workflows/build.yaml` for the exact merge the CI performs.

## Branches

| Branch | Binaries | Status | Intended for |
| --- | --- | --- | --- |
| [`main`](https://github.com/Event-Horizon-VL/blackhole-vl/tree/main) | yes | stable, tested templates | end users |
| [`manual`](https://github.com/Event-Horizon-VL/blackhole-vl/tree/manual) | no | expected to build | local builds |
| `package/*` | no | may be incomplete or broken | development |

> [!IMPORTANT]
> The `manual` branch contains a **larger set of packages** than `main`. Some templates are only available there due to size or build constraints. If something is missing in `main`, check `manual`.

Package-specific branches are used for testing, refactoring or bring-up, and are merged into `manual` or `main` once validated.

---

## Package requests

Submit requests for new packages, updates or fixes using the [package request issue template](https://github.com/Event-Horizon-VL/blackhole-vl/issues/new?template=pkg-request.yml).

For questions and general discussion, use [GitHub Discussions](https://github.com/Event-Horizon-VL/blackhole-vl/discussions).

---

## Troubleshooting

### Migrating from old GitHub repositories

The GitHub-hosted repositories (`repository-x86_64`, `repository-aarch64`, and their musl variants) are deprecated and no longer receive updates.

Remove the old repository configuration files:

```sh
sudo rm -f /etc/xbps.d/20-repository-extra.conf
sudo rm -f /etc/xbps.d/00-repository-main.conf
```

Then follow [Quick start](#quick-start) to configure the current mirror and refresh the repository metadata.

### `unresolvable shlib libhyprutils.so.10`

An outdated repository configuration is still present. Remove `/etc/xbps.d/20-repository-extra.conf`, re-enable the mirror as shown in [Quick start](#quick-start).

### `ERROR: package: the RSA signature is not valid!`

This can happen when repository metadata cached packages are corrupted or only partially updated. Clear the local cache and retry:

```sh
sudo xbps-remove -O
sudo rm -rf /var/cache/xbps/*
sudo xbps-install -S
```

If the issue persists, remove and reinstall the affected package:

```sh
sudo xbps-remove -R <package>
sudo xbps-install -S <package>
```

### Package not found

The package may only exist on the `manual` branch. See [Branches](#branches).

You can [build it manually](#manual-building), or [request the package](#package-requests).

---

## Contributing

Packages and improvements are welcome, see [CONTRIBUTING.md](CONTRIBUTING.md) for the workflow, commit message format and target branch.

CI builds every changed template for all four architectures and publishes the results to the mirror. CI checks whether templates build; it does **not** audit their sources for malware. **Review before installing them**.

## Credits

- [Makrennel: hyprland-void](https://github.com/Makrennel/hyprland-void) — Hyprland template files
- Special thanks to Encoded14.

## Support

[Boosty](https://boosty.to/niarjh) • [BuyMeaCoffee](https://buymeacoffee.com/nizarjh)

---

## License

BSD 2-Clause, see [LICENSE](LICENSE).
