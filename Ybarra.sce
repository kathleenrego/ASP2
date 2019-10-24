clear
clc

//TRABALHO ASP 2 - Segunda unidade- CÁLCULO DE CURTO CIRCUITO
// AUTORES: 
//Bruno Matias de Sousa
//Kathleen Noemi Duarte Rego


//Calculo do Ybarra

funcprot(0);
function[Y]= ybarra(Zshunt,Z, NB)
    for i = 1:NB
        if Zshunt(i) ~= 0.0
            Y(i,i) = (Zshunt(i))^-1
        else
            Y(i,i) = 0.0
        end
        
        for j = 1:NB
            if abs(Z(i,j)) ~= 0
               Y(i,j) = (-1)*Z(i,j)^-1 
               Y(i,i) = Y(i,i) - Y(i,j)      
            end 
             
        end
    end
endfunction
function[V]= vfalta(Zb,Icc,seq, NB)
    if(seq == 1)
        for i = 1:NB
            V(i,1) = 1 - Zb(i,NB)*Icc(seq+1,1)
        end
    else
       for i = 1:NB
            V(i,1) = -(Zb(i,NB)*Icc(seq+1,1))
        end
    end
endfunction
function[I]= ilinha(Vf,Z, NB)
    for i = 1:NB
         for j = 1:NB
              if  (Z(i,j)) ~= 0.0
                  I(i,j) = ((Vf(i)-Vf(j)) / Z(i,j));
              end
         end
    end
endfunction
function[x]= toreal(x1,tipo)
    //Tipo0 - Corrente
    //Tipo1 - Tensão
    sbase = 100E6;
    vbase = 69E3;
    ibase = sbase/vbase;
    if(tipo == 0)
        x = x1*ibase;
    else
        x = x1*vbase;
    end
endfunction
function[p]= topolar(k)
    for i = 1:size(k, "r")
        for j = 1:size(k, "c")
            m = abs(k(i,j));
            angle = atand(imag(k(i,j)),real(k(i,j)));
            p(i,j) = strcat([string(m)," < ",string(angle), "°"]);       
        end
    end
endfunction
//CURTO NA BARRA 4
NB1 = 4
NB0 = 4
//CURTO NA BARRA DEPOIS DO TRANSFORMADOR
//NB1 = 5

Z1=zeros(NB1,NB1)
Z0=zeros(NB0,NB0)
Zshunt0 = zeros(NB0,1)
Zshunt1 = zeros(NB1,1)
//Sequencia +/-:

Z1(1,2) = 0.3406 + %i* 0.8261
Z1(2,1) = Z1(1,2)
Z1(1,4) = 0.2128 + %i* 0.5162
Z1(4,1) = Z1(1,4)
Z1(2,3) = 0.2923 + %i* 0.2472
Z1(3,2) = Z1(2,3)
Z1(3,4) = 0.1996 + %i* 0.4842
Z1(4,3) = Z1(3,4)

// PARTE ADICIONAL PARA SEGUNDA PARTE DA ATIVIDADE
//Z1(4,5) = %i*1.312
//Z1(5,4) = Z1(4,5)


//Sequencia 0:

Z0(1,2) = 0.6591 + %i* 3.0692
Z0(2,1) = Z0(1,2)
Z0(1,4) = 0.4118 + %i* 1.9178
Z0(4,1) = Z0(1,4)
Z0(2,3) = 0.3669 + %i* 0.7731
Z0(3,2) = Z0(2,3)
Z0(3,4) = 0.3863 + %i* 1.7991
Z0(4,3) = Z0(3,4)

//Impedancias Shunt

//Zth:
Zshunt0(1) = %i*0.4201
Zshunt1(1) = 0.011+%i*0.114

//CALCULO DE MATRIZES
//Calculo Ybarra1
Ybarra1 = ybarra(Zshunt1,Z1,NB1);
//Calculo do Zbarra
Zbarra1 = inv(Ybarra1);

//Calculo Ybarra0
Ybarra0 = ybarra(Zshunt0,Z0,NB0);
//Calculo do Zbarra
Zbarra0 = inv(Ybarra0);

//CURTO NA BARRA 4

//CALCULO DAS CORRENTES DE CURTO
//Corrente de curto trifásica
Icc3 = [0; 1/Zbarra1(4,4); 0];
// Corrente de curto Monofásica
Icc1b = 1/(2*Zbarra1(4,4)+Zbarra0(4,4));
Icc1 = [Icc1b; Icc1b; Icc1b];

// Corrente de curto Bifásica
Icc2b = 1/(2*Zbarra1(4,4));
Icc2 = [0; Icc2b; -Icc2b];

//Tensões Durante a falta

//SEQ 0 (Zbarra, Tipo da corrente, sequencia))
Vfalta01 = vfalta(Zbarra0, Icc1, 0, NB0);
Vfalta02 = vfalta(Zbarra0, Icc2, 0, NB0);
Vfalta03 = vfalta(Zbarra0, Icc3, 0, NB0);

//SEQ POSITIVA
Vfalta11 = vfalta(Zbarra1, Icc1, 1, NB1);
Vfalta12 = vfalta(Zbarra1, Icc2, 1, NB1);
Vfalta13 = vfalta(Zbarra1, Icc3, 1, NB1);

//SEQ NEGATIVA
Vfalta21 = vfalta(Zbarra1, Icc1, 2, NB1);
Vfalta22 = vfalta(Zbarra1, Icc2, 2, NB1);
Vfalta23 = vfalta(Zbarra1, Icc3, 2, NB1);

//Correntes de Linha durante a falta

//SEQ. 0
Ilinha01 = ilinha(Vfalta01,Z0, NB0);
Ilinha02 = ilinha(Vfalta02,Z0, NB0);
Ilinha03 = ilinha(Vfalta03,Z0, NB0);

//SEQ. POSITIVA
Ilinha11 = ilinha(Vfalta11,Z1, NB1);
Ilinha12 = ilinha(Vfalta12,Z1, NB1);
Ilinha13 = ilinha(Vfalta13,Z1, NB1);

//SEQ. NEGATIVA
Ilinha21 = ilinha(Vfalta21,Z1, NB1);
Ilinha22 = ilinha(Vfalta22,Z1, NB1);
Ilinha23 = ilinha(Vfalta22,Z1, NB1);

