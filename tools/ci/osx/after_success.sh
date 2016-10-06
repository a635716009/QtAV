PKG=$TRAVIS_BUILD_DIR/${QTAV_OUT}-QMLPlayer.dmg

cd $QTAV_OUT
cp -af lib_osx_x86_64_llvm/*.framework bin/Player.app/Contents/Frameworks
mkdir -p bin/Player.app/Contents/Resources/qml/QtAV
cp -avf lib_osx_x86_64_llvm/*.dylib bin/Player.app/Contents/Resources/qml/QtAV
cp -avf $TRAVIS_BUILD_DIR/qml/{plugins.qmltypes,Video.qml,qmldir} bin/Player.app/Contents/Resources/qml/QtAV
cp -avf $TRAVIS_BUILD_DIR/tools/sdk_osx.sh bin/Player.app/
macdeployqt bin/Player.app -dmg
hdiutil convert -format UDBZ bin/Player.dmg -o $PKG
cd -

wget http://sourceforge.net/projects/sshpass/files/sshpass/1.05/sshpass-1.05.tar.gz/download -O sshpass.tar.gz
tar zxf sshpass.tar.gz
cd sshpass-1.05
./configure
make
sudo make install
export PATH=$PWD:$PATH
cd $TRAVIS_BUILD_DIR
type -a sshpass
# ignore known hosts: -o StrictHostKeyChecking=no
sshpass -p $SF_PWD scp -o StrictHostKeyChecking=no $PKG $SF_USER,qtav@frs.sourceforge.net:/home/frs/project/q/qt/qtav/ci/
