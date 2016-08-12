classdef (Abstract) ShapeManager < TextureManager

    properties
        proto_pointers % References to Offscreen Windows containing shape prototypes.

        % Use isnan(fill_color) to do proper subsetting during `DrawTextures`
        fill_color % [3 x N] color of fill; if do not want to fill, add [3 x 1] NaN vector.
        frame_color % [3 x N] color of frame; if do not want to frame, add [3 x 1] NaN vector.
        fill_alpha % Alpha value of fill. Either scalar or [1 x N] vector.
        frame_alpha % Alpha value of frame. Either scalar or [1 x N] vector.
        frame_stroke

    end

    methods
        function self = ShapeManager()
            self@TextureManager;
            self.p.addParamValue('fill_color', [nan nan nan], @(x) all(all(isnan(x(:, isnan(x(1,:)))))) && all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('frame_color', [nan nan nan], @(x) all(all(isnan(x(:, isnan(x(1,:)))))) && all(all(~isnan(x(:, ~isnan(x(1,:)))))));
            self.p.addParamValue('fill_alpha', 1, @(x) all(x >= 0) && all(x <= 1));
            self.p.addParamValue('frame_alpha', 1, @(x) all(x >= 0) && all(x <= 1));
            self.p.addParamValue('frame_stroke', 10, @(x) all(x >= 0));
        end

        function Prime(self, win_pointer, indices)
            Prime@TextureManager(self, win_pointer, indices);

            if isempty(self.proto_pointers)
                self.proto_pointers(1) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 512 512]);
                self.proto_pointers(2) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 512 512]);
                % Draw shapes here (eg. Fill*)
            end
        end

        function Draw(self, win_pointer, indices)
        % need to do logical subsetting about whether frame or fill
        % are nan, then build up combinations of matrices that work
        % properly
        valid_fill = ~isnan(self.fill_color(1, indices));
        valid_frame = ~isnan(self.frame_color(1,  indices));
        shape_ptrs = [repmat(self.proto_pointers(1), 1, sum(valid_fill)), ...
                      repmat(self.proto_pointers(2), 1, sum(valid_frame))];

        Screen('DrawTextures', win_pointer, ...
               shape_ptrs, [], ... % TODO: hash out source_rect
               [self.temp_rect(:, valid_fill), self.temp_rect(:, valid_frame)],... % destinationRect
               [self.rotation_angle(valid_fill), self.rotation_angle(valid_frame)], ...
               [self.filter_mode(valid_fill), self.filter_mode(valid_frame)], ...
               [self.fill_alpha(valid_fill), self.frame_alpha(valid_frame)], ...
               [self.fill_color(:, valid_fill), self.frame_color(:, valid_frame)], ...
               [], ...
               [], []); %TODO: Handle special flags and aux parameters properly
        end
    end
end
