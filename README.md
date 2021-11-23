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
4. Ejecutar el inicializador del proyecto. El instalador pedira inputs para la creacion de infaestructura.
 4.1. Perfil: Si no configuraste tu perfil con algun nombre en especifico puedes utilizar el `default`.
 4.2. Stack Name: Puedes utilizar cualquier nombre, este sera con el cual se identificara tu stack del repositorio. (Sugerencia: repositorio-base)
 4.3. Region: Puedes utilizar cualquier region de AWS, sin embargo, en esta region deberas situar toda tu infraestructura. (Sugerencia fuerte: us-east-1)
 4.4. Confirmar cambios: No. (n)
 4.5. Permitir a SAM CLI la creacion de un role: Si. (y)
 4.6. Permitir a SAM CLI guardar los argumentos en un archivo de configuracion: Si. (y/)
 4.7. Archivo de configuracion: `samconfig.toml`.
 4.7. Configuracion de ambiente de SAM: `default`.
5. 

## ¿Que hace el instalador?
1. Sube el repositorio a AWS con el nombre de `repositorio-basico-iot`.
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
