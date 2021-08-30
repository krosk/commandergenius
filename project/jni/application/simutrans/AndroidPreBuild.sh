#!/bin/sh

if [ -e simutrans ]; then
	echo Simutrans SVN already downloaded
else
	svn checkout https://github.com/aburch/simutrans/trunk simutrans || exit 1
	cd simutrans || exit 1
	./get_lang_files.sh || exit 1
	cd ..
fi

echo Generating data.zip
mkdir -p AndroidData
cd simutrans
[ -e simutrans/pak ] || (wget --show-progress -nc https://downloads.sourceforge.net/project/simutrans/pak64/122-0/simupak64-122-0.zip && unzip -n simupak64-122-0.zip)
[ -e simutrans/pak64.german ] || (wget --show-progress -nc http://simutrans-germany.com/pak.german/pak64.german_0-122-0-0-2_full.zip && unzip -n pak64.german_0-122-0-0-2_full.zip)
cd simutrans
[ -e music/TimGM6mb.sf2 ] || wget -nc --show-progress https://sourceforge.net/p/mscore/code/HEAD/tree/trunk/mscore/share/sound/TimGM6mb.sf2?format=raw -O music/TimGM6mb.sf2
rm -f ../../AndroidData/data.zip
zip -r -0 ../../AndroidData/data.zip * >/dev/null
cd ../..
echo Generating data.zip done
