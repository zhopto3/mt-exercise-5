"""A script to visualize the translation time and BLEU scores of our Romanian-English transformer-based translation model with a vocabulary of 
5000 symbols produced with BPE. 

Zachary W. Hopton 22-737-037
Allison Ponce de Leon Diaz, 22-740-633

Example call: python scripts/vis_beamsearch.py --input-dir "beamsearch_results" --out-dir "beamsearch_results"
"""
import argparse
import os
import re
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

def get_args():
    args = argparse.ArgumentParser("Script to visualize the effects of beam search")

    args.add_argument("--input-dir", type = str, required=True,
                      help = "directory containing evaluations from beam search experminets")
    args.add_argument("--out-dir", type = str,
                      help="Path to output for of visualizations, if not the same as the script location")
    
    return args.parse_args()


def get_data(input: str)->dict:

    data = {}

    for file in os.listdir(input):
        if file[:4] == "eval":
            beamsize = int(re.search(r"_bs(\d+)",file).group(1))
            data[beamsize]={}
            
            with open(input+"/"+file,"r",encoding="utf-8") as current:
                for lines in current:
                    if """"score":""" in lines:
                        data[beamsize]["bleu"]=float(re.search(r" ([\d\.]+),$",lines).group(1))
                    elif "seconds" in lines:
                        data[beamsize]["time"]=float(re.search(r"^([\d\.]+) ",lines).group(1))

    return data


def save_graphs(data: pd.DataFrame, out: str)->None:
    #bleu = plt.figure()

    qual = sns.lineplot(data, x = "BeamSize", y="BLEU").set(title="Comparison of BLEU and Beam Size")

    plt.ylim(0,40)

    plt.savefig(out+"/BeamsizeBleu.png")
    #clear current plot settings
    plt.clf()

    time = sns.lineplot(data, x = "BeamSize", y="time").set(title="Comparison of Translation Time and Beam Size")

    plt.savefig(out+"/BeamsizeTime.png")

def main():
    args = get_args()

    data = get_data(args.input_dir)

    data_array = sorted([[bs,data[bs]["bleu"],data[bs]["time"]] for bs in data.keys()], key =lambda x:x[0])

    df = pd.DataFrame(data_array,columns=["BeamSize","BLEU","time"])

    save_graphs(df, args.out_dir)

if __name__ == "__main__":
    main()