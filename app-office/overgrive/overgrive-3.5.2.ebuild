# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit xdg-utils font gnome2-utils eutils

KEYWORDS="~amd64 ~x86 ~arm ~arm64"

PYTHON_COMPAT=( python3_{5..12} )

DESCRIPTION="overGrive is a complete Google Drive desktop client solution for Linux"
HOMEPAGE="https://www.thefanclub.co.za/overgrive"
SRC_URI="${PN}_${PV}.deb"

SLOT="0"
RESTRICT="fetch strip mirror" # mirror as explained at bug #547372
LICENSE="fanclub-EULA"
IUSE=""

RDEPEND="
	dev-libs/libappindicator
	dev-python/pyinotify
	>=dev-python/google-api-python-client-1.5.3
"

DEPEND="
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download"
	einfo "  - overgrive_${PV}_all.deb -> ${PN}_${PV}.deb"
	einfo "from ${HOMEPAGE} and place them in your DISTDIR directory."
}

src_prepare() {
	unpack ./control.tar.gz
	unpack ./data.tar.gz

	eapply_user

}

src_install() {
	doins -r opt
	doins -r usr
	cp ${FILESDIR}/overgrive ${D}/bin
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	/usr/bin/gtk-update-icon-cache
	/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas/
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	/usr/bin/gtk-update-icon-cache
}
