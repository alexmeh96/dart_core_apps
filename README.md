получение зависимостей
```shell
dart pub get
```
обновление зависимостей
```shell
dart pub upgrade
```
запуск
```shell
dart main.dart
```
добавление зависимости
```shell
dart pub add <package_name>
```
добавление dev-зависимости
```shell
dart pub add dev:<package_name>
```
создание имэджа
```shell
docker build -t <image_name> .
```
запуск контейнера
```shell
docker run --name <container_name> -p 8081:8081 <image_name>
```
запуск генерации кода
```shell
dart run build_runner build
```
