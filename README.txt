# binary-stager
executable binary file staging and splitting for limited shells
===============================================================
(maximum length splitting, may have to set smaller in script)

./script <file>
recommended file size -> max.: 100KB !

lzma compressing # order of effectiveness in one binary: lzma, xz, bz2, gzip, tar+bz2, tar+gz
xz file can extracted with lzma, but not vice versa !!!

(search for executable binary)
find / -name "strip" -executable -type f

