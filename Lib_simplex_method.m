function [optimal_solution, optimal_value, iterations] = Lib_simplex_method(varargin)
    % Lib_simplex_method - 使用單純形法求解線性規劃問題
    % 
    % 調用方式1（簡化版）:
    %   [solution, value, iter] = Lib_simplex_method(c, A, b)
    %   c - 目標函數係數向量，例如 [15, 12] 表示 max Z = 15x1 + 12x2
    %   A - 約束條件係數矩陣，例如 [1, 2; 2, -1] 表示 x1+2x2≤?, 2x1-x2≤?
    %   b - 約束條件右邊常數，例如 [15; 20] 表示 ≤15, ≤20
    %
    % 調用方式2（進階版）:
    %   [solution, value, iter] = Lib_simplex_method(initial_tableau, objective_coeffs)
    %   [solution, value, iter] = Lib_simplex_method(initial_tableau, objective_coeffs, basic_vars)
    %   initial_tableau - 初始單純形表（不包含Z行）
    %   objective_coeffs - 目標函數係數向量 [c1, c2, ..., cn]
    %   basic_vars - 基本變數的索引向量（可選，如果不提供則自動推導）
    %
    % 輸出參數:
    %   optimal_solution - 最優解
    %   optimal_value - 最優值
    %   iterations - 迭代次數
    
    % 判斷調用方式
    if nargin == 3 && isvector(varargin{1}) && ismatrix(varargin{2}) && isvector(varargin{3})
        % 簡化版調用: Lib_simplex_method(c, A, b)
        c = varargin{1}(:)';  % 確保是行向量
        A = varargin{2};
        b = varargin{3}(:);   % 確保是列向量
        
        % 顯示問題描述
        fprintf('=== 單純形法求解 ===\n');
        fprintf('目標函數: max Z = ');
        for i = 1:length(c)
            if i == 1
                fprintf('%.0fx%d', c(i), i);
            else
                if c(i) >= 0
                    fprintf(' + %.0fx%d', c(i), i);
                else
                    fprintf(' - %.0fx%d', abs(c(i)), i);
                end
            end
        end
        fprintf('\n');
        
        fprintf('約束條件:\n');
        for i = 1:size(A, 1)
            fprintf('  ');
            for j = 1:size(A, 2)
                if j == 1
                    fprintf('%.0fx%d', A(i,j), j);
                else
                    if A(i,j) >= 0
                        fprintf(' + %.0fx%d', A(i,j), j);
                    else
                        fprintf(' - %.0fx%d', abs(A(i,j)), j);
                    end
                end
            end
            fprintf(' <= %.0f\n', b(i));
        end
        fprintf('  x1, x2, ... >= 0\n');
        
        % 自動構建初始單純形表
        [m, n] = size(A);
        initial_tableau = [A, eye(m), b];
        objective_coeffs = c;
        basic_vars = (n+1):(n+m);  % slack變數的索引
        
    else
        % 進階版調用: Lib_simplex_method(initial_tableau, objective_coeffs, [basic_vars])
        initial_tableau = varargin{1};
        objective_coeffs = varargin{2};
        
        if nargin >= 3
            basic_vars = varargin{3};
        else
            basic_vars = auto_detect_basic_vars(initial_tableau);
        end
    end
    
    % 獲取矩陣維度
    [m, n] = size(initial_tableau);
    
    % 構建完整的單純形表（包含Z行）
    tableau = zeros(m+1, n);
    tableau(1:m, :) = initial_tableau;
    
    % 計算Z行
    for j = 1:n-1  % 不包括RHS列
        z_value = 0;
        for i = 1:m
            if basic_vars(i) <= length(objective_coeffs)
                z_value = z_value + objective_coeffs(basic_vars(i)) * tableau(i, j);
            end
        end
        if j <= length(objective_coeffs)
            tableau(m+1, j) = z_value - objective_coeffs(j);
        else
            tableau(m+1, j) = z_value;
        end
    end
    
    % 計算Z行的RHS（目標函數值）
    z_rhs = 0;
    for i = 1:m
        if basic_vars(i) <= length(objective_coeffs)
            z_rhs = z_rhs + objective_coeffs(basic_vars(i)) * tableau(i, n);
        end
    end
    tableau(m+1, n) = z_rhs;
    
    iteration = 0;
    
    while true
        iteration = iteration + 1;
        fprintf('\n=== 第 %d 次迭代 ===\n', iteration);
        
        % 檢查是否達到最優解
        z_row = tableau(m+1, 1:n-1);
        if all(z_row >= 0)
            display_tableau(tableau, basic_vars, 0);
            break;
        end
        
        % 找到entering變數（最負的Z行元素）
        [min_val, entering_col] = min(z_row);
        
        % 檢查是否無界
        entering_column = tableau(1:m, entering_col);
        if all(entering_column <= 0)
            fprintf('問題無界！\n');
            optimal_solution = [];
            optimal_value = inf;
            iterations = iteration;
            return;
        end
        
        % 顯示帶有ratio的當前表格
        display_tableau(tableau, basic_vars, entering_col);
        
        % 計算ratio並找到leaving變數
        min_ratio = inf;
        leaving_row = -1;
        
        for i = 1:m
            if tableau(i, entering_col) > 0
                ratio = tableau(i, n) / tableau(i, entering_col);
                if ratio < min_ratio
                    min_ratio = ratio;
                    leaving_row = i;
                end
            end
        end
        
        if leaving_row == -1
            fprintf('無法找到leaving變數！\n');
            break;
        end
        
        fprintf('Entering: 第%d列, Leaving: 第%d行\n', entering_col, leaving_row);
        
        % 更新基本變數
        basic_vars(leaving_row) = entering_col;
        
        % 進行pivoting操作
        pivot_element = tableau(leaving_row, entering_col);
        
        % 將pivot行標準化
        tableau(leaving_row, :) = tableau(leaving_row, :) / pivot_element;
        
        % 消除其他行的entering列
        for i = 1:m+1
            if i ~= leaving_row && tableau(i, entering_col) ~= 0
                multiplier = tableau(i, entering_col);
                tableau(i, :) = tableau(i, :) - multiplier * tableau(leaving_row, :);
            end
        end

    end
    
    % 提取最優解
    optimal_solution = zeros(length(objective_coeffs), 1);
    for i = 1:m
        if basic_vars(i) <= length(objective_coeffs)
            optimal_solution(basic_vars(i)) = tableau(i, n);
        end
    end
    
    optimal_value = tableau(m+1, n);
    iterations = iteration;
    
    % 對簡化版調用顯示最終結果
    if nargin == 3 && isvector(varargin{1})
        fprintf('\n=== 最終結果 ===\n');
        fprintf('最優解: ');
        for i = 1:length(optimal_solution)
            fprintf('x%d=%.4f ', i, optimal_solution(i));
        end
        fprintf('\n最優值: %.4f\n', optimal_value);
    end
