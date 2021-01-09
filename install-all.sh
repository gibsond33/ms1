#!/usr/bin/env bash


INSTALL_DIR=/home/gd/workarea/mstest

[ -d ${INSTALL_DIR}/bin ] || mkdir -pv ${INSTALL_DIR}/bin

cp -pv MS ${INSTALL_DIR}/bin
#cp -pv stock/*.so ${INSTALL_DIR}/bin
#cp -pv stock/stock ${INSTALL_DIR}/bin
#cp -pv purchase/*.so ${INSTALL_DIR}/bin
#cp -pv purchase/purchase ${INSTALL_DIR}/bin
cp -pv common/*.so ${INSTALL_DIR}/bin
cp -pv common/syssetup ${INSTALL_DIR}/bin

echo "Do you want to run the program?"
read input

if [ ${input} == "Y" ] || [ ${input} == "y" ]; then
	PATH=${INSTALL_DIR}/bin:${PATH}
	export COB_LIBRARY_PATH=${INSTALL_DIR}/bin
  cd ${INSTALL_DIR}
  bin/MS
fi

