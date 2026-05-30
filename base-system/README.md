# base-system

Build scripts and orchestrator for AryaLinux. See the [project README](../README.md) for an overview and quick start.

**Run every command here as root.** Do not use the repository root or `applications/` as your working directory.

## Run from here

```bash
cd /path/to/aryalinux/base-system
sudo -i
./download-sources.sh   # once, on the host
./build-arya            # start or resume a build
```

Use `./build-arya --cli` for non-curses prompts.

## Directories

| Directory | LFS chapter | Contents |
|-----------|-------------|----------|
| `cross-toolchain/` | 5 | Binutils, GCC, glibc, linux-headers |
| `temp-tools/` | 6 | Temporary toolchain packages |
| `additional-temp-tools/` | 7 | gettext, bison, perl, python, texinfo, util-linux |
| `final-system/` | 8 | Final system packages (ordered like the book) |
| `extras/` | — | AryaLinux-specific additions installed in stage 7 |

Other notable files: `kernel.sh`, `initramfs.sh`, `lvm2.sh`, `createlivedisk.sh`, `wget-list`.
