# carbon-cloud-docker
###the docker module of the Carbon Cloud
For making the dev and deploy more easy to go. I make every service and database into docker image.<br>
Here is the Dockerfile and config and script files which is used to build the image.<br>
For details please track [dockerhub/carbonface](https://hub.docker.com/u/carbonface).
****
## before you start
###There is docker images for services and databases.
###_Attention should be paid if you wanna build a customs one._
***
* ###database image config file.
  Each database module contains a configuration file which is in used.
* ###custom service docker image 
  To start to make your onw services image for Carbon Cloud, you should build the base image `carbon-cloud-docker-base` first or use the [_carbonface/carbon-cloud-docker-base_][carbon-cloud-docker-base_dockerhub] image.<br>
  The [Dockerfile][carbon-cloud-docker-base_Dockerfile] for the base image `carbon-cloud-docker-base` can be find in [carbon-docker/services/carbon-cloud-docker-base][carbon-cloud-docker-base_github].
  
  The [carbon-docker][carbon-docker_github] contains a shell script [_docker_services_build.sh_][docker_services_build.sh_github] 
  which can help you to build the service images in Carbon Cloud base on local codes automatically.<br>
  This shell script [docker_services_build.sh][docker_services_build.sh_github] is based on maven plugin:`docker-maven-plugin`.<br>
  Or you can simply build the service image by copy the jar file into `/carbon-docker/services/[service-name]/` and run the `docker build` command.
* ###docker compose 
  The [carbon-docker][carbon-docker_github] contains the [_docker-compose.yml_][docker-compose.yml_github]
  which helps to build the docker compose.<br>
  _And before run the docker compose, make sure you have the correct directory for mounting use._<br>
  The [_docker_local_dir_init.sh_][docker_local_dir_init.sh_github] 
  in [carbon-docker][carbon-docker_github] can be ran to init the local directory automatically.<br>
  Run the command `/bin/bash docker_local_dir_init.sh /{baseDir}` and build your docker-compose local directory base for mounting datas.<br>
  `{baseDir}` is the base directory you wanna create. The default baseDir is `~/CarbonCloud` and the default cnofig file for databases can be found in [carbon-docker/databases][carbon-docker/databases_github].
* ###Ready to run
  After all database images and services images have been pulled or built into local.<br>
  And when the local directory for mounting datas initialized.
  Run `docker-compose up -d` to run the Carbon Cloud docker compose!
## Have fun!
## To Be Continued
## ヽ(^_−)ﾉ


[carbon-cloud-docker-base_github]:https://github.com/CarbonFace/carbon-docker/blob/master/services/carbon-cloud-docker-base
[carbon-cloud-docker-base_dockerhub]:https://hub.docker.com/r/carbonface/carbon-cloud-docker-base
[carbon-cloud-docker-base_Dockerfile]:https://github.com/CarbonFace/carbon-docker/blob/master/services/carbon-cloud-docker-base/Dockerfile
[carbon-docker_github]:https://github.com/CarbonFace/carbon-docker
[docker_services_build.sh_github]:https://github.com/CarbonFace/carbon-docker/docker_services_build.sh
[docker-compose.yml_github]:https://github.com/CarbonFace/carbon-docker/blob/master/docker-compose.yml
[docker_local_dir_init.sh_github]:https://github.com/CarbonFace/carbon-docker/blob/master/docker_local_dir_init.sh
[carbon-docker/databases_github]:https://github.com/CarbonFace/carbon-docker/blob/master/databases
