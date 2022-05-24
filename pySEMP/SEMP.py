import matplotlib.dates as mdates
import numpy as np
from scipy.optimize import fsolve 

AU2km = 149597870.7;
r_earth2km  = 6371;
r_sun2km  = 695700;
v_light2km_s = 3e5;


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


def f_Ne(N_e): 
    # in Hz
    return 8.93e3 * (N_e)**(0.5)

def Ne_f(f):
    # in cm-3
    return (f/8.93e3)**2.0

def leblanc98(r):
    return 3.3e5* r**(-2.)+ 4.1e6 * r**(-4.)+8.0e7* r**(-6.)


def R_to_freq(R,ne_r = leblanc98):
    """
    Frequency(Hz) from R
    """
    return f_Ne(ne_r(R))   

def freq_to_R(f,ne_r = leblanc98,Ne_par=2):
    """
    R[R_s] to frequency f
    """
    func  = lambda R : f - f_Ne(ne_r(R)*Ne_par)
    R_solution = fsolve(func, 2) # solve the R
    return R_solution # [R_s]


def parkerSpiral(r,theta0,v_sw):
    omega = 2.662e-6
    b=v_sw/omega
    r0= 1.0*r_sun2km
    theta = theta0 - 1/b*(r-r0)
    return theta

def t_arrival_model(freq,t0,theta0,vs,v_sw=400,alpha=0,r_satellite_AU=1,Ne_par=2):
    
    omega = 2.662e-6
    b=v_sw/omega
    r0= 1.0*r_sun2km
    r_satellite = r_satellite_AU * AU2km

    r = freq_to_R(freq,leblanc98,Ne_par)*r_sun2km;
    
    S_r = r/2*np.sqrt(1+(r/b)**2)+b/2*np.log(r/b+np.sqrt(1+(r/b)**2))
    
    theta = theta0 - 1/b*(r-r0)
    D_so = np.sqrt((r*np.cos(theta)-r_satellite * np.cos(alpha ))**2 
        +(r*np.sin(theta)-r_satellite*np.sin(alpha ))**2)
    
    t_res = t0 + (S_r/vs + D_so/v_light2km_s)
    return t_res

def Dt_STA_WI_PSP(freq_STA,freq_WI,freq_PSP,
        t_STA,t_WI,t_PSP,
        t0,theta0,vs,v_sw,alpha_STA,alpha_WI,
        alpha_PSP,r_STA,r_WI,r_PSP,Ne_par=2.0):
    
    dt2=0
    N = 0

    for ii,var in enumerate(freq_STA):
        dt2 = dt2+ (t_STA[ii] - t_arrival_model(freq_STA[ii],
                    t0,theta0,vs,v_sw, alpha_STA, r_STA,Ne_par))**2;
        N=N+1

    for ii,var in enumerate(freq_WI):
        dt2 = dt2+ (t_WI[ii] - t_arrival_model(freq_WI[ii],
                    t0,theta0,vs,v_sw, alpha_WI, r_WI,Ne_par))**2;
        N=N+1

    for ii,var in enumerate(freq_PSP):
        dt2 = dt2+ (t_PSP[ii] - t_arrival_model(freq_PSP[ii],
                    t0,theta0,vs,v_sw, alpha_PSP, r_PSP, Ne_par))**2;
        N=N+1

    Dt = np.sqrt(dt2/N)

    return Dt

def Dt_STA_WI_PSP_SOLO(freq_STA,freq_WI,freq_PSP,freq_SOLO,
        t_STA,t_WI,t_PSP,t_SOLO,
        t0,theta0,vs,v_sw,alpha_STA,alpha_WI,
        alpha_PSP,alpha_SOLO,r_STA,r_WI,r_PSP,r_SOLO,
        w_STA,w_WI,w_PSP,w_SOLO,
        Ne_par=2.0):
    
    dt2=0
    N = 0

    for ii,var in enumerate(freq_STA):
        dt2 = dt2+w_STA*(t_STA[ii] - t_arrival_model(freq_STA[ii],
                    t0,theta0,vs,v_sw, alpha_STA, r_STA,Ne_par))**2;
        N=N+w_STA

    for ii,var in enumerate(freq_WI):
        dt2 = dt2+ w_WI*(t_WI[ii] - t_arrival_model(freq_WI[ii],
                    t0,theta0,vs,v_sw, alpha_WI, r_WI,Ne_par))**2;
        N=N+w_WI

    for ii,var in enumerate(freq_PSP):
        dt2 = dt2+ w_PSP*(t_PSP[ii] - t_arrival_model(freq_PSP[ii],
                    t0,theta0,vs,v_sw, alpha_PSP, r_PSP, Ne_par))**2;
        N=N+w_PSP

    for ii,var in enumerate(freq_SOLO):
        dt2 = dt2+ w_SOLO*(t_SOLO[ii] - t_arrival_model(freq_SOLO[ii],
                    t0,theta0,vs,v_sw, alpha_SOLO, r_SOLO, Ne_par))**2;
        N=N+w_SOLO

    Dt = np.sqrt(dt2/N)

    return Dt