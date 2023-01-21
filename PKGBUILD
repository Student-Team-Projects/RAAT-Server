# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.

# Maintainers: (refer to the gitlab page)
pkgname="raat"
pkgver="1.0.0"
pkgrel=1
epoch=
pkgdesc="Remote Archlinux Android Tool (server)"
arch=('any')
url="https://gitlab.com/ia-projekt-zespolowy-2022-2023/raat-server"
license=('GPL')
groups=()
depends=('cinnamon' 'tigervnc' 'openssh')
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=("script.sh")
noextract=()
md5sums=("SKIP")
validpgpkeys=()

package() {
    mkdir -p "${pkgdir}/usr/bin"
    cp "${srcdir}/script.sh" "${pkgdir}/usr/bin/raat-server"
    chmod +x "${pkgdir}/usr/bin/raat-server"
}

