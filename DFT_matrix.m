x = load('input.mat')
N= 4
function D = constructDFTMatrix(N)
    % Construct the DFT matrix of size N x N
    D = zeros(N, N); % Initialize an N x N matrix
    for n = 0:N-1
        for k = 0:N-1
            D(n+1, k+1) = exp(1j * 2 * pi * k * n / N);
        end
    end
end
D = constructDFTMatrix(N);
disp(D)
N=4;
orthogonality_check = zeros(N, N);
for i = 1:N
    for j = 1:N
        orthogonality_check(i, j) = sum(D(:, i) .* conj(D(:, j)));
end end
% Display result
disp('Orthogonality matrix:');
disp(orthogonality_check);
I=eye(4);
a1 = abs(D*D')
b1 = 4*I
function X = DFT(x)
    N = length(x);
    D = constructDFTMatrix(N);
    X = (1/sqrt(N)) * D' * x; % Analysis equation for DFT
end
function x = IDFT(X)
    N = length(X);
    D = constructDFTMatrix(N);
    x = (1/sqrt(N)) * D * X; % Synthesis equation for IDFT
end
N = 8;
x = randn(N, 1); % Generate a random sequence
X = DFT(x); % Compute the DFT of the sequence
m = 2; % Define the shift
x_shifted = circshift(x, -m); % Circularly shift the sequence
X_shifted = DFT(x_shifted); % Compute the DFT of the shifted sequence
% Check the circular shift property
   1
   k = (0:N-1)';
X_theoretical = exp(-1j * 2 * pi * k * m / N) .* X; % Expected result
disp('DFT of circularly shifted sequence:');
disp(X_shifted);
disp('Theoretical DFT result after circular shift:');
disp(X_theoretical);
load('eeg-realseq.mat'); % Load the real EEG signal
X = DFT(n); % Compute DFT of real sequence
% Verify symmetry property
symmetry_check = abs(X - conj(flipud(X))); % X(K) should equal X*(N-K)
disp('Symmetry check (should be close to zero):');
disp(symmetry_check(1:min(5, length(symmetry_check))));
X_even = (X + flipud(X)) / 2; % Compute even component
X_odd = (X - flipud(X)) / 2;  % Compute odd component
% Verify that DFT of even component is real and odd component is imaginary
disp('Check if DFT of even component is real:');
disp(isreal(X_even));
disp('Check if DFT of odd component is imaginary:');
disp(isreal(1i*X_odd)); % This should be true if the odd part is imaginary
abs
