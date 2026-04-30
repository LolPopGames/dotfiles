if ((exec_time_on == 1)); then
    exec_time_on=0
    local exec_time__exec_time=$(( SECONDS - exec_time_start )) 
    if ((exec_time__exec_time >= 1)); then
        exec_time_start=0 

