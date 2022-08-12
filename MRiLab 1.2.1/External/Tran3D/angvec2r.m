%ANGVEC2R Convert angle and vector orientation to a rotation matrix
%
% R = ANGVEC2R(THETA, V) is an orthonormal rotation matrix, R, 
% equivalent to a rotation of THETA about the vector V.
%
% See also eul2r, rpy2r.


% Copyright (C) 1993-2011, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for Matlab (RTB).

function R = angvec2r(theta, k)

    if nargin < 2 || ~isscalar(theta) || ~isvec(k)
        error('RTB:angvec2r:badarg', 'bad arguments');
    end

	cth = cos(theta);
	sth = sin(theta);
	vth = (1 - cth);
	kx = k(1); ky = k(2); kz = k(3);

        % from Paul's book, p. 28
	R = [
kx*kx*vth+cth      ky*kx*vth-kz*sth   kz*kx*vth+ky*sth
kx*ky*vth+kz*sth   ky*ky*vth+cth      kz*ky*vth-kx*sth
kx*kz*vth-ky*sth   ky*kz*vth+kx*sth   kz*kz*vth+cth
	];
