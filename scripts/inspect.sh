#!/bin/bash
#author: xxu@tenable.com
#usage: sh inspect.sh

##运行示例及说明
#shawn@ubuntu1804:~/consec$ sh inspect.sh
#REPOSITORY                                          TAG                 IMAGE ID            CREATED             SIZE
#xxc0310/node-web-app                                latest              3a9a02f31063        24 hours ago        897MB
#alpine                                              latest              4d90542f0623        8 days ago          5.58MB
#node                                                8                   a7dabdc7cd4b        2 weeks ago         895MB
#mongo-express                                       latest              8d57e5498af3        3 weeks ago         97MB
#tenableio-docker-consec-local.jfrog.io/cs-scanner   latest              c7d7c0221c81        3 weeks ago         166MB
#registry                                            latest              f32a97de94e1        3 months ago        25.8MB
#hello-world                                         latest              fce289e99eb9        5 months ago        1.84kB
#myjenkins                                           181228              44f0a792a8b2        6 months ago        1.31GB
#eightzerobits/ubuntu                                infected            4013750e4cd5        23 months ago       200MB
#======================================================================================================================
#Enter Local Image name (REPOSITORY) or id (IMAGE ID): 3a9a02f31063 #输入本地docker镜像名称(即REPOSITORY），或IMAGE ID。查看命令为`docker images`
#Enter Repo name where you uploading the Image to tenable.io: nodejs #输入上传t.io的repository名称，如repo不存在则自动创建。
#Enter Image name appears on tenable.io: mywebapp #输入上传t.io的镜像名称
#16:30:57 [INFO] - Starting application in image inspection mode
#16:30:58 [INFO] - Checking connectivity to Tenable.io
#16:30:59 [INFO] - Reading snapshot from stdin
#16:30:59 [INFO] - (if you did not pipe `docker save` or equivalent to this command, please press Ctrl-D to exit.)
#16:31:04 [INFO] - Retrieval complete, extracting image archive
#16:31:06 [INFO] - Extracted image, finding layers
#16:31:12 [INFO] - Out of 13 layer(s) - need to import 0
#16:31:12 [INFO] - Pushing image manifest to Tenable.io
#16:31:13 [INFO] - Import of image nodejs/mywebapp complete
#16:31:13 [INFO] - Terminating application, please stand by.
#======================================================================================================================
#Upload completed. You may check Container Security Report at below.
#
# {"os_release_name":"stretch","malware":[],"sha256":"sha256:7ad7c63a16a6d11d3b5ab804d3066e607517762287268506b3de304cf0230233","os":"LINUX_DEBIAN",#"risk_score":10,"findings":[{"nvdFinding":{"cve":"CVE-2019-11479","description":"2019/06/17","published_date":"2019/06/17","modified_date":"Several #vulnerabilities have been discovered in the Linux kernel that\nmay lead to a privilege escalation, denial of service or information\nleaks.\n\n  - #CVE-2019-3846, CVE-2019-10126\n    huangwen reported multiple buffer overflows in the\n....}
#======================================================================================================================
#Image Compliance Status: [fail]

docker images
echo '======================================================================================================================'
read -p 'Enter Local Image name (REPOSITORY) or id (IMAGE ID): ' local_image 
read -p 'Enter Repo name where you uploading the Image to tenable.io: ' cs_repo
read -p 'Enter Image name appears on tenable.io: ' cs_image
##cs-scanner inspect mode does not support tagging at this moment.
#read -p 'Enter Image tag appears on tenable.io: [latest] ' cs_tag
#if [ -z "$cs_tag" ]; then
#    cs_tag=latest
#fi
docker save $local_image | docker run \
    -e TENABLE_ACCESS_KEY=${TENABLE_ACCESS_KEY} \
    -e TENABLE_SECRET_KEY=${TENABLE_SECRET_KEY} \
    -e IMPORT_REPO_NAME=$cs_repo \
    -i --rm tenableio-docker-consec-local.jfrog.io/cs-scanner:latest inspect-image $cs_image
echo '======================================================================================================================'
echo "Upload completed. You may check Container Security Report at below. \n"
curl -X GET \
    https://cloud.tenable.com/container-security/api/v2/reports/$cs_repo/$cs_image/latest \
    -H 'X-ApiKeys: accessKey='"$TENABLE_ACCESS_KEY"'; secretKey='"$TENABLE_SECRET_KEY"'' \
    -H 'cache-control: no-cache' \
    -H 'Content-Type: application/json'
echo '\n======================================================================================================================'
echo "\nImage Compliance Status: [$(curl "https://cloud.tenable.com/container-security/api/v1/compliancebyname?image=$cs_image&repo=$cs_repo&tag=latest" -H "X-ApiKeys: accessKey=$TENABLE_ACCESS_KEY; secretKey=$TENABLE_SECRET_KEY" -s --insecure | cut -d '"' -f4)]"