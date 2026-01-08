# Save $PATH prior to env script call.
PATH_SAVE="$PATH"

# For command line builds of Zephyr.
. /opt/nordic/ncs/zephyr/zephyr-env.sh

# Do the PATH change in the script without adding '/bin' to the end.
PATH="$ZEPHYR_BASE/scripts:$PATH_SAVE"

# For the nRF Command Line Tools (nrfjprog)
NRF_CMD_LINE_DIR=/opt/nordic/nrf-command-line-tools
export PATH="$NRF_CMD_LINE_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NRF_CMD_LINE_DIR/lib"
