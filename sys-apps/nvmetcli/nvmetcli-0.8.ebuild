# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 git-r3

DESCRIPTION="Command line interface for the kernel NVMe target"
HOMEPAGE="http://git.infradead.org/users/hch/nvmetcli.git"
EGIT_REPO_URI="git://git.infradead.org/users/hch/nvmetcli.git"
EGIT_COMMIT="v${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/configshell-fb[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
"

src_prepare() {
	# Fix installation paths to use /usr/bin instead of /usr/sbin
	sed -i 's|/usr/sbin|/usr/bin|' setup.cfg nvmet.service || die

	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile

	# Build documentation
	emake -C Documentation
}

src_install() {
	distutils-r1_src_install

	# Install systemd service file
	systemd_dounit nvmet.service

	# Install documentation
	dodoc README *.json
	dodoc Documentation/nvmetcli.txt
	doman Documentation/nvmetcli.8
}
