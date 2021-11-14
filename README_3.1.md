**Какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?**\
***1GB RAM\
2 ядра\
Винт 64гб .vmdk\
видео VBoxVGA 4MB\
сеть NAT***


**Как добавить оперативной памяти или ресурсов процессора виртуальной машине?**\
Прописать в Vagrantfile:\
***v.memory = кол-во памяти\
v.cpus = кол-во CPU***


**Какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
Что делает директива ignoreboth в bash?**\
***HISTSIZE***\
_When the -o history option to the set builtin is enabled, the shell provides access to the command history, the list of commands previously typed.\
The value of the HISTSIZE variable is used as the number of commands to save in a history list.\
The text of the last HISTSIZE commands (default 500) is saved.\
The shell stores each command in the history list prior to parameter and variable expansion (see EXPANSION above) but after history expansion
is performed, subject to the values of the shell variables HISTIGNORE and HISTCONTROL._\
***ignoreboth сочетает значения ignorespace и ignoredups***


**В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?**\
***Brace Expansion***\
_Brace expansion is a mechanism by which arbitrary strings may be generated._\
_This mechanism is similar to pathname expansion, but the filenames generated need not exist._\
_Patterns to be brace expanded take the form of an optional preamble, followed by either a series of comma-separated strings or a sequence expression between a pair of braces, followed by an optional postscript._\
_The preamble is prefixed to each string contained within the braces, and the postscript is then appended to each resulting string, expanding left to right._\
_Brace expansions may be nested. The results of each expanded string are not sorted; left to right order is preserved._\
_For example, a{d,c,b}e expands into `ade ace abe'._


**Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов?**\
***touch {1..100000}***

**А получилось ли создать 300000? Если нет, то почему?**\
***В одну команду передается слишком много аргументов***\
_touch {1..300000}\
-bash: /usr/bin/touch: Argument list too long_


**Что делает конструкция [[ -d /tmp ]]?**\
***Проверяет, существет ли директория /tmp***


**Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:**

	```bash
	bash is /tmp/new_path_directory/bash
	bash is /usr/local/bin/bash
	bash is /bin/bash
	```
***[Screen](https://github.com/Borodatko/devops_netology/blob/c727572f0f280f2da3756cdaf46e26be0ebb53b0/PATH.jpg)***

**Чем отличается планирование команд с помощью batch и at?**\
***batch выполняет задания последовательно***\
***at выполняет задания параллельно***
