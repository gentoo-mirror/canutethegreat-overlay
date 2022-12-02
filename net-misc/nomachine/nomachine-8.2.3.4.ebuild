# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper desktop

MY_V=$(ver_cut 1-2)
MY_PV=$(ver_rs 3 '_')

DESCRIPTION="NoMachine all-in-one package"
HOMEPAGE="https://www.nomachine.com"
SRC_URI="https://download.nomachine.com/download/${MY_V}/Linux/${PN}_${MY_PV}_x86_64.tar.gz"
S="${WORKDIR}/NX/etc/NX/server/packages"

LICENSE="nomachine"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="strip"

DEPEND=""
BDEPEND=""
RDEPEND="dev-libs/glib:2
		sys-libs/libudev-compat
		virtual/libcrypt:0
		dev-libs/openssl:0"

QA_PREBUILT="*"

src_install() {
	local NXROOT=/opt/NX

	###doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry "nxserver" "NoMachine Server" "" "Network"
	make_desktop_entry "nxnode" "NoMachine nxnode" "" "Network"
	make_desktop_entry "nxrunner" "NoMachine nxrunner" "" "Network"
	make_desktop_entry "nxplayer" "NoMachine Client" "" "Network"
	dodir /opt
	tar xzof nxserver.tar.gz -C "${D}"/opt
	tar xzof nxnode.tar.gz -C "${D}"/opt
	tar xzof nxrunner.tar.gz -C "${D}"/opt
	tar xzof nxplayer.tar.gz -C "${D}"/opt

	make_wrapper nxserver ${NXROOT}/bin/nxserver ${NXROOT} ${NXROOT}/lib /opt/bin
	make_wrapper nxnode ${NXROOT}/bin/nxnode ${NXROOT} ${NXROOT}/lib /opt/bin
	make_wrapper nxrunner ${NXROOT}/bin/nxrunner ${NXROOT} ${NXROOT}/lib /opt/bin
	make_wrapper nxplayer ${NXROOT}/bin/nxplayer ${NXROOT} ${NXROOT}/lib /opt/bin
}
