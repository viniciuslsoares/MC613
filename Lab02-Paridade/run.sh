iverilog -o tb_paridade tb_paridade.v calcula_paridade.v verifica_paridade.v injetor.v
rm -f paridade.out
cp teste$1.txt teste.txt
./tb_paridade > paridade.out
cp paridade.out paridade$1.out

if diff paridade$1.out paridade$1.ok >/dev/null; then
    echo "OK"
    exit 0
else
    echo "ERRO"
    exit 1
fi
