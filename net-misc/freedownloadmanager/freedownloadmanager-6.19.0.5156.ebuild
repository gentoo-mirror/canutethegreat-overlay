# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit xdg-utils font eutils

KEYWORDS="~amd64"

DESCRIPTION="Free Download Manager allows you to adjust traffic usage, organize downloads, control file priorities for torrents, efficiently download large files and resume broken downloads."
HOMEPAGE="https://www.freedownloadmanager.org/"
SRC_URI="https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb"

SLOT="0"
RESTRICT="strip"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-libs/openssl
	x11-misc/xdg-utils
	media-video/ffmpeg
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	net-libs/libtorrent
"

DEPEND="
"

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
	dosym /opt/thefanclub/overgrive/__pycache__/overgrive.cpython-36.pyc /opt/thefanclub/overgrive/overgrive
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
