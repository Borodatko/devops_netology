**1.**
```
a+b # конкатенация a и b
1+2 # конкатенация значений строковых переменных $a и $b
3   # сложение целочисленных переменных $a и $b
```

**2.**
```bash
#!/usr/bin/env bash

#Добавили 2ую закрывающую скобку и сделали пробелы между скобками
while (( 1 == 1 ))
    do
        sleep 1
        #Изменили строку, чтобы не сыпало в stdout, перед этой строчкой сделали sleep 1 секунду
        curl -s https://localhost:4757 > /dev/null
        #Сделали пробелы между скобками
        if (( $? != 0 ))
            then
            #Указан полный путь хранения лога
            date >> /var/log/curl.log
        fi
    done
```

**3.**
```bash
#!/usr/bin/env bash

total=0
while (( $total < 5 ))
    do
        for addr in 173.194.222.113 87.250.250.242 192.168.0.1
            do
                curl -s -m 5 http://$addr:80 >> /dev/null
                if (( $? != 0 ))
                then
                    echo $addr "Problem at `date`" >> /var/log/http.log
                else
                    echo $addr "OK at `date`" >> /var/log/http.log
                fi
            done
        total=$(($total+1))
    done
```

**4.**
```bash
#!/usr/bin/env bash

while (( 1 == 1 ))
    do
        for addr in 173.194.222.113 87.250.250.242 192.168.0.1
            do
                curl -s -m 5 http://$addr:80 >> /dev/null
                if (( $? != 0 ))
                then
                    echo $addr "Problem at `date`" >> /var/log/error.log
                    exit 1
                else
                    echo $addr "OK at `date`" >> /var/log/http.log
                fi
            done
    done
```

**5.**
```bash
#!/usr/bin/env bash

pattern=04-script-01-bash
task=$1
message=$2

if [[ $task != $pattern ]] || [[ `echo -n $message | wc -c` < 30  ]]
    then
        echo "Bad commit message"
        exit 1
    else
        echo \[$pattern\] $message
fi
```
