FROM balenalib/armv7hf-debian-node:12-buster-build
RUN echo "deb [arch=armhf] http://repos.rcn-ee.net/debian/ buster main" >> /etc/apt/sources.list \
	&& apt-key adv --batch --keyserver keyserver.ubuntu.com --recv-key D284E608A4C46402
ENV UDEV=1
RUN install_packages apt-utils

WORKDIR /var/run/beagle
COPY . /var/run/beagle

RUN install_packages \
  tio usbutils \
  less \
  iputils-ping \
  i2c-tools \
  kmod \
  nano \
  net-tools \
  ifupdown \
  xz-utils file \
  git wget libiio-dev \
  vim-tiny \
  dnsmasq wireless-tools \
  bsdmainutils \
  libiio-utils \
  python3-smbus \
  python3-libiio \
  python3-boto3 \
  python3-ntplib \
  cpufrequtils \
  wpan-tools \
  bb-code-server

CMD ["bash", "start.sh"]

