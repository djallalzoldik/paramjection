# paramjection

During work, we will search for parameters and try to injected them And that takes work and time Especially when it's as complicated as this ▶ grep -HnrE '(\$_(POST|GET|COOKIE|REQUEST|SERVER|FILES)|php://(input|stdin))' *

So paramjection will do this work for you it will try to find specific parameters and injecting them according to what you want

![This is an image](https://github.com/djallalzoldik/paramjection/blob/master/paramjectionMap.png)

## Features !

+ Find a specific parameter and you can inject what you want
+ Inject parameter with specific kind like (ssrf,or xss ....etc)
+ Encode the injection paramter
+ unique output

if you have link like this https://example.com?url=xxx&page=sss , let assume (url and page ) params belong to type ssrf so the output will be

```
https://example.com?url=collabrator&page=sss
https://example.com?url=xxx&page=collabrator
```
NOT
```
https://example.com?url=collabrator&page=collabrator
```

## HOW TO USE

There are two different way to use paramjection
### 1 First way Finding common parameters such as [ssrf,xss,lfi....etc]
### 2 Second way Finding specific param which is set by the user

## First way :

There are 7 Options comes with -k argument wich are [ssrf,redirect,xss,idoor,isql,rce,lfi,all] 
+ use the argument -c with ssrf and redirect 
+ use the argument -w with xss,idor, also with -f find param 
+ second way use the argument -p with isql,rce,lfi

+ Analyze the list and try to find ssrf pramters , you can use -c argument to add your collabrator
```
./paramjection.sh -k ssrf -c xxxxxxxxxxxxxxxxxxxxxxxxxxx.oast.site
```

Analyze the list and try to find xss pramters , you can use -w argument to add your word
```
./paramjection.sh -k xss -w hello
```

Analyze the list and try to find lfi pramters , you can use -p argument to add your payloads list
```
./paramjection.sh -k lfi -p /home/kali/payloads.txt
```
If you have list and try to find all the kinds [ssrf rce xss ...etc ,] type this command

```
./paramjection.sh -k all -c xxxxxxxxxxxxxxxxxxxxxxxxxxx.oast.site

```
## Second way :

some time you have list and try to find specific param and injected with specific word

```
./paramjection.sh -f specificparam -w hello

```

# Install

```
git clone https://github.com/djallalzoldik/paramjection.git
```
```
sudo chmod +x paramjection.sh
```
