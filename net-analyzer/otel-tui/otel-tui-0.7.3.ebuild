# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Terminal UI viewer for OpenTelemetry telemetry data"
HOMEPAGE="https://github.com/ymtdzzz/otel-tui"
SRC_URI="https://github.com/ymtdzzz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://fau.re/tmp/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

src_compile() {
	GOWORK=off ego build -mod=vendor -o "${PN}" .
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
