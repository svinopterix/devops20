# devops20
DEVOPS-20 homework repository

## 3.5 Файловые системы - Вячеслав Медведев
2. Нет, не могут, т.к. метаданные (в т.ч. владелец и права доступа) хранятся в inode, на который и будут ссылаться созданные жесткие ссылки.<br>

4. 
<pre>
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk


Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xb99e3285

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
</pre>
5.
<pre>
sfdisk /dev/sdb --dump > sdb.dump
sfdisk /dev/sdc < sdb.dump

root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
loop3                       7:3    0 61.9M  1 loop /snap/core20/1518
loop4                       7:4    0   47M  1 loop /snap/snapd/16292
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
└─sdc2                      8:34   0  511M  0 part
</pre>
6. mdadm -C /dev/md0 -l 1 -n 2 -x 0 /dev/sdb1 /dev/sdc1<br>
7. mdadm -C /dev/md1 -l 0 -n 2 /dev/sdb2 /dev/sdc2<br>

8. pvdisplay
<pre>
  "/dev/md0" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               iklQF9-aNkW-bO1F-PNhW-Kgiu-OXiy-vitgoL

  "/dev/md1" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               0xquSL-Apbo-AsKc-tINb-bLmB-W3w4-UWvf0i
</pre>  
9. 
<pre>
root@vagrant:~# vgdisplay vg01
  --- Volume group ---
  VG Name               vg01
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               JemyQJ-UuL3-M6Ge-Cg6g-0IGK-Lmjh-0Q9TX9
  
  
root@vagrant:~# pvdisplay /dev/md0 /dev/md1
  --- Physical volume ---
  PV Name               /dev/md0
  VG Name               vg01
  PV Size               <2.00 GiB / not usable 0
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              511
  Free PE               511
  Allocated PE          0
  PV UUID               iklQF9-aNkW-bO1F-PNhW-Kgiu-OXiy-vitgoL

  --- Physical volume ---
  PV Name               /dev/md1
  VG Name               vg01
  PV Size               1018.00 MiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              254
  Free PE               254
  Allocated PE          0
  PV UUID               0xquSL-Apbo-AsKc-tINb-bLmB-W3w4-UWvf0i
  
</pre>  
10.
<pre>
root@vagrant:~# lvcreate vg01 -n lv01 -L 100M /dev/md1
  Logical volume "lv01" created.
root@vagrant:~# lvdisplay vg01
  --- Logical volume ---
  LV Path                /dev/vg01/lv01
  LV Name                lv01
  VG Name                vg01
  LV UUID                PI8luf-P26e-eyAp-4Pcd-CnQx-Jh3Z-fW0sUx
  LV Write Access        read/write
  LV Creation host, time vagrant, 2022-07-18 16:03:56 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:1
</preO  
11.
<pre>
root@vagrant:~# mkfs.ext4 /dev/vg01/lv01
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

</pre>
12.
mkdir /tmp/lv01<br>
mount /dev/vg01/lv01 /tmp/lv01<br>

14.
<pre>
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
loop1                       7:1    0 61.9M  1 loop  /snap/core20/1328
loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978
loop3                       7:3    0 61.9M  1 loop  /snap/core20/1518
loop4                       7:4    0   47M  1 loop  /snap/snapd/16292
loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0  1.5G  0 part  /boot
└─sda3                      8:3    0 62.5G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/lv01
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/lv01

</pre>
15. 
<pre>
root@vagrant:/tmp/lv01# gzip -t ./test.gz
root@vagrant:/tmp/lv01# echo $?
0
</pre>
16. 
<pre>
root@vagrant:/tmp/lv01# pvmove -n /dev/vg01/lv01 /dev/md1 /dev/md0
  /dev/md1: Moved: 28.00%
  /dev/md1: Moved: 100.00%
  
</pre>
17. mdadm --fail /dev/md0 /dev/sdc1

<pre>
root@vagrant:/tmp/lv01# mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Mon Jul 18 15:22:55 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Mon Jul 18 16:22:49 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:0  (local to host vagrant)
              UUID : f5a7e1d9:e4cd6a1a:3121cd09:591af344
            Events : 19

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       -       0        0        1      removed

       1       8       33        -      faulty   /dev/sdc1
</pre>	   
18.	  
<pre>
root@vagrant:/tmp/lv01# dmesg | grep md/raid
......
[ 7128.198063] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
			  
</pre>			  
19.
<pre>
root@vagrant:/tmp/lv01# gzip -t ./test.gz
root@vagrant:/tmp/lv01# echo $?
0
</pre>
## 3.6 Компьютерные сети, лекция 1 - Вячеслав Медведев

