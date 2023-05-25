# MT Exercise 5: Byte Pair Encoding, Beam Search
This repository is a starting point for the 5th and final exercise. As before, fork this repo to your own account and the clone it into your prefered directory.

## Requirements

- This only works on a Unix-like system, with bash available.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

## Steps

Clone your fork of this repository in the desired place:

    git clone https://github.com/[your-name]/mt-exercise-5

Create a new virtualenv that uses Python 3.10. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/install_packages.sh

Now install setuptools, torch, and joeyNMT as described in the exercise 4 pdf. 

Download data:

    ./scripts/download_iwslt_2017_data.sh

Sample training data:

    ./scripts/sample_data.sh
    
Learn BPE models, one with a vocabulary of 2000 symbols and one with a vocabulary of 5000 symbols. 

    ./scripts/learnBPE.sh

Train a word-level model and two BPE level models:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Once training for the three models is complete, the following script can be run in order to evaluate all three models on the test set data. It will output the case-sensitive BLEU score for each of the three models (using a constant beam size of five). 

    ./scripts/evaluate.sh

## Beam Size Experimentation