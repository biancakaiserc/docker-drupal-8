
# README

## Dependências

- PHP 7.1
- Apache 2.2
- MySQL client 5.7


## Bibliotecas PHP
- php-xml
- php-pdo
- php-mysql
- php-gd

## Como usar

Para usar esse container você precisa primeiro criar um fork ou clonar esse repositório.

Em seguida vá até o arquivo .gitignore na raiz do projeto e remova as linhas seguintes do comentário:

`## Remove this lines when using your project`

Remova esse Readme e faça as alterações necessárias para o seu projeto.

## Instalação

Crie um arquivo .env baseado no example.env.txt

Em seguida rode o docker-compose:

`$ docker-compose up`

> Use o parametro -d para rodar o comando acima sem log

Durante esse processo ele ira criar a imagem, o container e configurar os arquivos baseados nas variaveis do .env criado

### Drupal

### Gerando um Hash Salt

Ao tentar abrir o projeto pela primeira vez ele irá gerar um erro que o *settings['hash_salt]* esta faltando, esse hash é gerado quando a instalação é limpa e feita via interface (sem utilizar dump), para resolver esse problema há duas opções:

#### Usando o Drush

Para usar essa opção faça:

1. Entre no container do cms atraves do comando:
`docker exec -it [PROJECT_NAME]-app bash`

2. Rode o seguinte comando do Drush:
`vendor/bin/drush eval "var_dump(Drupal\Component\Utility\Crypt::randomBytesBase64(55))"`

3. Copie a string gerada

4. Cole a string no arquivo settings.local.php da seguinte forma:
`settings['hash_salt']='[STRING]';`

#### Instalando via interface

1. Acesse o site através da porta

2. Siga com os passos de instalação e defina os valores para a parte de banco de dados usando as variáveis MYSQL definidas no seu .env

3. O hash e o array database serão gerados no arquivo *settings.php*, copie o hash deste arquivo e cole no arquivo *settings.local.php*

4. Dê um git checkout no arquivo *settings.php*

### Importando banco de dados

Depois de configurado o site, importe um dump recente do banco para o seu ambiente para pegar os conteúdos cadastrados.

Para fazer a importação descompacte o sql.

#### Usando o mysql do container:

1. Rode `docker exec -it [PROJECT_NAME]-app` para entrar no container

2. `vendor/bin/drush sqlc < [PATH]/[NAME].sql`

#### Usando o mysql local

1. `mysql -u[USER] -p[PASSWORD] [DATABASE_NAME] < [PATH]/[NAME].sql`

2. Altere os dados no arquivo settings localizado em:
`/docroot/sites/default/settings.local.php`

```php
$databases['default']['default'] = array (
  'database' => '[PROJECT_NAME]',
  'username' => '[USER_DO_BANCO]',
  'password' => '[SENHA_DO_BANCO]',
  'prefix' => '',
  'host' => '[SEU_HOST_LOCAL]',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
```

## Configurações

As configurações estão sendo importadas usando o módulo  **Configuration Management**.

Para utilizar via interface, vá para:

*Admin > Configurações > Development > Configuration Synchronization*

ou

`https://[URL_DO_AMBIENTE]/admin/config/development/configuration`

Parta usar via terminal, acesse o bash do seu container com:

`docker exec -it [PROJECT_NAME]-app bash`

e rode os comandos:

Importar:
`vendor/bin/drush config:import`
ou
`vendor/bin/drush csim`

Exportar:
`vendor/bin/drush config:export`
ou
`vendor/bin/drush csex`

## Referencias

[Using Composer with Drupal](https://www.drupal.org/docs/develop/using-composer/using-composer-with-drupal)

[Drupal 7 with composer](http://cambrico.net/drupal/using-composer-to-build-your-drupal-7-projects)

[Drupal Composer](https://github.com/drupal-composer)

[Wodby - Docker-based Drupal stack](https://github.com/wodby/docker4drupal)
