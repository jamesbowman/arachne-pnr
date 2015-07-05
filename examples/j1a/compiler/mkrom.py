code = list(open("build/nuc.hex"))[:8]
open("build/nuc.v", "w").write(
  "".join(["3'd%d: insn <= 16'h%s;\n" % (i,l.strip()) for (i,l) in enumerate(code)]))
