%  a funciton to read the data, the data can be 
%  author : P.J.Zhang
%  date : 2018-4-25 20:48:13

function [T_ste,T_wind,F_ste,F_wind,freq_ste,freq_wind,S_ste_A,S_wind,S_ste_B] = ...
    read_data_wind_stereo(fname_stereo,fname_wind)
    % fname_stereo : file name of stereo
    % fname_wind   : file name of wind
    
    % T_ste  : matrix of time axis for stereo A and B
    % T_wind : matrix of time axis for WIND
    % T      : matrix type of the time
    % freq   : vector type of the frequency
    % S      : matrix type of the signal
    
    
    data_wind = cdfread(fname_wind,...
               'CombineRecords', true, ...
               'ConvertEpochToDatenum', true);
    time_wind=data_wind{1}';
    [T_wind,~]=meshgrid(time_wind,ones(512,1));

    
    data_ste = cdfread(fname_stereo,...
               'CombineRecords', true, ...
               'ConvertEpochToDatenum', true);
    time_ste=double(data_ste{1}');
    [T_ste,~]=meshgrid(double(time_ste),ones(367,1));
    
    % make matrix form of the data
    F_ste  = double(data_ste{6}');
    S_ste_A= double(data_ste{2}');
    S_ste_B= double(data_ste{4}');
    F_wind = double([[data_wind{9};data_wind{8}]]);
    
    S_wind = double([[data_wind{3};data_wind{2}]]*2);

    % aim to eleminate the signal too nagatively large (for exmaple -1e8)
    thresh_s=0.1;
    S_wind(S_wind<thresh_s)=0;
    S_ste_A(S_ste_A<thresh_s)=0;
    S_ste_B(S_ste_B<thresh_s)=0;
    
    % ignore the data on the overlaped frequency channel
    S_ste_A(49,:)=[];
    S_ste_B(49,:)=[];
    T_ste(49,:)=[];
    F_ste(49,:)=[];
    
    freq_wind = F_wind(:,1);
    freq_ste = sort(F_ste(:,1));
end