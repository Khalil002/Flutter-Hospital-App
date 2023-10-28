# Flutter-Hospital-App

Deberia de poder correr si tienes Docker
Corre el siguientes commandos en el host, en la carpeta de fresh-laravel:

./vendor/bin/sail up. 

corre los siguientes commandos dentro del container 'fresh-laravel-laravel.test-1'

composer require Laravel/jetstream

php artisan jetstream:install livewire

php artisan vendor:publish --tag=jetstream-views

php artisan vendor:publish --provider=“Laravel\Fortify\FortifyServiceProvider”

php artisan vendor:publish --provider=“Laravel\Sanctum\SanctumServiceProvider”


Corre el migrador de php para migrar la base de datos
php aritsan migrate:fresh

Corre este comando en otra terminal en el host, en la carpeta de fresh-laravel
Npm run dev 
