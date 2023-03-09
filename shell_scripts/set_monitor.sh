xrandr --output DVI-I-2-2 --primary
xrandr --output eDP-1 --mode 2560x1600 --rate 59.99
xrandr --output DVI-I-2-2 --mode 3440x1440 --rate 49.99 --right-of eDP-1
xrandr --output DVI-I-1-1 --mode 1920x1080 --rate 60.00 --right-of DVI-I-2-2
#xrandr --output DP-4 --primary
#xrandr --output DP-4 --mode 3440x1440 --rate 165.00 --right-of DP-0
#echo "monitor 1 set..."
#xrandr --output DP-2 --mode 2560x1440 --rate 165.00 --right-of DP-4
#echo "monitor 2 set..."
#xrandr --output DP-0 --mode 2560x1440 --rate 165.00 --left-of DP-4
#echo "monitor 3 set..."

# not using nitrogen for now
#nitrogen --restore
#echo "restored wallpapers..."
