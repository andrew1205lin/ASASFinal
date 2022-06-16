function y_limited = limiter(y)
% a simple limiter
for i = 1 : length(y)
    if y(i) > 0.95
        y(i) = 0.95;
    end
    if y(i) < -0.95
        y(i) = -0.95;
    end
    if abs(y(i)) > 0.707
        y(i) = 0.7*y(i); % 80=0.5ms*16000frame/s attack
    end
end
y_limited = y;
end

