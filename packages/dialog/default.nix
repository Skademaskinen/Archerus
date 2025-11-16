{ pkgs, ... }:

message: command:

pkgs.writeShellScript "dialog.sh" ''
    FIFOIN="./pipe-in"
    FIFOOUT="./pipe-out"
    
    rm -rf "$FIFOIN" "$FIFOOUT"	# sanity removal
    
    mkfifo "$FIFOIN" "$FIFOOUT"
    
    ${pkgs.dialogbox}/bin/dialogbox <"$FIFOOUT" >"$FIFOIN" &
    DBPID=$!			# PID of the dialogbox
    
    trap "kill $DBPID &>/dev/null; wait $DBPID; rm -rf \"$FIFOIN\" \"$FIFOOUT\"" EXIT
    
    cat ${pkgs.writeText "commands.txt" ''
        add frame horizontal
        add label "${message}"
        add frame horizontal
        add stretch
        add pushbutton O&k okay apply exit
        add pushbutton &Cancel cancel exit
        end frame
        set okay default
        set cb1 focus       
    ''} > $FIFOOUT
    
    flag=0
    cbflag=0
    
    while IFS=$'=' read key value
    do
    	case $key in
    		dsbl)
    			if [ "$cbflag" == "0" ]
    			then
    				echo disable cb1 >"$FIFOOUT"
    				echo set dsbl title \"\&Enable option 1\" >"$FIFOOUT"
    				cbflag=1
    			else
    				echo enable cb1 >"$FIFOOUT"
    				echo set dsbl title \"\&Disable option 1\" >"$FIFOOUT"
    				cbflag=0
    			fi
    			;;
    		cb1)
    		# Note: disabled widgets are not reported
    			if [ "$value" == "1" ]
    			then
    				echo Option 1 is checked
    			else
    				echo Option 1 is unchecked
    			fi
    			;;
    		okay)
    			flag=1
                ${command}
    			;;
    		cancel)
    			flag=1
    			echo User clicked Cancel pushbutton
    			;;
    	esac
    done <"$FIFOIN"
    
    if [ "$flag" == "0" ]
    then
    	echo User closed the window
    fi
''
