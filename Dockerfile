FROM debian:buster
MAINTAINER yohan <783b8c87@scimetis.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install openvpn procps iptables
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy; update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy; update-alternatives --set arptables /usr/sbin/arptables-legacy; update-alternatives --set ebtables /usr/sbin/ebtables-legacy
RUN mv /etc/openvpn/openvpn.conf /etc/openvpn/openvpn.conf-bak || true
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