1. Вернулся код 301<br>
HTTP/1.1 301 Moved Permanently<br>
Означает, что страница перемещена и доступна по другой ссылке. В данном случае идёт редирект на HTTPS: location: https://stackoverflow.com/questions

2. Скрин net1. Вернулся код 307 - страница временно перемещена
Дольше всего отрабатывал запрос GET на https://stackoverflow.com/

3. Приложил скрин с IP-адресом net2
4. Скрин net3

5. Видна только AS Google: AS15169
<pre>
root@vagrant:~# traceroute -A 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (172.16.5.1) [*]  2.416 ms  1.432 ms  1.199 ms
 2  * * *
 3  * * *
 4  * * *
 5  * * *
 6  72.14.209.81 (72.14.209.81) [AS15169]  4.427 ms  4.936 ms  4.769 ms
 7  * * *
 8  108.170.226.172 (108.170.226.172) [AS15169]  3.286 ms 72.14.235.226 (72.14.235.226) [AS15169]  3.573 ms 72.14.233.94 (72.14.233.94) [AS15169]  3.757 ms
 9  108.170.250.99 (108.170.250.99) [AS15169]  4.799 ms 108.170.250.146 (108.170.250.146) [AS15169]  3.621 ms 108.170.250.113 (108.170.250.113) [AS15169]  4.665 ms
10  142.250.238.214 (142.250.238.214) [AS15169]  18.785 ms  18.691 ms 142.251.238.84 (142.251.238.84) [AS15169]  19.845 ms
11  72.14.232.76 (72.14.232.76) [AS15169]  19.762 ms 172.253.65.82 (172.253.65.82) [AS15169]  18.244 ms 142.250.235.74 (142.250.235.74) [AS15169]  19.544 ms
12  142.250.209.161 (142.250.209.161) [AS15169]  19.481 ms 172.253.70.49 (172.253.70.49) [AS15169]  21.302 ms 216.239.47.173 (216.239.47.173) [AS15169]  19.070 ms
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  dns.google (8.8.8.8) [AS15169]  17.905 ms  16.998 ms  21.167 ms
</pre>

6. Вот на этом хопе самая большая задержка: 142.251.49.158

7. A-записи

       dns.google.             900     IN      A       8.8.4.4
       dns.google.             900     IN      A       8.8.8.8

серверы:

       dns.google.             10800   IN      NS      ns2.zdns.google.
       dns.google.             10800   IN      NS      ns4.zdns.google.
       dns.google.             10800   IN      NS      ns1.zdns.google.
       dns.google.             10800   IN      NS      ns3.zdns.google.

8. dig -x IP

       10.8.8.8.in-addr.arpa.   6598    IN      PTR     dns.google.
       11.4.8.8.in-addr.arpa.   69320   IN      PTR     dns.google.

## 3.4 Операционные системы, лекция 2 - Вячеслав Медведев

1.
<pre>
vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service
[Unit]
Description=Node exporter

[Service]
EnvironmentFile=-/home/vagrant/node_exporter-1.3.1.linux-386/node_exporter_options
ExecStart=/home/vagrant/node_exporter-1.3.1.linux-386/node_exporter $CLI_OPTIONS
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
</pre>
2. Ну, например:
CPU
для всех CPU:
<pre>
node_cpu_seconds_total{cpu="0",mode="idle"}
node_cpu_seconds_total{cpu="0",mode="iowait"}
node_cpu_seconds_total{cpu="0",mode="system"}
node_cpu_seconds_total{cpu="0",mode="user"}
</pre>

Mem
<pre>
node_memory_MemFree_bytes
node_memory_SwapFree_bytes
</pre>

Disk
<pre>
node_disk_io_now
node_filesystem_files_free
</pre>

Network
<pre>
node_network_receive_errs_total
node_network_receive_bytes_total
node_network_receive_packets_total
node_network_transmit_errs_total
node_network_transmit_bytes_total
node_network_transmit_packets_total
</pre>

3. Приложил скриншот Netdata

4. Осознаёт - Ubuntu говорит при загрузке, что работает на гипервизоре

       [    0.000000] Hypervisor detected: KVM

5. fs.nr_open = 1048576
Максимальное число открытых файловых дескрипторов

