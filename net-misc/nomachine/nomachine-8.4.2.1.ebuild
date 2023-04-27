# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper desktop

MY_V=$(ver_cut 1-2)
MY_PV=$(ver_rs 3 '_')

DESCRIPTION="NoMachine all-in-one package"
HOMEPAGE="https://www.nomachine.com"
SRC_URI="amd64? ( https://download.nomachine.com/download/${MY_V}/Linux/${PN}_${MY_PV}_x86_64.tar.gz )
arm64? ( https://download.nomachine.com/download/${MY_V}/Arm/${PN}_${MY_PV}_aarch64.tar.gz )"
S="${WORKDIR}/NX/etc/NX/server/packages"

LICENSE="nomachine"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+nxserver +nxnode +nxrunner +nxplayer"
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
	###doicon "${NXROOT}/share/icons/48x48/NoMachine-desktop.png"
	dodir /opt

	if use nxserver ; then
		tar xzof nxserver.tar.gz -C "${D}"/opt
		make_desktop_entry "/opt/bin/nxserver" "nxserver" "${NXROOT}/share/icons/48x48/NoMachine-desktop.png" "Network" ""
		make_wrapper nxserver ${NXROOT}/bin/nxserver ${NXROOT} ${NXROOT}/lib /opt/bin
	fi
	if use nxnode ; then
		tar xzof nxnode.tar.gz -C "${D}"/opt
		make_desktop_entry "/opt/bin/nxnode" "nxnode" "${NXROOT}/share/icons/48x48/NoMachine-desktop.png" "Network" ""
		make_wrapper nxnode ${NXROOT}/bin/nxnode ${NXROOT} ${NXROOT}/lib /opt/bin
	fi
	if use nxrunner ; then
		tar xzof nxrunner.tar.gz -C "${D}"/opt
		make_desktop_entry "/opt/bin/nxrunner" "nxrunner" "${NXROOT}/share/icons/48x48/NoMachine-desktop.png" "Network" ""
		make_wrapper nxrunner ${NXROOT}/bin/nxrunner ${NXROOT} ${NXROOT}/lib /opt/bin
	fi
	if use nxplayer ; then
		tar xzof nxplayer.tar.gz -C "${D}"/opt
		make_desktop_entry "/opt/bin/nxplayer" "nxplayer" "${NXROOT}/share/icons/48x48/NoMachine-desktop.png" "Network" ""
		make_wrapper nxplayer ${NXROOT}/bin/nxplayer ${NXROOT} ${NXROOT}/lib /opt/bin
	fi
}
