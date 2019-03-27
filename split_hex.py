import sys
import os

hexfile = sys.argv[1]

outdir = "VERIFICATION"

if not os.path.exists(outdir):
    os.makedirs(outdir)

b0 = open(os.path.join(outdir,"program_B0.hex"),"w")
b1 = open(os.path.join(outdir,"program_B1.hex"),"w")
b2 = open(os.path.join(outdir,"program_B2.hex"),"w")
b3 = open(os.path.join(outdir,"program_B3.hex"),"w")

for line in open(hexfile):
    inst = line.strip().zfill(8)

    b0.write(inst[6:8]+"\n")
    b1.write(inst[4:6]+"\n")
    b2.write(inst[2:4]+"\n")
    b3.write(inst[0:2]+"\n")

print "HEX split completed -> files stored in VERIFICATION/"
