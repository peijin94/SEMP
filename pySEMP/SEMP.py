import matplotlib.dates as mdates
import numpy as np

def findLeadingPoint(x,y,ratio_x=0.7,thresh_std=0):
    N_arr_x=y.ravel().shape[0]
    idx_x = np.arange(N_arr_x)
    x_dist=np.partition(y,int(ratio_x*N_arr_x))[:int(ratio_x*N_arr_x)]
    avg_d = np.mean(x_dist)
    y =y - avg_d

    var_d = np.std(x_dist)

    cursor_prev = idx_x[
        np.where(y[0:np.argmax(y)]<var_d*3)][-1]
    idx_fit=idx_x[(cursor_prev-1):(cursor_prev+3)]
    fit_parm = np.polyfit(x[idx_fit],y[idx_fit],1)
    x_get_this = (thresh_std*var_d-fit_parm[1])/fit_parm[0] 
    return x_get_this



def smooth(y, box_pts):

    # example : x_smooth = smooth(arr_x,int(0.1*N_arr_x))
    
    box = np.ones(box_pts)/box_pts
    y_smooth = np.convolve(y, box, mode='same')
    return y_smooth
