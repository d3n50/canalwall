#!/bin/bash

code='apxvodkefoskjvbakcjnkjvcdsavicjklsdfihhvkjsxksfslajd' #### CHANGE THIS RANDOM STRING (You can put whatever you want, but must be random and long)

########### HELP

echo 'Read the file "README.txt"'
echo -e "\e[92mYou must add something like this "$code" to some interesting file like /etc/passwd"
echo "or you can create some file like passwords.txt and add the random string"
echo
echo
echo -e "\e[33mAnother option is: rename some use binary and create a script with the name of the real binary, like this:"
echo
echo "mv /usr/bin/id /usr/bin/.id"
echo '#!/bin/bash > /usr/bin/id'
echo "echo .id '$(echo '"$@";echo -e "\e[8m;30m'$code'\e[28m"')' > /usr/bin/id"
echo -e "\e[34m"

############# ADD CODE TO COMMANDS

read -p "Do you want to change the binary automatically? (y/n): " auth

if [ "$auth" == "y" ] || [ "$auth" == "Y" ];then

        read -p "Please, add the code here (30-50 characters): " codigo
	code=$codigo
        echo -e "\e[93mPlease, try to use some of the next commands:\nid\nwhoami\nuname\n"
	echo
        echo -e "\e[31mAnd dont use:\ncd\nls\ncat\npwd\n\e[34m"

        while true;do

                read -p "Tell me what command you wanna change: " command
                cp $(which $command) $(echo $(which $command) | sed 's/'"$command"'/\.'"$command"'/g')
                echo '#!/bin/bash' > $(which $command)
                echo 'echo $('.$command '"$@")$(echo -e "\e[8m;30mapxvodkefoskjvbakcjnkjvcdsavicjklsdfihhvkjsxksfslajd\e[28m")' >> $(which $command)
                echo -e "\e[39mDONE\e[34m"
                echo
                read -p "¿Add in another binary?" re

                if [ "$re" == "n" ] || [ "$re" == "N" ];then

                        break

                fi

        done
fi
