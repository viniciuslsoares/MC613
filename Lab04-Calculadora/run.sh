iverilog -o tb_calculadora tb_calculadora.v calculadora.v cb7s.v
./tb_calculadora

rm -f calculadora.out
./tb_calculadora > calculadora.out

echo "Veja a saida no arquivo calculadora.out"