# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin vcs-snapshot

MY_PN="${PN/-/.}"
REF="59e5e2f8b7df21eb438124b95c7295da9c53e1d7"

DESCRIPTION="Vim configuration for Rust"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="https://github.com/rust-lang/${MY_PN}/tarball/${REF} -> ${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
