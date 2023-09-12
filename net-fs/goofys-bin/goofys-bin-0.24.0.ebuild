# Copyright 1999-2023 Gentoo 
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A high-performance, user-space file system for mounting Amazon S3 buckets (binary)"
HOMEPAGE="https://github.com/kahing/goofys"
SRC_URI="https://github.com/kahing/goofys/releases/download/v${PV}/goofys -> ${P}-amd64"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND=""

QA_PREBUILT="*"

S="${WORKDIR}"

src_unpack() {
    cp "${DISTDIR}/${P}-$(usex amd64 amd64 x86)" "${S}/${PN}" || die
}

src_install() {
    dobin "${S}/${PN}"
}

