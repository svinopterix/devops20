# devops20
DEVOPS-20 homework repository

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
