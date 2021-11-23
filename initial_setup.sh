clear
echo "== Inicializando configuracion del proyecto =="
current_dir=$(pwd)
repos_dir=$current_dir/../

# COPIADO DE ARCHIVO ~CREDENTIALS~
FILE=~/.aws/credentials
if test -f "$FILE"; then
  exists=true
  cp ~/.aws/credentials ~/.aws/credentials2
  cp $current_dir/util/credentials ~/.aws/credentials
else
  cp $current_dir/util/credentials ~/.aws/credentials
fi

echo "$current_dir"
echo "Que perfil usaras? (uagrole)"
read aws_profile
echo "Que ambiente crearas? (beta)"
read aws_environment
echo "Matricula de usuario? (5636267)"
read uag_id

if [[ -z "$aws_profile" ]]; then
  aws_profile="uagrole"
fi
if [[ -z "$aws_environment" ]]; then
  aws_environment="beta"
fi

if [[ -z "$uag_id" ]]; then
  uag_id="5636267"
fi

working_dir="$current_dir/codecommit-repository/";

cd $working_dir && aws cloudformation deploy --template-file template.yaml --profile $aws_profile --stack-name "codecommit-repository-${uag_id}" --region us-east-1 --parameter-overrides UserId=$uag_id;

repo_url=$(aws cloudformation describe-stacks --stack-name "codecommit-repository-${uag_id}" --profile $aws_profile --query 'Stacks[0].Outputs[?OutputKey==`RepositoryURLOutput`].OutputValue' --output text)
codecommit_repo_name="codecommit-uag-tesis"
cd $repos_dir && git clone $repo_url $codecommit_repo_name
cp -r github-uag-tesis/* $codecommit_repo_name
cd $repos_dir/$codecommit_repo_name && git checkout -b beta && git add . && git commit -m "initial commit" && git push --set-upstream origin beta

# COPIADO GIT CREDENTIALS 
cp ~/.gitconfig ~/.gitconfig2
cp $current_dir/util/.gitconfig ~/.gitconfig
# COPIADO DE ARCHIVO ~CREDENTIALS~
FILE=~/.aws/credentials
if test -f "$FILE"; then
  exists=true
  cp ~/.aws/credentials ~/.aws/credentials2
  cp $current_dir/util/credentials ~/.aws/credentials
else
  cp $current_dir/util/credentials ~/.aws/credentials
fi

repo_name=$(aws cloudformation describe-stacks --stack-name "codecommit-repository-${uag_id}" --profile $aws_profile --query 'Stacks[0].Outputs[?OutputKey==`RepositoryNameOutput`].OutputValue' --output text)
s3_name=$(aws cloudformation describe-stacks --stack-name "codecommit-repository-${uag_id}" --profile $aws_profile --query 'Stacks[0].Outputs[?OutputKey==`S3Output`].OutputValue' --output text)

aws cloudformation deploy --capabilities CAPABILITY_NAMED_IAM --template-file $current_dir/codepipeline/template.yaml --stack-name codepipeline-app-$uag_id --profile $aws_profile --parameter-overrides RepositoryName=$repo_name BucketName=$s3_name UserId=$uag_id;

# REGRESANDO GIT CREDENTIALS
cp ~/.gitconfig2 ~/.gitconfig
rm ~/.gitconfig2

# REGRESAMOS DE ARCHIVO ~CREDENTIALS~
if "$exists" ; then
  cp ~/.aws/credentials2 ~/.aws/credentials
fi