function testparse(varargin)
    p = inputParser;
    p.addParamValue('val1', 0);
    p.addParamValue('val2', 2);
    p.parse(varargin{:});
    disp(p)
end
