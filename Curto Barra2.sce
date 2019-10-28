

vf = 1; // Tensão pre falta
barra = 4; // Barra onde ocorre o curto
nb = 4;

T = [1 1 1; 1 (-0.5-0.866025403784*%i) (-0.5+0.866025403784*%i); 1 (-0.5+0.866025403784*%i) (-0.5-0.866025403784*%i)];
zth1 = [(0.011 + %i*0.1141);0;0;0];
zth0 = [(%i*0.4201);0;0;0];

//Matriz de Impedâncias de Sequencia Positiva 
z1 = zeros(4,4);
//z1(1,1) = (0.011 + %i*0.1141); // Zth1
z1(1,2) = (0.3406 + %i*0.826);
z1(1,4) = (0.2128 + %i*0.516);
z1(2,1) = z1(1,2);
z1(2,3) = (0.2923 + %i*0.247);
z1(3,2) = z1(2,3);
z1(3,4) = (0.1996 + %i*0.484);
z1(4,1) = z1(1,4);
z1(4,3) = z1(3,4);
//z1(4,4) = (%i*1.31);

//Matriz de Impedâncias de Sequencia Zero
z0 = zeros(4,4);
//z0(1,1) = (%i*0.4201); //Zth0
z0(1,2) = (0.6591 + %i*3.069);
z0(1,4) = (0.4118 + %i*1.918);
z0(2,1) = z0(1,2);
z0(2,3) = (0.3669 + %i*0.7731);
z0(3,2) = z0(2,3);
z0(3,4) = (0.3863 + %i*1.799);
z0(4,1) = z0(1,4);
z0(4,3) = z0(3,4);

yb11 = zeros(4,4);
for i =1 :nb
    for j=1:nb
        if(z1(i,j)<>0)
            yb11(i,j) = -1/z1(i,j);
        end     
    end   
    if(zth1(i)<>0)
        yb11(i,i)= -1*sum(yb11(i,:)) +1/zth1(i);
    else
         yb11(i,i)= -1*sum(yb11(i,:));
    end  
end

yb00= zeros(4,4);
for i =1 :nb
    for j=1:nb
        if(z0(i,j)<>0)
            yb00(i,j) = -1/z0(i,j);
        end     
    end   
    if(zth0(i)<>0)
        yb00(i,i)= -1*sum(yb00(i,:)) +1/zth0(i);
    else
         yb00(i,i)= -1*sum(yb00(i,:));
    end  
end


zb11 = yb11^(-1);
zb00 = yb00^(-1);

//Correntes de Curto Monofásico
i1f1 = vf/(zb00(barra,barra) + 2*zb11(barra,barra));
i1f2 = i1f1;
i1f0 = i1f1;

//Corentes de Curto Bifásico(Fase-Fase)
i2f1 = vf/(2*zb11(barra,barra));
i2f2 = -i2f1;
i2f0 = 0;

//Correntes de Curto Trifásico
i3f1 = vf/zb11(barra,barra);
i3f2 = 0;
i3f0 = 0;


vbm = zeros(3,4);
vbb =zeros(3,4);
vbt =zeros(3,4);
 
for i =1 :3 //sequencias
    for j=1:nb //barras
        if(i==1) //sequencia zero
            vbm(i,j) = -zb00(j,barra)*i1f0;
        end
        if(i==2) //sequencia positiva
            vbt(i,j) = vf-zb11(j,barra)*i3f1;
            vbb(i,j) = vf-zb11(j,barra)*i2f1;
            vbm (i,j)= vf-zb00(j,barra)*i1f1;
        end
        if(i==3) //sequencia negativa
            vbm(i,j) = -zb00(j,barra)*i1f2;
            vbb(i,j) = -zb11(j,barra)*i2f2;
        end    
    end   
end

ilm0 = zeros(4,4);
ilm1 = zeros(4,4);
ilm2 = zeros(4,4);

ilb0 =zeros(4,4);
ilb1 =zeros(4,4);
ilb2 =zeros(4,4);

ilt0 =zeros(4,4);
ilt1 =zeros(4,4);
ilt2 =zeros(4,4);


for i =1 :nb
    for j=1:nb
        if(z0(i,j)<>0)
            ilm0(i,j) = (vbm(1,j) - vbm(1,i))/z0(i,j);
            ilm1(i,j) = (vbm(2,j) - vbm(2,i))/z0(i,j);
            ilm2(i,j) = (vbm(3,j) - vbm(3,i))/z0(i,j);
         end
        if(z1(i,j)<>0)           
            ilb1(i,j) = (vbm(2,j) - vbm(2,i))/z1(i,j);
            ilb2(i,j) = (vbm(3,j) - vbm(3,i))/z1(i,j);
            
            ilt1(i,j) = (vbm(2,j) - vbm(2,i))/z1(i,j);
        end        
    end   
end






