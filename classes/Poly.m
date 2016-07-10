classdef Poly < PsychFrames

    properties (SetAccess = protected, GetAccess = protected)
        is_convex;
        point_list;
    end

    methods
        function self = Poly(varargin)
            self.p.FunctionName = 'Poly';
            self.p.addParamValue('is_convex', true, @(x) islogical(x));
            self.p.addParamValue('point_list', [], @(x) isempty(x) || isnumeric(x))
            self.p.parse(varargin{:});
            opts = self.p.Results;

            % check whether frame, fill, or both
            if isempty(opts.fill_color) && isempty(opts.frame_color)
                error('Need to specify at least one color!');
            end
            if isempty(opts.fill_color)
                p.type = 'FillPoly';
            elseif isempty(opts.frame_color)
                p.type = 'FramePoly';
            else
                p.type = 'FillFrame';
            end

            % shuffle options into the obj
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end
        end % end constructor

        function Draw(self, pointer)
            if strcmpi(self.type, 'FillPoly') || strcmpi(self.type, 'FillFrame')
                Screen('FillPoly', pointer, self.fill_color, ...
                       self.point_list, self.is_convex);
            end

            if strcmpi(self.type, 'FramePoly') || strcmpi(self.type, 'FillFrame')
                Screen('FramePoly', pointer, self.frame_color, ...
                       self.point_list, self.pen_width);
            end
        end % end Draw
    end % end methods
end % end classdef


Screen('FramePoly', windowPtr [,color], pointList [,penWidth]);
Screen('FillPoly', windowPtr [,color], pointList [, isConvex]);
