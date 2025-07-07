function [f_forward, f_backward, f_center, f_exact, err_forward, err_backward, err_center] = Lib_diff_ch1(f, df, h, x)
% 計算數值導數並比較真實導數

    % 使用各種差分方法計算導數
    f_forward = forwardDifference(f, x, h);
    f_backward = backwardDifference(f, x, h);
    f_center = centerDifference(f, x, h);
    
    % 計算真實導數
    f_exact = df(x);
    
    % 計算相對誤差（百分比）
    err_forward = relativeError(f_forward, f_exact);
    err_backward = relativeError(f_backward, f_exact);
    err_center = relativeError(f_center, f_exact);
    
    % 顯示結果
    fprintf('f(x) = %.8f\n', f(x));
    fprintf('f(x+h) = %.8f\n', f(x + h));
    fprintf('f(x-h) = %.8f\n', f(x - h));
    fprintf('前向差分導數: %.8f, 相對誤差: %.4f%%\n', f_forward, err_forward);
    fprintf('後向差分導數: %.8f, 相對誤差: %.4f%%\n', f_backward, err_backward);
    fprintf('中心差分導數: %.8f, 相對誤差: %.4f%%\n', f_center, err_center);
    fprintf('真實導數: %.8f\n', f_exact);
end

function df = forwardDifference(f, x, h)
% 前向差分: f'(x) ≈ (f(x+h) - f(x)) / h

    df = (f(x + h) - f(x)) / h;
end

function df = backwardDifference(f, x, h)
% 後向差分: f'(x) ≈ (f(x) - f(x-h)) / h

    df = (f(x) - f(x - h)) / h;
end

function df = centerDifference(f, x, h)
% 中心差分: f'(x) ≈ (f(x+h) - f(x-h)) / (2h)

    df = (f(x + h) - f(x - h)) / (2 * h);
end

function rel_err = relativeError(approx, exact)
% 相對誤差: (approx - exact) / exact × 100%

    rel_err = ( exact - approx ) / exact * 100;
end