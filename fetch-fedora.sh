#!/usr/bin/env bash

set -euxo pipefail

OUTDIR=$(pwd)/fedora
RELEASE_VER=39
# Upstream: https://src.fedoraproject.org/rpms/fedora-release
VARIANTS=(
	cinnamon
	cloud
	compneuro
	container
	coreos
	designsuite
	i3
	iot
	kde
	kinoite
	matecompiz
	server
	silverblue
	snappy
	soas
	workstation
	xfce
	# Release >= 38
	budgie
	lxqt
	sericea
	sway
	# Release >= 39
	mobility
	onyx
)
PKG_PREFIX=fedora-release-identity

# Download packages
workdir=$(mktemp -d)
cd "${workdir}"
dnf download \
	--repo=fedora \
	--releasever="${RELEASE_VER}" \
	$(printf "${PKG_PREFIX}-%s " "${VARIANTS[@]}")

# Unpack packages
rpm2archive --nocompression fedora-release-identity-*.rpm
for var in "${VARIANTS[@]}"; do
	mkdir -p "${var}" "${OUTDIR}/${var}"
	tar -xf "${PKG_PREFIX}-${var}"*.tar -C "${var}"
	mv "${var}/usr/lib/os-release" "${OUTDIR}/${var}/${RELEASE_VER}"
done
rm -r "${workdir}"
