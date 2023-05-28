#!/bin/bash

mkdir -p compiled images

# ############ Convert friendly and compile to openfst ############
for i in friendly/*.txt; do
	echo "Converting friendly: $i"
   python3 compact2fst.py  $i  > sources/$(basename $i ".formatoAmigo.txt").txt
done


# ############ convert words to openfst ############
for w in tests/*.str; do
	echo "Converting words: $w"
	./word2fst.py `cat $w` > tests/$(basename $w ".str").txt
done


# ############ Compile source transducers ############
for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

# ############ CORE OF THE PROJECT  ############

echo "Implementation of the transducer metaphoneLN"

fstcompose compiled/step1.fst compiled/step2.fst > compiled/int1.fst
fstcompose compiled/int1.fst compiled/step3.fst > compiled/int2.fst
fstcompose compiled/int2.fst compiled/step4.fst > compiled/int3.fst
fstcompose compiled/int3.fst compiled/step5.fst > compiled/int4.fst
fstcompose compiled/int4.fst compiled/step6.fst > compiled/int5.fst
fstcompose compiled/int5.fst compiled/step7.fst > compiled/int6.fst
fstcompose compiled/int6.fst compiled/step8.fst > compiled/int7.fst
fstcompose compiled/int7.fst compiled/step9.fst > compiled/metaphoneLN.fst

echo "Inversion of methaphoneLN"

fstinvert compiled/metaphoneLN.fst > compiled/invertMetaphoneLN.fst


# ############ tests  ############

echo "Testing metaphoneLN"

fstcompose compiled/t-89723-std1-in.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-89723-std1-out.fst 

fstcompose compiled/t-89723-std1-in.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-89723-std2-in.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-89723-std2-out.fst

fstcompose compiled/t-89723-std2-in.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-93713-std1-in.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-93713-std1-out.fst

fstcompose compiled/t-93713-std1-in.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-93713-std2-in.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-93713-std2-out.fst

fstcompose compiled/t-93713-std2-in.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "To be or not to be, that is the question, by william shakespear"

fstcompose compiled/t-to.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-be.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-or.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-not.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-to.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-be.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-that.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-is.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-the.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-question.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-by.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-william.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-shakespear.fst compiled/metaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing invertMetaphoneLN"

fstcompose compiled/t-89723-std-inv.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-89723-std-inv-out.fst

fstcompose compiled/t-89723-std-inv.fst compiled/invertMetaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-89723-std2-inv.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-89723-std2-inv-out.fst

fstcompose compiled/t-89723-std2-inv.fst compiled/invertMetaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-93713-std-inv.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-93713-std-inv-out.fst

fstcompose compiled/t-93713-std-inv.fst compiled/invertMetaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

fstcompose compiled/t-93713-std2-inv.fst compiled/metaphoneLN.fst | fstshortestpath | fsttopsort > compiled/t-93713-std2-inv-out.fst

fstcompose compiled/t-93713-std2-inv.fst compiled/invertMetaphoneLN.fst | fstshortestpath | fstproject --project_type=output |
fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


# ############ generate PDFs  ############
echo "Starting to generate PDFs"
for i in compiled/step*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
   fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done
for i in compiled/t*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
   fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done








