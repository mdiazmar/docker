#!/bin/bash
#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
export debug=$debug							;
set +x && test "$debug" = true && set -x				;
#########################################################################
pwd=$( dirname $( readlink -f $0 ) )					;
source $pwd/../../common/functions.sh					;
#########################################################################
export stack=$stack							;
#########################################################################
test -z "$stack"							\
	&& echo PLEASE DEFINE THE VALUE FOR stack			\
	&& exit 1							\
									;
#########################################################################
calico=https://docs.projectcalico.org/v3.14/manifests			;
ip=10.168.1.100								;
kube=kube-apiserver.sebastian-colomar.com				;
#########################################################################
docker=raw.githubusercontent.com/secobau/docker				;
folder=master/AWS/install/Kubernetes					;
log=/etc/kubernetes/kubernetes-install.log                              ;
#########################################################################
file=kube-install.sh							;
remote=https://$docker/$folder/$file					;
command="								\
	wget $remote							\
	&&								\
	chmod +x $file							\
	&&								\
	./$file								\
"									;
targets="								\
	InstanceManager1						\
	InstanceManager2						\
	InstanceManager3						\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
file=leader.sh								;
remote=https://$docker/$folder/$file					;
command="								\
	export log=$log							\
	&&								\
	wget $remote							\
	&&								\
	chmod +x $file							\
	&&								\
	./$file								\
"									;
targets="								\
	InstanceManager1						\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	kubectl get node						\
		2> /dev/null						\
	|								\
		grep Ready						\
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	grep								\
		--max-count						\
			1						\
		certificate-key						\
		$log							\
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_certificate="$output"						;
#########################################################################
command="								\
	grep								\
		--max-count						\
			1						\
		discovery-token-ca-cert-hash				\
		$log							\
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_discovery="$output"						;
#########################################################################
command="								\
	grep								\
		--max-count						\
			1						\
		kubeadm.*join						\
		$log							\
"									;
targets="InstanceManager1"						;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
token_token="$output"							;
#########################################################################
file=manager.sh								;
remote=https://$docker/$folder/$file					;
command="								\
	export log=$log							\
	&&								\
	export token_certificate=$token_certificate			\
	&&								\
	export token_discovery=$token_discovery				\
	&&								\
	export token_token=$token_token					\
	&&								\
	wget $remote							\
	&&								\
	chmod +x $file							\
	&&								\
	./$file								\
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
file=worker.sh								;
remote=https://$docker/$folder/$file					;
command="								\
	export log=$log							\
	&&								\
	export token_discovery=$token_discovery				\
	&&								\
	export token_token=$token_token					\
	&&								\
	wget $remote							\
	&&								\
	chmod +x $file							\
	&&								\
	./$file								\
"									;
targets="								\
	InstanceWorker1							\
	InstanceWorker2							\
	InstanceWorker3							\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	kubectl get node						\
		2> /dev/null						\
	|								\
		grep Ready						\
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	sudo sed --in-place /$kube/d /etc/hosts				\
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################
command="								\
	kubectl get node						\
		2> /dev/null						\
	|								\
		grep Ready						\
"									;
targets="								\
	InstanceManager2						\
	InstanceManager3						\
"									;
for target in $targets							;
do									\
	send_list_command "$command" "$target" "$stack"			\
									;
done									;
#########################################################################