classdef Oval < PsychFrames

    properties (SetAccess = private, GetAccess = private)
        perfect_up_to_max_diameter;
        pen_width;
        pen_height;
    end

    methods
        function self = Oval(varargin)
            p = inputParser;
            p.FunctionName = 'Oval';
            p.addParamValue('color', [255 255 255], @(x) isnumeric(x));
            p.addParamValue('rect', [], @(x) isempty(x) || (isnumeric(x) && length(x) == 4));
            p.addParamValue('pen_width', 0, @(x) isnumeric(x));
            p.addParamValue('pen_height', 0, @(x) isnumeric(x));
            
        end

    end
Screen('FillOval', windowPtr [,color] [,rect] [,perfectUpToMaxDiameter]);
Screen('FrameOval', windowPtr [,color] [,rect] [,penWidth] [,penHeight] [,penMode]);


end
