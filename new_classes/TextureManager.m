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
        end

        function Prime(self, win_pointer, indices)
        % Prepare specific indices for drawing on the specified win_pointer.
        % Usage:
        % myobj.Prime(win1, 1:3);
        end

        function Remove(self, win_pointer, indices)
        % Remove specific indices.
        end

        function Draw(self, win_pointer, indices)
        % Draw objects from specified indices to the window.
        end

        function Set(self, indices, varargin)
        % Set particular values

        end

        function Get(self, indices, varargin)
        % Get particular values

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
