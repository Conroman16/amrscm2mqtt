FROM debian:trixie-slim

WORKDIR /amrscm2mqtt

# Install software
RUN apt update && \
	apt install --no-install-recommends -y \
		ca-certificates \
		git \
		golang \
		librtlsdr-dev \
		python3 \
		python3-paho-mqtt \
		procps \
		rtl-sdr \
	&& rm -rfv /var/cache/apt/* \
	&& rm -rfv /var/lib/apt/*

# Set up rtlamr
ENV GOPATH=/amrscm2mqtt/go
ENV PATH=$PATH:$GOPATH/bin
RUN go install github.com/bemasher/rtlamr@latest

# Copy files into place
COPY * /amrscm2mqtt/
COPY settings_template.py /amrscm2mqtt/settings.py

# Prevent kernel from claiming RTL-SDR
RUN echo "blacklist dvb_usb_rtl28xxu" > /etc/modprobe.d/rtl-sdr.conf

# Set the entrypoint
CMD ["/amrscm2mqtt/amrscm2mqtt", "> /var/log/amrscm2mqtt.log 2>&1"]
