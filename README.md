Minimal Fortran SIGBUS reproducer for the new Apple linker (ld_prime, Xcode 15+) when COMMON blocks are declared at different sizes per source file.

See <https://github.com/Nek5000/Nek5000/issues/897>.

```
$ sh build.sh                                            # SIGBUS
$ LDFLAGS=-Wl,-ld_classic sh build.sh                    # survives
$ FCFLAGS=-flto LDFLAGS=-flto sh build.sh                # survives
$ LDFLAGS="-fuse-ld=lld -Wl,-arch,arm64 -Wl,-platform_version,macos,$(xcrun --show-sdk-version),$(xcrun --show-sdk-version)" sh build.sh   # survives
```

CI matrix in `.github/workflows/repro.yml`: ubuntu 22.04/24.04, macos-13/14/15.  Default-ld is expected to fail on macos-14/15 only.

```
$ gh run list   --repo slitvinov/ld-prime-common-bug
$ gh run watch  --repo slitvinov/ld-prime-common-bug
$ gh run view   --repo slitvinov/ld-prime-common-bug --log-failed
$ gh workflow run "ld_prime SIGBUS reproducer" --repo slitvinov/ld-prime-common-bug
```
