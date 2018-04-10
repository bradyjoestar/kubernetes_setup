# docker 私有仓库的搭建和防灾
从docker hub上拉去镜像速度很慢，因此搭建了docker内网镜像仓库。

安全角度上考虑，需要在阿里云镜像市场做相应的备份。防止其中一方出现问题。

docker 私有仓库的搭建和升级主要分为客户端和服务端两个部分。

### 服务端

首先拉取仓库的镜像
```
docker pull registry
```

启动仓库容器
```
docker run -d -p 5000:5000 -v /myregistry:/var/lib/registry registry:2
```

通过将容器中的/var/lib/registry目录下所有文件映射出来，防止容器死掉后，可以从之前挂载的目录还原。通过同一条命令。

参数中-d ==> 作为daemon进程启动，也就是后台启动


目前市面上有一个名为harbor的企业级镜像服务，提供更高级的镜像管理功能，包括ui，api等。暂时还用不到。

另外harbor的高可用目前可以通过在私有仓库和阿里云上同时备份一份实现。

### 客户端


当服务端搭建成功后，可以将客户端打包的镜像提交到私有仓库中，以及从私有仓库拉取相应的镜像。

与docker registry交互默认使用的是https，然而此处搭建的私有仓库只提供http服务。

首先需要解决https通信的问题。在客户端/etc/docker/daemon.json中，添加` "insecure-registries": ["192.168.1.160:5000"]`


我的json文件配置如下：其中mirrors是我的远程镜像。
```
{
  "registry-mirrors": ["https://86pnz78f.mirror.aliyuncs.com"],
     "insecure-registries": ["192.168.1.160:5000"]
     }

```


其中192.168.1.160 是客户端的ip地址。

修改配置后，需要重启docker服务。

```
systemctl daemon-reload
systemctl restart docker
```


这里以busybox镜像为例：

拉取busybox镜像：
```
docker pull busybox
```

将下载的镜像打tag
```
docker push 192.168.0.153:5000/busybox
```
提交镜像
```
docker push 192.168.0.153:5000/busybox
```


删除本地镜像后，从客户端拉取仓库的镜像：
```
sudo docker pull 192.168.0.153:5000/busybox
```


可以通过下面的url访问仓库
```
curl -XGET http://192.168.1.160:5000/v2/_catalog
`

``
