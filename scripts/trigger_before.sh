#!/bin/bash

rm -f /tmp/vagrant_rsa*
ssh-keygen -t rsa -b 4096 -N "" -f /tmp/vagrant_rsa

exit 0
