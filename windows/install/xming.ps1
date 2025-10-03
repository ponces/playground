$ErrorActionPreference = 'Stop'

winget install Xming.Xming

setx DISPLAY "localhost:0.0"

# ssh -X user@hostname
# echo $DISPLAY
# export XAUTHORITY=$HOME/.Xauthority
# xauth list
