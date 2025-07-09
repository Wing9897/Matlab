function [U_final, n_iter] = Lib_liebmann_accelerated_school(U0, max_iter)
    % Lib_liebmann_accelerated_school - 使用學校版加速 Liebmann 方法求解拉普拉斯方程
    % 迭代順序：從左下角到右上角
    % 輸入參數:
    %   U0 - 完整的初始網格矩陣（包含邊界條件和初始值）
    %   max_iter - 迭代次數
    
    U = U0;
    [m, n] = size(U);
    
    fprintf('學校版加速 Liebmann 方法求解拉普拉斯方程（左下至右上）\n');
    
    % 顯示初始矩陣
    fprintf('\n初始矩陣:\n');
    for i = 1:m
        for j = 1:n
            fprintf('%8.12f ', U(i,j));
        end
        fprintf('\n');
    end
    
    % 迭代求解
    for iter = 1:max_iter
        % 從左下角到右上角迭代（i 從大到小，j 從小到大）
        for i = m-1:-1:2
            for j = 2:n-1
                U(i,j) = 0.25 * (U(i-1,j) + U(i+1,j) + U(i,j-1) + U(i,j+1));
            end
        end
        
        % 顯示每次迭代的結果
        fprintf('\n第 %d 次迭代結果:\n', iter);
        for i = 1:m
            for j = 1:n
                fprintf('%8.12f ', U(i,j));
            end
            fprintf('\n');
        end
    end
    
    fprintf('\n完成 %d 次迭代\n', max_iter);
    
    U_final = U;
    n_iter = max_iter;
end 