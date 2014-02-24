export MAVENDIR=/opt/apache-maven-3.0.5
export PATH="$PATH:$MAVENDIR/bin"

# Leave my user name out of the META-INF/MANIFEST.MF Built-By field.
alias mvn='mvn -Duser.name=""'
