#! /bin/bash

#Zachary W. Hopton, 22-737-027
#Allison Ponce de Leon Diaz, 22-740-633

scripts=$(dirname "$0")
base=$scripts/..
data=$base/data

sampled_data=$base/sampled_data

mkdir -p sampled_data

mv $data/dev.ro-en.en $data/dev.ro-en.ro $data/test.ro-en.ro $data/test.ro-en.en $sampled_data

#now we randomly sample 100k lines from our training set

python $scripts/get_subsample.py --in_dir $data --parallel_data train.ro-en.en train.ro-en.ro --out_dir $sampled_data