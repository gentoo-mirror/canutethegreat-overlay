# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit fdo-mime font eutils versionator

KEYWORDS="~amd64 ~x86 ~arm64 ~arm ~ppc ~ppc64"

DESCRIPTION="EasyTether is an Android tethering client solution for Linux"
HOMEPAGE="http://www.mobile-stream.com/index.html"
SRC_URI="amd64? ( http://www.mobile-stream.com/beta/ubuntu/18.04/easytether_${PV}_amd64.deb )
		x86? ( http://www.mobile-stream.com/beta/ubuntu/18.04/easytether_${PV}_i386.deb )
		arm64? ( http://www.mobile-stream.com/beta/ubuntu/18.04/easytether_${PV}_arm64.deb )
		arm? ( http://www.mobile-stream.com/beta/ubuntu/18.04/easytether_${PV}_armhf.deb )
		ppc? ( http://www.mobile-stream.com/beta/ubuntu/18.04/easytether_${PV}_powerpc.deb )
		ppc64? ( http://www.mobile-stream.com/beta/ubuntu/18.04/easytether_${PV}_ppc64el.deb )"

SLOT="0"
RESTRICT="strip mirror" # mirror as explained at bug #547372
LICENSE="easytether-EULA"
IUSE=""

NATIVE_DEPEND=""

RDEPEND="
	${NATIVE_DEPEND}
"

DEPEND=""

S="${WORKDIR}"

src_prepare() {
	unpack ./control.tar.xz
	unpack ./data.tar.xz

	eapply_user
}

src_install() {
	doins -r usr
	doins -r etc
	doins -r lib
	doins -r var
}

pkg_postinst() {
	:
}

pkg_postrm() {
	:
}
