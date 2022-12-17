# 8.2 Ansible playbook
Плейбук выполняет
- инсталляцию java на всех хостах инвентори
- инсталляцию Elasticsearch на хостах из группы elasticsearch из инвентори
- инсталляцию Vector на хостах из группы elasticsearch из инвентори
## теги
В плейбуке есть теги:
<pre>
vmedvedev@mintdesk:~/devops20/ansible/8.2$ ansible-playbook site.yml --list-tags
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
[WARNING]: Could not match supplied host pattern, ignoring: elasticsearch

playbook: site.yml

  play #1 (all): Install Java	TAGS: []
      TASK TAGS: [java]

  play #2 (elasticsearch): Install Elasticsearch	TAGS: []
      TASK TAGS: [elastic]

  play #3 (elasticsearch): Install Vector	TAGS: []
      TASK TAGS: [vector]
</pre>
Эти теги позволяют запускать отдельно инсталляцию Java, Elastic и Vector соответственно.
## параметры
Параметры плейбука задаются через переменный group_vars. В файле group_vars/all/vars.yml задаются параметры для установки Java: версия и имя файла с дистрибутивом. В group_vars/elasticsearch/vars.yml задаются параметры инсталляции Elastic и Vector: версии и домашние директории для установки этих продуктов.