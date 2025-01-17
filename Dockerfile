FROM ubuntu:16.04

LABEL maintainer="Gooroomee ycs <robin.lee@gooroomee.com>"

COPY copyables /

ADD https://dl.google.com/linux/linux_signing_key.pub /tmp/

RUN apt-key add /tmp/linux_signing_key.pub \
	&& sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y \
	google-chrome-stable \
	chrome-remote-desktop \
	fonts-takao \
	pulseaudio \
	supervisor \
	x11vnc \
	fluxbox \
	&& apt-get clean \
	&& rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/* \
	&& useradd -m -G chrome-remote-desktop,pulse-access chrome \
	&& usermod -s /bin/bash chrome \
	&& ln -s /crdonly /usr/local/sbin/crdonly \
	&& ln -s /update /usr/local/sbin/update \
	&& mkdir -p /home/chrome/.config/chrome-remote-desktop \
	&& mkdir -p /home/chrome/.fluxbox \
	&& echo ' \n\
		session.screen0.toolbar.visible:        false\n\
		session.screen0.fullMaximization:       true\n\
		session.screen0.maxDisableResize:       true\n\
		session.screen0.maxDisableMove: true\n\
		session.screen0.defaultDeco:    NONE\n\
	' >> /home/chrome/.fluxbox/init \
	&& chown -R chrome:chrome /home/chrome/.config /home/chrome/.fluxbox

VOLUME ["/home/chrome"]

EXPOSE 5900

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
