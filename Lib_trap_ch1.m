function I = Lib_trap_ch1(func,a,b,n,varargin)%varargin is **arg
% 複合梯形法則數值積分

if nargin<3,error('至少需要3個輸入參數'),end
if ~(b>a),error('上限必須大於下限'),end
if nargin<4|isempty(n),n=100;end

x = a; 
h = (b - a)/n;
s = func(a,varargin{:});

% 創建表格標題
fprintf('%-4s %-8s %-15s %-15s %-15s\n', 'i', 'x', 'f(x)', '係數', 'sigma');
fprintf('%-4s %-8s %-15s %-15s %-15s\n', '---', '--------', '---------------', '---------------', '---------------');

% 左端點
fprintf('%-4d %-8.4f %-15.12f %-15s %-15.12f\n', 0, x, s, '1', s);

for i = 1 : n-1
    x = x + h;
    fx = func(x,varargin{:});
    s = s + 2*fx;
    fprintf('%-4d %-8.4f %-15.12f %-15s %-15.12f\n', i, x, fx, '2', s);
end

% 右端點
fx = func(b,varargin{:});
s = s + fx;
fprintf('%-4d %-8.4f %-15.12f %-15s %-15.12f\n', n , b, fx, '1', s);

I = (b - a) * s/(2*n);
fprintf('\n積分結果: I = %.12f\n', I);