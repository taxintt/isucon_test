## 0. create GCE Instance
```
$ cd ./terraform
$ terraform apply
```

## 1. set up ssh config
```
$ cd ~/.ssh

<!-- add isucon-{bench,web,mysql} user -->
$ cat config
Host isucon-bench
  HostName xxx.xxx.xxx.xxx
  User isucon9-user
  IdentityFile ~/.ssh/id_isucon9
```

## 2. set up GCE Instance
```
$ cd ./scripts

<!-- 本来のssh setupはこの手順で行い、ssh自体はGCP VMの機能を利用する? -->
$ cat ./gce_init.sh | ssh isucon-{bench,web,mysql} /bin/bash
```