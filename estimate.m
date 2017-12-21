function S = estimate(Y, type, Cw, mic, mt, Ct)
    a = ones(1,mic);
    P = permute(Y, [3 1 2]);
    
    for j = 1:size(Y,2)
        Z = P(:,:,j);
        switch(type)
            case 1
                % BLUE / WLS /MLE
                B = (a*inv(Cw)*Z)/(a*inv(Cw)*a');
            case 2
                % LS
                B = pinv(a)'*Z;
            case 3
                % LMMSE / MAP
                mu = mt(j)*ones(1,size(Y,1));
                C = a'*Ct(j)*a + Cw;
                B = mu + Ct(j)*a*inv(C)*(Z - a'*mu);
        end
        S(:, j) = B.';
    end   
    
end