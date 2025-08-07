FROM debian:bookworm-slim

# Install software
RUN apt update && \
	apt install --no-install-recommends -y \
		ca-certificates \
		git \
		golang \
		librtlsdr-dev \
		python3-paho-mqtt \
		rtl-sdr \
	&& rm -rfv /var/cache/apt/* \
	&& rm -rfv /var/lib/apt/*

# Grab rtlamr
RUN go get github.com/bemasher/rtlamr

# Copy files into place
COPY * /amrscm2mqtt/
COPY settings.py /amrscm2mqtt/settings.py

# Set the entrypoint
ENTRYPOINT ["/amrscm2mqtt/amrscm2mqtt"]
