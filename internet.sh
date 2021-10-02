#!/bin/bash
echo 'http_proxy=http://datalab-proxy:3128' >> /etc/environment
echo 'https_proxy=https://datalab-proxy:3128' >> /etc/environment
echo 'https_proxy=http://datalab-proxy:3128' >> /etc/environment
echo 'https_proxy=http://datalab-proxy:3128' >> /etc/environment
echo 'no_proxy=127.0.0.1,localhost' >> /etc/environment