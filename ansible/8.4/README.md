# 8.4 Ansible playbook

## общая информация
Плейбук выполняет
- инсталляцию clickhouse на хостах группы clickhouse
- инсталляцию vector на хостах из группы vector
- инсталляцию lighthouse на хостах из группы lighthouse

В директории ./terraform содержится описание инфраструктуры в Yandex-облаке.

## теги
В плейбуке есть теги:

- vector - для инсталляции только vector
- lighthouse - для инсталляции только lighthouse

## роли
В плейбуке использованы роли:
- clickhouse - готовая роль из репо https://github.com/AlexeySetevoi/ansible-clickhouse
- vector - роль, разработанная мной в рамках данного курса
- lighthouse - роль, разработанная мной в рамках данного курса

## параметры

### group_vars для группы clickhouse
- clickhouse_version - требуемая версия clickhouse
- clickhouse_packages - перечень пакетов clickhouse для скачивания

### group_vars для группы vector
- vector_version - требуемая версия vector
- vector_home - домашняя директория для инсталляции vector

### group_vars для группы lighthouse
- lighthouse_home - домашняя директория для инсталляции lighthouse