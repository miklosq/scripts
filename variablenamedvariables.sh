var=DISPLAY
echo "var is" $var 
#echo ${!var} 	# bash only
eval echo $"$var" # dash/sh
if [ `eval echo $"$var"` = ":0.0" ]; then 
   echo OK
fi
