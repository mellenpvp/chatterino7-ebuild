# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature xdg-utils

DESCRIPTION="Chat client for https://twitch.tv"
HOMEPAGE="https://github.com/SevenTV/chatterino7"
SRC_URI="
    https://github.com/SevenTV/chatterino7/archive/refs/tags/v7.5.1.tar.gz -> ${P}.tar.gz
"

S=${WORKDIR}/chatterino7-7.5.1

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
    dev-libs/openssl:=
    dev-libs/qtkeychain:=
    dev-qt/qtbase:6
    dev-qt/qttools:6
    dev-qt/qt5compat:6
    dev-qt/qtsvg:6
    dev-qt/qtimageformats:6
    net-im/libcommuni
    dev-cpp/magic_enum
    dev-libs/miniaudio
    dev-libs/rapidjson
    dev-cpp/websocketpp
    dev-libs/boost
    dev-util/pkgconf
    dev-build/cmake
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_prepare() {
    git submodule update --init --recursive
    rmdir --ignore-fail-on-non-empty ./lib/*/ ./cmake/*/ || die
    ln -sr ../libcommuni-* ./lib/libcommuni || die
    ln -sr ../magic_enum-* ./lib/magic_enum || die
    ln -sr ../miniaudio-* ./lib/miniaudio || die
    ln -sr ../rapidjson-* ./lib/rapidjson || die
    ln -sr ../serialize-* ./lib/serialize || die
    ln -sr ../settings-* ./lib/settings || die
    ln -sr ../signals-* ./lib/signals || die
    ln -sr ../websocketpp-* ./lib/websocketpp || die
    ln -sr ../sanitizers-cmake-* ./cmake/sanitizers-cmake || die
    cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
        -DBUILD_WITH_QT6=ON
        -DUSE_SYSTEM_QTKEYCHAIN=OFF
    )
    cmake_src_configure
}

src_install() {
    cmake_src_install
    mv "${D}"/usr/share/icons/hicolor/256x256/apps/{com.chatterino.,}chatterino.png || die
}

pkg_postinst() {
    xdg_icon_cache_update
    optfeature "for opening streams in a local video player" net-misc/streamlink
}

pkg_postrm() {
    xdg_icon_cache_update
}