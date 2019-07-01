clear; close all force; clc;
%% Informações da base
% Base retirada do repositório UCI datasets, pode ser encontrada no link :
% <https://archive.ics.uci.edu/ml/datasets/Computer+Hardware>.
% Informações Gerais : Dados Relativos de Desempenho de CPUs de 30 fabricantes.
% 1. Nome: Dados relativos de desempenho da CPU
% 2. Data: 01/10/1987
% 3. 209 amostras com 6 atributos previsores, sendo ...
%   - MYCT: Tempo de ciclo em ns (inteiro)
%   - MMIN: Mínimo de memória principal utilizada em KB (inteiro)
%   - MMAX: Máximo de memória principal utilizada em KB (inteiro)
%   - CACH: Memória cache em KB (inteiro)
%   - CHMIN: Mínimo de canais em unidades (inteiro)
%   - CHMAX: Máximo de canais em unidades (inteiro)
% 4. 1 atributo objetivo, sendo ...
%   - PRP: Performance relativa publicada (inteiro)
% 5. Há também um atributo já estimado pelos autores pela regressão linear.
%   - ERP: Performance relativa estimada (inteiro)
% Este último irei usar apenas como forma de comparação de meus resultados com os dos autores da base.
attrb = ["MYCT", "MMIN", "MMAX", "CACH", "CHMIN", "CHMAX"];
goal = "PRP";

%% Importação da base
data = importdata('machine.data');
data = data.data;
x1 = data(:, 1);
x2 = data(:, 2);
x3 = data(:, 3);
x4 = data(:, 4);
x5 = data(:, 5);
x6 = data(:, 6);
y = data(:, 7);
ERP = data(:, 8);

%% Regressão múltipla feita com regressões lineares simples, com cada entrada sozinha
for i = 1:length(attrb)
    % Regressão linear simples
    x = data(:, i);
    X = [ones(size(data, 1), 1), x];
    B = pinv(X) * y;
%     B = (((X.' * X)^(-1)) * X.') * y; % Cálculo equivalente

    % Cálculo do R2 da regressão linear simples
    Y = X * B;
    [R2, R2aj] = R2_R2aj(X, y, Y);
    
    % Plot
    figure, plot(x, y, 'bo', x, Y, '-r', 'LineWidth', 2);
    title("RL simples para a " + i + "^{a} entrada, R^{2} = " + R2 + " e R_{aj}^{2} = " + R2aj);
    xlabel(attrb(i));
    ylabel(goal)
    legend('Amostras', 'Regressão linear simples');
end

%% Regressão linear múltipla
X = [ones(size(x1, 1), 1), x1, x2, x3, x4, x5, x6];
B = pinv(X) * y;
Y = X * B;

%% Cálculo do R2 e R2aj da regressão linear múltipla
[R2, R2aj] = R2_R2aj(X, y, Y);

fprintf('R2 e R2 ajustado da minha regressão linear múltipla.\n');
fprintf(' - R2 = %f\n', R2);
fprintf(' - R2aj = %f\n', R2aj);

%% R2 dos valores estimados pelos autores da base para comparação
RSS = sum((y - ERP) .^ 2);
TSS = sum((y - mean(y)) .^ 2);
R2 = 1 - (RSS / TSS);
fprintf('R2 dos valores estimados pelos autores da base.\n');
fprintf(' - R2 = %f\n', R2);
% Acredito que, o R2 dos valores estimados pelos autores esteja melhor,
% pois os mesmos podem ter usados mais dados ou algum pré-processamento.
