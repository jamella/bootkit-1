#!/bin/bash

export AWS_ACCESS_KEY=''
export AWS_SECRET_KEY=''

export JAVA_HOME=/usr
export EC2_HOME=/opt/aws
export PATH=$PATH:$EC2_HOME/bin

instance=`/root/boot/bin/ec2-metadata -i | awk '{ print $2 }'`
eip=`cat /root/boot/config/eip`
region=`cat /root/boot/config/region`

ec2-associate-address -i $instance $eip --region $region

