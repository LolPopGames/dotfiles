
        ((exec_time__exec_time > 86400)) && exec_time_text+="$((exec_time__exec_time / 86400))d " 
        ((exec_time__exec_time > 3600)) && exec_time_text+="$((exec_time__exec_time / 3600 % 24))h " 
        ((exec_time__exec_time > 60)) && exec_time_text+="$((exec_time__exec_time / 60 % 60))m " 
        exec_time_text+="$((exec_time__exec_time % 60))s "
    else exec_time_text=''
    fi
else exec_time_text=''
fi

