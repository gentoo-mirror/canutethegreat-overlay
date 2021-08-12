# Copyright 2020-2021 LiGurOs Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

DESCRIPTION="Fast, dense and secure container management"
HOMEPAGE="https://linuxcontainers.org/lxd/introduction/"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT MPL-2.0"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 x86"

IUSE="+daemon +ipv6 +dnsmasq nls test +tools"

inherit autotools bash-completion-r1 linux-info systemd user

SRC_URI="https://linuxcontainers.org/downloads/${PN}/${P}.tar.gz"

DEPEND="
	acct-group/lxd
	>=dev-libs/raft-0.9.22
	>=dev-db/sqlite-3.25
	dev-lang/tcl
	>=dev-lang/go-1.9.4
	dev-libs/libuv
	dev-libs/protobuf
	nls? ( sys-devel/gettext )
	test? (
		app-misc/jq
		net-misc/curl
		sys-devel/gettext
	)
"

RDEPEND="
	daemon? (
		dev-libs/raft
		app-arch/xz-utils
		>=app-emulation/lxc-4.0.0
		dev-libs/libuv
		dev-libs/lzo
		dev-util/xdelta:3
		dnsmasq? (
			net-dns/dnsmasq[dhcp,ipv6?]
		)
		net-firewall/ebtables
		net-firewall/iptables[ipv6?]
		net-libs/libnfnetlink
		net-libs/libnsl:0=
		net-misc/rsync[xattr]
		sys-apps/iproute2[ipv6?]
		sys-fs/fuse
		sys-fs/lxcfs
		sys-fs/squashfs-tools[lzma]
		virtual/acl
	)
"

CONFIG_CHECK="
	~BRIDGE
	~DUMMY
	~IP6_NF_NAT
	~IP6_NF_TARGET_MASQUERADE
	~IPV6
	~IP_NF_NAT
	~IP_NF_TARGET_MASQUERADE
	~MACVLAN
	~NETFILTER_XT_MATCH_COMMENT
	~NET_IPGRE
	~NET_IPGRE_DEMUX
	~NET_IPIP
	~NF_NAT_MASQUERADE_IPV4
	~NF_NAT_MASQUERADE_IPV6
	~VXLAN
"

ERROR_BRIDGE="BRIDGE: needed for network commands"
ERROR_DUMMY="DUMMY: needed for network commands"
ERROR_IP6_NF_NAT="IP6_NF_NAT: needed for network commands"
ERROR_IP6_NF_TARGET_MASQUERADE="IP6_NF_TARGET_MASQUERADE: needed for network commands"
ERROR_IPV6="IPV6: needed for network commands"
ERROR_IP_NF_NAT="IP_NF_NAT: needed for network commands"
ERROR_IP_NF_TARGET_MASQUERADE="IP_NF_TARGET_MASQUERADE: needed for network commands"
ERROR_MACVLAN="MACVLAN: needed for network commands"
ERROR_NETFILTER_XT_MATCH_COMMENT="NETFILTER_XT_MATCH_COMMENT: needed for network commands"
ERROR_NET_IPGRE="NET_IPGRE: needed for network commands"
ERROR_NET_IPGRE_DEMUX="NET_IPGRE_DEMUX: needed for network commands"
ERROR_NET_IPIP="NET_IPIP: needed for network commands"
ERROR_NF_NAT_MASQUERADE_IPV4="NF_NAT_MASQUERADE_IPV4: needed for network commands"
ERROR_NF_NAT_MASQUERADE_IPV6="NF_NAT_MASQUERADE_IPV6: needed for network commands"
ERROR_VXLAN="VXLAN: needed for network commands"

EGO_PN="github.com/lxc/lxd"

src_prepare() {
	default
	eapply_user

	cd "${S}/_dist/deps/dqlite" || die "Can't cd to dqlite dir"
	eautoreconf
}

src_configure() {
	export GOPATH="${S}/_dist"

	cd "${GOPATH}/deps/dqlite" || die "Can't cd to dqlite dir"
	econf --libdir=${EPREFIX}/usr/lib/lxd
}

