#! /bin/bash

#Zachary W. Hopton, 22-737-027
#Allison Ponce de Leon Diaz, 22-740-633

scripts=$(dirname "$0")
base=$scripts/..

data=$base/sampled_data
configs=$base/configs
beamsearch_configs=$base/beamsearch_configs

beamsearch_results=$base/beamsearch_results

mkdir -p $beamsearch_results

src=ro
trg=en


num_threads=2
device=0

for i in 2 3 4 5 6 7 9 11 13 15
do
# measure time

SECONDS=0

model_name=roen_bpe_5000_bs$i

echo "###############################################################################"
echo "model_name $model_name"


CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $beamsearch_configs/$model_name.yaml -o $beamsearch_results/translations.$model_name.$trg < $data/test.ro-en.$src 


# compute case-sensitive BLEU for the best model with a given beam search size

cat $beamsearch_results/translations.$model_name.$trg | sacrebleu $data/test.ro-en.$trg > $beamsearch_results/eval.$model_name

echo "$SECONDS seconds" >> $beamsearch_results/eval.$model_name

echo "time taken:"
echo "$SECONDS seconds"
done