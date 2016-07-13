classdef PsychTexture < PsychHandle
% PsychTexture Draw an image.
%
% PsychTexture Properties:
%
    properties (SetAccess = public, GetAccess = public)
        pointer;
        optimize_for_draw_angle;
        float_precision;
        texture_orientation;
        texture_shader;
        try_gl_texture_2d;
    end

    methods
        function self = PsychTexture(image_matrix, varargin)
        end

        function Draw(self, pointer)
        end
    end
end



    %textureIndex=Screen('MakeTexture', WindowIndex, imageMatrix [, optimizeForDrawAngle=0] [, specialFlags=0] [, floatprecision=0] [, textureOrientation=0] [, textureShader=0]);
 %textureIndex=Screen('MakeTexture', WindowIndex, imageMatrix [, optimizeForDrawAngle=0] [, specialFlags=0] [, floatprecision=0] [, textureOrientation=0] [, textureShader=0]);
