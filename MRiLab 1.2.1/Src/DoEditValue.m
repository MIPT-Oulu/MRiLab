%                                                _______
% _________________________________________     / _____ \      
%     .  .     |---- (OO)|       ___   |       | |     | |     
%    /\  /\    |__ |  || |      /   \  |___    |_|     |_|     
%   /  \/  \   |  \   || |      \___/  |   \   |S|     |N|     
%  /   ||   \  |   \_ || |____|     \  |___/  MRI Simulator    
% _________________________________________                  
% Numerical MRI Simulation Package
% Version 1.2  - https://sourceforge.net/projects/mrilab/
%
% The MRiLab is a numerical MRI simulation package. It has been developed to 
% simulate factors that affect MR signal formation, acquisition and image 
% reconstruction. The simulation package features highly interactive graphic 
% user interface for various simulation purposes. MRiLab provides several 
% toolboxes for MR researchers to analyze RF pulse, design MR sequence, 
% configure multiple transmitting and receiving coils, investigate B0 
% in-homogeneity and object motion sensitivity et.al. The main simulation 
% platform combined with these toolboxes can be applied for customizing 
% various virtual MR experiments which can serve as a prior stage for 
% prototyping and testing new MR technique and application.
%
% Author:
%   Fang Liu <leoliuf@gmail.com>
%   University of Wisconsin-Madison
%   April-6-2014
% _________________________________________________________________________
% Copyright (c) 2011-2014, Fang Liu <leoliuf@gmail.com>
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
% _________________________________________________________________________

function DoEditValue(handles,parent_handle,Attributes,AttrhNumber,dims)

% Create Editbox for ajusting attributes at the frame given by parent_handle
% special mark
% '$value' ----popupmenu
% '^value' ----checkbox
% '@' ----static text

TextW=dims(1);
EditW=dims(2);
SpaceW=dims(3);
TextH=dims(4);
EditH=dims(5);
SpaceH=dims(6);

%--old schema
% switch get(parent_handle,'Type')
%     case 'uitab'
%         Position=get(get(get(parent_handle,'Parent'),'Parent'),'Position');
%     case 'uipanel'
%         Position=get(parent_handle,'Position');
% end
% Hpair=floor(Position(4)/(TextH+SpaceH));
% Wpair=floor(Position(3)/(TextW+SpaceW));
%--end

Hpair=floor(1/(TextH+SpaceH));
Wpair=floor(1/(TextW+SpaceW));
ind=1;
for j=1:Wpair
    for i=1:Hpair
        if ind<=length(Attributes)
            Attrh.([Attributes(ind).Name 'Text'])=uicontrol(parent_handle,'Style', 'text', 'String', Attributes(ind).Name,'FontWeight','bold','Units','normalized',...
                                                                    'Position', [(j-1)*(TextW+SpaceW+EditW) (i-1)*(TextH+SpaceH) TextW TextH]);
            eval(['handles.Attrh' num2str(AttrhNumber) '.' Attributes(ind).Name 'Text=Attrh.' Attributes(ind).Name 'Text;']);
            if ~isempty(Attributes(ind).Value)
                switch Attributes(ind).Value(1)
                    case '$'
                        eval(['AttributeOpt={' Attributes(ind).Value(3:end) '};']);
                        Attrh.(Attributes(ind).Name)=uicontrol(parent_handle,'Style', 'popupmenu', 'String', AttributeOpt,'BackgroundColor',[1 1 1],...
                                                                        'Value',str2double(Attributes(ind).Value(2)),'Units','normalized',...
                                                                        'Position', [(j-1)*(TextW+SpaceW+EditW)+TextW (i-1)*(TextH+SpaceH) EditW EditH],...
                                                                        'TooltipString',[Attributes(ind).Name ' : ' Attributes(ind).Value(3:end)]);
                        eval(['handles.Attrh' num2str(AttrhNumber) '.' Attributes(ind).Name '=Attrh.' Attributes(ind).Name ';']);
                    case '^'
                        Attrh.(Attributes(ind).Name)=uicontrol(parent_handle,'Style', 'checkbox', 'String',[],'BackgroundColor',[1 1 1],...
                                                                        'Value',str2double(Attributes(ind).Value(2)),'Units','normalized',...
                                                                        'Position', [(j-1)*(TextW+SpaceW+EditW)+TextW (i-1)*(TextH+SpaceH) EditW EditH],...
                                                                        'TooltipString',[Attributes(ind).Name ' : ' Attributes(ind).Value]);
                        eval(['handles.Attrh' num2str(AttrhNumber) '.' Attributes(ind).Name '=Attrh.' Attributes(ind).Name ';']);
                    case '@'
                        eval(['AttributeOpt=' Attributes(ind).Value(2:end) ';']);
                        Attrh.(Attributes(ind).Name)=uicontrol(parent_handle,'Style', 'text', 'String',AttributeOpt,'Units','normalized',...
                                                                        'Position', [(j-1)*(TextW+SpaceW+EditW)+TextW (i-1)*(TextH+SpaceH) EditW EditH],...
                                                                        'TooltipString',[Attributes(ind).Name ' : ' AttributeOpt]);
                        eval(['handles.Attrh' num2str(AttrhNumber) '.' Attributes(ind).Name '=Attrh.' Attributes(ind).Name ';']);
                    otherwise
                        Attrh.(Attributes(ind).Name)=uicontrol(parent_handle,'Style', 'edit', 'String', Attributes(ind).Value,'Units','normalized','BackgroundColor',[1 1 1],...
                                                                    'Position', [(j-1)*(TextW+SpaceW+EditW)+TextW (i-1)*(TextH+SpaceH) EditW EditH],...
                                                                    'TooltipString',[Attributes(ind).Name ' : ' Attributes(ind).Value]);
                        eval(['handles.Attrh' num2str(AttrhNumber) '.' Attributes(ind).Name '=Attrh.' Attributes(ind).Name ';']);
                end
            else
                Attrh.(Attributes(ind).Name)=uicontrol(parent_handle,'Style', 'edit', 'String', Attributes(ind).Value,'Units','normalized','BackgroundColor',[1 1 1],...
                                                                    'Position', [(j-1)*(TextW+SpaceW+EditW)+TextW (i-1)*(TextH+SpaceH) EditW EditH],...
                                                                    'TooltipString',[Attributes(ind).Name ' : ' Attributes(ind).Value]);
                eval(['handles.Attrh' num2str(AttrhNumber) '.' Attributes(ind).Name '=Attrh.' Attributes(ind).Name ';']);
            end
        end
        ind=ind+1;
    end
end
guidata(parent_handle,handles);
end