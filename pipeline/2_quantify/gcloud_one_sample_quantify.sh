# install docker
sudo apt-get install -y docker.io

# enable unsecure repository
sudo bash -c "echo 'DOCKER_OPTS=\"--insecure-registry dockerimages:5000\"' >> /etc/default/docker"
sudo service docker restart

# pull docker image
sudo docker pull dockerimages:5000/asesuite

# create data_in and data_out folders
sudo mkdir /data_in
sudo mkdir /data_out
sudo chmod a+rwx /data_in

# for faster gutils file copy - inctall crcmo
#sudo apt-get -y install gcc python-dev python-setuptools
#sudo easy_install -U pip
#sudo pip install -U crcmod

# copy BAM file
gsutil cp gs://calico-jax/jax/bams/do_kidney_korstanje/${SAMPLE}*.bam /data_in

# copy additional files
gsutil cp -r gs://calico-jax/jax/assets/mm10/R75-REL1410/ref/ /data_in
gsutil cp -r gs://calico-jax/jax/assets/mm10/R75-REL1410/8-way/ /data_in

# prepare docker container
sudo docker run -dt -v /data_in:/data_in --name dockercontainer -v /data_out:/data_out dockerimages:5000/asesuite

# run the commands in the container
sudo docker exec dockercontainer bam-to-emase -a /data_in/$SAMPLE.8-way.transcriptome.bam -i /data_in/ref/emase.transcriptome.info -s A,B,C,D,E,F,G,H -o /data_out/$SAMPLE.h5
sudo docker exec dockercontainer run-emase -i /data_out/$SAMPLE.h5 -g /data_in/ref/emase.gene2transcripts.tsv -M 4 -o /data_out/$SAMPLE.emase -r 100 -p 0.0 -m 999 -t 0.0001 -L /data_in/8-way/emase.pooled.transcripts.info

# copy the results back to the bucket
gsutil cp -r /data_out/* gs://calico-jax/jax/emase/do_kidney_korstanje/

# destroy itself
gcloud compute instances delete $(hostname) --quiet
