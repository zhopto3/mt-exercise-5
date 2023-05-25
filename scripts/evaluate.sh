#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/sampled_data
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=ro
trg=en


num_threads=2
device=0

# measure time

SECONDS=0

model_name=roen_transformer_word

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

#made changes to call because (for some reason) the original version was printing the testing_batch_type at the beginning of all the translation files
#CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.ro-en.$src > $translations_sub/test.$model_name.$trg
CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml -o $translations_sub/test.$model_name.$trg < $data/test.ro-en.$src 


# compute case-sensitive BLEU for word-level model

cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test.ro-en.$trg


echo "time taken:"
echo "$SECONDS seconds"

SECONDS=0

model_name=roen_transformer_bpe_2000

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

#CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.ro-en.$src > $translations_sub/test.$model_name.$trg
CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml -o $translations_sub/test.$model_name.$trg < $data/test.ro-en.$src 


# compute case-sensitive BLEU for sub-word-level model (with 2000 symbols in vocabulary)

cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test.ro-en.$trg

echo "time taken:"
echo "$SECONDS seconds"


SECONDS=0

model_name=roen_transformer_bpe_5000

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

#CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.ro-en.$src > $translations_sub/test.$model_name.$trg
CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml -o $translations_sub/test.$model_name.$trg < $data/test.ro-en.$src 


# compute case-sensitive BLEU for sub-word-level model (with 2000 symbols in vocabulary)

cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test.ro-en.$trg


echo "time taken:"
echo "$SECONDS seconds"
