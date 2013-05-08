for i in \
magic.eworldcom.hu \
discovery.eworldcom.hu \
icall-ewc-1.eworldcom.hu \
icall-ewc-2.eworldcom.hu \
maxi.eworldcom.hu \
icall-ltk-1 \
icall-itarab-1 \
devil.eworldcom.hu \
devil2.eworldcom.hu \
devil3.eworldcom.hu \
icall-multicom-1 \
icall-szonda-1 \
icall-szonda-2 \
icall-szonda-3 \
viking.eworldcom.hu
do
   echo 'ssh to host ' $i '...'
   #ssh $i uptime
   echo 'done.'
done
