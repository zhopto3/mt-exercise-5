#! /bin/bash

#Zachary W. Hopton, 22-737-027
#Allison Ponce de Leon Diaz, 22-740-633

scripts=$(dirname "$0")
base=$scripts/..
data=$base/data

sampled_data=$base/sampled_data

vocabs=$base/vocabs

mkdir -p vocabs

pip install subword-nmt

#Number of symbols for First BPE Experiment
Exp1_num=2000

#Number of symbols for Second BPE Experiment
Exp2_num=5000

#Learn joint vocabularies over training data in both languages. 

# See subword-nmt github for details: https://github.com/rsennrich/subword-nmt/tree/master

cat $sampled_data/Sampledtrain.it-en.en $sampled_data/Sampledtrain.it-en.it | subword-nmt learn-bpe --total-symbols -s $Exp1_num -o $vocabs/codes.$Exp1_num

cat $sampled_data/Sampledtrain.it-en.en $sampled_data/Sampledtrain.it-en.it | subword-nmt apply-bpe -c $vocabs/codes.$Exp1_num | subword-nmt get-vocab > $vocabs/pre_joint_BPE_vocab.$Exp1_num

cat $sampled_data/Sampledtrain.it-en.en $sampled_data/Sampledtrain.it-en.it | subword-nmt learn-bpe --total-symbols -s $Exp2_num -o $vocabs/codes.$Exp2_num

cat $sampled_data/Sampledtrain.it-en.en $sampled_data/Sampledtrain.it-en.it | subword-nmt apply-bpe -c $vocabs/codes.$Exp2_num | subword-nmt get-vocab > $vocabs/pre_joint_BPE_vocab.$Exp2_num

# Vocabulary counts aren't necessary, so we remove.
cut -d " " -f 1 $vocabs/pre_joint_BPE_vocab.$Exp1_num>$vocabs/joint_BPE_vocab.$Exp1_num

cut -d " " -f 1 $vocabs/pre_joint_BPE_vocab.$Exp2_num>$vocabs/joint_BPE_vocab.$Exp2_num

