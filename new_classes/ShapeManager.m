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
        function self = ShapeManager(varargin)

        end

        function Add(varargin)

        end

        function Prime()
