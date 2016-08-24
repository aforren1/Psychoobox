classdef PobText < SingularPsychMethods

    properties (SetAccess = public, GetAccess = public)
        size
        style
        font
        color
        background_color

        transform % transform in PTB speak
        rel_x_pos % use rect machinery for positioning, rather than x,y
        rel_y_pos
        window_pointer
        value

        wrapat
        fliph
        flipv
        vert_spacing
        right_to_left
    end

    properties (SetAccess = protected, GetAccess = protected)
        possible_styles
        drawing_rect
    end

    methods
        function self = PobText(value, varargin)
            self = self@SingularPsychMethods;
            self.p.FunctionName = 'PobText';

            self.p.addParamValue('value', '', @(x) ischar(x));
            self.p.addParamValue('size', 10, @(x) isnumeric(x) && x > 0);
            self.p.addParamValue('style', 'normal', ...
            @(x) any(not(cellfun('isempty', strfind({'normal','bold','underline','outline','condense','extend'}, x)))));

            self.p.addParamValue('font', 'Courier New');
            self.p.addParamValue('color', [255 255 255], @(x) isnumeric(x));
            self.p.addParamValue('background_color', [], @(x) isnumeric(x));
            self.p.addParamValue('transform', eye(2, 3), @(x) all(size(x) == size(zeros(2,3))));

            self.p.addParamValue('rel_x_pos', 0, @(x) x >= 0 && x <= 1);
            self.p.addParamValue('rel_y_pos', 0, @(x) x >= 0 && x <= 1);
            self.p.addParamValue('fliph', 0, @(x) any(x == [0, 1]));
            self.p.addParamValue('flipv', 0, @(x) any(x == [0, 1]));

            self.p.addParamValue('wrapat', [], @(x) isnumeric(x));
            self.p.addParamValue('vert_spacing', 1, @(x) isnumeric(x));
            self.p.addParamValue('right_to_left', 0, @(x) any(x == [0, 1]));

            self.p.parse(value, varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1}) = opts.(fns{1});
            end

            self.window_pointer = [];

            self.possible_styles = struct('normal', 0, 'bold', 1, 'italic', 2, ...
                                          'underline', 4, 'outline', 8, 'condense', 32, ...
                                          'extend', 64);
        end

        function Register(self, win_pointer)
            self.window_pointer = win_pointer;
        end

        function Draw(self)
            if isempty(self.window_pointer)
                error('Call obj.Register(window_pointer) first.')
            end
            self.RelativeToRect(Screen('Rect', self.window_pointer));

            Screen('TextSize', self.window_pointer, self.size);
            Screen('TextStyle', self.window_pointer, self.possible_styles.(self.style));
            Screen('TextFont', self.window_pointer, self.font);
            Screen('TextTransform', self.window_pointer, self.transform);
            [~, ~, x] = DrawFormattedText(self.window_pointer, self.value,...
                              'center', 'center', ...
                              self.color, self.wrapat, self.fliph, self.flipv, ...
                              self.vert_spacing, self.right_to_left, ...
                              self.drawing_rect);
        end
    end

    methods (Hidden = true)
        function RelativeToRect(self, reference_rect)
            self.drawing_rect = CenterRectOnPoint([0 0 2 2], ...
                                         self.rel_x_pos * (reference_rect(3) - reference_rect(1)), ...
                                         self.rel_y_pos * (reference_rect(4) - reference_rect(2)));
        end
    end
end
