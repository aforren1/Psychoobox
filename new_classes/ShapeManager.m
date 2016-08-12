classdef (Abstract) ShapeManager < TextureManager

    properties
        proto_pointers % References to Offscreen Windows containing shape prototypes.

        % Use isnan(fill_color) to do proper subsetting during `DrawTextures`
        fill_color % [3 x N] color of fill; if do not want to fill, add [3 x 1] NaN vector.
        frame_color % [3 x N] color of frame; if do not want to frame, add [3 x 1] NaN vector.
        fill_alpha % Alpha value of fill. Either scalar or [1 x N] vector.
        frame_alpha % Alpha value of frame. Either scalar or [1 x N] vector.

    end

    methods
        function self = ShapeManager()
            self.p.addParamValue('fill_color', [nan nan nan], @(x) isnan(x) || isnumeric(x));
            self.p.addParamValue('frame_color', [nan nan nan], @(x) isnan(x) || isnumeric(x));
            self.p.addParamValue('fill_alpha', 1, @(x) x >= 0 && x <= 1);
            self.p.addParamValue('frame_alpha', 1, @(x) x >= 0 && x <= 1);
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

        end
    end
end