end

function display_tableau(tableau, basic_vars, entering_col)
    % 顯示單純形表的輔助函數
    [m, n] = size(tableau);
    
    % 列標題
    fprintf('%-8s', 'Basic');
    for j = 1:n-1
        if j <= 2
            fprintf('%-8s', sprintf('x%d', j));
        else
            fprintf('%-8s', sprintf('S%d', j-2));
        end
    end
    fprintf('%-8s', 'RHS');
    if entering_col >= 0
        fprintf('%-8s', 'Ratio');
    end
    fprintf('\n');
    
    % 約束行
    for i = 1:m-1
        if basic_vars(i) <= 2
            fprintf('%-8s', sprintf('x%d', basic_vars(i)));
        else
            fprintf('%-8s', sprintf('S%d', basic_vars(i)-2));
        end
        for j = 1:n
            fprintf('%-8.4f', tableau(i, j));
        end
        
        % 計算並顯示ratio
        if entering_col >= 0
            if entering_col > 0
                % 迭代過程中，顯示相對於entering變數的ratio（允許負數）
                if tableau(i, entering_col) ~= 0
                    ratio = tableau(i, n) / tableau(i, entering_col);
                    fprintf('%-8.4f', ratio);
                else
                    fprintf('%-8s', '-');
                end
            else
                % 最終迭代時，顯示所有可能的ratio值（以第一個變數為基準）
                if tableau(i, 1) ~= 0
                    ratio = tableau(i, n) / tableau(i, 1);
                    fprintf('%-8.4f', ratio);
                else
                    % 如果第一列為0，嘗試其他列
                    found_ratio = false;
                    for j = 2:n-1
                        if tableau(i, j) ~= 0
                            ratio = tableau(i, n) / tableau(i, j);
                            fprintf('%-8.4f', ratio);
                            found_ratio = true;
                            break;
                        end
                    end
                    if ~found_ratio
                        fprintf('%-8.4f', tableau(i, n));
                    end
                end
            end
        end
        fprintf('\n');
    end
    
    % Z行
    fprintf('%-8s', 'Z');
    for j = 1:n
        fprintf('%-8.4f', tableau(m, j));
    end
    if entering_col >= 0
        fprintf('%-8s', '-');
    end
    fprintf('\n');
end

function basic_vars = auto_detect_basic_vars(tableau)
    % 自動檢測基本變數
    % 通過尋找單位矩陣的列來確定基本變數
    
    [m, n] = size(tableau);
    basic_vars = zeros(m, 1);
    
    % 對每一行，找到對應的基本變數
    for i = 1:m
        for j = 1:n-1  % 不包括RHS列
            % 檢查是否為單位向量
            if tableau(i, j) == 1
                % 檢查該列的其他元素是否都為0
                column = tableau(:, j);
                if sum(column == 0) == m-1 && sum(column == 1) == 1
                    basic_vars(i) = j;
                    break;
                end
            end
        end
    end
end 