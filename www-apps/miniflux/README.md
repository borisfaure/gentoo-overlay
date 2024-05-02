Few steps:

- download the release
  ```
   wget https://github.com/miniflux/v2/archive/refs/tags/2.1.3.tar.gz
  ```
- and extract it into `/tmp/`
  ```
  tar xvzf 2.1.3.tar.gz  -C /tmp/
  ```
- there,
  ```
  GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw -x
  ```
- generate the tarball
  ```
  tar --create --auto-compress --file miniflux-2.1.3-deps.tar.xz go-mod
  ```
- host the tarball
  ```
  scp miniflux-2.1.3-deps.tar.xz macha.fau.re:/var/www/fau.re/htdocs/tmp/
  ```
- generate the manifest
  ```
  doas ebuild *.ebuild manifest
  ```
