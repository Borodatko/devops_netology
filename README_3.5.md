**2.**\
***Нет, так как они обращаются к одной и той же inode, поэтому имеют одинаковые права доступа, владельца и время последней модификации.***


\
**4.**\
***root@vagrant:~# fdisk /dev/sdb***

_Welcome to fdisk (util-linux 2.34).\
Changes will remain in memory only, until you decide to write them.\
Be careful before using the write command._

_Device does not contain a recognized partition table.\
Created a new DOS disklabel with disk identifier 0xe504c2ba._

***Command (m for help): p***\
_Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors\
Disk model: VBOX HARDDISK\
Sector size (logical/physical): 512 bytes / 512 bytes\
I/O size (minimum/optimal): 512 bytes / 512 bytes\
Disklabel type: dos\
Disk identifier: 0xe504c2ba_

***Command (m for help): n***\
_Partition type\
   p   primary (0 primary, 0 extended, 4 free)\
   e   extended (container for logical partitions)\
Select (default p): p\
Partition number (1-4, default 1): 1\
First sector (2048-5242879, default 2048):\
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G_

_Created a new partition 1 of type 'Linux' and of size 2 GiB._

***Command (m for help): p***\
_Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors\
Disk model: VBOX HARDDISK\
Units: sectors of 1 * 512 = 512 bytes\
Sector size (logical/physical): 512 bytes / 512 bytes\
I/O size (minimum/optimal): 512 bytes / 512 bytes\
Disklabel type: dos\
Disk identifier: 0xe504c2ba_

_Device     Boot Start     End Sectors Size Id Type\
/dev/sdb1        2048 4196351 4194304   2G 83 Linux_

***Command (m for help): n***\
_Partition type\
   p   primary (1 primary, 0 extended, 3 free)\
   e   extended (container for logical partitions)\
Select (default p): p\
Partition number (2-4, default 2):\
First sector (4196352-5242879, default 4196352):\
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):_

_Created a new partition 2 of type 'Linux' and of size 511 MiB._

***Command (m for help): p***\
_Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors\
Disk model: VBOX HARDDISK\
Units: sectors of 1 * 512 = 512 bytes\
Sector size (logical/physical): 512 bytes / 512 bytes\
I/O size (minimum/optimal): 512 bytes / 512 bytes\
Disklabel type: dos\
Disk identifier: 0xe504c2ba_

_Device     Boot   Start     End Sectors  Size Id Type\
/dev/sdb1          2048 4196351 4194304    2G 83 Linux\
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux_

***Command (m for help): w***\
_The partition table has been altered.\
Calling ioctl() to re-read partition table.\
Syncing disks._


\
**5.**\
***root@vagrant:\~# sfdisk --dump /dev/sdb > sdb.dump\
root@vagrant:\~# sfdisk /dev/sdc < sdb.dump***\
Checking that no-one is using this disk right now ... OK_

_Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors\
Disk model: VBOX HARDDISK\
Units: sectors of 1 * 512 = 512 bytes\
Sector size (logical/physical): 512 bytes / 512 bytes\
I/O size (minimum/optimal): 512 bytes / 512 bytes_

_\>>> Script header accepted.\
\>>> Script header accepted.\
\>>> Script header accepted.\
\>>> Script header accepted.\
\>>> Created a new DOS disklabel with disk identifier 0xe504c2ba.\
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.\
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.\
/dev/sdc3: Done._

_New situation:\
Disklabel type: dos\
Disk identifier: 0xe504c2ba_

_Device     Boot   Start     End Sectors  Size Id Type\
/dev/sdc1          2048 4196351 4194304    2G 83 Linux\
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux_

_The partition table has been altered.\
Calling ioctl() to re-read partition table.\
Syncing disks._


\
**6.**\
***root@vagrant:~# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1***\
_mdadm: Note: this array has metadata at the start and\
    may not be suitable as a boot device.  If you plan to\
    store '/boot' on this device please ensure that\
    your boot-loader understands md/v1.x metadata, or use\
    --metadata=0.90\
mdadm: size set to 2094080K\
Continue creating array? yes\
mdadm: Defaulting to version 1.2 metadata\
mdadm: array /dev/md0 started._\

***root@vagrant:~# cat /proc/mdstat***\
_Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]\
md0 : active raid1 sdc1[1] sdb1[0]\
      2094080 blocks super 1.2 [2/2] [UU]_
      
_unused devices: \<none>_


\
**7.**\
***root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2***\
_mdadm: Defaulting to version 1.2 metadata\
mdadm: array /dev/md1 started._

***root@vagrant:~# cat /proc/mdstat***\
_Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]\
md1 : active raid0 sdc2[1] sdb2[0]\
      1042432 blocks super 1.2 512k chunks_\
      
_md0 : active raid1 sdc1[1] sdb1[0]\
      2094080 blocks super 1.2 [2/2] [UU]_
      
_unused devices: \<none>_


\
**8.**\
***root@vagrant:~# pvcreate /dev/md0***\
  _Physical volume "/dev/md0" successfully created._\
***root@vagrant:~# pvcreate /dev/md1***\
  _Physical volume "/dev/md1" successfully created._\
