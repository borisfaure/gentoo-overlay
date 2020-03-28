# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Other Implementations letters. Figlet replacement"
HOMEPAGE="http://caca.zoy.org/wiki/toilet"

KEYWORDS="~amd64 ~x86"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://github.com/cacalabs/${PN}.git"
else
	SRC_URI="http://caca.zoy.org/raw-attachment/wiki/${PN}/${P}.tar.gz"
fi

PROPERTIES+=" live"

LICENSE="WTFPL-2"
SLOT="0"

RDEPEND=">=media-libs/libcaca-0.99_beta18"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
if [[ ${PV} == "9999" ]] ; then
	# Remove problematic LDFLAGS declaration
	sed -i -e '/^LDFLAGS/d' src/Makefile.am || die

	# Rerun autotools
	einfo "Regenerating autotools files..."
	WANT_AUTOCONF=2.69 eautoreconf
	WANT_AUTOCONF=2.69 eautoconf
	eapply_user
	eautomake
else
	sed -i \
		-e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' \
		configure || die
	eapply_user
fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog NEWS README TODO
}
