function [x_new, y_new] = Lib_rk2_ch3(df, x0, y0, h, x_end, varargin)
% Second-Order Runge-Kutta method

if nargin<4,error('至少需要4個輸入參數'),end
if nargin<5|isempty(x_end),x_end=x0+h;end  % 默認只做一步

% 創建表格標題
fprintf('%-4s %-15s %-15s %-15s %-15s %-15s %-15s\n', 'i', 'x', 'y', 'k1', 'k2', 'x_new', 'y_new');
fprintf('%-4s %-15s %-15s %-15s %-15s %-15s %-15s\n', '---', '---------------', '---------------', '---------------', '---------------', '---------------', '---------------');

x = x0;
y = y0;
i = 1;

while x < x_end
    % 計算 k1, k2
    k1 = df(x, y, varargin{:});
    k2 = df(x + h, y + h*k1, varargin{:});
    
    % 計算 RK2 結果
    x_new_step = x + h;
    y_new_step = y + h * (k1 + k2) / 2;
    
    % 顯示計算過程
    fprintf('%-4d %-15.12f %-15.12f %-15.12f %-15.12f %-15.12f %-15.12f\n', i, x, y, k1, k2, x_new_step, y_new_step);
    
    % 更新值
    x = x_new_step;
    y = y_new_step;
    i = i + 1;
end

x_new = x;
y_new = y;

fprintf('\n最終結果:\n');
fprintf('x_final = %.12f\n', x_new);
fprintf('y_final = %.12f\n', y_new);
end 