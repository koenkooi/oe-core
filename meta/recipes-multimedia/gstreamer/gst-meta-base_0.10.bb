DESCRIPTION = "Gstreamer package groups"
LICENSE = "MIT"
DEPENDS = "gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=3f40d7994397109285ec7b81fdeb3b58 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"


PR = "r11"

PACKAGES = "\
    gst-meta-base \
    gst-meta-audio \
    gst-meta-debug \
    gst-meta-video"

ALLOW_EMPTY = "1"

RDEPENDS_gst-meta-base = "\
    gstreamer \
    gst-plugin-playbin \
    gst-plugin-decodebin \
    gst-plugin-decodebin2 \
    gst-plugin-gio \
    gst-plugin-alsa \
    gst-plugin-volume \
    gst-plugin-ximagesink \
    gst-plugin-audioconvert \
    gst-plugin-audioresample \
    gst-plugin-typefindfunctions \
    gst-plugin-videoscale \
    gst-plugin-ffmpegcolorspace \
    gst-plugin-autodetect \
    gst-plugin-souphttpsrc"


RDEPENDS_gst-meta-audio = "\
    gst-meta-base \
    gst-plugin-vorbis \
    gst-plugin-ogg \
    gst-plugin-wavparse \
    gst-plugin-flac \
    ${COMMERCIAL_AUDIO_PLUGINS}"


RDEPENDS_gst-meta-debug = "\
    gst-meta-base \
    gst-plugin-debug \
    gst-plugin-audiotestsrc \
    gst-plugin-videotestsrc"


RDEPENDS_gst-meta-video = "\
    gst-meta-base \
    gst-plugin-avi \
    gst-plugin-matroska \
    gst-plugin-theora \
    ${COMMERCIAL_VIDEO_PLUGINS}"

RRECOMMENDS_gst-meta-video = "\
    gst-meta-audio"
