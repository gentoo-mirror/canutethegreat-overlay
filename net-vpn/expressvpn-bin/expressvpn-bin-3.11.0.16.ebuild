# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Commercial VPN"
HOMEPAGE="https://www.expressvpn.works/"
SRC_URI="https://www.expressvpn.works/clients/linux/expressvpn_${PV}-1_amd64.deb"

LICENSE="expressvpn"
SLOT="0"
KEYWORDS="-* ~amd64"

src_unpack(){
	unpack_deb ${A}
}

src_install(){
	cp -R "${WORKDIR}/usr" "${D}" || die "install failed!"
	cp -R "${WORKDIR}/lib" "${D}" || die "install failed!"
	cp -R "${WORKDIR}/etc" "${D}" || die "install failed!"
}
