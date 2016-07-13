classdef PsychText < PsychHandle
% PsychText Draw text on the specified window.
%
% Options available when `formatted = true` are marked with [DFT].
% Settings under the default are marked with [DT].
%
% PsychText Properties:
%    val - The string to be written.
%    formatted - Use DrawFormattedText instead of DrawText. Default is false.
%    size - Size of the text. Default is 10. [DT, DFT]
%    style - Style of the font, including bold, italic, and underline. Default is 0 (normal). [DT, DFT]
%    styles - Struct containing all possible styles. [DT, DFT]
%    font - Default is Courier New. [DT, DFT]
%    color - Default is 0 (black). [DT, DFT]
%    background_color - Default is []. [DT]
%    transform - 2x3 matrix specifying the text orientation. Default is the identity matrix. [DT, DFT]
%    x - Position on x axis. Default is 0. 'center' is also allowed under DFT. [DT, DFT]
%    y - Position on y axis. Default is 0. 'center' is also allowed under DFT. [DT, DFT]
%    y_pos_is_baseline - Setting to 1 replicates old PTB behavior. [DT]
%    right_to_left - Whether text should be written right to left. Defaults to 0 (false).
%    renderer - Use new or old renderer. 1 (new) is default. [DT, DFT]
%    wrapat - After this number of characters, automatically wrap the string. Default is []. [DFT]
%    fliph - Flip text horizontally. Default is 0. [DFT]
%    flipv - Flip text vertically. Default is 0. [DFT]
%    vert_spacing - Add space between lines. Default is 1. [DFT]

    properties (SetAccess = public, GetAccess = public)
        size;
        style;
        styles;
        font;
        color;

        background_color;
        transform;
        x;
        y;
        y_pos_is_baseline;

        val;
        renderer;
        formatted;
        wrapat;

        fliph;
        flipv;
        vert_spacing;
        right_to_left;
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

            p.addParamValue('x', 0, @(x) isnumeric(x) || strcmpi(x, 'center'));
            p.addParamValue('y', 0, @(x) isnumeric(x) || strcmpi(x, 'center'));
            p.addParamValue('y_pos_is_baseline', 0, @(x) any(x == [0, 1]));
            p.addParamValue('renderer', 1, @(x) any(x == [0, 1]));
            p.addParamValue('formatted', false, @(x) islogical(x));

            p.addParamValue('wrapat', [], @(x) isnumeric(x));
            p.addParamValue('fliph', 0, @(x) any(x == [0, 1]));
            p.addParamValue('flipv', 0, @(x) any(x == [0, 1]));
            p.addParamValue('vert_spacing', 1, @(x) isnumeric(x));
            p.addParamValue('right_to_left', 0, @(x) any(x == [0, 1]));


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
            if self.formatted
                DrawFormattedText(window_pointer, self.val, self.x, self.y,...
                                  self.color, self.wrapat, self.fliph, self.flipv, ...
                                  self.vert_spacing, self.right_to_left);
            else
                Screen('DrawText', window_pointer, self.val, ...
                       self.x, self.y, self.color, self.background_color, ...
                       self.y_pos_is_baseline, self.right_to_left);
            end
        end
    end
end
