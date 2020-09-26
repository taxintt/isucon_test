## 0. create GCE Instance
```
$ cd ./terraform

<!-- https://medium.com/@jryancanty/stop-downloading-google-cloud-service-account-keys-1811d44a97d9 -->
$ {
  export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token --project isucon)
  terraform apply
}
```

## 1. set up ssh config
```
$ cd ~/.ssh

// create ssh key
$ ssh-keygen -t rsa -b 4096

$ cat config
Host isucon9
  HostName xxx.xxx.xxx.xxx
  User isucon9-user
  IdentityFile ~/.ssh/id_isucon9
```

## 2. set up GCE Instance
```
$ ssh isucon9-user@xxx.xxx.xxx.xxx -i ~/.ssh/id_isucon9

// another way
$ ssh isucon9 

```