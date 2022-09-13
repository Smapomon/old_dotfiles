xrandr --output DP-1-1 --primary
xrandr --output DP-1-1 --mode 3440x1440 --rate 49.99 --right-of HDMI-0
echo "monitor 1 set..."
xrandr --output eDP-1 --mode 1920x1080 --rate 60.00 --left-of DP-1-1
echo "monitor 2 set..."
xrandr --output DP-2 --mode 1920x1080 --rate 60.00 --right-of DP-1-1
echo "monitor 3 set..."

# not using nitrogen for now
#nitrogen --restore
#echo "restored wallpapers..."
