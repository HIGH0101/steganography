function y = addNoise(y, snr)

signal_power = norm( y )^2 / numel(y);
noise_power = signal_power / ( 10^(snr/10) );
noise = sqrt(noise_power)*randn( size(y) );
y = y + noise; 