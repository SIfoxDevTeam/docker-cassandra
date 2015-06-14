#  Cassandra Datastax
FROM lefan/centos
MAINTAINER Alexey Larin <Alexey.I.Larin@gmail.com>

ENV DSC_VERSION 21

COPY datastax.repo /etc/yum.repo.d/datastax.repo

RUN yum update && \
    yum install -y tar \
                   wget \
                   unzip \
                   dsc$DSC_VERSION \
                   cassandra$DSC_VERSION-tools

ENV CASSANDRA_CONFIG /etc/cassandra/conf

# listen to all rpc
RUN sed -ri ' \
		s/^(rpc_address:).*/\1 0.0.0.0/; \
	' "$CASSANDRA_CONFIG/cassandra.yaml"

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /var/lib/cassandra/data

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160
CMD ["cassandra", "-f"]
