# Reference: https://dev.to/angular/deploying-an-i18n-angular-app-with-angular-cli-2fb9
server {
    listen       80;
    server_name  traquer.cht.nc;

    location / {
        alias   /usr/share/nginx/html/traquer-frontend-angular/;
        try_files $uri$args $uri$args/ /index.html;
    }
    location /fr/ {
        alias   /usr/share/nginx/html/traquer-frontend-angular/;
        try_files $uri$args $uri$args/ /fr/index.html;
    }
    location /en/ {
        alias   /usr/share/nginx/html/traquer-frontend-angular-en/;
        try_files $uri$args $uri$args/ /en/index.html;
    }

    set $first_language $http_accept_language;
    if ($http_accept_language ~* '^(.+?),') {
        set $first_language $1;
    }

    set $language_suffix 'fr';
    if ($first_language ~* 'en') {
        set $language_suffix 'en';
    }

    #location / {
    #    rewrite ^/$ http://demo.medilegist.com/$language_suffix/index.html permanent;
    #}
} 