src_compile() {
	export GOPATH="${S}/_dist"

	cd "${GOPATH}/deps/dqlite" || die "Can't cd to dqlite dir"
	emake CFLAGS="-I${GOPATH}/deps/sqlite" LDFLAGS="-L${GOPATH}/deps/sqlite"

	# We don't use the Makefile here because it builds targets with the
	# assumption that `pwd` is in a deep gopath namespace, which we're not.
	# It's simpler to manually call "go install" than patching the Makefile.
	cd "${S}"
	GO111MODULE=auto go install -v -x ${EGO_PN}/lxc || die "Failed to build the client"

	if use daemon; then

		# LXD depends on a patched, bundled sqlite with replication
		# capabilities.
		export CGO_CFLAGS="-I${GOPATH}/deps/dqlite/include/"
		export CGO_LDFLAGS="-L${GOPATH}/deps/dqlite/.libs/ -Wl,-rpath,${EPREFIX}/usr/lib/lxd"
		export LD_LIBRARY_PATH="${GOPATH}/deps/dqlite/.libs/"

		GO111MODULE=auto go install -v -x ${EGO_PN}/lxd || die "Failed to build the daemon"
	fi

	if use tools; then
		GO111MODULE=auto go install -v -x ${EGO_PN}/fuidshift || die "Failed to build fuidshift"
		GO111MODULE=auto go install -v -x ${EGO_PN}/lxc-to-lxd || die "Failed to build lxc-to-lxd"
		GO111MODULE=auto go install -v -x ${EGO_PN}/lxd-agent || die "Failed to build lxd-agent"
		GO111MODULE=auto go install -v -x ${EGO_PN}/lxd-benchmark || die "Failed to build lxd-benchmark"
		GO111MODULE=auto go install -v -x ${EGO_PN}/lxd-p2c || die "Failed to build lxd-p2c"
	fi

	use nls && emake build-mo

	mkdir _dist/man
	./_dist/bin/lxc manpage _dist/man/
}

src_test() {
	if use daemon; then
		export GOPATH="${S}/_dist"
		# This is mostly a copy/paste from the Makefile's "check" rule, but
		# patching the Makefile to work in a non "fully-qualified" go namespace
		# was more complicated than this modest copy/paste.
		# Also: sorry, for now a network connection is needed to run tests.
		# Will properly bundle test dependencies later.
		go get -v -x github.com/rogpeppe/godeps
		go get -v -x github.com/remyoudompheng/go-misc/deadcode
		go get -v -x github.com/golang/lint/golint
		go test -v ${EGO_PN}/lxd
	else
		einfo "No tests to run for client-only builds"
	fi
}

src_install() {
	local bindir="_dist/bin"
	dobin ${bindir}/lxc
	if use daemon; then

		export GOPATH="${S}/_dist"

		cd "${GOPATH}/deps/dqlite" || die "Can't cd to dqlite dir"
		emake DESTDIR="${D}" install

		# Must only install libs
		rm -r "${D}/usr/include" || die "Can't remove include directory"

		cd "${S}" || die "Can't cd to \${S}"
		dosbin ${bindir}/lxd
	fi

	if use tools; then
		dobin ${bindir}/fuidshift
		dobin ${bindir}/lxc-to-lxd
		dobin ${bindir}/lxd-agent
		dobin ${bindir}/lxd-benchmark
		dobin ${bindir}/lxd-p2c
	fi

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${PN}-sysctl.conf" 60-${PN}.conf

	if use nls; then
		domo po/*.mo
	fi

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd lxd
		newconfd "${FILESDIR}"/${PN}.confd lxd

		systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
	fi

	newbashcomp scripts/bash/lxd-client lxc

	doman _dist/man/*
	dodoc AUTHORS doc/*
}

pkg_postinst() {
	elog
	elog "Consult https://wiki.gentoo.org/wiki/LXD for more information,"
	elog "including a Quick Start."

	# The messaging below only applies to daemon installs
	use daemon || return 0

	# Ubuntu also defines an lxd user but it appears unused (the daemon
	# must run as root)
	elog
	elog "Though not strictly required, some features are enabled at run-time"
	elog "when the relevant helper programs are detected:"
	elog "- sys-apps/apparmor"
	elog "- sys-fs/btrfs-progs"
	elog "- sys-fs/lvm2"
	elog "- sys-fs/zfs"
	elog "- sys-process/criu"
	elog
	elog "Since these features can't be disabled at build-time they are"
	elog "not USE-conditional."
	elog
	elog "Be sure to add your local user to the lxd group."
	elog
	elog "Networks with bridge.mode=fan are unsupported due to requiring"
	elog "a patched kernel and iproute2."
}

