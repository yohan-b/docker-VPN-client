#For hosts that use SELinux

#Run these commands to compile and load the policy:

checkmodule -M -m -o docker-openvpn.mod docker-openvpn.te
semodule_package -o docker-openvpn.pp -m docker-openvpn.mod
semodule -i docker-openvpn.pp

