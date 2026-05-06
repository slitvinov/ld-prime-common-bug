# ld_prime SIGBUS reproducer

Minimal Fortran reproducer for an Apple ld_prime (the new linker shipped with
Xcode 15) regression: same-named COMMON blocks declared at different sizes
across translation units are not merged to the largest size, so writes through
the larger view fall outside the linker-allocated region and SIGBUS at runtime.

The pattern (declaring the same named COMMON at different shapes per file) is
itself non-conforming Fortran 77 / 90; old linkers (GNU ld, LLVM lld, classic
Apple ld64) historically picked the larger size as a courtesy, ld_prime no
longer does so above some byte-count threshold.

See <https://github.com/Nek5000/Nek5000/issues/897>.

## Files

- `small.f` — declares `common /scruz/ x(4000)`
- `main.f`  — declares `common /scruz/ x(20000)` and writes `x(20000)`
- `build.sh` — `gfortran $FCFLAGS -c ...; gfortran $FCFLAGS $LDFLAGS ... -o test; ./test`

## Reproducing locally

```
sh build.sh                                              # default linker -> SIGBUS on macOS arm64 (Xcode 15+)
LDFLAGS=-Wl,-ld_classic sh build.sh                     # workaround: classic ld64
FCFLAGS=-flto LDFLAGS=-flto sh build.sh                 # workaround: gfortran LTO
LDFLAGS="-fuse-ld=lld -Wl,-arch,arm64 -Wl,-platform_version,macos,$(xcrun --show-sdk-version),$(xcrun --show-sdk-version)" sh build.sh   # workaround: LLVM lld
```

## CI

`.github/workflows/repro.yml` runs the reproducer on a matrix of:

- `ubuntu-22.04`, `ubuntu-24.04` (control — GNU ld picks max, expected to pass)
- `macos-13` (classic ld64 era, expected to pass)
- `macos-14`, `macos-15` (ld_prime, expected to fail with SIGBUS)

The three workaround invocations are also exercised on macOS 14/15 and expected to pass.
