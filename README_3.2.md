**1.** ***Команда cd встроена в оболочку. Она использует переменные среды оболочки для определения необходимой информации и выполнения.***


**2.** ***grep -c***\
***-c, --count***\
_Suppress normal output; instead print a count of matching lines for each input file._  
_With the -v, --invert-match option (see below), count non-matching lines._


**3.** ***/sbin/init***\
_vagrant@vagrant:~$ ps aux | head  -2\
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND\
root           1  0.4  1.1 101692 11268 ?        Ss   14:05   0:01 /sbin/init_


**4.** ***ls 2> /dev/pts/1***


**5.** ***df -h | tee disk_usage.txt***


**6.** ***echo 123 > /dev/tty1, ctrl+alt+f1 для перехода tty1 и ctrl+alt+f7 возврата в GUI***
 

**7.**

_root@docker:\~# bash 5>&1\
root@docker:\~#_

_root@docker:~# echo netology > /proc/$$/fd/5\
netology_

***Команда аналогична >&1***


**8.** ***command 2>&1 > file | grep 'something'***


**9.** ***Выведет переменные окружения***\
***env; printenv; set; если просто PATH, то echo $PATH***


**10.** 
***/proc/[pid]/cmdline***\
_This read-only file holds the complete command line for the process, unless the process is a zombie.\
In the latter case, there is nothing in this file: that is, a read on this file will return 0 characters._

***/proc/[pid]/exe***\
_Under Linux 2.2 and later, this file is a symbolic link containing the actual pathname of the executed command.\
This symbolic link can be dereferenced normally; attempting to open it will open the executable._


**11.** ***sse4_2***


**12.** 
***vagrant@vagrant:~$ ssh -t localhost tty***\
_vagrant@localhost's password:\
/dev/pts/2\
Connection to localhost closed._

**13.**\
***htop\
ctrl+z\
screen\
reptyr $(pgrep htop)***

**14.** ***Tee берет со стандартного ввод и пишет в стандартный вывод и файл.***
