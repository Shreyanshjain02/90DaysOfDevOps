Notes here:-

What happens if you remove the shebang line?
>if you don't use shebang (#!/bin/bash) execution will work but it good and optimized way to add shebang on top of script which flag or alert kernel to use bash(or any other interpreter) for following script execution.

Try using single quotes vs double quotes — what's the difference?
>In my case, argument($1) and variable ($name) is considered as string.
Research:-
Double Quotes (" ") act like a "translator"—they see the $ and look up the values of $1 and $wish to fill them in. GNU Bash Reference: Double Quotes
Single Quotes (' ') act like a "photocopy"—they don't care what the symbols mean; they just print exactly what they see. GNU Bash Reference: Single Quotes

Used all  Hints :-
Shebang: #!/bin/bash tells the system which interpreter to use
Variables: NAME="Shubham" (no spaces around =)
Read: read -p "Enter name: " NAME
If syntax: if [ condition ]; then ... elif ... else ... fi
File check: if [ -f filename ]; then\

Additional:-
How to download multiple file from server:-
  scp -i "SRE_Key.pem" ubuntu@ec2-35-92-136-126.us-west-2.compute.amazonaws.com:/home/ubuntu/Shell_Scripts/*.sh C:\Users\sjn46\Downloads

  explanation:- scp >> ssh detail:file (with path) (here we used wild card to download all .sh files)>>local download path
  result:-
    T1_hello.sh                   100%   44     0.0KB/s   00:01
    T2_variable.sh                100%   68     0.1KB/s   00:00
    T3_greet_read.sh              100%  116     0.1KB/s   00:00
    T4_check_number.sh            100%  231     0.2KB/s   00:01
    T4_file_check.sh              100%  163     0.2KB/s   00:00
    T5_server_check.sh            100%  174     0.2KB/s   00:00
    install_package.sh            100%  543     0.7KB/s   00:00
    system_usage.sh               100%  472     0.3KB/s   00:01

