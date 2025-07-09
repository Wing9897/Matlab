function [U_final, n_iter] = Lib_liebmann(U0, max_iter)
    % Lib_liebmann - 使用 Liebmann 方法求解拉普拉斯方程
    % 輸入參數:
    %   U0 - 完整的初始網格矩陣（包含邊界條件和初始值）
    %   max_iter - 迭代次數
    
    U = U0;
    [m, n] = size(U);
    
    fprintf('Liebmann 方法求解拉普拉斯方程\n');
    
    % 顯示初始矩陣
    fprintf('\n初始矩陣:\n');
    for i = 1:m
        for j = 1:n
            fprintf('%8.8f ', U(i,j));
        end
        fprintf('\n');
    end
    
    % 迭代求解
    for iter = 1:max_iter
        % 保存舊值
        U_old = U;
        
        % 使用舊值更新所有內部節點（左下至右上）
        for i = m-1:-1:2
            for j = 2:n-1
                U(i,j) = 0.25 * (U_old(i-1,j) + U_old(i+1,j) + U_old(i,j-1) + U_old(i,j+1));
            end
        end
        
        % 顯示每次迭代的結果
        fprintf('\n第 %d 次迭代結果:\n', iter);
        for i = 1:m
            for j = 1:n
                fprintf('%8.8f ', U(i,j));
            end
            fprintf('\n');
        end
    end
    
    fprintf('\n完成 %d 次迭代\n', max_iter);
    
    U_final = U;
    n_iter = max_iter;
end