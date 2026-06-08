# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 go-module

DESCRIPTION="Terminal UI for monitoring OpenMetrics/Prometheus metrics in real-time"
HOMEPAGE="https://github.com/michaelvl/openmetrics-tui"
EGIT_REPO_URI="https://github.com/michaelvl/${PN}.git"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""

RESTRICT="mirror test"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	CGO_ENABLED=0 ego build -o "${PN}" .
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