6. 
<pre>
root@vagrant:~# unshare -f --pid --mount-proc sleep 1h
^Z
[1]+  Stopped                 unshare -f --pid --mount-proc sleep 1h
root@vagrant:~# bg
[1]+ unshare -f --pid --mount-proc sleep 1h &
root@vagrant:~# ps -ef | grep sleep
root        1484    1401  0 14:59 pts/0    00:00:00 unshare -f --pid --mount-proc sleep 1h
root        1485    1484  0 14:59 pts/0    00:00:00 sleep 1h
root        1487    1401  0 14:59 pts/0    00:00:00 grep --color=auto sleep
root@vagrant:~# nsenter -t 1485 --pid --mount
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   5476   584 pts/0    S    14:59   0:00 sleep 1h
root           2  0.0  0.2   7236  4080 pts/0    S    14:59   0:00 -bash
root          13  0.0  0.1   8888  3368 pts/0    R+   14:59   0:00 ps aux
</pre>

7. Приведенная конструкция рекурсивно плодит процессы.
Если я правильно понял, в systemd есть модуль контроля за ресурсам, в котором по умолчанию стоит ограничение: один unit не может породитьболее 33% процессов.
<pre>
vagrant@vagrant:/usr/lib/systemd/system/user-.slice.d$ cat /usr/lib/systemd/system/user-.slice.d/10-defaults.conf
#  SPDX-License-Identifier: LGPL-2.1+
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=User Slice of UID %j
Documentation=man:user@.service(5)
After=systemd-user-sessions.service
StopWhenUnneeded=yes

[Slice]
TasksMax=33%
</pre>

Это ограничение срабатывает, о чём появляется сообщение в dmesg:

       [   65.780326] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope

## 2.4 - Инструменты Git - Вячеслав Медведев

1. aefead220 Update CHANGELOG.md

       git log --oneline | grep aefea
2. tag: v0.12.23
<pre>
ubuntu@primary:~/terraform$ git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (<b>tag: v0.12.23</b>)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000
</pre>       
3. 56cd7859e и 9ea88f22f
<pre>
ubuntu@primary:~/terraform$ git show b8d720
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
Merge: <b>56cd7859e 9ea88f22f</b>
</pre>
4.
<pre>
ubuntu@primary:~/terraform$ <b>git log v0.12.23..v0.12.24 --oneline</b>
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
</pre>
5. 8c928e83589d90a031f811fae52a81be7153e82f
Сначала нашёл все коммиты, где функция была добавлена или удалена:
<pre>
ubuntu@primary:~/terraform$ git log -S "func providerSource" --oneline
5af1e6234 main: Honor explicit provider_installation CLI config when present
8c928e835 main: Consult local directories as potential mirrors of providers
</pre>
А потом посмотрел с помощью git show <commit_id>, где её добавили

6. Сначала нашёл, в каком файле находится требуемая функция - она в plugins.go<br>
<b>git log -S "func globalPluginDirs" -p</b><br>
Потом с помощью команды <b>git log -L :globalPluginDirs:plugins.go</b> вывел диффы всех коммитов, изменяющих эту функцию.
Ключ --oneline при этом не работает, поэтому пришлось руками копипастить хэши и их описания
<pre>
78b122055 Remove config.go and update things using its aliaseswho
52dbf9483 keep .terraform.d/plugins for discovery
41ab0aef7 Add missing OS_ARCH dir to global plugin paths
66ebff90c move some more plugin search path logic to command
8364383c3 Push plugin discovery down into command package
</pre>
7. Нашел все коммиты, где функция появляется или исчезает: <b>git log -S "func synchronizedWriters" -p</b><br>
И посмотрел, кто автор коммита, в котором функция была добавлена.<br>
Martin Atkins <mart@degeneration.co.uk>


## 3.3 - Операционные системы, лекция 1 — Вячеслав Медведев

1. Системный вызов chdir
2. Судя по всему, тут /usr/share/misc/magic.mgc

       vagrant@vagrant:~$ grep "misc/magic.mgc" bash.strace tty0.strace sda1.strace
       bash.strace:openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
       tty0.strace:openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
       sda1.strace:openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
3. Можно с помощью lsof найти дескриптор открытого файла и PID процесса, который его открыл


       vagrant@vagrant:~$ lsof | grep bigfile
       tail      216079                         vagrant    3r      REG              253,0 2780567790    1311516 /home/vagrant/bigfile (deleted)

PID: 216079
дескриптор: 3

Потом перезаписать файл пустой строкой через файловую систему /proc
Например:
echo "" > /proc/216079/fd/3

