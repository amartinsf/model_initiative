function [output_correlogram, output_IIDweight] = mccgramIIDweight_BT(correlogram, IID, infoflag);
%Author Leslie R Bernstein
%Additional comments JH Lestang
%This file is intended to be used as an optional appendix to the binaural cross-correlogram toolbox written by Michael Akeroyd.

% function [output_correlogram, output_delayweight] = 
% mccgramIIDweight(correlogram, IID, infoflag);
%
%------------------------------------------------------------------
% Applies a delay-weighting (=p(tau)) function to a correlogram
%------------------------------------------------------------------
%
% Input parameters:
%    correlogram = 'correlogram' structure as defined in mccgramcreate.m
%    
%    IID         = Intensity difference of stimulus
%    
%
%    infoflag    = 1: report some information while running only
%                = 0  dont report anything
%
% Output parameters:
%    output_correlogram = the input correlogram weighted by p(tau)
%    output_delayweight = the delay-weighting function in a correlogram structure
%
%
% Example:
% to apply intensity weighting to a previously-made correlogram cc1, 
% and store the weighted correlogram in cc2 and the weighting-
% function itself in ccw, type:
% >> [cc2 ccw] = mccgramIIDyweight(cc1, IID, 1);
%
%
%----------------------------------------------------------------

 
% define and clear delay-weighting function
% (create by copying then changing input)
IIDweight = correlogram;
IIDweight.title = 'IID-weighting function';
IIDweight.data = zeros(IIDweight.nfilters, IIDweight.ndelays); 

%Parameters and coefficients for Intensity Pulse fit
P=[-0.0000470516337  0.0041076354613   -0.1179639189083  -0.3916993488504  114.8376012402683 -0.6749107331646];
WI=1778; %us     
%Apply the intensity pulse
%Note that the absolute value of IID is used and then the sign of the of the
%M-function implemented by polyval is determined based on the sign of the
%IID

for filter=1:correlogram.nfilters
   for delay=1:correlogram.ndelays
      %Find sign of IID
      if IID==0
          signmult=1;
      else
          signmult=sign(IID);
      end;
      IIDweight.data(filter, delay) =(1/((2*pi).^2*WI)).*exp((-(correlogram.delayaxis(delay)-signmult.*(polyval(P,abs(IID)))).^2)/(2.*WI.^2));
   end; 
end;
  
  



% apply weight (but copy first to get index values ok)
if (infoflag >= 1)
   fprintf('applying function ... \n');
end;
correlogram2 = correlogram;
correlogram2.data = IIDweight.data .* correlogram.data;

% reset names
correlogram2.IIDweight = 'Final';
IIDweight.IIDweight = 'Final';
IIDweight.modelname = mfilename;


% return values
output_correlogram = correlogram2;
output_IIDweight = IIDweight;

if infoflag >= 1
   fprintf('\n');
end;
  
  
  
% the end
%------------------------------
