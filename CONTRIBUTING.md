# Contributing to blackhole-vl

blackhole-vl is a community-driven repository. Packages and improvements welcome.

## Adding a Package

1. Fork the repo.

2. Create your template at `blackhole-vl/srcpkgs/<pkgname>/template`.
   Follow standard [Void packaging conventions](https://github.com/void-linux/void-packages/blob/master/Manual.md).

3. Open a PR. CI will check if it builds, after it is merged CI will build your package automatically.

> [!IMPORTANT]
> If your resulting `.xbps` package is ≥100 MB or requires ≥8 GB of RAM to build, target the `manual` branch. Otherwise, please target `main`.

## Template Notes

#### Updating a template

At minimum, a template update will consist of changing `version` and `checksum`, if there was an upstream version change, and/or `revision`, if a template-specific change (e.g. patch, correction, etc.) is needed.
Other changes to the template may be needed depending on what changes the upstream has made.

The checksum can be updated automatically with the `xgensum` helper from the [xtools](https://github.com/leahneukirchen/xtools) package:

    $ xgensum -i <pkgname>

#### Adopting a template

If a template is orphaned (maintained by `orphan@example.org`) or the current `maintainer` has not contributed to
blackhole-vl in over a 3-6 months, template maintainership can be adopted by someone else.

It is best to adopt a template when making another change to it. When adopting the template, add your name or username
and email to the `maintainer` field in the template, and mention the adoption in your commit message, for example:

    <pkgname>: update to 0.0.7, adopt.

#### Committing your changes
Once you have made and verified your changes to the package template and/or other files, make one commit per package (including all changes to its sub-packages). Each commit message should have one of the following formats:

* for new packages, use `New package: <pkgname>-<version>` ([example](https://github.com/Event-Horizon-VL/blackhole-vl/commit/c53c1f73cbb65c691f4f99ee32d4e12a7a8b79f3)).

* for package updates, use `<pkgname>: update to <version>.` ([example](https://github.com/Event-Horizon-VL/blackhole-vl/commit/9685afda893da5252e56e1ace85ec46923e696a7)).

* for template modifications without a version change, use `<pkgname>: <reason>` ([example](https://github.com/Event-Horizon-VL/blackhole-vl/commit/6b090b6cb60d712d028fd0990e075ec33f490345)).

* for package removals, use `<pkgname>: remove package` and include the removal reason in the commit body ([example](https://github.com/Event-Horizon-VL/blackhole-vl/commit/6c063cc38f85083cfd8f191bcca387e9966fa38c)).

* for changes to any other file, use `<filename>: <reason>` ([example](https://github.com/void-linux/void-packages/commit/e00bea014c36a70d60acfa1758514b0c7cb0627d),
  [example](https://github.com/void-linux/void-packages/commit/93bf159ce10d8e474da5296e5bc98350d00c6c82), [example](https://github.com/void-linux/void-packages/commit/dc62938c67b66a7ff295eab541dc37b92fb9fb78), [example](https://github.com/void-linux/void-packages/commit/e52317e939d41090562cf8f8131a68772245bdde))

## Policy

If it builds, is FOSS, and isn’t malicious - it’s acceptable. \
No malware, no piracy, no proprietary software. \
No guarantees. Use at your own risk.

## Liability

> **Use at your own risk.**

Packages are submitted by random people on the internet. We only check that the manifest builds. We don't:
- Audit source code
- Check for malware

By using blackhole-vl, you accept responsibility for what you install. If you're paranoid (and you should be), read the template before installing.
