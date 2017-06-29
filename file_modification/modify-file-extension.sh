#!/bin/bash                                                                                                                                                             
#!/bin/bash

while getopts ":d:e:n:lo:" opt; do
    case $opt in
        #flag to set directory to process
        d)
	    echo " commandline flag d received"
            dir=$OPTARG
	    ;;
        #flag for setting the file extension to be removed / replaced
        e)
            #determine length of file extension
            ext=$OPTARG
            declare -i len_e=$(printf $OPTARG | wc -m)
            ;;
        #flag for setting a new file extension
        n)
            new_ext=$OPTARG
            ;;
        #flag to enable logging
        l)
            ;;
        o)
            isDir=$(echo $OPTARG | grep "/$")
            if [ $isDir ]; then 
                if [ ! -d "$OPTARG" ]; then mkdir -p $OPTARG ; fi
                if [ ! -d "'$OPTARG'extension-remover.log" ]; then touch "$OPTARG"extension-remover.log ; fi
                echo "Logging to custom directory: $OPTARG "
            else
                echo "Custom logfile name not supported, please supply only the desired storage directory (input must end with a trailing /)"
                echo "Logs will be stored in default location ~/log/"
                logdir='~/log/'
            fi 
            ;;

	\?)
	    echo " Invalid Option given"
	    ;;
    esac
done

log_it() {
    #@todo Insert code to write entry to log file
    echo "inside log_it func"
}


files=("$dir""$ext"*)                                                                                                                                                   

#iterate through files in chosen directory 
for f in "${!files[@]}"; do
    echo "iterating on "${files[f]}""
    echo "${files[f]}" > temp.file
    echo "${files[f]}" >> breadcrumbs.log
    if grep "$ext" "temp.file"; then
            echo ""${files[f]}" has extension $ext and will be modified"
            cat temp.file | gawk -v ext_len="$len_e" '{print substr($0,1,length()-ext_len)}' > temp2.file
            cat temp2.file | while read LINE
            do
                    echo "$LINE" >> ~/.log/bigcedar/modified.log
                    if ls "$dir" | grep "$files"; then rm "$LINE"; fi
                    mv "$f" "$LINE"                                                                                                                         
            done                                                                                                                                            
    else                                                                                                                                                    
            echo "${files[f]}" >> ~/.log/bigcedar/untouched.log                                                                                
    fi                                                                                                                                                      
done
if [ -a temp.file ];then rm temp.file; fi
if [ -a temp2.file ];then rm temp2.file; fi  
