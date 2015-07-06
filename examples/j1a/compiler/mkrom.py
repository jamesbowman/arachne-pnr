code = list(open("build/nuc.hex"))[:16]
open("build/nuc.v", "w").write(
  "".join(["4'd%d: insn <= 16'h%s;\n" % (i,l.strip()) for (i,l) in enumerate(code)]))
