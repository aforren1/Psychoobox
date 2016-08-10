function out_rect = RelativeToRect(rel_x_pos, rel_y_pos, ...
                                   rel_x_scale, rel_y_scale, ...
                                   reference_rect)

    if any([isempty(rel_x_pos), isempty(rel_y_pos)])
       error('Must specify either rel_x_pos and rel_y_pos or rect.')
    end

    if all([isempty(rel_x_scale), isempty(rel_y_scale)])
       error('Must specify the scale of at least one dimension.')
    end

    if isempty(rel_x_scale)
       % assign dims from y
       y_size = rel_y_scale * (reference_rect(4) - reference_rect(2));
       x_size = y_size;
    elseif isempty(rel_y_scale)
       % assign dims from x
       x_size = rel_x_scale * (reference_rect(3) - reference_rect(1));
       y_size = x_size;
    else
       x_size = rel_x_scale * (reference_rect(3) - reference_rect(1));
       y_size = rel_y_scale * (reference_rect(4) - reference_rect(2));
    end
    tmprct = [zeros(2, size(x_size, 2)); [x_size; y_size]];
    if all(size(tmprct) == 4)
        [cx, cy] = RectCenter(tmprct);
        tmpx = rel_x_pos * (reference_rect(3) - reference_rect(1));
        tmpy = rel_y_pos * (reference_rect(4) - reference_rect(2));
        tmprct([1, 3], :) = tmprct([1, 3], :) + tmpx - cx;
        tmprct([2, 4], :) = tmprct([2, 4], :) + tmpy - cy;
        out_rect = tmprct;
    else
        out_rect = CenterRectOnPoint(tmprct, ...
                                     rel_x_pos * (reference_rect(3) - reference_rect(1)), ...
                                     rel_y_pos * (reference_rect(4) - reference_rect(2)));
    end
end
