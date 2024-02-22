Few steps:

- download the release and extract it into /tmp/
- there, GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw -x
- tar --create --auto-compress --file miniflux-2.1.0-deps.tar.xz go-mod
- scp miniflux-2.1.0-deps.tar.xz macha.fau.re:/var/www/fau.re/htdocs/tmp/
- doas ebuild *.ebuild manifest
