# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit xdg-utils font gnome2-utils eutils

KEYWORDS="~amd64"

DESCRIPTION="Insync extends Google Drive & OneDrive's web functionality to your desktop by integrating tightly with Linux so you can get work done"
HOMEPAGE="https://www.insynchq.com/"
SRC_URI="https://d2t3ff60b2tol4.cloudfront.net/builds/${PN}_${PV}-focal_amd64.deb"
###SRC_URI="https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.4.3.40990-focal_amd64.deb"

SLOT="0"
RESTRICT="strip mirror" # mirror as explained at bug #547372
LICENSE="insynchq-EULA"
IUSE=""

VRDEPEND="
	x11-misc/xdg-utils/xdg-utils
	dev-libs/nss
	app-crypt/gnupg
"

DEPEND="
"

S="${WORKDIR}"

src_prepare() {
	unpack ./control.tar.xz
	unpack ./data.tar.xz

	eapply_user

}

src_install() {
	doins -r usr
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	/usr/bin/gtk-update-icon-cache
}
