# Working
## Descrição
Working é um sistema de gerenciamento de registros de entrada e saída, criado para facilitar o controle de horas trabalhadas em diferentes projetos. Cada projeto possui um valor atribuído por hora, e quando um registro de saída é feito, o sistema calcula automaticamente o período trabalhado e o valor total a ser recebido.

## Tecnologias utilizadas
- [Laravel](https://laravel.com/)
- [Livewire 3](https://livewire.laravel.com/)
- [TailwindCSS](https://tailwindcss.com/)
- [DaisyUI](https://daisyui.com/)
- [MySQL](https://www.mysql.com/)
- [Redis](https://redis.io/)

## Requisitos
- [Docker](https://docs.docker.com/get-docker/) com o plugin [Docker Compose](https://docs.docker.com/compose/) (v2)

Não é necessário ter PHP, Composer ou Node instalados na máquina: tudo roda dentro dos containers.

## Ambiente Docker
| Serviço   | Descrição                                                        | Acesso                  |
|-----------|------------------------------------------------------------------|-------------------------|
| `nginx`   | Servidor web                                                     | http://localhost:8000   |
| `app`     | PHP 8.2 (FPM) com as extensões do projeto, Composer e Xdebug     | -                       |
| `queue`   | Worker das filas (`php artisan queue:listen`)                    | -                       |
| `vite`    | Servidor de desenvolvimento do Vite (hot reload dos assets)      | http://localhost:5173   |
| `mysql`   | MySQL 8.4 (bancos `working` e `testing`)                         | `localhost:3306`        |
| `redis`   | Redis, utilizado como gerenciador de filas                       | `localhost:6379`        |
| `mailpit` | Caixa de e-mails local (captura os e-mails enviados pelo sistema) | http://localhost:8025   |

As portas podem ser alteradas no `.env` (`APP_PORT`, `VITE_PORT`, `FORWARD_DB_PORT`, `FORWARD_REDIS_PORT`, `FORWARD_MAILPIT_DASHBOARD_PORT`).

## Instalação
Siga os passos abaixo para configurar o ambiente de desenvolvimento:

### 1) Clonar o Repositório
- git clone https://github.com/CWillwohl/project-working
- cd project-working

### 2) Configurar o arquivo .env
Copie o arquivo de exemplo para desenvolvimento:

- cp .env.dev .env

O `.env.dev` já vem configurado para os containers. Pontos de atenção:
- `HOST_UID` e `HOST_GID` devem corresponder ao seu usuário (`id -u` e `id -g`), para que os arquivos criados pelos containers (como `vendor` e `node_modules`) pertençam a você. O padrão é `1000`.
- Os e-mails (como os de recuperação de senha) são capturados pelo Mailpit em http://localhost:8025. Se preferir usar um SMTP externo, como o [Mailtrap.io](https://mailtrap.io/), altere as variáveis `MAIL_*`.

### 3) Subir os containers
- docker compose up -d --build

Na primeira execução o container `app` instala as dependências do Composer, gera a `APP_KEY` e executa as migrations; o container `vite` instala as dependências do NPM. Isso pode levar alguns minutos. Acompanhe com:

- docker compose logs -f app vite

Quando terminar, acesse o projeto em http://localhost:8000.

### 4) Popular o banco (opcional)
- docker compose exec app php artisan db:seed

### Comandos Úteis
Para parar os containers:
- docker compose down

Para executar comandos Artisan:
- docker compose exec app php artisan <comando>

Para executar comandos do Composer:
- docker compose exec app composer <comando>

Para executar comandos do NPM:
- docker compose exec vite npm <comando>

Para executar os testes:
- docker compose exec app php artisan test

Para depurar com Xdebug, defina `XDEBUG_MODE=debug` no `.env` e recrie os containers com `docker compose up -d`. O Xdebug se conecta em `host.docker.internal:9003` quando a requisição tem o gatilho de debug (ex.: extensão Xdebug Helper no navegador).

Para apagar também os dados do MySQL e do Redis:
- docker compose down -v

### Considerações Finais
Sinta-se à vontade para adaptar o arquivo .env conforme suas necessidades, garantindo que todas as variáveis de ambiente estejam corretamente configuradas para o funcionamento do projeto.

---

Feito com ❤️ por Caio Willwohl
