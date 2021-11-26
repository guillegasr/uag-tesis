#!/bin/bash

# Configuracion inicial
working_dir="~/repositorios/github-uag-tesis"
supervisord_path="$working_dir/supervisord.conf"
repos_dir="$working_dir/.."
mkdir ~/.aws
ln -s $working_dir/util/credentials ~/.aws/credentials
cp $working_dir/util/.gitconfig ~/.gitconfig

# Convertidor de variables
sed -i "s#AWS_ACCESS_KEY#$AWS_ACCESS_KEY#" ~/.aws/credentials
sed -i "s#AWS_SECRET_KEY#$AWS_SECRET_KEY#" ~/.aws/credentials
sed -i "s#AWS_ACCOUNT#$AWS_ACCOUNT#" ~/.aws/credentials
sed -i "s#ROOT_DOMAIN_NAME#$ROOT_DOMAIN_NAME#" $working_dir/infrastructure/0static-website-s3/beta.properties
sed -i "s#USER_ID#$USER_ID#" $working_dir/infrastructure/0static-website-s3/beta.properties
sed -i "s#USER_ID#$USER_ID#" $working_dir/infrastructure/1data-manager-app/beta.properties
sed -i "s#USER_ID#$USER_ID#" $working_dir/infrastructure/2api/beta.properties
sed -i "s#USER_ID#$USER_ID#" $working_dir/codecommit-repository/beta.properties

# Creacion de stack codecommit-repository-${USER_ID}
aws cloudformation deploy --template-file $working_dir/codecommit-repository/template.yaml --profile uagrole --stack-name "codecommit-repository-${USER_ID}" --region us-east-1 --parameter-overrides UserId=$USER_ID;

# Clonar repositorio dentro del contenedor y subir contenido a codecommit
codecommit_repo_name="codecommit-uag-tesis"
repo_url=$(aws cloudformation describe-stacks --stack-name "codecommit-repository-${USER_ID}" --profile uagrole --query 'Stacks[0].Outputs[?OutputKey==`RepositoryURLOutput`].OutputValue' --output text)
cd $repos_dir && git clone $repo_url $codecommit_repo_name
cp -r $working_dir/* $repos_dir/$codecommit_repo_name
cd $repos_dir/$codecommit_repo_name && git checkout -b beta && git add . && git commit -m "initial commit" && git push --set-upstream origin beta

# Creacion de stack codepipeline-app-$USER_ID
repo_name=$(aws cloudformation describe-stacks --stack-name "codecommit-repository-${USER_ID}" --profile uagrole --query 'Stacks[0].Outputs[?OutputKey==`RepositoryNameOutput`].OutputValue' --output text)
s3_name=$(aws cloudformation describe-stacks --stack-name "codecommit-repository-${USER_ID}" --profile uagrole --query 'Stacks[0].Outputs[?OutputKey==`S3Output`].OutputValue' --output text)
aws cloudformation deploy --capabilities CAPABILITY_NAMED_IAM --template-file $repos_dir/$codecommit_repo_name/codepipeline/template.yaml --stack-name codepipeline-app-$USER_ID --profile uagrole --parameter-overrides RepositoryName=$repo_name BucketName=$s3_name UserId=$USER_ID;
sleep 30

# Esperar a que termine la creacion para poder subir el contenido al bucket de S3. Necesitamos esperar al stack de S3 y de API.
state='Init'
while [ "$state" != "Succeeded" ]; do
  echo $state
  state=$(aws codepipeline get-pipeline-state --name app-pipeline-$USER_ID --profile uagrole --query 'stageStates[?stageName==`Beta`].latestExecution.status' --output text)
  sleep 10
done

bucket_name=$(aws cloudformation describe-stacks --stack-name "${ENVIRONMENT}-0static-website-s3-${USER_ID}" --profile uagrole --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' --output text)
api_id=$(aws cloudformation describe-stacks --stack-name "${ENVIRONMENT}-2api-${USER_ID}" --profile uagrole --query 'Stacks[0].Outputs[?OutputKey==`ApiIdOutput`].OutputValue' --output text)

# Convertir variable de API ID al valor real.
sed -i "s#YOUR_API_ID#$api_id#" $repos_dir/$codecommit_repo_name/website/appController.js

# Sincronizacion de bucket de S3
aws s3 sync $repos_dir/$codecommit_repo_name/website/ s3://$bucket_name --profile uagrole

# Sustitucion de valores de scripts de python.
# edge_publisher.py
sed -i "s#USER_ID#$USER_ID#" $working_dir/util/Raspberry/edge_publisher.py
sed -i "s#ENVIRONMENT#$ENVIRONMENT#" $working_dir/util/Raspberry/edge_publisher.py
sed -i "s#AWS_ACCOUNT#$AWS_ACCOUNT#" $working_dir/util/Raspberry/edge_publisher.py

# on_event.py
sed -i "s#USER_ID#$USER_ID#" $working_dir/util/Raspberry/on_event.py
sed -i "s#ENVIRONMENT#$ENVIRONMENT#" $working_dir/util/Raspberry/on_event.py
sed -i "s#AWS_ACCOUNT#$AWS_ACCOUNT#" $working_dir/util/Raspberry/on_event.py

supervisord -c $supervisord_path