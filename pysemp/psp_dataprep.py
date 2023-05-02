#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# """
#  * \file psp_dataprep.py
#  * \brief 
#     Uses cdfopenV3.py to extract radio data from PSP
#    	Stiches all the data into one big data file
#     Adds the two dipoles to get Stokes I param
#     Background subtracts the data
#     Saves three .txt files. one for each: data, freq, time 
#     default data extracted located at cwd/../../ExtractedData/YEAR/MONTH/
    
    
#     NOTES:  User may manually choose the day to be extracted or 
#             give the program a range of days and the software
#             will extract all the data between those days.
#             For more than one day extraction use  day = None
            
#             If a day is missing or the data is faulty, it 
#             must be flagged. 
            
            
    
#  * \author L. A. Canizares
#  * \version 2.0
#  * \date 2019-11-13
# """



# # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#      Libraries                                      #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#from spacepy import pycdf
import cdflib
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import datetime as dt
import numpy as np
from statistics import mode
import math
import os
#import cdfopenV2 as cdfo


class fnames:
    """
    This class stores the location of the directories where data is, as well as the names of the datasets to be extracted
    from CDF file. 

    
    band: Either hfr or lfr for high band or low band
    year: year of the observation
    month: month of the observation
    day: day of the observation 
    dipoles: Antenna pair V1V2 or V3V4

    fname - file name
    path_data - path to the data (for now change here but in the future this will be an option)
    dataname - name of dataset in the CDF file
    epochname - name of epoch dataset in the CDF file
    freqname - name of frequency dataset in the CDF file

    """
    def __init__(self,band,year,month,day,dipoles,dirdata='./',prefix="psp_fld_l2_rfs_"):
        if dipoles == "V1V2":
            ch = "0"
        elif dipoles == "V3V4":
            ch = "1"
        else:
            print("ERROR: class fnames: ch is wrong")
            
        self.band = band
        self.year = year
        self.month = month
        self.day = day
        self.dipoles = dipoles
        self.fname = prefix+self.band+"_"+self.year+self.month+self.day+"_v01.cdf"

        # PLACE HERE THE DIRECTORY WHERE RAW DATA IS
        self.path_data = dirdata+'psp/'+self.fname

        # HEADER NAMES
        self.dataname = prefix+self.band+"_auto_averages_ch"+ch+"_"+self.dipoles
        self.epochname = "epoch_"+self.band+"_auto_averages_ch"+ch+"_"+self.dipoles
        self.freqname = "frequency_"+self.band+"_auto_averages_ch"+ch+"_"+self.dipoles



class data_spectro:
    """
    Data class. Data extracted from CDF file will be stored in this class format. 
    With:
    data : 2D matrix of the dynamic spectra
    epoch: 1D array of the time datapoints
    freq: 1D array of the frequency channels used for each data point. 
    """
    def __init__(self, data, epoch, freq):
        self.data=data
        self.epoch=epoch
        self.freq=freq



def data_from_CDF(date, myfile,verbose=False):
    """ data_from_CDF
     outputs dynamic spectra data from PSP CDF datafile. 
     inputs:
        date: datetime.datetime class. Date of the observation. 
        myfile: fnames class defined in psp_dataprep. Location of all directories 

    output:
        data: 2D numpy matrix of dynamic spectra
        epoch: 1D numpy array of the date and times of each datapoint
        freqs: 1D numpy array of the frequency channels 

    """

    cwd = os.getcwd()
    print(myfile.path_data)
    cdf = cdflib.CDF(myfile.path_data)
    # print(cdf)

    data = cdf.varget(myfile.dataname)
    epoch = cdflib.cdfepoch.to_datetime(cdf.varget(myfile.epochname)) # return datetime format
    freqs = cdf.varget(myfile.freqname)
    

    data = np.array(data)
    epoch = np.array(epoch)
    freqs = np.array(freqs)
    freqs = freqs[0,:]  
    
    if verbose:
        print('data shape: ', data.shape)
        print('t shape:', epoch.shape)
        print('f shape:', freqs.shape)
    return data, epoch, freqs    


def find_gaps(data):
    # time resolution
    timediff = []
    for i in range(0,len(data.epoch)-1):
        diff = data.epoch[i+1]-data.epoch[i]
        #print(diff)
        buffer = diff.total_seconds()
        timediff.append(float(buffer))

    timeres = np.mean(timediff)
    print(f"Time res: {timeres}")
    cadence=mode(timediff)
    if developer ==1:
        print(f"cadence type: {type(cadence)}")
    thres = cadence*3
    thres=float(thres)

    inseconds = []
    for each in timediff:
        inseconds.append(float (abs(each)))

    if developer == 1:
        if verbose == 1:
            print(inseconds)
        print(f"inseconds type {type(inseconds[1])}")
        print(f"thres type {type(thres)}")
        print(f"timediff type {type(timediff[i])}")

    # Find gaps and measure their lengths    
    gap_indices = []
    gap_lengths = []
    for i in range(0,len(inseconds)):
        if inseconds[i]>thres:
            gap_indices.append(i)
            gap_lengths.append(round(inseconds[i]/cadence))

    if developer == 1:
        plt.figure()
        plt.plot(inseconds[:], 'r-')
        plt.plot(inseconds[:], 'r*')
        c = 0
        for i in range(0, len(inseconds)):
            if c < len(gap_indices):
                if i == gap_indices[c]:
                    plt.plot(gap_indices[c],inseconds[i],'b*')    
                    c= c+1
            else:
                break
        plt.title("Time differences")
        plt.xlabel("Index number")
        plt.ylabel(r'$\Delta$T   [s]')

    return cadence, gap_indices, gap_lengths 



