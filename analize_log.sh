#!/bin/bash

shopt -s lastpipe

if [ -f ./server.log ]; then
    rm server.log
    echo "server.log file found. Removing it"
fi

wget https://raw.githubusercontent.com/akjolkg/tntk/4f47929e79726836a170d25f13e0279136cb29f9/tntk.log -O server.log

# if [ $? -eq 0 ]; then
#     cat ./server.log
# fi

#URLS
#User Activity Pattern

count_pending_messages='count_pending_messages'
get_messages='get_messages'
get_friends_messages='get_friends_progress'
get_friends_score='get_friends_score'
fb_request_messages='fb_request_messages'
files="files"

arr=($count_pending_messages $get_messages $get_friends_messages $get_friends_score $fb_request_messages $files)

echo ${arr[@]}

# Functions

# Count occurences
count_lines() {
    cat server.log | grep "$1" | wc -l
}

count_request_times() {
    grep "$1" server.log | while read -r line; do
        field_num=$2  # Set this dynamically as needed
        field=$(echo "$line" | awk -v num="$field_num" '{print $num}')
        local num=$(echo "$field" | sed 's/[a-zA-Z=]*//g')
        ((sum+=num))
    done
}



final_function() {

    local sum=0
    #count service

    count_request_times $1 9
    count_request_times $1 10

    #count words
    local lines=$(count_lines $1)
    echo "Total requests for $1: $lines"
    # local avg=$(($sum/$lines))
    local avg=$(echo "scale=2; $sum / $lines" | bc)
    echo "avg time for $1 is: $avg"
}


print_analitics() {
    for item in ${arr[@]}; do
        final_function $item
        echo "======================"
    done
}

print_analitics




