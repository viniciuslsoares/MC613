iverilog -o tb_hamming tb_hamming.v calcula_hamming.v corrige_hamming.v injetor.v
rm -f hamming.out
cp teste$1.txt teste.txt
./tb_hamming > hamming.out
cp hamming.out hamming$1.out

if diff hamming$1.out hamming$1.ok >/dev/null; then
    echo "OK"
    exit 0
else
    echo "ERRO"
    exit 1
fi
