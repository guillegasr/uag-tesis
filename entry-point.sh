working_dir=$(pwd)
git clone https://github.com/guillegasr/uag-tesis.git github-uag-tesis


set -a # automatically export all variables
source $working_dir/github-uag-tesis/.env
set +a

# sed -i "s#fandoradb_password#root#" /fandora/java/FandoraDB/src/main/resources/configdb.xml