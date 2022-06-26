# devops20
DEVOPS-20 homework repository

## 3.3 - Операционные системы, лекция 1

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
