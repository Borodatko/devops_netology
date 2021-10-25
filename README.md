# devops_netology

interface GigabitEthernet1/0/1
 switchport mode access
 switch port access vlan 1000
 switchport voice vlan 1001
 spanning-tree portfast
 spanning-tree bpduguard enable
 switchport port-security
 switchport port-security maximum 2
 switchport port-security mac-address sticky
 switchport port-security violation restrict
!

copy run sta
