#!/bin/bash

shopt -s lastpipe

#If file 'server.log' exists, remove it
if [ -f ./server.log ]; then
    rm server.log
    echo "server.log file found. Removing it"
fi

#Download and save in new 'server.log'
wget https://raw.githubusercontent.com/akjolkg/tntk/4f47929e79726836a170d25f13e0279136cb29f9/tntk.log -O server.log

#User Activity Pattern
count_pending_messages='count_pending_messages'
get_messages='get_messages'
get_friends_messages='get_friends_progress'
get_friends_score='get_friends_score'
fb_request_messages='fb_request_messages'
files="files"

arr=("$count_pending_messages" "$get_messages" "$get_friends_messages" "$get_friends_score" "$fb_request_messages" "$files")

# Functions

# Count occurences
count_lines() {
    cat server.log | grep "$1" | wc -l
}

# Function to count service and connect times
count_request_times() {
    grep "$1" server.log | while read -r line; do
        field_num=$2  # Set this dynamically as needed
        field=$(echo "$line" | awk -v num="$field_num" '{print $num}')
        local num=$(echo "$field" | sed 's/[a-zA-Z=]*//g')
        ((sum+=num))
    done
}



consolidate() {
    local sum=0

    #count service and connect (updates local sum)
    count_request_times $1 9
    count_request_times $1 10

    #count words
    local lines=$(count_lines $1)
    echo "Total requests for $1: $lines"
    
    #count average including decimals
    local avg=$(echo "scale=2; $sum / $lines" | bc)
    echo "avg time for $1 is: $avg"
}


print_analitics() {
    for item in ${arr[@]}; do
        echo "======================"
        consolidate $item
    done
}

echo "======================"

print_analitics




