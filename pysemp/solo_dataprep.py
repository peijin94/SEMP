import os
os.environ["CDF_LIB"] = 'c:\cdf_distribution\cdf38_0-dist'
from spacepy import pycdf
import cdflib
import numpy as np

def solo_rpw_hfr(filepath):
    rpw_l2_hfr = cdflib.CDF(filepath)
    l2_cdf_file = pycdf.CDF(filepath)

    # times = l2_cdf_file['Epoch']
    # times = times[:]

    times = rpw_l2_hfr.varget('EPOCH')


    freqs = rpw_l2_hfr.varget('FREQUENCY')

    # Indicates the THR sensor configuration (V1=1, V2=2, V3=3, V1-V2=4, V2-V3=5,
    # V3-V1=6, B_MF=7, HF_V1-V2=9, HF_V2-V3=10, HF_V3-V1=11)
    sensor = rpw_l2_hfr.varget('SENSOR_CONFIG')
    freq_uniq = np.unique(rpw_l2_hfr.varget('FREQUENCY'))  # frequency channels list
    sample_time = rpw_l2_hfr.varget('SAMPLE_TIME')

    agc1 = rpw_l2_hfr.varget('AGC1')
    agc2 = rpw_l2_hfr.varget('AGC2')

    flux_density1 = rpw_l2_hfr.varget('FLUX_DENSITY1')
    flux_density2 = rpw_l2_hfr.varget('FLUX_DENSITY2')

    rpw_l2_hfr.close()
    # l2_cdf_file.close()

    # For CH1 extract times, freqs and data points
    slices1 = []
    times1 = []
    freq1 = []
    for cfreq in freq_uniq:
        search = np.argwhere((freqs == cfreq) & (sensor[:, 0] == 9) & (agc1 != 0))
        if search.size > 0:
            slices1.append(agc1[search])
            times1.append(times[search])
            freq1.append(cfreq)

    # For CH1 extract times, freqs and data points
    slices2 = []
    times2 = []
    freq2 = []
    for cfreq in freq_uniq:
        search = np.argwhere((freqs == cfreq) & (sensor[:, 1] == 9) & (agc2 != 0))
        if search.size > 0:
            slices2.append(agc2[search])
            times2.append(times[search])
            freq2.append(cfreq)

    # Kinda arb but pick a time near middle of freq sweep
    tt1 = np.hstack(times1)[:, 160]
    tt2 = np.hstack(times2)[:, 50]

    spec1 = np.hstack(slices1)
    spec2 = np.hstack(slices2)

    return tt1, freq1, spec1, tt2, freq2, spec2