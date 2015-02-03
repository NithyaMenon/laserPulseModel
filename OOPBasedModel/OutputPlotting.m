clc
close all

[ times,verticalPowers,horizontalPowers,widths ] = IDtoPulseData( simout );

plot(times,verticalPowers,'k+');
grid on;