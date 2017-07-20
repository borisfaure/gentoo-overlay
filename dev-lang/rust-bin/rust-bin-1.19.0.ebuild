# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils bash-completion-r1

MY_P="rust-${PV}"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="amd64? ( http://static.rust-lang.org/dist/${MY_P}-x86_64-unknown-linux-gnu.tar.xz )
	x86? ( http://static.rust-lang.org/dist/${MY_P}-i686-unknown-linux-gnu.tar.xz )"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="stable"
KEYWORDS="~amd64 ~x86"
IUSE="cargo doc"

DEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
	!dev-lang/rust:0
"
RDEPEND="${DEPEND}"

src_unpack() {
	default

	local postfix
	use amd64 && postfix=x86_64-unknown-linux-gnu
	use x86 && postfix=i686-unknown-linux-gnu
	mv "${WORKDIR}/${MY_P}-${postfix}" "${S}" || die
}

src_install() {
	echo "rustc" > components
	if use x86 ; then
		echo "rust-std-x86-unknown-linux-gnu" >> components
	fi
	if use amd64 ; then
		echo "rust-std-x86_64-unknown-linux-gnu" >> components
	fi
	if use cargo ;  then
		echo "cargo" >> components
	fi
	if use doc;  then
		echo "rust-docs" >> components
	fi
	cat components
	./install.sh \
		--prefix="${D}/opt/${P}" \
		--mandir="${D}/usr/share/${P}/man" \
		--disable-ldconfig \
		|| die

	local rustc=rustc-bin-${PV}
	local rustdoc=rustdoc-bin-${PV}
	local rustgdb=rust-gdb-bin-${PV}
	if use cargo ;  then
		local cargo=cargo-bin-${PV}
	fi

	mv "${D}/opt/${P}/bin/rustc" "${D}/opt/${P}/bin/${rustc}" || die
	mv "${D}/opt/${P}/bin/rustdoc" "${D}/opt/${P}/bin/${rustdoc}" || die
	mv "${D}/opt/${P}/bin/rust-gdb" "${D}/opt/${P}/bin/${rustgdb}" || die
	if use cargo ;  then
		mv "${D}/opt/${P}/bin/cargo" "${D}/opt/${P}/bin/${cargo}" || die
	fi

	dosym "/opt/${P}/bin/${rustc}" "/usr/bin/${rustc}"
	dosym "/opt/${P}/bin/${rustdoc}" "/usr/bin/${rustdoc}"
	dosym "/opt/${P}/bin/${rustgdb}" "/usr/bin/${rustgdb}"
	if use cargo ;  then
		dosym "/opt/${P}/bin/${cargo}" "/usr/bin/${cargo}"
	fi
	if use doc;  then
		dosym "/opt/${P}/share/doc/" "/usr/share/doc/${MY_P}"
	fi

	cat <<-EOF > "${T}"/50${P}
	LDPATH="/opt/${P}/lib"
	MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
	/usr/bin/rustdoc
	/usr/bin/rust-gdb
	EOF
	if use cargo ;  then
		cat <<-EOF >> "${T}/provider-${P}"
		/usr/bin/cargo
		EOF
	fi
	dodir /etc/env.d/rust
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb-bin-${PV},"

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-mode to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
