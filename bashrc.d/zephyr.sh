# For command line builds of Zephyr.
. /opt/nordic/ncs/zephyr/zephyr-env.sh

# For the nRF Command Line Tools (nrfjprog)
NRF_CMD_LINE_DIR=/opt/nordic/nrf-command-line-tools
export PATH="$PATH:$NRF_CMD_LINE_DIR/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NRF_CMD_LINE_DIR/lib"
