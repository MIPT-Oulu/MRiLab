%ANGVEC2TR Convert angle and vector orientation to a homogeneous transform
%
% T = ANGVEC2TR(THETA, V) is a homogeneous transform matrix equivalent to a 
% rotation of THETA about the vector V.
%
% Note::
% - The translational part is zero.
%
% See also EUL2TR, RPY2TR, ANGVEC2R.


% Copyright (C) 1993-2011, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for Matlab (RTB).

function T = angvec2tr(theta, k)

    if nargin < 2 
        error('RTB:angvec2tr:badarg', 'bad arguments');
    end


    T = r2t( angvec2r(theta, k) );
