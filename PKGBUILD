# Maintainer: gcb

pkgname=dumb_ups
pkgver=1
pkgrel=1
pkgdesc='Monitor network interface as an alternative for a smart UPS.'
url='about:blank'
arch=(any)
# see https://spdx.org/licenses
license=('AGPL-3.0-only')
#install=${pkgname}.install
depends=(
)
# just like the arch base package
# a kernel should be optional
# so we can use this in containers?
# TODO: ^
optdepends=(
#	'beep'
)

source=(
	'dumb_ups.sh'
	'dumb_ups.service'
	'dumb_ups.timer'
)
#sha256sums=('SKIP')
sha256sums=(
	'a0a5650166d3fb57ec039b55f45aacef33181d7940a28750ffc407e7a90ec70b' #  dumb_ups.sh
	'094a2309d03d07553419f83f5d202409301d7a0654433c8eb6be7c944c082e71' #  dumb_ups.service
	'2de76ebde7782eec151778951a43d009aff7b8ce3845901b44d253ef17691268' #  dumb_ups.timer
)

package() {
	install -Dm 0644 dumb_ups.sh      "$pkgdir/sbin/dumb_ups.sh"
	install -Dm 0644 dumb_ups.service "$pkgdir/etc/systemd/system/dumb_ups.service"
	install -Dm 0644 dumb_ups.timer   "$pkgdir/etc/systemd/system/dumb_ups.timer"
}
# NOTE: if you have to overwrite settings files,
#       see https://disconnected.systems/blog/archlinux-meta-packages/#overwriting-existing-configs
#       but hopefully everything will have .d dir :)
