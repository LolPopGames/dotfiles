    if ((exec_time_on == 1)); then
        exec_time_on=0
        local exec_time$((SECONDS - exec_time_start))
        if ((exec_time >= 1)); then
            exec_time_start=0
            ((exec_time > 86400)) && exec_time_text+="$((exec_time / 86400))d " 
            ((exec_time > 3600)) && exec_time_text+="$((exec_time / 3600 % 24))h " 
            ((exec_time > 60)) && exec_time_text+="$((exec_time / 60 % 60))m " 
            exec_time_text+="$((exec_time % 60))s "
        else exec_time_text=''
        fi
    else exec_time_text=''
    fi
