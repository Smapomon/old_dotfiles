# 13 is g pro id in "xinput list" change if needed
str=$(xinput list | grep "G Pro.*pointer" | cut -f2 -d"=" | tr -s ' ' | cut -f1 -d '[' | grep -Eo '[0-9]{1,4}')
echo "mouse found with id: $str..."
xinput set-prop $str "Coordinate Transformation Matrix" 0.4 0 0 0 0.4 0 0 0 1
echo "mouse speed set to 0.4..."
