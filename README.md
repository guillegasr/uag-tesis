# Despliegue automatizado de infraestructura en Amazon Web Services para aplicaciones de internet de las cosas
## Por: Guillermo Martin Gastelum Rodriguez

[![N|Solid](https://www.uag.mx/img/logoNegro.svg?u=9)]()
## Descripcion
Repositorio base para la creacion de una arquitectura simple para proyectos de internet de las cosas. El aprovisionamiento de infraestructura utiliza los siguientes recursos en AWS:
- [Amazon S3]
- [Amazon CloudFront]
- [Amazon API Gateway]
- [Amazon Lambda]
- [Amazon DynamoDB]
- [Amazon IoT]
- [Amazon Greengrass]

## Instalación

1. Descargar este repositorio.
2. [Instalar el CLI] de Amazon Web Services.
3. [Configurar AWS CLI]. (El instalador esta hecho para funcionar con el profil por defecto (default). En caso de configurar el perfil con un nombre especifico sera necesario modificarlo en el instalador.)
4. Ejecutar el inicializador del proyecto. (Este instalador es el encargado de aprovisionar la infraestructura necesaria para la integrcion y despliegue continuo de la infaestructura)

## ¿Que hace el instalador?
1. Sube el repositorio a AWS con el nombre de `basic-iot-repo`.
2. Aprovisionar la infraestructura necesaria para la integrcion y despliegue continuo de recursos en AWS.

[Amazon S3]: <https://aws.amazon.com/s3/>
[Amazon CloudFront]: <https://aws.amazon.com/cloudfront/>
[Amazon API Gateway]: <https://aws.amazon.com/api-gateway/>
[Amazon Lambda]: <https://aws.amazon.com/lambda/>
[Amazon DynamoDB]: <https://aws.amazon.com/dynamodb/>
[Amazon IoT]: <https://aws.amazon.com/iot-core/?nc=sn&loc=2&dn=3>
[Amazon Greengrass]: <https://aws.amazon.com/greengrass/?nc=sn&loc=2&dn=2>
[Instalar el CLI]: <https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html>
[Configurar AWS CLI]: <https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html>
