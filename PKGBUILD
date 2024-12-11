# Maintainers: (refer to the gitlab page)
pkgname="raat-server"
pkgver="1.0.0"
pkgrel=1
epoch=
pkgdesc="Remote Archlinux Android Tool (server) for managing and connecting to VNC sessions"
arch=('any')
url="https://github.com/Student-Team-Projects/RAAT-Server"
license=('GPL')
groups=()
depends=('cinnamon' 'tigervnc' 'openssh' 'lxde-common' 'jq')
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
source=("raat-server.sh" "raat-connect.sh" "raat-close-session.sh" "raat-server-request.sh")
noextract=()
sha256sums=('SKIP' 'SKIP' 'SKIP' 'SKIP')
validpgpkeys=()

package() {
    mkdir -p "${pkgdir}/usr/bin"

    # Install the raat-server script
    cp "${srcdir}/raat-server.sh" "${pkgdir}/usr/bin/raat-server"
    chmod +x "${pkgdir}/usr/bin/raat-server"

    # Install the raat-connect script
    cp "${srcdir}/raat-connect.sh" "${pkgdir}/usr/bin/raat-connect"
    chmod +x "${pkgdir}/usr/bin/raat-connect"

    # Install the raat-server-request script
    cp "${srcdir}/raat-server-request.sh" "${pkgdir}/usr/bin/raat-server-request"
    chmod +x "${pkgdir}/usr/bin/raat-server-request"

    # Install the raat-close-session script
    cp "${srcdir}/raat-close-session.sh" "${pkgdir}/usr/bin/raat-close-session"
    chmod +x "${pkgdir}/usr/bin/raat-close-session"
}
