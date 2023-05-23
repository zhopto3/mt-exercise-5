"""A script to sample 100k sentences of parallel training data
Authors:
Zachary W. Hopton, 22-737-027
Allison Ponce de Leon Diaz, 22-740-633
"""
import argparse
from numpy import random

def parse_args():
    args = argparse.ArgumentParser("Get lines subsampled from parallel data input")

    args.add_argument("--in_dir", required=True, nargs=1,
                      help = "File path to directory where parallel data is held")
    args.add_argument("--parallel_data", required = True, nargs = 2, 
                      help= "Two file names in the in_dir; parallel data for machine translation")
    args.add_argument("--num_lines", nargs=1, default=100000,
                      help = "Number of lines to be sub sampled from the input")
    args.add_argument("--out_dir", required=True, nargs=1,
                      help = "Output directory for the two parallel files with a reduced number of lines")
    
    return args.parse_args()


def resevoir_sample(samples1: list, samples2: list, lines1: str, lines2: str, num_lines: int, call_num: int)->tuple:
    """Sample the parallel input data using resevoir sampling to avoid reading it all into memory at once.
    Details about the algorithm can be found on: https://en.wikipedia.org/wiki/Reservoir_sampling
    """
    if len(samples1) <= num_lines:
         samples1.append(lines1)
         samples2.append(lines2)
    else:
         ran_num = random.randint(call_num)
         if ran_num < num_lines:
              samples1[ran_num] = lines1
              samples2[ran_num] = lines2

    return (samples1,samples2)


def main():
    args = parse_args()

    samples1 = []
    samples2 = []

    with (open(args.in_dir[0]+"/"+args.parallel_data[0],"r",encoding="utf-8") as in1,
          open(args.in_dir[0]+"/"+args.parallel_data[1],"r",encoding="utf-8") as in2,
          open(args.out_dir[0]+"/Sampled"+args.parallel_data[0],"w",encoding="utf-8") as out1,
          open(args.out_dir[0]+"/Sampled"+args.parallel_data[1],"w",encoding="utf-8") as out2):
            
            for call_num, (lines1, lines2), in enumerate(zip(in1,in2)):
                samples1,samples2 = resevoir_sample(samples1,samples2,lines1, lines2, args.num_lines, call_num)
                    
            #then when I'm done, write all samples1 to out1 and samples2 to out2
            out1.writelines(samples1)
            out2.writelines(samples2)
            

if __name__ == "__main__":
    main()