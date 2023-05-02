# **S**olar radio burst **E**lectron **M**otion **T**racker

## Forward Modeling of the Type III Radio Burst Exciter

Description of model can be found in ./paper.pdf



### Matlab

Step-by-step demo (matlab):
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/p-Fkccnp0gQ/0.jpg)](https://www.youtube.com/watch?v=p-Fkccnp0gQ)

Install Matlab 2018b or newer then,

```bash
git clone https://github.com/peijin94/SEMP.git
cd SEMP/matlabsemp
```


Run the runMe_gui.m 

- Load data files of CDF format
- Input the poistions of WIND and STEREO
- Select the time range which contains a event
- Select the frequency channels
- Mark the leading edge (fun part)
- Start the 'Best Model Finding Process' by click 'NextStep'


Click "import" button in the LoadData GUI, and click all the 'NextStep' way down to see the result

The final step may take a few minutes to find the best solution for the radio source trajectory, thank you for the patience.

(Please let me know if there is a problem using this code, contact me: pjer1316_AT_gmail.com)


### Python

```bash
git clone https://github.come/peijin94/SEMP.git
cd SEMP
python -m pip install .
```
demo in Jupyter notebook in demo-ipynb folder


### Data

CDF data format [NASA online database](https://cdaweb.sci.gsfc.nasa.gov/index.html/).

cdflib is used for reading CDF files.

Download demo data:

run this to download the data to parent folder
```bash
cd ../  
gdown --folder https://drive.google.com/drive/folders/1y7--cGBXU3gsYz2nZ_kI_5plRAHQY4MO
```

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
