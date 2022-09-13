# grep all matching mouse pointer ids
str=$(xinput list | grep "G Pro.*pointer" | cut -f2 -d"=" | tr -s ' ' | cut -f1 -d '[' | grep -Eo '[0-9]{1,4}')

# set ifs to find new lines
IFS=$'
'

# G pro not in use so try to find MX Master
if [ -z "$str" ]
then
  str=$(xinput list | grep "Logitech MX Master 3" | grep "pointer" | cut -f2 -d"=" | tr -s ' ' | cut -f1 -d '[' | grep -Eo '[0-9]{1,4}')
fi


# loop pointers and set speed to each one of them
# since we don't know which of them is active
for mouse in $str; do echo "setting mouse with id: $mouse"; xinput set-prop $mouse "Coordinate Transformation Matrix" 0.4 0 0 0 0.4 0 0 0 1; done

# don't forget to unset ifs
# since we don't want it to be set to new lines for ever
unset IFS

echo "mouse speed set to 0.4..."