def add_gaps(data):

    # use the year month and day of the first item in epoch list to get the date of observation
    t0 = data.epoch[0]
    if developer == 1:
        print(f"t0: {t0}")

    # date of observation
    year = t0.year
    month = t0.month
    day = t0.day
     
    # generic begining and end of the day 
    day_start = dt.datetime(year, month, day, 0, 0, 0)
    day_end = day_start + dt.timedelta(days=1)

    if developer == 1:
        print(f"day_start : {day_start}")
        print(f"day_end : {day_end}")
        print(f"day/month/year : {day}/{month}/{year}")


    # check beginning of the day. if Day doesnt start at midnight, add. 
    if data.epoch[0] > day_start:
        if developer ==1:
            if verbose ==1:
                print(data.epoch)
        data.epoch = np.insert(data.epoch,0, values=day_start,axis=0)
        data.data = np.insert(data.data, 0, values=0, axis=0)
        print("Begining of day added")
        



    #check end of the day. if day doesnt end at midnight of next day, add. 
    if data.epoch[-1]<day_end:
        data.epoch = np.insert(data.epoch,len(data.epoch), values=day_end,axis=0)
        data.data = np.insert(data.data, data.data.shape[0], values=0, axis=0)
        print("End of day added")    


    cadence, gap_indices, gap_lengths = find_gaps(data)

    # Add gaps
    cadence_dt=dt.timedelta(seconds=cadence)
    index_offset = 0
    for j in range(0,len(gap_indices)):
        for i in range(0, gap_lengths[j]):
            current_gap_index = gap_indices[j]+i+index_offset
            
            if developer == 1:
                if verbose == 1:
                    print(current_gap_index)

            data.epoch = np.insert(data.epoch,current_gap_index, values=data.epoch[current_gap_index-1]+cadence_dt,axis=0)
            data.data = np.insert(data.data, current_gap_index, values=0, axis=0)
        index_offset = index_offset + gap_lengths[j]
        


    if developer == 1:
        print(f"Length gap_indices: {len(gap_indices)}")
        print(f"gap_indices: {gap_indices}")
        print(f"gap_lengths: {gap_lengths}")

    cadence, gap_indices, gap_lengths = find_gaps(data)

    if developer == 1:
        print(f"Length gap_indices: {len(gap_indices)}")
        print(f"gap_indices: {gap_indices}")
        print(f"gap_lengths: {gap_lengths}")

    if len(gap_indices) == 0:
        print("Gaps added correctly")



    return data
            




def backSub(data, percentile=1):
    """ Background subtraction:
        This function has been modified from Eoin Carley's backsub funcion
        https://github.com/eoincarley/ilofar_scripts/blob/master/Python/bst/plot_spectro.py
        
        data:        numpy 2D matrix of floating values for dynamic spectra 
        percentile:  integer value def = 1. bottom X percentile of time slices
                                     
        
        
        METHOD ----
        * This function takes the bottom x percentile of time slices  
        * Averages those time slices.
        * Subtracts the average value from the whole dataset 
        
        
        """
    # Get time slices with standard devs in the bottom nth percentile.
    # Get average spectra from these time slices.
    # Devide through by this average spec.
    # Expects (row, column)

    
    print("Start of Background Subtraction of data")
    dat = data.T
    #dat = np.log10(dat)
    dat[np.where(np.isinf(dat)==True)] = 0.0
    dat_std = np.std(dat, axis=0)
    dat_std = dat_std[np.nonzero(dat_std)]
    min_std_indices = np.where( dat_std < np.percentile(dat_std, percentile) )[0]
    min_std_spec = dat[:, min_std_indices]
    min_std_spec = np.mean(min_std_spec, axis=1)
    dat = np.transpose(np.divide( np.transpose(dat), min_std_spec))


    data.data = dat.T


    #Alternative: Normalizing frequency channel responses using median of values.
        #for sb in np.arange(data.shape[0]):
        #       data[sb, :] = data[sb, :]/np.mean(data[sb, :])

    print("Background Subtraction of data done")
    return data




