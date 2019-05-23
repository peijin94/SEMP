# **S**olar radio burst **E**lectron **M**otion **T**racker

## Forward Modeling of the Type III Radio Burst Exciter

Detailed description of this paper can be found in ./paper.pdf

### Install

Install Matlab 2018b or newer then,
```bash
git clone https://github.com/Pjer-zhang/SEMP.git
```
or download code zip

### Data

This tool uses the CDF-data from [NASA online database](https://cdaweb.sci.gsfc.nasa.gov/index.html/).

The there should be two files for one event (STEREO A/B and WIND).

Please find the sample data in the ./data/ directory, which is a good example to start with.

### Run

Simply run the runMe_gui.m in the ./src directory.
 - Load data files of CDF format
 - Input the poistions of WIND and STEREO
 - Select the time range which contains a event
 - Select the frequency channels
 - Mark the leading edge (fun part)
 - Start the 'Best Model Finding Process' by click 'NextStep'

I also prepared a generated .mat data file : ./data/20101117.mat

You can click "import" button in the LoadData GUI, and click all the 'NextStep' way down to see the result

The final step may take a few minutes to find the best solution for the radio source trajectory, thank you for the patience.

(Please let me know if there is a problem using this code, contact me: pjer1316_AT_gmail.com)


### Reference

Make sure to cite the paper if you use the idea or code in this repo: 

```
@Article{Zhang2019,
author="Zhang, Peijin
and Wang, Chuanbing
and Ye, Lin
and Wang, Yuming",
title="Forward Modeling of the Type III Radio Burst Exciter",
journal="Solar Physics",
year="2019",
month="May",
day="22",
volume="294",
number="5",
pages="62",
issn="1573-093X",
doi="10.1007/s11207-019-1448-0",
url="https://doi.org/10.1007/s11207-019-1448-0"
}
```
