# install docker
sudo apt-get install -y docker.io

# enable unsecure repository
sudo bash -c "echo 'DOCKER_OPTS=\"--insecure-registry dockerimages:5000\"' >> /etc/default/docker"
sudo service docker restart

# pull docker image
sudo docker pull dockerimages:5000/gbrs

# create data_in and data_out folders
sudo mkdir /data_in
sudo mkdir /data_out
sudo chmod a+rwx /data_in

# for faster gutils file copy - inctall crcmo
#sudo apt-get -y install gcc python-dev python-setuptools
#sudo easy_install -U pip
#sudo pip install -U crcmod

# copy BAM file
gsutil cp gs://calico-jax/jax/emase/do_kidney_korstanje/$SAMPLE.emase.genes.tpm /data_in

# copy additional files
gsutil cp -r gs://calico-jax/jax/assets/mm10/R75-REL1410/hmm/ /data_in

# prepare docker container
sudo docker run -dt -v /data_in:/data_in --name dockercontainer -v /data_out:/data_out dockerimages:5000/gbrs

# run the commands in the container
sudo docker exec dockercontainer gbrs -e /data_in/$SAMPLE.emase.genes.tpm \
  -x /data_in/hmm/avecs.npz \
  -t /data_in/hmm/tranprob.DO.${GENERATION}.${SEX}.npz \
  -g /data_in/hmm/ENSMUSG.ids.wYwMT.npz \
  -c 1.5 -s 0.12 -o /data_in
sudo docker exec dockercontainer interpolate2 -i /data_in/gbrs.gamma.npz \
  -o /data_out/$SAMPLE.gbrs.csv \
  -g '/data_in/hmm/marker_grid_64K.wYwMT.txt' \
  -p '/data_in/hmm/gene_pos.wYwMT.npz'

# copy the results back to the bucket
gsutil cp -r /data_out/* gs://calico-jax/jax/gbrs/do_kidney_korstanje/

# destroy itself
gcloud compute instances delete $(hostname) --quiet
