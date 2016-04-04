# install docker
sudo apt-get install -y docker.io

# enable unsecure repository
sudo bash -c "echo 'DOCKER_OPTS=\"--insecure-registry dockerimages:5000\"' >> /etc/default/docker"
sudo service docker restart

# pull docker image
sudo docker pull dockerimages:5000/bowtie

# create data_in and data_out folders
sudo mkdir /data_in
sudo mkdir /data_out
sudo chmod a+rwx /data_in

# for faster gutils file copy - inctall crcmo
#sudo apt-get -y install gcc python-dev python-setuptools
#sudo easy_install -U pip
#sudo pip install -U crcmod

# copy FASTQ files
gsutil cp gs://calico-jax/jax/fastq/do_kidney_korstanje/${SAMPLE}*.fastq.gz /data_in

# create named pipeline and zcat FASTQs into it
mkfifo /data_in/${SAMPLE}.fastq
zcat /data_in/*.fastq.gz > /data_in/${SAMPLE}.fastq&

# copy additional files
gsutil cp -r gs://calico-jax/jax/assets/mm10/R75-REL1410/8-way/bowtie1/ /data_in

# prepare docker container
sudo docker run -dt -v /data_in:/data_in --name dockercontainer -v /data_out:/data_out dockerimages:5000/bowtie /bin/bash
echo "bowtie -q -a --best --strata --sam -v 3 /data_in/bowtie1/bowtie.transcriptome /data_in/${SAMPLE}.fastq | samtools view -bS -F 4 - > /data_out/${SAMPLE}.8-way.transcriptome.bam" > /data_in/run_me.sh

# run the command in the container
sudo docker exec dockercontainer bash "/data_in/run_me.sh"

# copy the results back to the bucket
gsutil cp -r /data_out/* gs://calico-jax/jax/bams/do_kidney_korstanje/

# destroy itself
gcloud compute instances delete $(hostname) --quiet

