#!/bin/bash

set -e

# Installing requried packages

sudo apt-get install bison g++ texinfo squashfs-tools gawk make syslinux-utils xorriso

if [ $(readlink /bin/sh) != "/bin/bash" ]; then
	ln -svf /bin/bash /bin/sh
fi

# Installing development libraries

if [ ! -f /usr/lib/libgmp.la ]; then
	wget http://ftp.gnu.org/gnu/gmp/gmp-6.1.0.tar.xz
	tar xf gmp-6.1.0.tar.xz 
	cd gmp-6.1.0/
	./configure --prefix=/usr && make -j$(nproc) && sudo make install
	cd ..
	rm -rf gmp-6.1.0/
fi

if [ ! -f /usr/lib/libmpfr.la ]; then
	wget http://www.mpfr.org/mpfr-3.1.3/mpfr-3.1.3.tar.xz
	tar xf mpfr-3.1.3.tar.xz 
	cd mpfr-3.1.3/
	./configure --prefix=/usr && make -j$(nproc) && sudo make install 
	cd ..
	rm -rf mpfr-3.1.3/
fi

if [ ! -f /usr/lib/libmpc.la ]; then
	wget https://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
	tar xf mpc-1.0.3.tar.gz 
	cd mpc-1.0.3/
	./configure --prefix=/usr && make -j$(nproc) && sudo make install 
	cd ..
	rm -rf mpc-1.0.3/
fi

# Checking once again.
cat > version-check.sh << "EOF"
#!/bin/bash
# Simple script to list version numbers of critical development tools
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1
if [ -h /usr/bin/yacc ]; then
 echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
 echo yacc is `/usr/bin/yacc --version | head -n1`
else
 echo "yacc not found" 
fi
bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1
if [ -h /usr/bin/awk ]; then
 echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
 echo awk is `/usr/bin/awk --version | head -n1`
else 
 echo "awk not found" 
fi
gcc --version | head -n1
g++ --version | head -n1
ldd --version | head -n1 | cut -d" " -f2- # glibc version
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1
xz --version | head -n1
echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
 then echo "g++ compilation OK";
 else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF
bash version-check.sh

# Checking libraries
cat > library-check.sh << "EOF"
#!/bin/bash
for lib in lib{gmp,mpfr,mpc}.la; do
 echo $lib: $(if find /usr/lib* -name $lib|
        grep -q $lib;then :;else echo not;fi) found
done
unset lib
EOF
bash library-check.sh

