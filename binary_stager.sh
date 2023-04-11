#!/bin/bash

# == MAXIMUM ULTIMATING USAGE FILE SIZE: 2600KB ! ==
# == maximum length splitting, may have to set smaller !!! ==
v_length='1006'
# == input file check and help menu ==
[ -f "$1" ] || echo -e '\nuse -> .\script <file>\n\nrecommended file size -> max.: 100KB !\n'
[ -f "$1" ] || exit
# == file size check ==
# v_round="$(ls -lsh "$1" | awk '{print $1}' | tr -d 'a-zA-Z ')" # rounded value
v_estim="$(ls -lsh "$1" | awk '{print $6}' | tr -d 'a-zA-Z ')" # estimated value
[ '100' -gt "$v_estim" ] || echo -e '\nFile size reaches -> 100KB, it can be annoying !!!\n'
# == strip check and choose exit ==
if [ -z "$(file "$1" | grep 'not stripped')" ]; then
 echo -e 'File is stripped ! :-)\n'
else
 echo -e 'File is not stripped!\nRecommended equivalent arc using, e.g. buildroot, in order to reduce the size.\n(Search like this: "find . | grep '\''strip$'\''")\n'
 echo -e 'example: strip -s -R .comment -R .note -R .gnu.version --strip-unneeded -O elf32-littlearm <file> # strip <file>\n'
read -p 'Do you want Exit? (y/n) ' yn_strp
 if [ "$yn_strp" = "y" ]; then
  echo -e '(chosen: exit)'
  exit
 else
  echo -e '(chosen: does not perform strip, continue...)'
 fi
fi
# == lzma compressing # order of effectiveness in one binary: lzma, xz, bz2, gzip, tar+bz2, tar+gz ==
# xz file can extracted with lzma, but not vice versa !!!
[ -d workdir ] && rm -rf workdir
[ -d result ] && rm -rf result
mkdir workdir result
cp "$1" workdir/z # create one char short name backup
lzma workdir/z
split -b 100K workdir/z.lzma --suffix-length=1 workdir/ # split by 100K if possible
# == make lowercase letters uppercase for better clarity. ==
bash -c "$(paste <(ls workdir/[a-z] | sed 's/.*/mv &/g') <(ls workdir/[a-z] | sed 's/\/[a-z].*/\U&/g') | sed 's/\t/ /g')"
# == Final workflow, creating multiple files at once if present. ==
for v_file in workdir/[A-Z]; do
 v_name=$(basename "$v_file")
 od -A n -t o1 "$v_file" | tr -d '\n' | sed 's/ /\n/g' | sed '/^[[:space:]]*$/d;s/000/0/g;s/^00//g;/^0[1-9]/s/^/\*/g;s/\*0//g' | paste -d ':' -s | sed 's/.*/:&/' > "${v_file}_oc.txt"
 sed "s/\(.\{$v_length\}\):/\1\n:/g" "${v_file}_oc.txt" > "${v_file}_oc_part.txt"
 sed "s/.*/printf \"&\">>$v_name/g;1s/>>/>/;s/:/\\\\/g" "${v_file}_oc_part.txt" > "result/${v_name}_pstgr.sh"
done
# == END ==
echo -e "\nProcess end !!!\nuse files -> result/*.sh\nuse after print -> cat [A-Z] | lzma -dc > execfile\n"
# od -A n -t o1 z.lzma | tr -d '\n' | sed 's/ /\n/g' | sed '/^[[:space:]]*$/d;s/000/0/g;s/^00//g;/^0[1-9]/s/^/\*/g;s/\*0//g' | paste -d ':' -s | sed 's/.*/:&/' > octal_colon.txt
# sed "s/\(.\{$v_length\}\):/\1\n:/g" octal_colon.txt > oc_part.txt; sed 's/.*/printf "&">>M/g;1s/>>/>/;s/:/\\/g' oc_part.txt > printf_stager_fast.sh
