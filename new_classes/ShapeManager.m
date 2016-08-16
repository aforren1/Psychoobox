classdef (Abstract) ShapeManager < TextureManager

    properties
        % Use isnan(fill_color) to do proper subsetting during `DrawTextures`
        fill_color % [3 x N] color of fill; if do not want to fill, add [3 x 1] NaN vector.
        frame_color % [3 x N] color of frame; if do not want to frame, add [3 x 1] NaN vector.
        fill_alpha % Alpha value of fill. Either scalar or [1 x N] vector.
        frame_alpha % Alpha value of frame. Either scalar or [1 x N] vector.
        frame_stroke

    end

    properties (SetAccess = protected, GetAccess = protected)
        proto_pointers % References to Offscreen Windows containing shape prototypes.
        ds
    end

    methods
        function self = ShapeManager()
            self@TextureManager;
            self.p.addParamValue('fill_color', [nan nan nan], @(x) all(all(isnan(x(:, isnan(x(1,:)))))) && all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('frame_color', [nan nan nan], @(x) all(all(isnan(x(:, isnan(x(1,:)))))) && all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('fill_alpha', 1, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_alpha', 1, @(x) all(x >= 0) && all(x <= 255));
            self.p.addParamValue('frame_stroke', 10, @(x) all(x >= 0));
            self.ds = [];
        end

        function Register(self, win_pointer)
            self.win
            if isempty(self.proto_pointers)
                self.proto_pointers(1) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 512 512]);
                self.proto_pointers(2) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 512 512]);
                % Draw shapes here (eg. Fill*)
            end
        end

        function Prime(self, win_pointer, indices)
            Prime@TextureManager(self, win_pointer, indices);

            shape_ptrs = reshape([repmat(self.proto_pointers(1), 1, length(indices)), ...
                                  repmat(self.proto_pointers(2), 1, length(indices))], 1, []);
            valids = ~reshape([isnan(self.fill_color(1, indices)),...
                               isnan(self.frame_color(1,  indices))], 1, []);
            self.ds.shape_ptrs = shape_ptrs(valids);

            temp_rect = reshape([self.temp_rect; self.temp_rect], [], 2*size(self.temp_rect, 2));
            self.ds.temp_rect = temp_rect(:, valids);
            rot_angle = reshape([self.rotation_angle, self.rotation_angle], 1, []);
            self.ds.rot_angle = rot_angle(valids);
            filt_mode = reshape([self.filter_mode, self.filter_mode], 1, []);
            self.ds.filt_mode = filt_mode(valids);
            colors = reshape([self.fill_color; self.frame_color], [], 2*size(self.fill_color, 2));
            self.ds.colors = colors(:, valids);
            alphas = reshape([self.fill_alpha, self.frame_alpha], 1, []);
            self.ds.colors(4, :) = alphas(valids);
            self.ds.wptr = win_pointer;
        end

        function Draw(self)
        % need to do logical subsetting about whether frame or fill
        % are nan, then build up combinations of matrices that work
        % properly
        Screen('DrawTextures', self.ds.wptr, ...
               self.ds.shape_ptrs, [], ... % TODO: hash out source_rect
               self.ds.temp_rect,... % destinationRect
               self.ds.rot_angle, ...
               self.ds.filt_mode, ...
               [], ...
               self.ds.colors, ...
               [], ... % handle whatever this is
               [], []); %TODO: Handle special flags and aux parameters properly
        end
    end

    methods (Hidden = true)
        function RelativeToRect(self, indices, reference_rect)
        % Convert relatives to absolutes
            y_size = self.rel_y_scale(indices) * (reference_rect(4) - reference_rect(2));
            x_size = self.rel_x_scale(indices) * (reference_rect(3) - reference_rect(1));
            if any(isnan(y_size))
                y_size(isnan(y_size)) = x_size(isnan(y_size));
            end
            if any(isnan(x_size))
                x_size(isnan(x_size)) = y_size(isnan(x_size));
            end

            if any([isnan(y_size), isnan(x_size)])
                % todo: add index at least, for debugging
                error('One dimension must not be nan!')
            end

            tmprct = [zeros(2, size(x_size, 2)); [x_size; y_size]];
            if size(tmprct, 2) == 1
                tmprct = tmprct.';
            end
            % Manual hack for 4x4 rect array
            if all(size(tmprct) == 4)
                [cx, cy] = RectCenter(tmprct);
                tmprct([1, 3], :) = tmprct([1, 3], :) + (reference_rect(3) - reference_rect(1)) - cx;
                tmprct([2, 4], :) = tmprct([2, 4], :) + (reference_rect(4) - reference_rect(2)) - cy;
                self.drawing_rect(:, indices) = tmprct;
            else
                self.drawing_rect(:, indices) = CenterRectOnPoint(tmprct, ...
                                             self.rel_x_pos(indices) * (reference_rect(3) - reference_rect(1)), ...
                                             self.rel_y_pos(indices) * (reference_rect(4) - reference_rect(2)));
            end
        end % end relativetorect
    end
end
