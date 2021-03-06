function [d, sr] = sbpca_inv_subbands(subbands, params)
% [d, sr] = sbpca_inv_subbands(subbands, params)
%    Invert mapping to subbands for SBPCA.
% 2013-05-27 Dan Ellis dpwe@ee.columbia.edu

%d = ifilterbank(params.fbank.b, params.fbank.a, subbands, 1, params.fbank.t);

%function X = ifilterbank(B,A,M,N,T)
% X = ifilterbank(B,A,M,N,T)    Invert IIR filterbank output to single channel.
% recover number of filters
[bands, flena] = size(params.fbank.a);
[sbbands, mcols] = size(subbands);
if sbbands ~= bands
  error('Rows of data different from number of filter definitions')
end

% columns in output may be interpolated
xcols = 1+(mcols-1);

% initialize output
d = zeros(xcols,1);

% calculate each row
for filt = 1:bands
  % get filter parameters
  a = params.fbank.a(filt, :);
  b = params.fbank.b(filt, :);
  % extract data row & interpolate with zeros
  interp = zeros(xcols,1);
  interp(1:xcols) = subbands(filt,:)';
  % time shift
  t = round(params.fbank.t(filt));	% samples to shift must be an integer
  interp = [zeros(t,1); interp(1:end-t)];
  % filter
  y = filter(b,a,flipud(interp));
  % accumulate in output
  d = d+flipud(y);
end

sr = params.sr;
