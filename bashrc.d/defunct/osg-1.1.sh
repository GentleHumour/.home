export OSG_VERSION=1.1
export OSGHOME=/opt/osg-$OSG_VERSION
export PATH="$PATH:$OSGHOME/share/OpenSceneGraph/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$OSGHOME/lib:$OSGHOME/lib/osgPlugins"
export OSG_FILE_PATH=/opt/OpenSceneGraph-Data:/opt/OpenSceneGraph-Data/Images

export OPENTHREADS_INC_DIR=$OSGHOME/include
export OPENTHREADS_LIB_DIR=$OSGHOME/lib
export PRODUCER_INC_DIR=$OSGHOME/include
export PRODUCER_LIB_DIR=$OSGHOME/lib
