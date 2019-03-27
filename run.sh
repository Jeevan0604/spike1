#!/bin/bash
set -e

TEST=$1

if [ -z "$TEST" ]; then
 echo "Usage: ./run.sh <test>"
 exit 1
fi

echo "=================================="
echo "Running test : $TEST"
echo "=================================="

########################################
# Paths
########################################

FIRMWARE=firmware
TB=VERIFICATION

ELF=$FIRMWARE/out/$TEST.elf
HEX=$FIRMWARE/out/$TEST.hex

SPIKE=$FIRMWARE/riscv64im/bin/spike

SPIKE_LOG=spike.log
RTL_LOG=rtl.log

SPIKE_PC=spike_pc.log
RTL_PC=rtl_pc.log

COMPARE_LOG=compare.log

########################################
# Compile firmware
########################################

echo ""
echo "Compiling firmware..."

cd $FIRMWARE
make TEST=$TEST
cd ..

echo "Firmware compile complete"

########################################
# Split HEX for RTL
########################################

echo ""
echo "Splitting HEX for instruction memory..."

python split_hex.py $HEX

echo "HEX split completed -> files stored in VERIFICATION/"
echo "HEX files copied to VERIFICATION/"

########################################
# Run Spike
########################################

echo ""
echo "Running SPIKE..."

$SPIKE -l --isa=RV32IA $ELF 2>&1 | tee $SPIKE_LOG

echo "Spike run complete"

########################################
# Extract SPIKE PC
########################################

echo ""
echo "Extracting SPIKE PC..."

grep "core" $SPIKE_LOG | awk '{print $3}' | sed 's/0x//' > spike_full_pc.log

# start recording from program address
awk '/80000000/ {found=1} found' spike_full_pc.log > $SPIKE_PC

echo "Spike PC log generated -> $SPIKE_PC"

echo ""
echo "SPIKE PC Trace:"
echo "------------------------------"
head -20 $SPIKE_PC
echo "------------------------------"

########################################
# Run RTL Simulation
########################################

echo ""
echo "Running RTL Simulation..."

cd $TB

xrun -sv ../rtl/*.v top_tb.v \
-access +rwc \
-input "@run; exit" \
-log ../$RTL_LOG

cd ..

echo "RTL simulation completed"

########################################
# Extract RTL PC
########################################

echo ""
echo "Extracting RTL PC..."

grep "RTL_PC=" $RTL_LOG | awk -F= '{print $2}' > $RTL_PC

# remove duplicate PCs (pipeline stalls)
awk '!seen[$0]++' $RTL_PC > rtl_pc_clean.log
mv rtl_pc_clean.log $RTL_PC

echo "RTL PC log generated -> $RTL_PC"

echo ""
echo "RTL PC Trace:"
echo "------------------------------"
head -20 $RTL_PC
echo "------------------------------"

########################################
# Logs Summary
########################################

echo ""
echo "Logs Generated:"
echo "------------------------------"

echo $SPIKE_LOG
echo $SPIKE_PC
echo $RTL_LOG
echo $RTL_PC

echo ""
echo "Run completed"

########################################
# Compare SPIKE vs RTL
########################################

echo ""
echo "===================================="
echo "Comparing SPIKE vs RTL PC..."
echo "===================================="

rm -f $COMPARE_LOG

pass=1
line=1

paste $SPIKE_PC $RTL_PC | while read spike rtl
do

 if [ "$spike" = "$rtl" ]; then
   echo "Line $line : SPIKE=$spike RTL=$rtl PASS" | tee -a $COMPARE_LOG
 else
   echo "Line $line : SPIKE=$spike RTL=$rtl FAIL" | tee -a $COMPARE_LOG
   pass=0
 fi

 line=$((line+1))

done

echo ""
echo "===================================="

if [ $pass -eq 1 ]; then
 echo "FINAL RESULT : PASS"
else
 echo "FINAL RESULT : FAIL"
fi

echo "===================================="
