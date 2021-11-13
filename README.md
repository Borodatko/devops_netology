**1.** Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.\
***commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545\
comment Update CHANGELOG.md***

Команда: _git log -n 1 aefea_


**2.** Какому тегу соответствует коммит 85024d3?\
***tag: v0.12.23***

Команды:\
_git log -n 1 85024d3,\
либо git tag --contains=85024d3,\
**но в выхлопе последней команды отображаются несколько тегов:**\
***v0.12.23*** <-\
v0.12.24\
v0.12.25\
v0.12.26\
v0.12.27\
v0.12.28\
v0.12.29\
v0.12.30\
v0.12.31_


**3.** Сколько родителей у коммита b8d720? Напишите их хеши.\
***commit 9ea88f22fc6269854151c571162c5bcf958bee2b\
commit 56cd7859e05c36c06b56d013b55a252d0bb7e158***

Команда: _git show b8d720^2_


**4.** Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.\
***commit 85024d3100126de36331c6982bfaac02cdab9e76\
comment v0.12.23***

Команды:\
_git show-ref --tags -d_\
_git show 85024d3100126de36331c6982bfaac02cdab9e76_


**5.** Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func\ providerSource(...) (вместо троеточего перечислены аргументы).\
***commit 5af1e6234ab6da412fb8637393c5a17a1b293663***

Команды:\
_git grep -p "func providerSource"_\
_git log -L :"func providerSource":provider_source.go -n 1 | grep commit_


**6.** Найдите все коммиты в которых была изменена функция globalPluginDirs.\
***commit 78b12205587fe839f10d946ea3fdc06719decb05\
commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46\
commit 41ab0aef7a0fe030e84018973a64135b11abcd70\
commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17\
commit 8364383c359a6b738a436d1b7745ccdce178df47***

Команды:\
_git grep -p "globalPluginDirs"_\
_git log -L :globalPluginDirs:plugins.go | grep commit_


**7.** Кто автор функции synchronizedWriters?\
***Martin Atkins***

Команды:\
_git log -SsynchronizedWriters --oneline_\
_git log --pretty=format:"%H, %an" | grep 5ac311e2a_
