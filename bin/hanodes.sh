#!/bin/bash

set -x

cd /opt/aws/bin/

export AWS_ACCESS_KEY=''
export AWS_SECRET_KEY=''
export EC2_HOME=/opt/aws
export JAVA_HOME=/usr

node_instances=`/opt/aws/bin/ec2-describe-instances --region us-west-2 -F "tag-value=node" --filter "instance-state-code=16" | grep INSTANCE | awk '{print $2}'`
node_instances=( $node_instances )
bingo="nope"

for node in ${node_instances[@]}; do
	node_details=`/opt/aws/bin/ec2-describe-instances --region us-west-2 $node`
	ip=$(echo $node_details | awk '{print $21}')
	name=$(echo $node_details | awk '{print $55}')
	echo $name

	if [ -f "/root/boot/config/$name" ]; then
		oldip=`cat /root/boot/config/$name`
	else
		oldip=$(echo $node_details | awk '{print $20}')
	fi

	if [ "$oldip" != "$ip" ]; then
		sed -i "s/$oldip/$ip/g" /etc/haproxy/haproxy.cfg

		echo $ip > /root/boot/config/$name		

		bingo="yep"
	fi
done

if [ "$bingo" == "yep" ]; then
	/etc/init.d/haproxy reload
fi
