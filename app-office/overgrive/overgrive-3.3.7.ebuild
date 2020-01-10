# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit fdo-mime font gnome2-utils eutils versionator

KEYWORDS="~amd64 ~x86"

DESCRIPTION="overGrive is a complete Google Drive desktop client solution for Linux"
HOMEPAGE="https://www.thefanclub.co.za/overgrive"
SRC_URI="
https://www.thefanclub.co.za/sites/default/files/public/overgrive/overgrive_${PV}_all.deb -> ${PN}_${PV}.deb
"

SLOT="0"
RESTRICT="strip mirror" # mirror as explained at bug #547372
LICENSE="fanclub-EULA"
IUSE=""

NATIVE_DEPEND="
	>=dev-python/google-api-python-client-1.5.3
"

RDEPEND="
	${NATIVE_DEPEND}
"

DEPEND="
"

S="${WORKDIR}"

src_prepare() {
	unpack ./control.tar.gz
	unpack ./data.tar.xz

	eapply "${FILESDIR}/${PN}.desktop.patch"

	eapply_user
}

src_install() {
	doins -r opt
	doins -r usr
	fperms 755 /opt/thefanclub/overgrive/overgrive
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