def save_data(data,yearS,monthS,dayS,band):
    cwd = os.getcwd()

    # DIRECTORY TO SAVE THE DATA
    directory_extracted =  cwd+"/../DATA/ExtractedData"
    directory_year = directory_extracted + "/"+yearS
    directory_month = directory_year + "/"+monthS
    directory = directory_month + "/"+dayS

    
    
    if not os.path.exists(directory_extracted):
        os.makedirs(directory_extracted)
    
    if not os.path.exists(directory_year):
        os.makedirs(directory_year)
        
    if not os.path.exists(directory_month):
        os.makedirs(directory_month)

    if not os.path.exists(directory):
        os.makedirs(directory)


    fname_data = directory+"/PSP_" + yearS + "_" + monthS + "_" + dayS+"_data_"+band+".txt"
    fname_freq = directory+"/PSP_" + yearS + "_" + monthS + "_" + dayS+"_freq_"+band+".txt"
    fname_time = directory+"/PSP_" + yearS + "_" + monthS + "_" + dayS+"_time_"+band+".txt"

    
    np.savetxt(fname_data, data.data, delimiter=",")
    np.savetxt(fname_freq, data.freq, delimiter=",")

    print(type(data.epoch))

    for i in range(0,len(data.epoch)): 
        data.epoch[i] = dt.datetime.timestamp(data.epoch[i])
    np.savetxt(fname_time, data.epoch, delimiter=",")
    



if __name__=='__main__':
    
    starttime = dt.datetime.now()
    print(' ')
    print(' ')
    print(' Running psp_dataprep.py')
    print(' ')

    year = "2019"    ## must be in YYYY format 
    month = "04"     ## Must be in MM format
    day = "09"       ## Must be in DD format


    # options
    add_gaps_option = 1
    back_sub_option = 1
    save_data_option = 1
    developer = 0
    verbose = 0


    t0 = dt.datetime(int(year),int(month),int(day))

    
    
    # hfr
    my_fileh12 = fnames("hfr",year,month,day,"V1V2")
    my_fileh34 = fnames("hfr",year,month,day,"V3V4")

    # my_fileh12 = "/Users/albertocanizares/OneDrive/Work/0_PhD/DATA/PSP_RAW/2019/04/hfr/psp_fld_l2_rfs_hfr_20190409_v01.cdf"



    # extract from cdf file
    datah12, epochh12, freqsh12 = data_from_CDF(t0, my_fileh12)
    datah34, epochh34, freqsh34 = data_from_CDF(t0, my_fileh34)
    
    # merge V1V2 and V3V4
    datah = np.add(datah12, datah34)     # stokesI
    freqh = freqsh12                    # same as in V3V4
    epochh = epochh12                   # same as in V3V4
    

    
    # lfr
    my_filel12 = fnames("lfr",year,month,day,"V1V2")
    my_filel34 = fnames("lfr",year,month,day,"V3V4")
    # extract from cdf file
    datal12, epochl12, freqsl12 = data_from_CDF(t0, my_filel12)
    datal34, epochl34, freqsl34 = data_from_CDF(t0, my_filel34)

    
    # merge V1V2 and V3V4
    datal = np.add(datal12,datal34)     # stokesI
    freql = freqsl12                    # same as in V3V4
    epochl = epochl12                   # same as in V3V4

    lsd = data_spectro(datal,epochl,freql)      #lowband spectral data
    hsd = data_spectro(datah,epochh,freqh)      #highband spectral data

    # backsub
    if back_sub_option == 1:
        print(lsd.data[2])
        lsd = backSub(lsd)
        hsd = backSub(hsd)
        print(lsd.data[2])


    # add gaps 
    if add_gaps_option == 1:
        lsd = add_gaps(lsd)
        hsd = add_gaps(hsd)

    # save in txt files
    if save_data_option == 1:
        save_data(lsd,year,month,day,"l")
        save_data(hsd,year,month,day,"h")

    
    if developer == 1:
        print(f"t0:{lsd.epoch[0]}")
        plt.figure()
        plt.plot(lsd.epoch, 'r*')
        plt.title("Date as function of data index")
        plt.xlabel("Epoch data index")
        plt.ylabel("date")
    



    if developer == 1:
        # quick plot for now. 
        v_min = np.percentile(hsd.data, 1)
        v_max = np.percentile(hsd.data, 99)
        plt.figure()
        plt.title("Quick Dynamic spectra view")
        plt.xlabel("epoch data index")
        plt.ylabel("frequency data index")
        plt.imshow(hsd.data.T, aspect='auto', vmin=v_min, vmax=v_max)

        
        # quick plot for now. 
        v_min = np.percentile(lsd.data, 1)
        v_max = np.percentile(lsd.data, 99)
        plt.figure()
        plt.title("Quick Dynamic spectra view")
        plt.xlabel("epoch data index")
        plt.ylabel("frequency data index")
        plt.imshow(lsd.data.T, aspect='auto', vmin=v_min, vmax=v_max)
        plt.show()



    endtime = dt.datetime.now()

    totalrunningtime = endtime - starttime
    print('End of program')
    print(' ')
    print(f"Start Time: {starttime}")
    print(f"End Time: {endtime}")
    print(f"Total running time: {totalrunningtime}")
    print(' ')



