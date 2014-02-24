export VTKDIR=/opt/vtk-4.4
export VTKSODIR="$VTKDIR/lib/vtk"
export PATH="$PATH:$VTKDIR/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$VTKSODIR"
export PYTHONPATH="$PYTHONPATH:$VTKSODIR:$VTKDIR/lib/python2.3/site-packages/vtk_python"
export TCLLIBPATH="$TCLLIBPATH $VTKDIR/lib/vtk/tcl"
export VTK_DATA_ROOT=/opt/VTKData
