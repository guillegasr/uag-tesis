clear
echo "== Sincronizando bucket=="
current_dir=$(pwd)
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

bucket_name=$(aws cloudformation describe-stacks --stack-name "${aws_environment}-0static-website-s3-${uag_id}" --profile $aws_profile --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' --output text)

aws s3 sync $current_dir/website/ s3://$bucket_name --profile $aws_profile
