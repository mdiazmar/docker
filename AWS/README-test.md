This project will allow you to deploy a containerized application in AWS on a production-grade highly available and secure infrastructure consisting of private and public subnets, NAT gateways, security groups and application load balancers in order to ensure the isolation and resilience of the different components.

The following script will first create the infrastructure and then deploy your application. You need to run the following commands from a terminal in a Cloud9 environment with enough privileges.
You may also configure the variables so as to customize the setup:

```BASH 

#########################################################################
apps=" app1 app2 app3 "                                                 ;
apps=" dockercoins petclinic php "					;
AWS=secobau/docker/master/AWS						;
debug=false                                                     	;
debug=true                                                     		;
deploy=latest                                                   	;
deploy=release                                                   	;
domain=raw.githubusercontent.com					;
HostedZoneName=example.com                                  	 	;
HostedZoneName=sebastian-colomar.com                                   	;
# Identifier is the ID of the certificate in case you are using HTTPS	#
Identifier=c3f3310b-f4ed-4874-8849-bd5c2cfe001f                         ;
KeyName=mySSHpublicKey							;
KeyName=proxy2aws							;
mode=Kubernetes                                                       	;
mode=Swarm                                                       	;
RecordSetName1=service-1                                   		;
RecordSetName1=dockercoins                                   		;
RecordSetName2=service-2                                   		;
RecordSetName2=petclinic                                   		;
RecordSetName3=service-3                                   		;
RecordSetName3=php                                   			;
repository=myproject							;
repository=docker							;
stack=$repository                                                     	;
username=johndoe							;
username=secobau							;
#########################################################################
export apps								;
export AWS								;
export debug								;
export deploy								;
export domain								;
export HostedZoneName							;
export Identifier							;
export KeyName								;
export mode								;
export RecordSetName1							;
export RecordSetName2							;
export RecordSetName3							;
export repository							;
export stack								;
export username								;
#########################################################################
path=$AWS								;
file=init.sh								;
date=$( date +%F_%H%M )							;
mkdir $date								;
cd $date								;
curl --remote-name https://$domain/$path/$file				;
chmod +x ./$file							;
nohup ./$file								&
#########################################################################


```
