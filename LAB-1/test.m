pars=[0.02      0.2     -65      6       14;...    % tonic spiking
      0.02      0.25    -65      6       0.5 ;...   % phasic spiking
      0.02      0.2     -50      2       15 ;...    % tonic bursting
      0.02      0.25    -55     0.05     0.6 ;...   % phasic bursting
      0.02      0.2     -55     4        10 ;...    % mixed mode
      0.01      0.2     -65     8        30 ;...    % spike frequency adaptation
      0.02      -0.1    -55     6        0  ;...    % Class 1
      0.2       0.26    -65     0        0  ;...    % Class 2
      0.02      0.2     -65     6        7  ;...    % spike latency
      0.05      0.26    -60     0        0  ;...    % subthreshold oscillations
      0.1       0.26    -60     -1       0  ;...    % resonator
      0.02      -0.1    -55     6        0  ;...    % integrator
      0.03      0.25    -60     4        0;...      % rebound spike
      0.03      0.25    -52     0        0;...      % rebound burst
      0.03      0.25    -60     4        0  ;...    % threshold variability
      1         1.5     -60     0      -65  ;...    % bistability
        1       0.2     -60     -21      0  ;...    % DAP
      0.02      1       -55     4        0  ;...    % accomodation
     -0.02      -1      -60     8        80 ;...    % inhibition-induced spiking
     -0.026     -1      -45     0        80];       % inhibition-induced bursting
 names=[ 'Tonic Spiking', 'Phasic Spiking', 'Tonic Bursting', 'Phasic Bursting','Mixed mode','Spike Frequency Adaptation','Class 1 excitability','Class 2 excitability', ...
     'Spike Latency','Subthreshold oscillations','Frequency Preference – Resonators','Integration','Rebound Spike','Threshold Variability',...
     'Bistability','Depolarizing After-Potential','Accomodation','Inhibition-induced Spiking','Inhibition-induced Bursting']
 Plotting_params=... %tau   maxtspan    T1    I     V
     [0.25      100     -70 ;...    % tonic spiking
      0.25      200     -64 ;...   % phasic spiking
      0.25      220     -70 ;...    % tonic bursting
      0.20      200     -64 ;...   % phasic bursting
      0.25      160     -70 ;...    % mixed mode
      0.25      85      -70 ;...    % spike frequency adaptation
      0.25      300     -60 ;...    % Class 1
      0.25      300     -64 ;...    % Class 2
      0.25      100     -70  ;...    % spike latency
      0.20      200     -62  ;...    % subthreshold oscillations
      0.25      400     -62  ;...    % resonator
      0.25      100     -60  ;...    % integrator
      0.20      200     -64 ;...      % rebound spike
      0.20      200     -64 ;...      % rebound burst
      0.25      100     -61 ;...    % threshold variability
      0.25      300     -65 ;...    % bistability
      0.10      50      -70 ;...    % DAP
      0.50      400     -65 ;...    % accomodation
      0.50      350     -63.8 ;...    % inhibition-induced spiking
      0.50      350     -63.8 ];       % inhibition-induced bursting
  
  
  
  
  
  