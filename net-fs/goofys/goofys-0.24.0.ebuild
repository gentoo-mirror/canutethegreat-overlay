# Copyright 1999-2023 Gentoo 
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/kahing/goofys"

inherit golang-vcs-snapshot

DESCRIPTION="A high-performance, user-space file system for mounting Amazon S3 buckets"
HOMEPAGE="https://github.com/kahing/goofys"
SRC_URI="https://${EGO_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64 ~arm"

DEPEND="dev-lang/go"
RDEPEND=""

S="${WORKDIR}/${P}"

src_compile() {
    GOPATH="${S}" emake -C src/github.com/kahing/goofys
}

src_install() {
    dobin src/github.com/kahing/goofys/goofys
    dodoc README.md CHANGELOG.md
}