***root@vagrant:~# pvs***\
  _PV         VG        Fmt  Attr PSize    PFree\
  /dev/md0             lvm2 ---    <2.00g   <2.00g\
  /dev/md1             lvm2 ---  1018.00m 1018.00m\
  /dev/sda5  vgvagrant lvm2 a--   <63.50g       0_ 


\
**9.**\
***root@vagrant:~# vgcreate vg_test /dev/md0 /dev/md1***\
  _Volume group "vg_test" successfully created_\
***root@vagrant:~# vgs***\
  _VG        #PV #LV #SN Attr   VSize   VFree\
  vg_test     2   0   0 wz--n-  <2.99g <2.99g\
  vgvagrant   1   2   0 wz--n- <63.50g     0_


\
**10.**\
***root@vagrant:~# lvcreate -n lv_test -L 100M vg_test PV /dev/md1***\
  _Physical Volume "PV" not found in Volume Group "vg_test"._\
***root@vagrant:~# lvcreate -n lv_test -L 100M vg_test /dev/md1***\
  _Logical volume "lv_test" created._


\
**11.**\
***root@vagrant:~# mkfs.ext4 /dev/vg_test/lv_test***\
_mke2fs 1.45.5 (07-Jan-2020)\
Creating filesystem with 25600 4k blocks and 25600 inodes_

_Allocating group tables: done\
Writing inode tables: done\
Creating journal (1024 blocks): done\
Writing superblocks and filesystem accounting information: done_


\
**12.**\
***root@vagrant:\~# mkdir /tmp/new\
root@vagrant:\~# mount /dev/vg_test/lv_test /tmp/new/\
root@vagrant:~# df -h /tmp/new***\
_Filesystem                   Size  Used Avail Use% Mounted on\
/dev/mapper/vg_test-lv_test   93M   72K   86M   1% /tmp/new_


\
**13.**\
***root@vagrant:~# cd /tmp/new/\
root@vagrant:/tmp/new# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz***\
_--2021-11-27 14:14:33--  https://mirror.yandex.ru/ubuntu/ls-lR.gz\
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183\
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.\
HTTP request sent, awaiting response... 200 OK\
Length: 22616192 (22M) \[application/octet-stream]\
Saving to: ‘/tmp/new/test.gz’_

_/tmp/new/test.gz 100% \[=========================================================================================================================================>]  21.57M  98.8MB/s    in 0.2s_

_2021-11-27 14:14:33 (98.8 MB/s) - ‘/tmp/new/test.gz’ saved \[22616192/22616192]_


\
**14.**\
***root@vagrant:/tmp/new# lsblk***\
_NAME                  MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT\
sda                     8:0    0   64G  0 disk\
+-sda1                  8:1    0  512M  0 part  /boot/efi\
+-sda2                  8:2    0    1K  0 part\  
L-sda5                  8:5    0 63.5G  0 part\  
  +-vgvagrant-root    253:0    0 62.6G  0 lvm   /\
  L-vgvagrant-swap_1  253:1    0  980M  0 lvm   \[SWAP]\
sdb                     8:16   0  2.5G  0 disk\
+-sdb1                  8:17   0    2G  0 part\
¦ L-md0                 9:0    0    2G  0 raid1\
L-sdb2                  8:18   0  511M  0 part\
  L-md1                 9:1    0 1018M  0 raid0\
    L-vg_test-lv_test 253:2    0  100M  0 lvm   /tmp/new\
sdc                     8:32   0  2.5G  0 disk\
+-sdc1                  8:33   0    2G  0 part\
¦ L-md0                 9:0    0    2G  0 raid1\
L-sdc2                  8:34   0  511M  0 part\
  L-md1                 9:1    0 1018M  0 raid0\
    L-vg_test-lv_test 253:2    0  100M  0 lvm   /tmp/new_


\
**15.**\
***root@vagrant:/tmp/new# gzip -t /tmp/new/test.gz\
root@vagrant:/tmp/new# echo $?***\
_0_


\
**16.**\
***root@vagrant:/tmp/new# pvs***\
  _PV         VG        Fmt  Attr PSize    PFree\
  /dev/md0   vg_test   lvm2 a--    <2.00g  <2.00g\
  /dev/md1   vg_test   lvm2 a--  1016.00m 916.00m\
  /dev/sda5  vgvagrant lvm2 a--   <63.50g      0_

***root@vagrant:/tmp/new# pvmove -b /dev/md1 /dev/md0***

***root@vagrant:/tmp/new# pvs***\
  _PV         VG        Fmt  Attr PSize    PFree\
  /dev/md0   vg_test   lvm2 a--    <2.00g   <1.90g\
  /dev/md1   vg_test   lvm2 a--  1016.00m 1016.00m\
  /dev/sda5  vgvagrant lvm2 a--   <63.50g       0_


\
**17.**\
***root@vagrant:/tmp/new# mdadm --fail /dev/md0 /dev/sdb1***\
_mdadm: set /dev/sdb1 faulty in /dev/md0_


\
**18.**\
***root@vagrant:/tmp/new# dmesg | tail -2***\
_[10733.432224] md/raid1:md0: Disk failure on sdb1, disabling device.\
               md/raid1:md0: Operation continuing on 1 devices._

\
**19.**\
***root@vagrant:/tmp/new# gzip -t /tmp/new/test.gz\
root@vagrant:/tmp/new# echo $?***\
_0_
