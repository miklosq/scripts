n=1
while [ $n -le 5 ]; do 
   tmpvar=bela
   echo $n
   n=$((n+1))
done

echo $tmpvar
exit 0
