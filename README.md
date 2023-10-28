# Flutter-Hospital-App

Deberia de poder correr si tienes Docker <br />
Corre el siguientes commandos en el host, en la carpeta de fresh-laravel: <br />
$./vendor/bin/sail up.  <br /> <br />
corre los siguientes commandos dentro del container 'fresh-laravel-laravel.test-1' <br />
$ composer require Laravel/jetstream <br />
$ php artisan jetstream:install livewire <br />
$ php artisan vendor:publish --tag=jetstream-views <br />
$ php artisan vendor:publish --provider=“Laravel\Fortify\FortifyServiceProvider” <br />
$ php artisan vendor:publish --provider=“Laravel\Sanctum\SanctumServiceProvider” <br /> <br />

Corre el migrador de php para migrar la base de datos <br />
$ php aritsan migrate:fresh <br /> <br />

Corre este comando en otra terminal en el host, en la carpeta de fresh-laravel <br />
$ Npm run dev  <br /> <br />
