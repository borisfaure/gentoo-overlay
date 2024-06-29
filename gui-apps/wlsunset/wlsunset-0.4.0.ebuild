# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Day/night gamma adjustments for Wayland compositors supporting wlr-gamma-control-unstable-v1."
HOMEPAGE="https://sr.ht/~kennylevinsen/wlsunset/"

SRC_URI="https://git.sr.ht/~kennylevinsen/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0"

DEPEND="dev-libs/wayland"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
"

src_configure() {
	meson_src_configure
}
