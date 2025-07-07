function [x_final, n_iter] = Lib_fixed_point_ch2(g, x0, tol, max_iter, varargin)
% Fixed-point iteration 方法

if nargin<2,error('至少需要2個輸入參數'),end
if nargin<3|isempty(tol),tol=1e-6;end
if nargin<4|isempty(max_iter),max_iter=100;end

% 創建表格標題
fprintf('%-4s %-15s %-15s %-15s\n', 'n', 'xn', 'xn+1', 'error(%)');
fprintf('%-4s %-15s %-15s %-15s\n', '---', '---------------', '---------------', '---------------');

x = x0;
for n = 0 : max_iter
    x_new = g(x, varargin{:});
    error = (x_new - x) / x_new * 100;
    
    fprintf('%-4d %-15.12f %-15.12f %-15.12f%%\n', n, x, x_new, error);
    
    if abs(error) < tol * 100
        x_final = x_new;
        n_iter = n + 1;
        fprintf('\n收斂於第 %d 次迭代\n', n_iter);
        fprintf('最終結果: x = %.12f\n', x_final);
        return
    end
    
    x = x_new;
end

x_final = x;
n_iter = max_iter + 1;
fprintf('\n達到最大迭代次數 %d，未收斂\n', max_iter);
fprintf('最終結果: x = %.12f\n', x_final);
end 