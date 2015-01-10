#!/bin/sh
tmppath="tmp$$"
mkdir $tmppath
for shname in `cd package; ls *.v`
do 
	name=`echo "$shname" | awk -F. '{print $1}'`      
	cp package/$shname matrix.v     
	echo "synthsis for file $shname"
	make synthsis
	cp output/grid.rbf $tmppath/$name.rbf
done
cd $tmppath; tar -czf ../package/grid.tar.gz *.rbf; cd ..
rm -rf $tmppath
echo "tar.gz file is ready in the package path"
