#/bin/bash

# passwordless connection between server and hosts ( ssh-keygen / ssh-copy-id user@ip_host --> from the server )

function host1(){

# connection attempt set in case the host answer's slow; redirect the error messages in err file with date and time

ssh -o ConnectTimeout=10 -o ConnectionAttempts=3 user@ip_host1 > output1.txt 2>> >(while read line; do echo "$(date +"%Y-%m-%d %H:%M:%S"): ${line}"; done >> /home/err) << EOF
command1
command2
command3
...
EOF
}

function host2(){
ssh -o ConnectTimeout=10 -o ConnectionAttempts=3 user@ip_host2 > output2.txt 2>> >(while read line; do echo "$(date +"%Y-%m-%d %H:%M:%S"): ${line}"; done >> /home/err) << EOF
command1
command2
command3
...
EOF
}


host1
host2

# exclude first 9 lines ( informations displayed after ssh login and echo the output separatly by name of host )

echo -e "Host 1\n\n$(sed 1,9d output1.txt)" > result
echo -e "Host 2\n\n$(sed 1,9d output2.txt)" >> result
rm -f output1.txt
rm -f output2.txt

# mail the hosts checks and remove the file

cat result | mailx -s "Hosts Health Checks" name@domain
rm -f result

