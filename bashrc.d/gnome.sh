# Reload gnome.
function gnome-reload() {
    gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'Main.loadTheme();' >&/dev/null
    echo "Reopen windows to see the changes."
}
