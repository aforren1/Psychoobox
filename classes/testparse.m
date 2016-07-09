function p = testparse(req1, req2, varargin);
    p = inputParser;
    p.FunctionName = 'PsychScreen';
    p.addRequired('req1', @(x) isnumeric(x));
    p.addRequired('req2', @(x) isnumeric(x));
    p.addParamValue('color', 'f', @(x) ischar(x));
    p.addParamValue('shape', true, @(x) islogical(x));
    p.addParamValue('size', 3, @(x) isnumeric(x));
    p.parse(req1, req2, varargin{:});
end
