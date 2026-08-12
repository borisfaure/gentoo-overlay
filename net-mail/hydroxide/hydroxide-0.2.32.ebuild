# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module multiprocessing

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emersion/hydroxide.git"
else
	inherit verify-sig
	SRC_URI="https://github.com/emersion/${PN}/releases/download/v${PV}/${P}.tar.gz
		verify-sig? ( https://github.com/emersion/${PN}/releases/download/v${PV}/${P}.tar.gz.sig )
		https://fau.re/tmp/${P}-vendor.tar.xz
	"
	# guru-depfiles has no depfile for this version, so the vendor tarball is
	# self-hosted. Generate it with:
	# $ GOMODCACHE="${PWD}"/../go-mod go mod vendor
	# $ XZ_OPT='-T0 -9' tar -acf ${P}-vendor.tar.xz ${P}/vendor
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-emersion )"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A third-party, open-source ProtonMail CardDAV, IMAP and SMTP bridge"
HOMEPAGE="https://github.com/emersion/hydroxide"

LICENSE="MIT"
#gentoo-go-license hydroxide-0.2.32.ebuild
LICENSE+=" BSD MIT "
SLOT="0"
BDEPEND+=" >=dev-lang/go-1.24.0"
DOCS=( README.md )

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		if use verify-sig; then
			verify-sig_verify_detached "${DISTDIR}/${P}".tar.gz{,.sig}
		fi
		go-module_src_unpack
	fi
}

src_compile() {
	ego build -mod=vendor -v -x -p "$(get_makeopts_jobs)" ./cmd/hydroxide
}

src_install() {
	default
	dobin "${PN}"
}
