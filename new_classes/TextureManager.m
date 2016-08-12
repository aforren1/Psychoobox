classdef (Abstract) TextureManager < handle
    properties
        pointer % reference to offscreen window or texture (also an offscreen window)
        float_precision %
        texture_orientation %
        source_rect % subset of the texture to draw
        draw_rect % size of the texture on the onscreen window
        rotation_angle % angle of the texture
        filter_mode % -3 to 5, deals with zooming on texture
        global_alpha % Alpha over the entire texture
        modulate_color % [3 x N] for color
        aux_parameters % See PTB help
        rel_x_pos % relative x position. Must be specified if draw_rect is unspecified.
        rel_y_pos % relative y position. Must be specified if draw_rect is unspecified.
        rel_x_scale % length along x dimension relative to onscreen window.
                    % If nan, use exact length of y (to get squares, etc.)
        rel_y_scale % length along y dimension relative to onscreen window.
                    % if nan, use exact length of x (to get squares, etc.)
        p % input parser
    end

    methods
        function self = TextureManager()
        % Initialize the manager object.
        % No arguments, returns object of class TextureManager.
        self.pointer = [];
        self.p = inputParser;
        self.p.addParamValue('special_flags', 0, @(x) any(x == [0 1 2 4 8 32]));
        self.p.addParamValue('float_precision', 0, @(x) isnumeric(x));
        self.p.addParamValue('texture_orientation', 0, @(x) any(x == 0:3));
        self.p.addParamValue('texture_shader', 0);
        self.p.addParamValue('source_rect', [], @(x) isempty(x) || isnumeric(x));
        self.p.addParamValue('draw_rect', [], @(x) isempty(x) || isnumeric(x));
        self.p.addParamValue('rotation_angle', 0, @(x) isnumeric(x));
        self.p.addParamValue('filter_mode', 0, @(x) any(x == -3:5));
        self.p.addParamValue('global_alpha', 1, @(x) x >= 0 && x <= 1);
        self.p.addParamValue('modulate_color', []);
        self.p.addParamValue('aux_parameters', []);

        self.p.addParamValue('rel_x_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
        self.p.addParamValue('rel_y_pos', [], @(x) isempty(x) || (all(x >= 0) || all(x <= 1)));
        self.p.addParamValue('rel_x_scale', [], @(x) isempty(x) || all(x >= 0));
        self.p.addParamValue('rel_y_scale', [], @(x) isempty(x) || all(x >= 0));

        end

        function Add(self, indices, varargin)
        % Add objects to specific indices.
        % Inputs:
        %    indices - Which indices to add properties to
        % Optional (key-value) Inputs:
        %    rel_x_pos - Relative x positions. Required if draw_rect is unspecified.
        %    rel_y_pos - Relative y positions. Required if draw_rect is unspecified.
        %    rel_x_scale - Length along x dimension relative to onscreen window.
        %                  If nan, use exact length of y (to get squares, etc.)
        %    rel_y_scale - Length along y dimension relative to onscreen window.
        %                  If nan, use exact length of x (to get squares, etc.)
        %    modulate_color - [3 x N] matrix of colors, N being equal to the length of indices.
        %    rotation_angle - Angle of the texture in degrees.
        %    global_alpha - Global alpha value.
        %    source_rect - Subset of the texture to draw. Currently unchecked.
        %    filter_mode - Filtering to use when zoomed in or out. See `Screen DrawTexture?`
        %    ... - other options, TBD
        %
        % Usage:
        % % Add one red square (relative to x) to index 2 that is 1/10 of the size
        % % of the target window.
        % myobj.Add(2, 'rel_x_pos', .2, 'rel_y_pos', .2, 'rel_x_scale', 0.1, ...
        %           'rel_y_scale', nan, 'modulate_color', [255 0 0]);
        %
        % % Add two rectangles
        % myobj.Add(1:2, 'rel_x_pos', [.1 .9], 'rel_y_pos', [.9 .1], ...
        %           'modulate_color', [255 0 0; 0 255 0]', 'global_alpha', [.9, .3]);
            self.p.parse(varargin{:});
            opts = self.p.Results;
            for fns = fieldnames(opts)'
                self.(fns{1})(:, indices) = opts.(fns{1});
            end
        end

        function Prime(self, win_pointer, indices)
        % Prepare specific indices for drawing on the specified window.
        % Usage:
        % myobj.Prime(win1, 1:3);
            if isempty(self.draw_rect)
                self.temp_rect(:, indices) = RelativeToRect(self.rel_x_pos(:, indices),...
                                                            self.rel_y_pos(:, indices), ...
                                                            self.rel_x_scale(:, indices),...
                                                            self.rel_y_scale(:, indices), ...
                                                            Screen('Rect', win_pointer));
            else
                % TODO: deprecate at some point?
                self.temp_rect(:, indices) = self.draw_rect(:, indices);
            end
            % Draw prototypes here (for shapes) or maketextures
        end

        function Draw(self, win_pointer, indices)
        % Draw objects from specified indices to the window.
            Screen('DrawTextures', win_pointer, ...
                   [self.pointer(indices)], ...
                   [self.source_rect(:, indices)], ...
                   [self.temp_rect(:, indices)], ...
                   [self.rotation_angle(indices)], ...
                   [self.filter_mode(indices)], ...
                   [self.global_alpha(indices)], ...
                   [self.modulate_color(:, indices)], ...
                   [self.texture_shader(indices)], ...
                   [self.special_flags(indices)], ...
                   [self.aux_parameters(indices)]);
        end

        function Set(self, indices, varargin)
        % Set particular values
            self.p.parse(varargin{:});
            opts = self.p.Results;
            if ~IsOctave
                temp_names = fieldnames(opts)';
                delta_names = temp_names(~ismember(temp_names,...
                                         self.p.UsingDefaults));
            else
                delta_names = fieldnames(opts)';
            end

            for fns = delta_names
                self.(fns{1})(:, indices) = opts.(fns{1});
            end
        end

        function value = Get(self, indices, property)
        % Get particular values
            value = self.(property)(:, indices);
        end

        function new = Copy(self)
            new = feval(class(self));

            props = fieldnames(struct(self));
            for ii = 1:length(props)
                new.(props{ii}) = self.(props{ii});
            end
        end

    end
end
