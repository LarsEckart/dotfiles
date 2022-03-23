if ( "$SSH_AGENT_PID" != "" ) then
        eval `/usr/bin/ssh-agent -k`
endif
