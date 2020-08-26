%  Bandpass filtering for specified band
%
%  ieeg_butterpass(signal, band, srate, silent)
% 
%      signal       = time X channels;
%      band         = [start:stop] or [start stop];
%      silent       = [optional] flag whether be non verbose
%
function [band_sig] = ieeg_butterpass(signal, band, srate, silent)
    if exist('silent', 'var') == 0,  silent = 0;     end
    
    %automatic stuff:
    num_chans=size(signal,2); % number of channels
    Rp = 3; Rs = 60; % third order Butterworth
    delta = 0.001*2/srate;
    low_p = band(2)*2/srate;
    high_p = band(1)*2/srate;

    high_s = max(delta, high_p - 0.1);
    low_s = min(1-delta, low_p + 0.1);
    [n_band, wn_band] = buttord([high_p low_p], [high_s low_s], Rp, Rs);
    [bf_b bf_a] = butter(n_band, wn_band);

    % fband=filtfilt(bf_b, bf_a, signal(:,84)); %band pass
    band_sig=zeros(size(signal));
    for k=1:num_chans
        % just for nice disp:
        if silent == 0 && mod(k,5)==0,disp(strcat(num2str(k),'/',num2str(num_chans))),end %this is to tell us our progress as the program runs
        band_sig(:,k)=filtfilt(bf_b,bf_a, signal(:,k)); %band pass
    end
    
end




