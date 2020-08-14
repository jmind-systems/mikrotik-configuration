#!/bin/sh

#read first argument, should be configfile
if [ -z "$1" ]; then 
    filename='test_config' #default value
else
    filename=$1
fi

#read second argument, should be ssh endpoint, example: "admin@192.168.88.1"
if [ -z "$2" ]; then
    endpoint='admin@router.lan' #default value
else
    endpoint=$2
fi


#The begin:
echo "Reading from $filename configuration and apply this on $endpoint router"


#Function for preparing long string for execution via ssh:
result_string="" #global variable
return_config() 
{   
    file=$1
    while read config_string
    do  
        #echo "Add next string $config_string;"
        if [ -z "$result_string" ]; then 
            result_string="$config_string" #first line
        else
            result_string="$result_string; $config_string"
        fi
        #echo "Result is: \n $result_string"
    done < $file
    echo $result_string
}

#Execute function and change global variable:
echo "Formating string: "
return_config $filename 

#Apply prepared config as string via ssh:
echo "Apply config:"
ssh $endpoint $result_string