classdef PsychText < PsychHandle

    properties (SetAccess = public, GetAccess = public)
        size; %set
        style;%set
        styles;
        font;%set
        color;%set
        background_color;%set
        transform;%set
        x;
        y;
        y_pos_is_baseline;
        swap_text_direction;
        val;
        renderer;
    end

    methods
        function self = PsychText(varargin)
            p = inputParser;
            p.FunctionName = 'PsychText';
            p.addParamValue('size', 10, @(x) isnumeric(x) && x > 0);
            p.addParamValue('style', 'normal', ...
            @(x) any(not(cellfun('isempty', strfind(x, {'normal','bold','underline','outline','condense','extend'})))));

            p.addParamValue('font', 'Courier New');
            p.addParamValue('color', 0, @(x) isnumeric(x));
            p.addParamValue('background_color', [], @(x) isnumeric(x));
            p.addParamValue('transform', eye(2, 3), @(x) all(size(x) == size(zeros(2,3))));
            p.addParamValue('val', '', @(x) ischar(x));

            p.addParamValue('x', 0, @(x) isnumeric(x));
            p.addParamValue('y', 0, @(x) isnumeric(x));
            p.addParamValue('y_pos_is_baseline', 0, @(x) any(x == [0, 1]));
            p.addParamValue('renderer', 1, @(x) any(x == [0, 1]));

            p.parse(varargin{:});
            opts = p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            self.styles = struct('normal', 0, 'bold', 1, 'italic', 2, ...
                                 'underline', 4, 'outline', 8, 'condense', 32, ...
                                 'extend', 64);

            if opts.renderer
                Screen('Preference', 'TextRenderer', opts.renderer);
            end
        end

        function Draw(self, window_pointer)
            Screen('TextSize', window_pointer, self.size);
            Screen('TextStyle', window_pointer, self.styles.(self.style));
            Screen('TextFont', window_pointer, self.font);
            Screen('TextTransform', window_pointer, self.transform);
            Screen('DrawText', window_pointer, self.val, ...
                   self.x, self.y, self.color, self.background_color, ...
                   self.y_pos_is_baseline, self.swap_text_direction);
        end
    end
end
