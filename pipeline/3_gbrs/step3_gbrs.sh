# create instances
for i in `seq 1 192`; do
  gcloud compute instances create --project "calico-jax" --zone "us-central1-c" --boot-disk-size=10GB --scopes https://www.googleapis.com/auth/cloud-platform --machine-type "https://www.googleapis.com/compute/v1/projects/calico-jax/zones/us-central1-c/machineTypes/n1-highmem-4" --image "ubuntu-14-04" "gbrs-$i" &
done

# give VMs 5 mins for start
sleep 300

# copy the master script
for i in `seq 1 192`; do
  echo $i
  gcloud compute copy-files --project "calico-jax" gcloud_one_sample_gbrs.sh gbrs-$i: --zone "us-central1-c" &
done

# give VMs 5 mins to copy the script
sleep 300

# run the master script
i=0 
while read p
do
  array=(${p//,/ })
  SAMPLE=${array[0]}
  SEX=${array[1]}
  GENERATION=${array[2]}
  let i+=1
  gcloud compute --project "calico-jax" ssh "gbrs-$i" --zone "us-central1-c" screen -d -m env "SAMPLE=$SAMPLE" "SEX=$SEX" "GENERATION=$GENERATION" bash ./gcloud_one_sample_gbrs.sh &
done < sample_list.csv
