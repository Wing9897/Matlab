function Lib_displayLatexArray(varargin)
% DISPLAYLATEXARRAY 顯示多個符號函數於 LaTeX 陣列中
%   displayLatexArray(f1, f2, ..., fn) 接受多個符號函數作為輸入，
%   並以 LaTeX 陣列格式在圖形窗口中顯示。

    % 將輸入函數轉換為 LaTeX 字串
    latexStr = ['$\begin{array}{l}'];
    for i = 1:nargin
        latexStr = [latexStr latex(varargin{i})];
        if i < nargin
            latexStr = [latexStr '\\ '];
        end
    end
    latexStr = [latexStr '\end{array}$'];
    
    % 創建圖形窗口並顯示 LaTeX
    figure('Color', 'w');
    text(0, 1, latexStr, 'Interpreter', 'latex', 'FontSize', 16, ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    axis off;
end