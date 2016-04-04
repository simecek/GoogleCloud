# create instances
for i in `seq 1 192`; do
  gcloud compute instances create --project "calico-jax" --zone "us-central1-c" --boot-disk-size=20GB --scopes https://www.googleapis.com/auth/cloud-platform --machine-type "https://www.googleapis.com/compute/v1/projects/calico-jax/zones/us-central1-c/machineTypes/n1-highmem-4" --image "ubuntu-14-04" "emase-$i" &
done

# give VMs 5 mins for start
sleep 300

# copy the master script
for i in `seq 1 192`; do
  echo $i
  gcloud compute copy-files --project "calico-jax" gcloud_one_sample_quantify.sh emase-$i: --zone "us-central1-c" &
done

# give VMs 5 mins to copy the script
sleep 300

# run the master script
i=0 
while read p
do
  array=(${p//,/ })
  SAMPLE=${array[0]}
  let i+=1
  gcloud compute --project "calico-jax" ssh "emase-$i" --zone "us-central1-c" screen -d -m env "SAMPLE=$SAMPLE" bash ./gcloud_one_sample_quantify.sh &
done < sample_list.csv
