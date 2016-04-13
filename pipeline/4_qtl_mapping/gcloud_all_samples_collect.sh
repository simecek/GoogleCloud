# install docker
sudo apt-get install -y docker.io

# enable unsecure repository
sudo bash -c "echo 'DOCKER_OPTS=\"--insecure-registry dockerimages:5000\"' >> /etc/default/docker"
sudo service docker restart

# pull docker image
sudo docker pull simecek/rocker # hack to avoid 'invalid tar header' error
sudo docker pull dockerimages:5000/rocker

# create data_in and data_out folders
sudo mkdir /data_in
sudo mkdir /data_out
sudo chmod a+rwx /data_in
mkdir /data_in/emase
mkdir /data_in/gbrs
mkdir /data_in/additional_data


# for faster gutils file copy - inctall crcmo
sudo apt-get -y install gcc python-dev python-setuptools
sudo easy_install -U pip
sudo pip install -U crcmod

# copy files
gsutil cp gs://calico-jax/jax/emase/do_kidney_korstanje/*.emase.genes.effective_read_counts /data_in/emase/
gsutil -m cp gs://calico-jax/jax/gbrs/do_kidney_korstanje/* /data_in/gbrs/
gsutil -m cp gs://calico-jax/jax/additional_data/do_kidney_korstanje/* /data_in/additional_data/
gsutil cp gs://calico-jax/jax/assets/mm10/R75-REL1410/marker_grid_64K.txt /data_in/
gsutil cp gs://calico-jax/jax/assets/mm10/R75-REL1410/mouse_genes.txt /data_in/

# prepare docker container
sudo docker run -dt -v /data_in:/data_in --name dockercontainer -v /data_out:/data_out -v /home/petrs:/home/docker dockerimages:5000/rocker /bin/bash

# run the command in the container
sudo docker exec dockercontainer bash R CMD BATCH /home/docker/make.dataset.R

# copy the results back to the bucket
gsutil cp -r /data_out/* gs://calico-jax/jax/rdata/do_kidney_korstanje/

# destroy itself
gcloud compute instances delete $(hostname) --quiet
