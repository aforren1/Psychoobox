classdef (Abstract) ShapeManager < TextureManager
    properties
        proto_pointers
        fill_array
        frame_array
    end
    methods
        function self = ShapeManager()
            self.p.addParamValue('fill_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('frame_color', [], @(x) isempty(x) || isnumeric(x));
            self.p.addParamValue('pen_width', 1, @(x) x >= 0);
            self.proto_pointers = [];
            self.fill_array = self.obj_array;
            self.frame_array = self.fill_array;
            self.obj_array = [];
            self.fill_array.color = [];
            self.frame_array.color = [];

        end

        function Add(self, indices, varargin)
        % Need to just distribute *_color appropriately
        % (and send duplicate settings appropriately)
        end

        function Prime(self, win_pointer, indices)
            Prime@TextureManager(self, win_pointer, indices);
            % check if only fill, only outline, or both
            % How to handle missing??
            if isempty(self.proto_pointers)
                self.proto_pointers(1) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 800 800]);
                self.proto_pointers(2) = Screen('OpenOffscreenWindow', win_pointer,...
                                                [0 0 0 0], [0 0 800 800]);
            end

            %
        end

        function Set(self, indices, varargin)
        % need to set the components on each sub array

        end
    end
end
