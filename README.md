получение зависимостей

dart pub get

обновление зависимостей

dart pub upgrade

запуск

dart main.dart

добавление зависимости

dart pub add <package_name>

добавление dev-зависимости

dart pub add dev:<package_name>

создание имэджа

docker build -t <image_name> .

запуск контейнера

docker run --name <container_name> -p 8081:8081 <image_name>

запуск генерации кода

dart run build_runner build
