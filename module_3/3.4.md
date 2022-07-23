**1.**\
***root@vagrant:~# systemctl enable node_exporter\
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service > /lib/systemd/system/node_exporter.service.***

***root@vagrant:~# cat /lib/systemd/system/node_exporter.service***\
_[Unit]\
Description=Node Exporter\
After=syslog.target network.target_

_[Service]\
Restart=always\
ExecStart=/usr/bin/prometheus-node-exporter $ARGS\
ExecStop=/sbin/killall5 /usr/bin/prometheus-node-exporter_

_[Install]\
WantedBy=multi-user.target_


***root@vagrant:~# systemctl status node_exporter***\
_? node_exporter.service - Node Exporter\
&emsp;Loaded: loaded (/lib/systemd/system/node_exporter.service; disabled; vendor preset: enabled)\
&emsp;Active: active (running) since Fri 2021-11-26 08:00:28 UTC; 5s ago\
&ensp;Main PID: 19175 (prometheus-node)\
&emsp;Tasks: 5 (limit: 1071)\
&ensp;Memory: 1.7M\
&ensp;CGroup: /system.slice/node_exporter.service\
&emsp;&emsp;L-19175 /usr/bin/prometheus-node-exporter_


\
**2.**\
***CPU***\
_node_cpu_seconds_total{cpu="0",mode="iowait"}\
node_cpu_seconds_total{cpu="0",mode="system"}_\
***MEMORY***\
_node_memory_MemAvailable_bytes\
node_memory_MemFree_bytes_\
***FILESYSTEM***\
_node_filesystem_avail_bytes\
node_filesystem_free_bytes\
node_filesystem_size_bytes_\
***NETWORK***\
_node_network_receive_bytes_total\
node_network_receive_errs_total\
node_network_receive_drop_total\
node_network_transmit_bytes_total\
node_network_transmit_errs_total\
node_network_transmit_drop_total_

\
**3.**\
***[Screen](https://github.com/Borodatko/devops_netology/blob/ba170e1161c6768242d0fe0d8b22cd2b30422b3d/netdata.jpg)***

\
**4.** ***Да.***\
_root@vagrant:~# dmesg | grep "Hypervisor detected"\
[    0.000000] Hypervisor detected: KVM_

\
**5.**\
_root@vagrant:~# sysctl -a | grep fs.nr_open\
fs.nr_open = 1048576_

***Это лимит на количество открытых файлов***

_root@vagrant:~# ulimit -n\
1024_

\
**6.**\
_root@vagrant:\~# screen\
root@vagrant:\~# unshare -f --pid --mount-proc sleep 1h &\
[1] 20827_

***Ctrl + A + D для выхода из screen***\
***На хосте:***

_root@vagrant:~# ps aux | grep sleep\
root&emsp;       1926&emsp;  0.0&emsp;  0.0&emsp;   8076&emsp;   528&emsp; ?&emsp;        S&emsp;    09:23&emsp;   0:00 sleep 1h\
root&emsp;       1938&emsp;  0.0&emsp;  0.0&emsp;   8076&emsp;   516&emsp; ?&emsp;        S&emsp;    09:23&emsp;   0:00 sleep 1h\
root&emsp;       20746&emsp;  0.0&emsp;  0.0&emsp;   8076&emsp;   592&emsp; ?&emsp;        S&emsp;    09:53&emsp;   0:00 sleep 1h\
root&emsp;       20748&emsp;  0.0&emsp;  0.0&emsp;   8076&emsp;   588&emsp; ?&emsp;        S&emsp;    09:53&emsp;   0:00 sleep 1h\
root&emsp;       20827&emsp;  0.0&emsp;  0.0&emsp;   8080&emsp;   524&emsp; pts/2&emsp;    S&emsp;    09:55&emsp;   0:00 unshare -f --pid --mount-proc sleep 1h\
root&emsp;       20828&emsp;  0.0&emsp;  0.0&emsp;   8076&emsp;   592&emsp; pts/2&emsp;    S&emsp;    09:55&emsp;   0:00 sleep 1h\
root&emsp;       20830&emsp;  0.0&emsp;  0.0&emsp;   8900&emsp;   736&emsp; pts/0&emsp;    S+&emsp;   09:56&emsp;   0:00 grep --color=auto sleep_

_root@vagrant:~# nsenter --target 20828 --pid --mount_

_root@vagrant:/# ps aux\
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND\
root&emsp;           1&emsp;  0.0&emsp;  0.0&emsp;   8076&emsp;   592&emsp; pts/2&emsp;    S+&emsp;   09:55&emsp;   0:00&emsp; sleep 1h\
root&emsp;           2&emsp;  0.0&emsp;  0.4&emsp;   9968&emsp;  4040&emsp; pts/0&emsp;    S&emsp;    09:56&emsp;   0:00&emsp; -bash\
root&emsp;          11&emsp;  0.0&emsp;  0.3&emsp;  11492&emsp;  3364&emsp; pts/0&emsp;    R+&emsp;   09:56&emsp;   0:00&emsp; ps aux_

\
**7.** ***Это fork bomb.***

***cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope***

***Настроен через user slice.***

_root@vagrant:~# systemctl status user-1000.slice\
? user-1000.slice - User Slice of UID 1000\
     Loaded: loaded\
    Drop-In: /usr/lib/systemd/system/user-.slice.d\
             L-10-defaults.conf\
     Active: active since Fri 2021-11-26 10:08:22 UTC; 14s ago\
       Docs: man:user@.service(5)\
      Tasks: 10 (limit: 2356)\
     Memory: 8.7M\
     CGroup: /user.slice/user-1000.slice\
             +-session-4.scope\
             ¦ +-1572 sshd: vagrant [priv]\
             ¦ +-1610 sshd: vagrant@pts/0\
             ¦ +-1611 -bash\
             ¦ +-1618 sudo su -\
             ¦ +-1619 su -\
             ¦ +-1621 -bash\
             ¦ +-1630 systemctl status user-1000.slice\
             ¦ L-1631 pager\
             L-user@1000.service\
               L-init.scope\
                 +-1575 /lib/systemd/systemd --user\
                 L-1576 (sd-pam)_


***В конфиге /usr/lib/systemd/system/user-.slice.d/10-defaults.conf меняем значение TasksMax:***

_[Slice]\
TasksMax=33%_
