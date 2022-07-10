# devops20
DEVOPS-20 homework repository

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
