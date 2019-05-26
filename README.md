# docker myjenkins

## 测试用例说明
Jenkins Project名称: **tio-importer-alpine**

构建[Alpine Linux]镜像(5MB)，上传到本地registry，经importer处理后发送manifest至[tenable.io cloud]。

在Image push到local registry后首次会延迟60秒，然后从tio cloud读取policy合规状态，并判断：

* 如返回pass视为构建成功，返回fail则视为构建失败;

* 若Image未上传成功，则依次等待120秒、300秒分别再去读取policy，若均失败，则结束整个流程并报告构建失败。

***请注意修改相应的local registry、repo及image。***

本测试默认从[我的Github]读取构建代码。所以如需测试镜像漏洞修复的，请自行准备github账号，或使用本地[Dockerfile](https://github.com/shawntns/docker-myjenkins/blob/master/Dockerfile)的方式替代。

## 镜像导入、运行方法
两个主要文件：受到github上传大小限制，需从第三方云盘下载。

* **[myjenkins-181228.tar]**
  * jenkins镜像，通过`docker load`导入

* **[myjenkins_volume.tar.gz]**
  * jenkins容器需调用的本机映射卷，通过`docker run -v`挂载

* [baidupan备用链接] (提取码: 822g)

#### step 1. 导入镜像
```
docker load < myjenkins-181228.tar
```
#### step 2. 将[myjenkins_volume.tar.gz]解压到本机
```
tar xvf myjenkins_volume.tar.gz
chown -R 1000:1000 myjenkins_volume
```
#### step 3. 启动容器
```
cd myjenkins_volume && docker run -d -p 8082:8080 --name myjenkins_loaded -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/var/jenkins_home myjenkins:181228
```
#### step 4. 为容器docker.sock赋权

```
docker exec -it -u root myjenkins_loaded bash -c "chmod 666 /var/run/docker.sock"
```
***
##### Jenkins WEBUI管理用户/密码
`admin / 973324a46c7b4f058932ce956a4f5500`


[Alpine Linux]: https://alpinelinux.org
[我的Github]:Dokcerfile/alpine/Dockerfile
[myjenkins-181228.tar]: https://mega.nz/#!gdtwgKzb!Q6BJfTKBPfsaAISrXK-Kru5z84uB1Hrvv3056p0svVA
[baidupan备用链接]: https://pan.baidu.com/s/1JfEBBQkIfl16jEN4Z6uWtA
[myjenkins_volume.tar.gz]: https://mega.nz/#!gEkgBKAB!d-bXDJwcaejXyWTK2CWGkcqj0Uhi6aok-8aCnY73esI
[tenable.io cloud]: https://cloud.tenable.com
