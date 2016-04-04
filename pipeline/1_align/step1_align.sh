# create instances
for i in `seq 1 192`; do
  gcloud compute instances create --project "calico-jax" --zone "us-central1-c" --boot-disk-size=50GB --scopes https://www.googleapis.com/auth/cloud-platform  --image "ubuntu-14-04" "align-$i" &
done

# give VMs 5 mins for start
sleep 300

# copy the master script
for i in `seq 1 192`; do
  echo $i
  gcloud compute copy-files --project "calico-jax" gcloud_one_sample_align.sh align-$i: --zone "us-central1-c" &
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
  gcloud compute --project "calico-jax" ssh "align-$i" --zone "us-central1-c" screen -d -m env "SAMPLE=$SAMPLE" bash ./gcloud_one_sample_align.sh &
done < sample_list.csv
