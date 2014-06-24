# manager installation on centos

function _wget
{
    echo "downloading $1 to $2"
    sudo wget $1 -P $2 --timeout=30 -t 3
}

function _yum
{
    echo "downloading $1 to $2"
    sudo yum reinstall -y --downloadonly --downloaddir=$2 $1
}

function _mkdir
{
    echo "creating dir $1 (recursively)"
    sudo mkdir -p $1
}

COMPONENTS_DIR=/cloudify-components
_mkdir ${COMPONENTS_DIR}

NGINX_DIR=${COMPONENTS_DIR}/nginx
_mkdir ${NGINX_DIR}
echo "[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1" > /etc/yum.repos.d/nginx.repo
# yum install -y --downloadonly --downloaddir=${NGINX_DIR} nginx
_yum nginx ${NGINX_DIR}

LOGSTASH_DIR=${COMPONENTS_DIR}/logstash
_mkdir ${LOGSTASH_DIR}
_wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz ${LOGSTASH_DIR}

ELASTICSEARCH_DIR=${COMPONENTS_DIR}/elasticsearch
_mkdir ${ELASTICSEARCH_DIR}
_wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz ${ELASTICSEARCH_DIR}

NODEJS_DIR=${COMPONENTS_DIR}/nodejs
_mkdir ${NODEJS_DIR}
sudo rpm --import https://fedoraproject.org/static/0608B895.txt
sudo rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo yum install -y --enablerepo=epel --downloadonly --downloaddir=${NODEJS_DIR} nodejs npm

RABBITMQ_DIR=${COMPONENTS_DIR}/rabbitmq
_mkdir ${RABBITMQ_DIR}
sudo wget -O /etc/yum.repos.d/epel-erlang.repo http://repos.fedorapeople.org/repos/peter/erlang/epel-erlang.repo
# sudo yum install -y --downloadonly --downloaddir=${RABBITMQ_DIR} erlang
_yum erlang ${RABBITMQ_DIR}
_wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.2.4/rabbitmq-server-3.2.4-1.noarch.rpm ${RABBITMQ_DIR}

RIEMANN_DIR=${COMPONENTS_DIR}/riemann
_mkdir ${RIEMANN_DIR}
_wget http://aphyr.com/riemann/riemann-0.2.2-1.noarch.rpm ${RIEMANN_DIR}

OPENJDK_DIR=${COMPONENTS_DIR}/openjdk
_mkdir ${OPENJDK_DIR}
# sudo yum install -y --downloadonly --downloaddir=${OPENJDK_DIR} java-1.7.0-openjdk
_yum java-1.7.0-openjdk ${OPENJDK_DIR}

VIRTUALENV_DIR=${COMPONENTS_DIR}/virtualenv
_mkdir ${VIRTUALENV_DIR}

CURL_DIR=${COMPONENTS_DIR}/curl
_mkdir ${CURL_DIR}
# sudo yum reinstall -y --downloadonly --downloaddir=${CURL_DIR} curl
_yum curl ${CURL_DIR}

MAKE_DIR=${COMPONENTS_DIR}/make
_mkdir ${MAKE_DIR}
# sudo yum reinstall -y --downloadonly --downloaddir=${MAKE_DIR} make
_yum make ${MAKE_DIR}

sudo /opt/ruby-build/bin/ruby-build -v 2.1.0 /opt/ruby
