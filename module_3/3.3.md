**1.** ***chdir("/tmp")***

**2.**\
***/etc/magic***\
***/usr/share/misc/magic.mgc***

**3.**\
***Перенаправить в файл и затем подчистить его***\
_cat /proc/1111/fd/5 > /var/log/app.log_

**4.** ***Нет, может использлвать лишь объем, необходимый для хранения своего дескриптора.\
Но зомби процесс сохраняет за собой PID. Учитывая, что в 32х битной системе кол-во PID - 32767, накопление зомби процессов может
привести к заполнению пула PID, не допуская к запуску другие процессы.***

**5.**\
***PID    COMM               FD ERR PATH\
585    irqbalance          6   0 /proc/interrupts\
585    irqbalance          6   0 /proc/stat\
585    irqbalance          6   0 /proc/irq/20/smp_affinity\
585    irqbalance          6   0 /proc/irq/0/smp_affinity\
585    irqbalance          6   0 /proc/irq/1/smp_affinity\
585    irqbalance          6   0 /proc/irq/8/smp_affinity\
585    irqbalance          6   0 /proc/irq/12/smp_affinity\
585    irqbalance          6   0 /proc/irq/14/smp_affinity\
585    irqbalance          6   0 /proc/irq/15/smp_affinity***


**6.**\
***uname({sysname="Linux", nodename="docker", ...}) = 0***
***/proc/version***\
_This string identifies the kernel version that is currently running.\
It includes the contents of /proc/sys/kernel/ostype, /proc/sys/kernel/osrelease, and /proc/sys/kernel/version.\
For example:\
Linux version 1.0.9 (quinlan@phaze) #1 Sat May 14 01:51:54 EDT 1994_

_root@docker:~# cat /proc/version\
Linux version 5.10.0-9-amd64 (debian-kernel\@lists.debian.org) (gcc-10 (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2) \#1 SMP Debian 5.10.70-1 (2021-09-30)_


**7.**\
***Команды через ; будут выполнены не зависимо от результата предыдущей.\
Команды через && будут выполнены только при успешном выполнении предыдущей команды.\
Если выполнять команду в консоли, то удобнее использовать &&, в скрипте указывать set -e.***

**8.**\
***-e  Exit immediately if a command exits with a non-zero status.\
-u  Treat unset variables as an error when substituting.\
-x  Print commands and their arguments as they are executed.\
-o option-name\
pipefail the return value of a pipeline is the status of the last command to exit with a non-zero status, no command exited with a non-zero status\
Можно использовать для отладки программ.***

**9.** ***S***
