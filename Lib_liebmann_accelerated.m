function [U_final, n_iter] = Lib_liebmann_accelerated(U0, max_iter)
    % Lib_liebmann_accelerated - 使用加速 Liebmann 方法求解拉普拉斯方程
    % 输入参数:
    %   U0 - 完整的初始网格矩阵（包含边界条件和初始值）
    %   max_iter - 迭代次数
    
    U = U0;
    [m, n] = size(U);
    
    fprintf('加速 Liebmann 方法求解拉普拉斯方程\n');
    
    % 显示初始矩阵
    fprintf('\n初始矩阵:\n');
    for i = 1:m
        for j = 1:n
            fprintf('%8.12f ', U(i,j));
        end
        fprintf('\n');
    end
    
    % 迭代求解
    for iter = 1:max_iter
        % 使用已更新的新值和未更新的旧值（左下至右上）
        for i = m-1:-1:2
            for j = 2:n-1
                U(i,j) = 0.25 * (U(i-1,j) + U(i+1,j) + U(i,j-1) + U(i,j+1));
            end
        end
        
        % 显示每次迭代的结果
        fprintf('\n第 %d 次迭代结果:\n', iter);
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