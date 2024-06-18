# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# Get with 'git rev-parse --short HEAD'
MY_GIT_COMMIT="f3bc8930983f"

DESCRIPTION="A simple clipboard manager for Wayland"
HOMEPAGE="https://github.com/chmouel/clipman"
SRC_URI="https://github.com/chmouel/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://fau.re/tmp/${P}-deps.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # requires network access

DEPEND=""
RDEPEND=""

S="${WORKDIR}/clipman-${PV}"

src_compile() {
	ego build
}

src_install() {
	dobin clipman
}
