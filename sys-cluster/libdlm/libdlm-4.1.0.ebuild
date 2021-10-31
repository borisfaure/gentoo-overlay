# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib toolchain-funcs

DESCRIPTION="General-purpose Distributed Lock Manager Library"
HOMEPAGE="https://pagure.io/dlm/"
SRC_URI="https://pagure.io/dlm/archive/dlm-${PV}/dlm-dlm-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa x86"
IUSE="static-libs"

RDEPEND="
        !sys-cluster/dlm-headers
        !sys-cluster/dlm-kernel
        !sys-cluster/dlm-lib"
DEPEND="${RDEPEND}
        sys-cluster/corosync
        >=sys-kernel/linux-headers-2.6.24"

S="${WORKDIR}/dlm-dlm-${PV}"



src_compile() {
        emake -C libdlm
}

src_install() {
        emake DESTDIR="${D}" -C libdlm install
        mv "${D}"/$(get_libdir) "${D}"/lib
        use static-libs || rm -f "${D}"/usr/lib*/*.a
        for i in libdlm/man/*; do
                doman $i
        done
}

