xrandr --output DP-4 --primary
xrandr --output DP-4 --mode 2560x1440 --rate 165.00 --right-of HDMI-0
echo "monitor 1 set..."
xrandr --output DP-2 --mode 2560x1440 --rate 165.00 --right-of DP-4
echo "monitor 2 set..."
xrandr --output HDMI-0 --mode 1920x1080 --rate 119.98 --left-of DP-4
echo "monitor 3 set..."

# not using nitrogen for now
#nitrogen --restore
#echo "restored wallpapers..."
