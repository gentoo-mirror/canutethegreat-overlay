# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Linux desktop client for GeForce NOW, using Electron"
HOMEPAGE="https://github.com/hmlendea/gfn-electron"
SRC_URI="https://github.com/hmlendea/gfn-electron/releases/download/v${PV}/geforcenow-electron_${PV}_linux.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="x11-libs/libva"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	mkdir ${S}
	mv ${WORKDIR}/* ${S}
}

src_install() {
	insinto /opt/${PN}
	doins -r ${S}/*
	insinto /usr/share/applications
	doins ${S}/com.github.hmlendea.geforcenow-electron.desktop /usr/share/applications/
	fperms +x /opt/${PN}/geforcenow-electron
	dosym -r /opt/${PN}/geforcenow-electron /usr/bin/geforcenow
}
