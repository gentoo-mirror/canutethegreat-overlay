# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AUTOTOOLS_IN_SOURCE_BUILD=1

DESCRIPTION="Implementation of the EWF (SMART and EnCase) image format"
HOMEPAGE="https://github.com/libyal/libewf"
SRC_URI="https://github.com/libyal/libewf/releases/download/${PV}/libewf-experimental-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
# upstream bug #2597171, pyewf has implicit declarations
#IUSE="debug python unicode"
IUSE="bfio debug ewf +fuse +ssl static-libs +uuid unicode zlib"

DEPEND="
	sys-libs/zlib
	bfio? ( =app-forensics/libbfio-0.0.20120425_alpha )
	fuse? ( sys-fs/fuse:= )
	uuid? ( sys-apps/util-linux )
	ssl? ( dev-libs/openssl:0= )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README documents/header.txt documents/header2.txt )

src_configure() {
	econf \
		$(use_enable debug debug-output)\
		$(use_enable debug verbose-output)\
		$(use_enable ewf v1-api)\
		$(use_enable unicode wide-character-type)\
		$(use_with zlib auto-detect)\
		# autodetects bzip2 but does not use
		--without-bzip2\
		$(use_with bfio libbfio)\
		$(use_with ssl openssl)\
		$(use_with uuid libuuid)\
		$(use_with fuse libfuse)
}

src_install() {
	emake DESTDIR="${D}" install
	doman manuals/*.1 manuals/*.3
}
