#!/bin/sh
cd /root/Desktop
pip3 install -r requirements.txt
jupyter notebook --ip 0.0.0.0 --no-browser --port=8888 --allow-root