4. Нет, зомби-процессы завершены, поэтому ресурсов системы не занимают.
5.
       root@vagrant:~# opensnoop-bpfcc
       PID    COMM               FD ERR PATH
       647    irqbalance          6   0 /proc/interrupts
       647    irqbalance          6   0 /proc/stat
       647    irqbalance          6   0 /proc/irq/20/smp_affinity
       647    irqbalance          6   0 /proc/irq/0/smp_affinity
       647    irqbalance          6   0 /proc/irq/1/smp_affinity
       647    irqbalance          6   0 /proc/irq/8/smp_affinity
       647    irqbalance          6   0 /proc/irq/12/smp_affinity
       647    irqbalance          6   0 /proc/irq/14/smp_affinity
       647    irqbalance          6   0 /proc/irq/15/smp_affinity
       1244   vminfo              6   0 /var/run/utmp
       635    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
       635    dbus-daemon        21   0 /usr/share/dbus-1/system-services
       635    dbus-daemon        -1   2 /lib/dbus-1/system-services
       635    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/
       1244   vminfo              6   0 /var/run/utmp
       635    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
       635    dbus-daemon        21   0 /usr/share/dbus-1/system-services
       635    dbus-daemon        -1   2 /lib/dbus-1/system-services
       635    dbus-daemon        21   0 /var/lib/snapd/dbus-1/system-services/

6. Системный вызов uname
       Part of the utsname information is also accessible via
       /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.

7. Команды ; и && - позволяют исполнять списки команд. ; - обычный список, команды выполняются последовательно. && - список AND, 
с1 && c2, с2 выполнится только если c1 закончилась с нулевым результатом.

Смысл использовать && с set -e есть, т.к. set -e игнорирует ненулевые результаты в списках && за исключением случая, когда ненулевой результат вернула последняя команда списка. 

8. set -euxo pipefail
e - валиться на ошибках за некоторыми исключениями (например, while, if, &&, ||)
u - валиться при использовании неустановленных переменных
x - выводит вложенные команды, в т.ч. для конструкций for, if
o pipefail - выдаёт ненулевой результат работы пайпа даже если с ошибкой завершилась какая-то команда в середине пайпа (не последняя) - позволяет обработать такую ошибку, т.к. по умолчанию результатом работы пайпа будет результат последней команды в пайпе, независимо от результата предыдущих команд

Хорошо, на мой взгляд, использовать в сценариях, т.к. делает явной автоматическую обработку всех ошибок, даже если их явно не обработал разработчик, и упрощает отладку всяческих списков и вложенных команд.

9. Самые частые статусы процессов: S - interruptible sleep и I - idle. Только у меня не получилось вывести статус всех процессов в системе: когда указываю -o stat, показываются только мои процессы. Все процессы со статусами вывела команда ps aux.


## 3.2 Работа в терминале, Лекция 2 — Вячеслав Медведев

1. cd - shell builtin. Думаю, потому, что текущая директория - это свойство каждого процесса, т.к. если мы хотим поменять именно текущую директорию того shell, в котором сейчас работаем, то было бы бессмысленно делать это, порождая дочерний процесс - тогда директория поменялась бы у дочернего процесса, а у shell осталась бы та же.
2. grep -c <some_string> <some_file>
считает число строк, включающих some_string
3. процесс c PID=1 initd
Правда, название команды почему-то зависит от синтаксиса команды:
       root@vagrant:/proc/sys/kernel# ps p 1
           PID TTY      STAT   TIME COMMAND
             1 ?        Ss     0:08 /sbin/init
       root@vagrant:/proc/sys/kernel# ps -p 1
           PID TTY          TIME CMD
             1 ?        00:00:08 systemd
4. ls /some_dir 2>/dev/pts/1
5.  
       root@vagrant:~# echo -e "1\n2\n3\nasdf" | sed s/[[:digit:]]*/D/ > out
       root@vagrant:~# cat out
       D
       D
       D
       Dasdf
6.Не пойму вопрос. Поставил графическую Убунту, запустил два терминала /dev/pts/0 и /dev/pts/1. Между ними так же передаются данные: echo "string" >/dev/ptsX

7. Создаётся поток 5 и перенаправляется на 1 (стандартный вывод). При этом создаётся файловый дескриптор. 
Его видно в директории 
       /proc\/\$\$\/fd
