%R2T Convert rotation matrix to a homogeneous transform
%
% T = R2T(R) is a homogeneous transform equivalent to an orthonormal 
% rotation matrix R with a zero translational component.
%
% Notes::
% - Works for T in either SE(2) or SE(3)
%  - if R is 2x2 then T is 3x3, or
%  - if R is 3x3 then T is 4x4.
% - Translational component is zero.
% - For a rotation matrix sequence returns a homogeneous transform
%   sequence.
%
% See also T2R.


% Copyright (C) 1993-2011, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for Matlab (RTB).

function T = r2t(R)

    % check dimensions: R is SO(2) or SO(3)
    d = size(R);
    if d(1) ~= d(2)
        error('matrix must be square');
    end
    if ~any(d(1) == [2 3])
        error('argument is not a rotation matrix (sequence)');
    end
    
    Z = zeros(d(1),1);
    B = [Z' 1];
    
    if numel(d) == 2
        % single matrix case
        T = [R Z; B];
    else
        %  matrix sequence case
        T = zeros(4,4,d(3));
        for i=1:d(3)
            T(:,:,i) = [R(:,:,i) Z; B];
        end
    end
