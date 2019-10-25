export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Keep nvcc happy by using GCC 7.
export HOST_COMPILER=/opt/gcc-7.3.0/bin/g++-7.3.0
