SIGBUS on the new Apple linker (ld_prime, Xcode 15+) when Fortran COMMON blocks are declared at different sizes per source file.

See <https://github.com/Nek5000/Nek5000/issues/897>.

```
$ sh build.sh
$ LDFLAGS=-Wl,-ld_classic sh build.sh
$ FCFLAGS=-flto LDFLAGS=-flto sh build.sh
$ LDFLAGS="-fuse-ld=lld -Wl,-arch,arm64 -Wl,-platform_version,macos,$(xcrun --show-sdk-version),$(xcrun --show-sdk-version)" sh build.sh
```

CI matrix in `.github/workflows/repro.yml`: ubuntu 22.04/24.04, macos-13/14/15.

```
$ gh run list   --repo slitvinov/ld-prime-common-bug
$ gh run watch  --repo slitvinov/ld-prime-common-bug
$ gh run view   --repo slitvinov/ld-prime-common-bug --log-failed
$ gh workflow run "ld_prime SIGBUS reproducer" --repo slitvinov/ld-prime-common-bug
```
