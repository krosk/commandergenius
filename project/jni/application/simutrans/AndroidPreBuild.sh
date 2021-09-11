#!/bin/sh

if [ -e simutrans ]; then
	echo Simutrans SVN already downloaded
else
	svn checkout https://github.com/aburch/simutrans/trunk simutrans || exit 1
	cd simutrans || exit 1
	./get_lang_files.sh || exit 1
	cd ..
fi

[ ! -e simutrans/android/add_assets.sh ] || (cd simutrans/android; ./add_assets.sh; cd ../..)
echo Generating data.zip
mkdir -p AndroidData
cd simutrans/simutrans
rm -f ../../AndroidData/data.zip
zip -r -0 ../../AndroidData/data.zip * >/dev/null
cd ../..
echo Generating data.zip done
