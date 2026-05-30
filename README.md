# AryaLinux

Automated build scripts for [AryaLinux](https://aryalinux.com) — a Linux distribution built from [Linux From Scratch (LFS) 13.0](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/) with systemd, plus AryaLinux-specific packages and optional desktop environments.

This repository contains the build orchestrator and package scripts. It does **not** include source tarballs or the LFS/BLFS book HTML (download those separately).

## Important: where and how to run everything

**All steps — cloning aside — must be run as root from the `base-system/` directory.** That directory is the build root; scripts expect `wget-list`, `build-properties`, and `stage*.sh` to live in the current working directory.

```bash
cd aryalinux/base-system    # stay here for the entire build
sudo -i                     # or su -, if you are not already root
./download-sources.sh
./build-arya
```

Do not run `download-sources.sh` or `build-arya` from the repository root (`aryalinux/`) or from `applications/`. Optional desktop packages use `additional-downloads.sh` for extra tarballs; run that from `base-system/` as well.

## Repository layout

| Path | Purpose |
|------|---------|
| `base-system/` | Cross toolchain, final system, boot tooling, extras, and the build orchestrator |
| `applications/` | ALPS application scripts for optional software (desktops, X server, apps) |

## Requirements

Follow the [LFS 13.0 host system requirements](https://www.linuxfromscratch.org/lfs/view/13.0-systemd/chapter02/hostreqs.html). In summary:

- A modern Linux host (Debian, Fedora, etc.) with build tools
- At least one spare partition for the target system (ext4 recommended)
- ~10 GB free disk for sources and build tree (more with backups or desktop)
- Root access on the host for partitioning, mounting, and chroot

## Quick start

### 1. Clone and enter the build root

```bash
git clone git@github.com:aryainformationsystems/aryalinux.git
cd aryalinux/base-system
```

Become root before downloading sources or starting the build (see [Important](#important-where-and-how-to-run-everything) above).

### 2. Download sources

```bash
./download-sources.sh
```

This populates `~/sources` from `wget-list` (LFS 13.0-systemd packages and patches) and fetches the AryaLinux **neofetch** tarball (`neofetch-7.1.0.tar.gz`). Run `./additional-downloads.sh` from the same directory when you need the rest of the AryaLinux-specific tarballs (live ISO, ALPS bundle, etc.).

### 3. Start the build

```bash
./build-arya
```

The orchestrator presents a configuration wizard (curses UI in a normal terminal, or line prompts with `--cli`). Press **Enter** to accept defaults.

**Default build identity:**

| Setting | Default |
|---------|---------|
| OS name | AryaLinux |
| Version | 26.6 |
| Codename | Phainix |
| Root/user password | `aryalinux` |

You will be asked for partition paths (bootloader device, root, optional home/swap), locale, username, and whether to install X11, a desktop environment, and a live ISO.

## Build stages

`build-arya` maps to the LFS book and AryaLinux extensions:

| Stage | LFS book | What runs |
|-------|----------|-----------|
| 1 | Chapters 2–4 | Host prep, `stage1.sh` (partition, mount, copy sources) |
| 2 | Chapters 5–6 | `cross-toolchain/`, `temp-tools/` |
| 3 | Chapters 7–8 | Chroot, `additional-temp-tools/`, `final-system/` |
| 5 | Chapters 9–10 | System config, kernel, bootloader, `extras/` |
| 6–7 | AryaLinux | Optional X server and desktop (XFCE, MATE, KDE, GNOME, LXQt) |

Build progress is logged in `/sources/build-log`. Resume a interrupted build from the startup menu by pointing at the root partition where `$LFS` was mounted.

## Key scripts

| Script | Description |
|--------|-------------|
| `build-arya` | Main orchestrator |
| `build_wizard.py` | Configuration UI (imported by `build-arya`) |
| `download-sources.sh` | Fetch LFS `wget-list` sources and neofetch tarball into `~/sources` |
| `additional-downloads.sh` | Fetch AryaLinux-specific tarballs and ALPS bundle |
| `stage*.sh` | Stage entry points called by the orchestrator |
| `extras/` | AryaLinux additions (sudo, busybox, neofetch, live-ISO tools, …) |
| `apps/` | Symlinked/copied application build helpers used inside chroot |

## Desktop environments

If you enable X server and a desktop during configuration, `build-arya` installs the chosen environment using meta-scripts under `applications/` (for example `mate-desktop-environment.sh`, `gnome-desktop-environment.sh`). Individual packages are built with [ALPS](https://github.com/aryainformationsystems/alps) inside the chroot.

## Configuration file

Answers from the wizard are written to `build-properties` in the build directory (and under `$LFS/sources` after stage 1). Shell stages source this file for partition paths, `OS_NAME`, `OS_VERSION`, `LOCALE`, feature flags, and similar settings.

## CLI mode

Force line-based prompts (no curses), useful over non-interactive SSH or automation:

```bash
./build-arya --cli
```

## License

Build scripts are provided as part of the AryaLinux project. Third-party sources built by these scripts are subject to their respective upstream licenses (GPL, LGPL, etc.).
