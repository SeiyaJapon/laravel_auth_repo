help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

up: ## Up containers
	docker-compose up -d
build: ## Build
	docker-compose build --no-cache --force-rm
enter: ## install laravel
	docker-compose exec php sh
laravel-install: ## install laravel
	docker-compose run composer create-project laravel/laravel:^11.0 .
create-project: ## create project
	mkdir -p src
	cd src
	@make laravel-install
	@make build
	@make up
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan storage:link
	docker-compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh
init: ## init
	docker-compose up -d --build
	docker-compose run composer install
	docker-compose exec app cp .env.example .env
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan storage:link
	docker-compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh
remake: ## destroy and remake all
	@make destroy
	@make init
stop: ## composer stop
	docker-compose stop
down: ## composer down
	docker-compose down --remove-orphans
restart: ## down and up
	@make down
	@make up
destroy: ## destroy
	docker-compose down --rmi all --volumes --remove-orphans
destroy-volumes: ## asdasd
	docker-compose down --volumes --remove-orphans
ps: ## compose ps
	docker-compose ps
logs: ## show logs
	docker-compose logs
logs-watch: ## compose logs --follow
	docker-compose logs --follow
log-web: ## compose logs web
	docker-compose logs web
log-web-watch: ## compose logs --follow web
	docker-compose logs --follow web
log-app: ## compose logs app
	docker-compose logs app
log-app-watch: ## compose logs --follow app
	docker-compose logs --follow app
log-db: ## compose logs db
	docker-compose logs db
log-db-watch: ## compose logs --follow db
	docker-compose logs --follow db
web: ## compose exec web ash
	docker-compose exec web ash
app: ## compose exec app bash
	docker-compose exec app bash
route-list: ## php artisan route:list
	docker-compose exec app php artisan route:list
migrate: ## php artisan migrate
	docker-compose exec app php artisan migrate
fresh: ## php artisan migrate:fresh --seed
	docker-compose exec app php artisan migrate:fresh --seed
refresh: ## php artisan migrate:fresh --seed
	docker-compose exec app php artisan migrate:refresh --seed
seed: ## php artisan db:seed
	docker-compose exec app php artisan db:seed
dacapo: ## php artisan dacapo
	docker-compose exec app php artisan dacapo
rollback-test: ## migrate:fresh and migrate:refresh
	docker-compose exec app php artisan migrate:fresh
	docker-compose exec app php artisan migrate:refresh
tinker: ## php artisan tinker
	docker-compose exec app php artisan tinker
test: ## php artisan test
	docker-compose exec app php artisan test
optimize: ## php artisan optimize
	docker-compose exec app php artisan optimize
optimize-clear: ## php artisan optimize:clear
	docker-compose exec app php artisan optimize:clear
dumpauto: ## dump-autoload
	docker-compose run composer dump-autoload -o
cache: ## cache
	docker-compose run composer dump-autoload -o
	@make optimize
	docker-compose exec app php artisan event:cache
	docker-compose exec app php artisan view:cache
cache-clear: ## cache clear
	docker-compose run composer clear-cache
	@make optimize-clear
	docker-compose exec app php artisan event:clear
npm: ## install npm
	@make npm-install
npm-install: ## install npm
	docker-compose exec web npm install
npm-dev: ## npm run dev
	docker-compose exec web npm run dev
npm-watch: ## npm run watch
	docker-compose exec web npm run watch
npm-watch-poll: ## npm run watch-poll
	docker-compose exec web npm run watch-poll
npm-hot: ## npm run hot
	docker-compose exec web npm run hot
yarn: ## install yarn
	docker-compose exec web yarn
yarn-install: ## install yarn
	@make yarn
yarn-dev: ## yarn dev
	docker-compose exec web yarn dev
yarn-watch: ## yarn watch
	docker-compose exec web yarn watch
yarn-watch-poll: ## yarn watch-poll
	docker-compose exec web yarn watch-poll
yarn-hot: ## yarn hot
	docker-compose exec web yarn hot
db: ## db
	docker-compose exec db bash
sql: ## sql
	docker-compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
redis: ## redis redis-cli
	docker-compose exec redis redis-cli
ide-helper: ## ide helper
	docker-compose exec app php artisan clear-compiled
	docker-compose exec app php artisan ide-helper:generate
	docker-compose exec app php artisan ide-helper:meta
	docker-compose exec app php artisan ide-helper:models --nowrite