(\$\$ - PID текущего процесса). Т.е. если вывести что-нибудь в этот 5-й дескриптор, то этот вывод будет перенаправлен на стандартный вывод, и мы увидим сточку на экране.
8.
       ls -la ~ /somedir 3>&1 1>&2 2>&3 | sed s/somedir/SOMEDIRRRRRRR/
       /home/vagrant:
       ls: cannot access '/SOMEDIRRRRRRR': No such file or directory
       total 100
       drwxr-xr-x 4 vagrant vagrant  4096 Jun 26 10:07 .
       drwxr-xr-x 3 root    root     4096 Jun  7 11:50 ..
       -rw------- 1 vagrant vagrant   862 Jun 20 21:36 .bash_history
       -rw-r--r-- 1 vagrant vagrant   220 Feb 25  2020 .bash_logout
       .....
9.Покажет переменные окружения текущего bash
Можно посмотреть переменные окружения командой env.

10. /proc/[pid]/cmdline - полная команда, запустившая процесс
/proc/[pid]/exe - симлинк на исполняемый файл процесса

11. Поддерживаются sse, sse2, sse4_1, sse4_2

12. По умолчанию sshd не создаёт виртуальный терминал при исполнении команды. Можно задать опцию -t, тогда будет создавать.
       vagrant@vagrant:~$ ssh -t localhost 'tty'
       vagrant@localhost's password:
       /dev/pts/2
       Connection to localhost closed.

13. Получилось переключить vi на другой терминал. Потребовалось kernel.yama.ptrace_scope = 0 в /etc/sysctl.d/10-ptrace.conf и перегрузиться.

14. tee читает stdin и пишет одновременно на stdout и в указанные файлы. Получается, что если делаем sudo smth > smth2, то smth2 выполняется под моим пользователем, а под root только smth. Т.е. в конструкции echo file > sudo tee file2 - tee file2 выполняется под root.


## 3.1 Работа в терминале, Лекция 1 — Вячеслав Медведев
8.
HISTCMD
строка 580

ignoreboth - значение переменной HISTCONTROL, управляющей историей: одновременная работа директив ignoredups (не сохранять повторные команды) и ignorespace (не сохранять команды, начинающиеся с пробела)

9.
{} - частный случай "составной команды" - используются как способ выполнить несколько команд в том же шелле, откуда запущены (т.е. без создания subshell environment), строка 218

10.
Не вполне понял вопрос, но можно так: for i in {1..100000}; do touch $i; done
Можно и 300000, почему нет.

11.
[[ -d /tmp ]] - возвращает True, если файл /tmp существует и является директорией

12.
mkdir /tmp/new_path_directory
cp /usr/bin/bash /tmp/new_path_directory
export PATH=/tmp/new_path_directory:$PATH

vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash

13.
at выполняет job в заданное время
batch выполняет job тогда, когда загрузка CPU падает ниже заданного порога


## 2.1 Системы контроля версий
Будут игнорироваться 
- содержимое директорий .terraform, где бы эти директории не находились.
- файлы с расширением .tfstate или имеющие .tfstate. в названиии
- файлы crash.log или начинающиеся на crash. и с расширением .log
- файлы с расширениями .tfvars или .tfvars.json
- файлы override.tf, override.tf.json или с именами, заканчивающимися на _override.tf или _override.tf.json
- файлы .terrafromrc
- файлы terraform.rc

## 2.1. Системы контроля версий
Отредактировано

## 1.1. Введение в DevOps — Вячеслав Медведев

Ссылка на скриншоты: https://disk.yandex.ru/d/HdwyvwvEVvwR9A

### Разработка задачи:
1. (менеджер) заводит задачу в таск-трекер
1. (разработчик) берёт задачу из таск-трекера
1. (разработчик) разрабатывает код для решения задачи
1. (разработчик) коммитит код в ветку, связанную с задачей
1. (старший разработчик/менеджер) ревьюит код, помечает задачу к тестированию
1. (тестировщик) разрабатывает автотесты для задачи
1. (devops) выполняет сборку приложения из ветки, связанной с задачей, деплоит приложение на тестовую среду, запускает автотесты. В случае успешного тестирования задача передаётся на включение в релиз. В случае неуспешного тестирования - возвращается в разработку.
1. (старший разработчик/менеджер) принимает задачу, включает задачу в релиз, мерджит ветку с решённой задачей в ветку следующего релиза

### Когда задачи на релиз кончились:
1. (devops) выполняет сборку приложения из ветки релиза, деплоит на тестовую среду, запускает автотесты. В случае успешного тестирования - тестовая среда готова для демонстрации заказчику. В случае неуспешного тестирования - деплоит на тестовую среду предыдущий работоспособный релиз. Уведомляет команду разработки (заводит таск в таск-трекер) о необходимости доработки релиза. 
